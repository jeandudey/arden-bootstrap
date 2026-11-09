"""
kaem: run kaem lines in the bootstrap sandbox and keep only what they install.

The early bootstrap has no shell, only stage0's kaem (no quoting, no functions,
one command per line, variables expanded as they are defined). Dependencies are
staged at / and the step installs under DESTDIR, which is the install root, so
the artifact is the files this step installed and nothing else. A step that
needs another's files names it in build-depends.

Sources are staged at /build, the working directory.

Configuration:

  commands: kaem lines, run after the prelude (the variables below).
  env:      extra NAME: value lines added to the prelude.

The prelude defines ARCH, ARCH_DIR, PREFIX, BINDIR, LIBDIR, INCDIR, DESTDIR,
M2LIBC_PATH and PATH.
"""

from buildstream import Element, ElementError

PRELUDE = [
    "set -ex",
    "ARCH=x86",
    "ARCH_DIR=x86",
    "PREFIX=/usr",
    "BINDIR=${PREFIX}/bin",
    "LIBDIR=${PREFIX}/lib/mes",
    "INCDIR=${PREFIX}/include/mes",
    "M2LIBC_PATH=/M2libc",
    "PATH=${BINDIR}:/${ARCH_DIR}/bin",
]

KAEM = "/x86/bin/kaem"
SCRIPT = "/tmp/step.kaem"
BUILD = "/build"


class KaemElement(Element):
    BST_MIN_VERSION = "2.0"

    def configure(self, node):
        node.validate_keys(["commands", "env"])
        self.commands = node.get_str_list("commands")
        self.env = {k: v.as_str() for k, v in node.get_mapping("env", {}).items()}
        self.root = self.get_variable("install-root")

    def preflight(self):
        pass

    def get_unique_key(self):
        return {"commands": self.commands, "env": self.env, "prelude": PRELUDE}

    def configure_sandbox(self, sandbox):
        # Nothing from BuildStream's default environment may reach the build.
        sandbox.set_environment({})
        sandbox.mark_directory(self.root)
        sandbox.mark_directory(BUILD)
        sandbox.set_work_directory(BUILD)

    def stage(self, sandbox):
        self.stage_dependency_artifacts(sandbox)
        self.stage_sources(sandbox, BUILD)

    def assemble(self, sandbox):
        vdir = sandbox.get_virtual_directory()
        vdir.open_directory("tmp", create=True)
        vdir.open_directory(self.root.strip("/"), create=True)

        lines = PRELUDE + ["DESTDIR=" + self.root]
        lines += ["{}={}".format(k, v) for k, v in self.env.items()]
        lines += self.commands
        with vdir.open_file(SCRIPT.lstrip("/"), mode="w") as f:
            f.write("\n".join(lines) + "\n")

        code = sandbox.run([KAEM, "--file", SCRIPT], cwd=BUILD, label=self.name)
        if code != 0:
            raise ElementError("{}: kaem exited with {}".format(self, code))
        return self.root


def setup():
    return KaemElement
