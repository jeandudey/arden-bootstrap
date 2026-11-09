"""
exec: run a step's commands directly, with no shell and no kaem.

The early bootstrap has no shell, but it does not need one: a step is a
sequence of program invocations, and BuildStream can run them. Each command is
run as its own process with an explicit working directory and environment.

Dependencies are staged at / and the step installs under the install root, so
the artifact is the files this step installed and nothing else. Sources are
staged at the build root, the starting working directory. Every string goes
through BuildStream's variable substitution (%{name}); there are no ${...}.

Configuration:

  env:      NAME: value, the environment of every command (the defaults are
            in exec.yaml).
  commands: run in order. An item is one of:

              - M2-Mesoplanet -f src/x.c -o %{destdir}%{bindir}/x
                  a command line, split like a shell would split quotes but
                  with nothing else: no variables, pipes or redirections;
              - [M2-Planet, -f, a.c, -f, b.c]
                  the same as a list of arguments, for long ones;
              - script: kaem.run        an upstream script in kaem's syntax, run
                                        command by command, without kaem;
              - cd: /build/x            the working directory from here on;
              - set: {MES_ARENA: 30M}   change the environment from here on;
              - concat:                 write a file made of other files,
                  output: libc.c
                  from: lib             # optional directory of the files
                  files: [mes/eputs.c, stdlib/exit.c]

  install:  after the commands, copy files into the install root:

              - from: /build/x/include
                to: %{incdir}
                files: [stdio.h, sys/stat.h]      # keeps its subdirectory
                rename: {mescc.scm.in: mescc.scm}  # optional, source: name
                mode: "755"                        # optional

Programs come from the staged dependencies; a bare name is looked up in PATH.
"""

import posixpath
import re
import shlex

from buildstream import Element, ElementError, ScalarNode, SequenceNode


class ExecElement(Element):
    BST_MIN_VERSION = "2.0"

    def configure(self, node):
        node.validate_keys(["commands", "env", "install"])
        self.env = {k: self.node_subst_vars(v) for k, v in node.get_mapping("env", {}).items()}

        self.commands = []
        for item in node.get_sequence("commands", []):
            if isinstance(item, SequenceNode):
                self.commands.append(["run", [self.node_subst_vars(a) for a in item]])
                continue
            if isinstance(item, ScalarNode):
                argv = shlex.split(self.node_subst_vars(item))
                if not argv:
                    raise ElementError(f"{self}: empty command")
                self.commands.append(["run", argv])
                continue
            item.validate_keys(["cd", "set", "concat", "script"])
            if "script" in item.keys():
                self.commands.append(["script", self.node_subst_vars(item.get_scalar("script"))])
            elif "cd" in item.keys():
                self.commands.append(["cd", self.node_subst_vars(item.get_scalar("cd"))])
            elif "set" in item.keys():
                values = {k: self.node_subst_vars(v) for k, v in item.get_mapping("set").items()}
                self.commands.append(["set", values])
            else:
                spec = item.get_mapping("concat")
                spec.validate_keys(["output", "from", "files"])
                self.commands.append(["concat", {
                    "output": self.node_subst_vars(spec.get_scalar("output")),
                    "from": self.node_subst_vars(spec.get_scalar("from", "")),
                    "files": [self.node_subst_vars(f) for f in spec.get_sequence("files")],
                }])

        self.install = []
        for entry in node.get_sequence("install", []):
            entry.validate_keys(["from", "to", "files", "rename", "mode"])
            mode = entry.get_scalar("mode", None)
            self.install.append({
                "from": self.node_subst_vars(entry.get_scalar("from")),
                "to": self.node_subst_vars(entry.get_scalar("to")),
                "files": [self.node_subst_vars(f) for f in entry.get_sequence("files", [])],
                "rename": {k: self.node_subst_vars(v) for k, v in entry.get_mapping("rename", {}).items()},
                "mode": self.node_subst_vars(mode) if mode else None,
            })

        self.root = self.get_variable("install-root")
        self.build_root = self.get_variable("build-root")

    def preflight(self):
        pass

    def get_unique_key(self):
        return {"env": self.env, "commands": self.commands, "install": self.install}

    def configure_sandbox(self, sandbox):
        # Nothing from BuildStream's default environment may reach the build.
        sandbox.set_environment({})
        sandbox.mark_directory(self.root)
        sandbox.mark_directory(self.build_root)
        sandbox.set_work_directory(self.build_root)

    def stage(self, sandbox):
        self.stage_dependency_artifacts(sandbox)
        self.stage_sources(sandbox, self.build_root)

    def assemble(self, sandbox):
        vdir = sandbox.get_virtual_directory()
        vdir.open_directory("tmp", create=True)
        vdir.open_directory(self.root.strip("/"), create=True)

        env = dict(self.env)
        cwd = self.build_root
        for kind, value in self.commands:
            if kind == "cd":
                cwd = posixpath.normpath(posixpath.join(cwd, value))
            elif kind == "set":
                env.update(value)
            elif kind == "run":
                self.__run(sandbox, value, cwd, env)
            elif kind == "script":
                self.__script(sandbox, value, cwd, env)
            else:
                self.__run(sandbox, self.__concat(value), cwd, env)
        for argv in self.__install():
            self.__run(sandbox, argv, cwd, env)
        return self.root

    def __script(self, sandbox, path, cwd, env):
        # An upstream script in kaem's syntax, run without kaem: its lines are
        # commands, NAME=value assignments (kept in the environment), echo and
        # cd. ${NAME} and ${NAME:-default} are expanded as each line is read,
        # as kaem does. Nothing else of a shell is understood.
        env = dict(env)
        full = posixpath.normpath(posixpath.join(cwd, path))
        with sandbox.get_virtual_directory().open_file(full.lstrip("/"), mode="r") as f:
            text = f.read().replace("\\\n", " ")

        def expand(match):
            name, _, default = match.group(1).partition(":-")
            return env.get(name) or default

        for line in text.split("\n"):
            line = line.strip()
            if not line or line.startswith("#"):
                continue
            line = re.sub(r"\$\{([^}]*)\}", expand, line)
            assignment = re.match(r"^(\w+)=(.*)$", line)
            if assignment:
                env[assignment.group(1)] = assignment.group(2)
                continue
            argv = shlex.split(line)
            if argv[0] == "echo":
                self.status(" ".join(argv[1:]))
            elif argv[0] == "cd":
                cwd = posixpath.normpath(posixpath.join(cwd, argv[1]))
            else:
                self.__run(sandbox, argv, cwd, env)

    def __run(self, sandbox, argv, cwd, env):
        argv = [self.__resolve(sandbox, argv[0], cwd, env)] + argv[1:]
        code = sandbox.run(argv, cwd=cwd, env=env, label=" ".join(argv)[:200])
        if code != 0:
            raise ElementError(f"{self}: {' '.join(argv)[:300]} exited with {code}")

    def __resolve(self, sandbox, program, cwd, env):
        # The sandbox refuses relative commands that contain a slash.
        if "/" in program:
            return posixpath.normpath(posixpath.join(cwd, program))
        vdir = sandbox.get_virtual_directory()
        for folder in env.get("PATH", "").split(":"):
            path = posixpath.join(folder, program).lstrip("/")
            if folder and vdir.exists(path):
                return "/" + path
        raise ElementError(f"{self}: no '{program}' in PATH={env.get('PATH', '')}")

    @staticmethod
    def __concat(spec):
        names = [posixpath.join(spec["from"], f) if spec["from"] else f for f in spec["files"]]
        return ["catm", spec["output"]] + names

    def __install(self):
        commands = []
        made = set()
        for entry in self.install:
            copied = []
            for name, target in [(n, n) for n in entry["files"]] + list(entry["rename"].items()):
                dest = self.root + posixpath.join(entry["to"], target)
                folder = posixpath.dirname(dest)
                if folder not in made:
                    made.add(folder)
                    commands.append(["mkdir", "-p", folder])
                commands.append(["cp", posixpath.join(entry["from"], name), dest])
                copied.append(dest)
            if entry["mode"]:
                for n in range(0, len(copied), 8):
                    commands.append(["chmod", entry["mode"]] + copied[n:n + 8])
        return commands


def setup():
    return ExecElement
