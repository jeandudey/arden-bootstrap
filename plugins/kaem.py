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
  install:  after the commands, copy files into DESTDIR. kaem has no loops, so
            a list of installs is written as data and expanded here:

              install:
              - from: ${MES_PREFIX}/include   # directory the files are in
                to: ${INCDIR}                 # directory under DESTDIR
                files: [stdio.h, sys/stat.h]  # keeps its subdirectory
                mode: "755"                   # optional, chmod'd after

            Every destination directory is created first.

The prelude defines ARCH, ARCH_DIR, PREFIX, BINDIR, LIBDIR, INCDIR, DESTDIR,
M2LIBC_PATH and PATH.
"""

import posixpath

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
        node.validate_keys(["commands", "env", "install"])
        self.commands = node.get_str_list("commands")
        self.env = {k: v.as_str() for k, v in node.get_mapping("env", {}).items()}
        self.install = []
        for entry in node.get_sequence("install", []):
            entry.validate_keys(["from", "to", "files", "mode"])
            self.install.append({
                "from": entry.get_str("from"),
                "to": entry.get_str("to"),
                "files": entry.get_str_list("files"),
                "mode": entry.get_str("mode", None),
            })
        self.root = self.get_variable("install-root")

    def preflight(self):
        pass

    def get_unique_key(self):
        key = {"commands": self.commands, "env": self.env, "prelude": PRELUDE}
        if self.install:
            key["install"] = self.install
        return key

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
        lines += self.__install_lines()
        with vdir.open_file(SCRIPT.lstrip("/"), mode="w") as f:
            f.write("\n".join(lines) + "\n")

        code = sandbox.run([KAEM, "--file", SCRIPT], cwd=BUILD, label=self.name)
        if code != 0:
            raise ElementError("{}: kaem exited with {}".format(self, code))
        return self.root

    def __install_lines(self):
        lines = []
        made = set()
        for entry in self.install:
            copied = []
            for name in entry["files"]:
                dest = "${DESTDIR}" + posixpath.join(entry["to"], name)
                folder = posixpath.dirname(dest)
                if folder not in made:
                    made.add(folder)
                    lines.append("mkdir -p " + folder)
                lines.append("cp {} {}".format(posixpath.join(entry["from"], name), dest))
                copied.append(dest)
            if entry["mode"]:
                # One chmod per few files keeps the lines short.
                for n in range(0, len(copied), 4):
                    lines.append("chmod {} {}".format(entry["mode"], " ".join(copied[n:n + 4])))
        return lines


def setup():
    return KaemElement
