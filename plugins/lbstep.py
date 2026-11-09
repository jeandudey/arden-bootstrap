"""
lbstep: run one live-bootstrap step.

live-bootstrap's steps install straight into /usr (and track what they
installed in /external/repo) and later steps read files earlier steps edited
(/steps/env, /steps/bootstrap.cfg), so every element of this kind collects the
whole root filesystem (install-root is "/"). Each element must depend on
exactly one predecessor so the artifacts layer into a single chain; the CAS
deduplicates the files carried from one artifact to the next.

Elements are normally generated from live-bootstrap's steps/manifest by
tools/gen-lb-elements.py.

Configuration:

  action:   build (default), improve, uninstall or setup.
  pkg:      build: step directory under /steps (e.g. mes-0.27.1).
            improve: name of the script under /steps/improve.
            uninstall: space separated packages or absolute file names.
  pass:     build: which passN script to run (default 1). passN.kaem is run
            with kaem, passN.sh through helpers.sh's build() under bash.
  commands: setup: kaem lines emulating live-bootstrap's seed.kaem.
  bootstrap-cfg:
            Overrides for the generated /steps/bootstrap.cfg.
  package-checksums:
            {package file: sha256} replacing the upstream line in
            SHA256SUMS.pkgs for this step.
  script:   improve: lines run instead of sourcing /steps/improve/<pkg>.sh.
  on-failure:
            Debugging aid, bash builds only: shell lines run if the build fails.
  write-bootstrap-cfg:
            Write /steps/bootstrap.cfg before running (the base element).
"""

from buildstream import Element, ElementError

# What rootfs.py writes to steps/bootstrap.cfg for a non-interactive,
# chroot-like (bubblewrap) x86 run, without the kernels.
BOOTSTRAP_CFG = {
    "ARCH": "x86",
    "ARCH_DIR": "x86",
    "FORCE_TIMESTAMPS": "False",
    "CHROOT": "True",
    "UPDATE_CHECKSUMS": "False",
    "JOBS": "1",
    "SWAP_SIZE": "0",
    "FINAL_JOBS": "1",
    "INTERNAL_CI": "False",
    "INTERACTIVE": "False",
    "QEMU": "False",
    "BARE_METAL": "False",
    "KERNEL_BOOTSTRAP": "False",
    "BUILD_KERNELS": "False",
    "CONFIGURATOR": "False",
    "DISK": "sda1",
    "MIRRORS_LEN": "0",
}

# Variables seed/seed.kaem sets for the first steps, after steps/env.
KAEM_EXTRA = [
    "M2LIBC_PATH=/M2libc",
    "NYACC_PKG=nyacc-1.00.2",
    "MES_PKG=mes-0.27.1",
    "MES_PREFIX=${SRCDIR}/${MES_PKG}/build/${MES_PKG}",
    "GUILE_LOAD_PATH=${MES_PREFIX}/mes/module:${MES_PREFIX}/module:"
    "${SRCDIR}/${MES_PKG}/build/${NYACC_PKG}/module",
]

KAEM = "/x86/bin/kaem"
BASH = "/usr/bin/bash"
SCRIPT = "/tmp/lb-step"


class LbStepElement(Element):
    BST_MIN_VERSION = "2.0"

    def configure(self, node):
        node.validate_keys(["action", "pkg", "pass", "commands", "bootstrap-cfg", "write-bootstrap-cfg", "on-failure", "package-checksums", "script"])
        self.action = node.get_str("action", "build")
        if self.action not in ("build", "improve", "uninstall", "setup"):
            raise ElementError("{}: unknown action '{}'".format(self, self.action))
        self.pkg = node.get_str("pkg", None)
        self.pass_no = node.get_int("pass", 1)
        self.commands = node.get_str_list("commands", [])
        self.write_cfg = node.get_bool("write-bootstrap-cfg", False)
        self.on_failure = node.get_str_list("on-failure", [])
        self.script = node.get_str_list("script", [])
        self.pins = {k: v.as_str() for k, v in node.get_mapping("package-checksums", {}).items()}
        self.cfg = dict(BOOTSTRAP_CFG)
        for key, value in node.get_mapping("bootstrap-cfg", {}).items():
            self.cfg[key] = value.as_str()

        if self.action == "setup":
            if not self.commands:
                raise ElementError("{}: 'setup' needs 'commands'".format(self))
        elif not self.pkg:
            raise ElementError("{}: '{}' needs 'pkg'".format(self, self.action))
        self.root = self.get_variable("install-root")

    def preflight(self):
        pass

    def get_unique_key(self):
        key = {
            "action": self.action,
            "pkg": self.pkg,
            "pass": self.pass_no,
            "commands": self.commands,
            "bootstrap-cfg": self.cfg if self.write_cfg else None,
        }
        if self.script:
            key["script"] = self.script
        # Only when set, so that adding the option left existing keys alone.
        if self.pins:
            key["package-checksums"] = self.pins
        return key

    def configure_sandbox(self, sandbox):
        # live-bootstrap starts every step from an empty environment and its
        # own steps/env sets what is needed. BuildStream's defaults (USER,
        # LOGNAME, TZ, ...) leak into build outputs, e.g. perl's Config.pm,
        # and break the package checksums.
        sandbox.set_environment({})
        sandbox.mark_directory(self.root)
        sandbox.set_work_directory("/")

    def stage(self, sandbox):
        self.stage_dependency_artifacts(sandbox)

        # Sources can only be staged into an empty directory, but they belong
        # in the root alongside the dependencies: stage, merge, clean up.
        scratch = "/.lb-sources"
        self.stage_sources(sandbox, scratch)
        vdir = sandbox.get_virtual_directory()
        vdir.import_files(vdir.open_directory(scratch.lstrip("/")))
        vdir.remove(scratch.lstrip("/"), recursive=True)

    def assemble(self, sandbox):
        vdir = sandbox.get_virtual_directory()

        if self.write_cfg:
            self.__write(vdir, "steps/bootstrap.cfg", "".join("{}={}\n".format(k, v) for k, v in self.cfg.items()))

        if self.pins:
            self.__pin(vdir)

        # Whether the step is run by kaem or bash is decided by which passN
        # script exists, as script-generator.c does by build phase.
        if self.action == "setup" or (self.action == "build" and self.__has(vdir, self.__kaem_script())):
            script = self.__kaem_wrapper(vdir)
            argv = [KAEM, "--file", SCRIPT + ".kaem"]
            path = SCRIPT + ".kaem"
        else:
            script = self.__bash_wrapper()
            argv = [BASH, SCRIPT + ".sh"]
            path = SCRIPT + ".sh"

        vdir.open_directory("tmp", create=True)
        self.__write(vdir, path.lstrip("/"), script)

        code = sandbox.run(argv, cwd="/", label=self.pkg or self.action)
        if code != 0:
            raise ElementError("{}: {} exited with {}".format(self, argv[0], code))
        return self.root

    def __pin(self, vdir):
        # Replace the upstream checksum of packages whose bytes depend on the
        # build environment (see tools/lb-pinned-checksums.txt).
        path = "steps/SHA256SUMS.pkgs"
        lines = self.__read(vdir, path).splitlines()
        lines = [l for l in lines if l.split()[-1:] and l.split()[-1] not in self.pins]
        lines += ["{}  {}".format(sha, name) for name, sha in self.pins.items()]
        self.__write(vdir, path, "\n".join(lines) + "\n")

    def __kaem_script(self):
        return "steps/{}/pass{}.kaem".format(self.pkg, self.pass_no)

    @staticmethod
    def __has(vdir, path):
        return vdir.exists(path)

    @staticmethod
    def __write(vdir, path, text):
        with vdir.open_file(path, mode="w") as f:
            f.write(text)

    @staticmethod
    def __read(vdir, path):
        with vdir.open_file(path, mode="r") as f:
            return f.read()

    def __kaem_wrapper(self, vdir):
        # kaem has no quoting or functions: one command per line, variables
        # are expanded as they are defined. This is what script-generator
        # emits: the configuration, then steps/env, then the step itself.
        lines = ["set -ex", "cd /steps"]
        lines += self.__read(vdir, "steps/bootstrap.cfg").splitlines()
        lines += [l for l in self.__read(vdir, "steps/env").splitlines() if l and not l.startswith("#")]
        lines += KAEM_EXTRA
        lines += self.commands
        if self.action == "build":
            lines += [
                "pkg={}".format(self.pkg),
                "cd ${pkg}",
                "kaem --file pass{}.kaem".format(self.pass_no),
            ]
        return "\n".join(lines) + "\n"

    def __bash_wrapper(self):
        lines = ["set -e", "cd /steps", ". ./bootstrap.cfg", ". ./env", ". ./helpers.sh"]
        if self.action == "build":
            # An EXIT trap, because `build ... || {...}` would switch off
            # `set -e` inside build() and let a failed package checksum
            # through. It always reports the checksum of what was built, so
            # a mismatch can be compared with other builds or pinned.
            failure = ["sha256sum /external/repo/{}_*.tar.bz2".format(self.pkg)]
            failure += self.on_failure
            lines.append("trap 'rc=$?; if [ $rc -ne 0 ]; then set +e; " +
                         "; ".join(failure) + "; fi' EXIT")
            lines.append("build {} pass{}.sh".format(self.pkg, self.pass_no))
        elif self.action == "improve":
            # An inline script stands in for improve/<pkg>.sh, which live-bootstrap
            # sources into the step script the same way.
            lines += self.script or [". ./improve/{}.sh".format(self.pkg)]
        elif self.action == "uninstall":
            lines.append("uninstall {}".format(self.pkg))
        return "\n".join(lines) + "\n"


def setup():
    return LbStepElement
