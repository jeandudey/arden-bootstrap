import posixpath

from buildstream import Element, ElementError

class RawElement(Element):
    BST_MIN_VERSION = "2.0"

    def configure(self, node):
        node.validate_keys(["command", "keep"])
        self.command = node.get_str_list("command")
        self.keep = node.get_str_list("keep", [])
        self.root = self.get_variable("install-root")

    def preflight(self):
        pass

    def get_unique_key(self):
        key = {"command": self.command}
        if self.keep:
            key["keep"] = self.keep
        return key

    def configure_sandbox(self, sandbox):
        sandbox.set_environment(self.get_environment())
        sandbox.mark_directory(self.root)
        sandbox.set_work_directory(self.root)

    def stage(self, sandbox):
        self.stage_dependency_artifacts(sandbox)
        self.stage_sources(sandbox, self.root)

    def assemble(self, sandbox):
        # Sandbox.run() rejects relative commands containing a slash, so
        # resolve them against the working directory.
        command = list(self.command)
        if "/" in command[0] and not command[0].startswith("/"):
            command[0] = posixpath.normpath(posixpath.join(self.root, command[0]))
        code = sandbox.run(command, cwd=self.root, label="raw")
        if code != 0:
            raise ElementError(f"{self.command} exited with {code}")
        if not self.keep:
            return self.root

        # Hand on only the listed paths: the rest is the build tree.
        vdir = sandbox.get_virtual_directory()
        root = self.root.strip("/")
        out = vdir.open_directory("keep-out", create=True)
        for path in self.keep:
            path = path.strip("/")
            src = vdir.open_directory(posixpath.join(root, path))
            out.open_directory(path, create=True).import_files(src)
        return "/keep-out"

def setup():
    return RawElement
