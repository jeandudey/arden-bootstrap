import posixpath

from buildstream import Element, ElementError

class RawElement(Element):
    BST_MIN_VERSION = "2.0"

    def configure(self, node):
        node.validate_keys(["command"])
        self.command = node.get_str_list("command")
        self.root = self.get_variable("install-root")

    def preflight(self):
        pass

    def get_unique_key(self):
        return {"command": self.command}

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
        return self.root

def setup():
    return RawElement
