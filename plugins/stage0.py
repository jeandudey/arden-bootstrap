import os

from buildstream import Element, ElementError


# Intermediate files go here, inside build-root, so they never
# collide with staged sources and never end up in the artifact
WORKDIR = ".hex-work"

# Source extensions that get translated before assembling, in order.
# Each contiguous run of a given extension is joined with catm (if more
# than one file), run through the tool, and replaced by a single file
# with the output extension in the same position:
#
#   .c/.h -> compiler -> .M1
#   .M1   -> M0 -> .hex2
#
# The compiler is cc (the default) or M2. cc takes a single file, so
# the run is joined first. M2 takes each file as its own -f argument,
# plus the target architecture, so nothing is joined.
COMPILERS = ("cc", "M2")


# The macro assembler is M0 (the default), M1-0 or M1. Like M2, M1-0 and M1 are
# given each file as its own -f argument, plus the architecture.
MACRO_ASSEMBLERS = ("M0", "M1-0", "M1")

# Tools that are given each input file itself, not a joined one
MULTI_FILE_TOOLS = ("M2", "M1-0", "M1")


def make_steps(compiler, macro_assembler):
    return [
        ((".c", ".h"), compiler, ".M1"),
        ((".M1",), macro_assembler, ".hex2"),
    ]


class Stage0Element(Element):
    # pylint: disable=attribute-defined-outside-init

    BST_MIN_VERSION = "2.0"

    def configure(self, node):
        node.validate_keys(["architecture", "assembler", "bootstrap-mode", "compiler", "debug", "footer-flags", "footer-tool", "link-flags", "macro-assembler", "macro-flags", "sources", "target"])
        self.assembler = node.get_str("assembler")
        self.compiler = node.get_str("compiler", "cc")
        self.architecture = node.get_str("architecture", None)
        self.debug = node.get_bool("debug", False)
        # Flags for blood-elf-0, which generates a debug footer from the
        # compiler's output. The footer follows the output in the M1 run
        self.footer_flags = node.get_str_list("footer-flags", None)
        # The tool that generates it: blood-elf-0, or blood-elf once built
        self.footer_tool = node.get_str("footer-tool", "blood-elf-0")

        if self.compiler not in COMPILERS:
            raise ElementError(f"{self}: 'compiler' must be one of: {', '.join(COMPILERS)}")
        self.macro_assembler = node.get_str("macro-assembler", "M0")
        # When set (even to an empty list), the assembler is hex2-1 or
        # later: it takes each file as its own -f argument, plus the
        # architecture, so the final files aren't joined with catm
        self.link_flags = node.get_str_list("link-flags", None)
        self.macro_flags = node.get_str_list("macro-flags", [])
        # M2 normally only has the bootstrap C library to work with
        self.bootstrap_mode = node.get_bool("bootstrap-mode", True)

        if self.macro_assembler not in MACRO_ASSEMBLERS:
            raise ElementError(f"{self}: 'macro-assembler' must be one of: {', '.join(MACRO_ASSEMBLERS)}")
        if self.macro_flags and self.macro_assembler == "M0":
            raise ElementError(f"{self}: 'macro-flags' is only used with macro-assembler M1-0")
        if not self.bootstrap_mode and self.compiler != "M2":
            raise ElementError(f"{self}: 'bootstrap-mode' is only used with compiler M2")
        uses_arch = self.compiler == "M2" or self.macro_assembler != "M0" or self.link_flags is not None
        if uses_arch and not self.architecture:
            raise ElementError(f"{self}: 'architecture' is required with compiler M2, macro-assembler M1-0 or link-flags")
        if not uses_arch and self.architecture:
            raise ElementError(f"{self}: 'architecture' is only used with compiler M2, macro-assembler M1-0 or link-flags")

        if self.debug and self.compiler != "M2":
            raise ElementError(f"{self}: 'debug' is only used with compiler M2")
        if self.footer_flags is not None and self.compiler != "M2":
            raise ElementError(f"{self}: 'footer-flags' is only used with compiler M2")

        self.steps = make_steps(self.compiler, self.macro_assembler)
        self.inputs = node.get_str_list("sources")
        self.target = node.get_str("target")

        bindir = self.get_variable("bindir")
        self.catm = os.path.join(bindir, "catm")
        self.blood_elf = os.path.join(bindir, self.footer_tool)
        self.tools = {tool: os.path.join(bindir, tool) for _, tool, _ in self.steps}

        if not self.inputs:
            raise ElementError(f"{self}: 'sources' must list at least one file")

        # Dry run the steps on the file names, to validate the layout
        # and find out which tools will run
        self.used_tools = set()
        catm_runs = 0
        names = list(self.inputs)

        for exts, tool, out_ext in self.steps:
            run = self._find_run(names, exts)
            if run is None:
                continue
            first, last = run
            if last > first and not self._takes_many(tool):
                catm_runs += 1
            self.used_tools.add(tool)
            names[first : last + 1] = ["x" + out_ext]
            if self.footer_flags is not None and tool == "M2":
                names.insert(first + 1, "x-footer" + out_ext)

        if len(names) > 1 and self.link_flags is None:
            catm_runs += 1

        self.needs_catm = catm_runs > 0

    def preflight(self):
        pass

    def get_unique_key(self):
        key = {
            "assembler": self.assembler,
            "sources": self.inputs,
            "target": self.target,
        }
        if self.architecture:
            key["architecture"] = self.architecture
        if self.debug:
            key["debug"] = True
        if not self.bootstrap_mode:
            key["bootstrap-mode"] = False
        if self.macro_flags:
            key["macro-flags"] = self.macro_flags
        if self.link_flags is not None:
            key["link-flags"] = self.link_flags
        if self.footer_flags is not None:
            key["footer-flags"] = self.footer_flags
            key["blood-elf"] = self.blood_elf
        # Tools only matter when they actually run
        for tool in sorted(self.used_tools):
            key[tool] = self.tools[tool]
        if self.needs_catm:
            key["catm"] = self.catm
        return key

    def configure_sandbox(self, sandbox):
        sandbox.mark_directory(self.get_variable("build-root"))
        sandbox.mark_directory(self.get_variable("install-root"))
        sandbox.set_work_directory(self.get_variable("build-root"))
        sandbox.set_environment(self.get_environment())

    def stage(self, sandbox):
        self.stage_dependency_artifacts(sandbox)
        self.stage_sources(sandbox, self.get_variable("build-root"))

    def assemble(self, sandbox):
        build_root = self.get_variable("build-root")
        install_root = self.get_variable("install-root")
        root = sandbox.get_virtual_directory()
        name = os.path.basename(self.target)

        # None of the stage0 tools check that their inputs exist
        for path in self.inputs:
            if not root.exists(self._sandbox_path(build_root, path), follow_symlinks=True):
                raise ElementError(f"{self}: Source file not found: {path}")

        # The stage0 tools can't create directories
        root.open_directory(self._sandbox_path(build_root, WORKDIR), create=True)

        inputs = list(self.inputs)

        # Number intermediates per step: a step's joined input and the
        # previous step's output share an extension, and catm truncates
        # its output before reading its inputs
        for step, (exts, tool, out_ext) in enumerate(self.steps):
            run = self._find_run(inputs, exts)
            if run is None:
                continue
            first, last = run
            output = os.path.join(WORKDIR, f"{name}.{step}-out{out_ext}")
            if self._takes_many(tool):
                # M2 --architecture ARCH -f FILE... [--bootstrap-mode] [--debug] -o OUTPUT
                # M1-0 --architecture ARCH [FLAGS] -f FILE... -o OUTPUT
                argv = [self.tools[tool], "--architecture", self.architecture]
                if tool != "M2":
                    argv += self.macro_flags
                for path in inputs[first : last + 1]:
                    argv += ["-f", path]
                if tool == "M2":
                    if self.bootstrap_mode:
                        argv += ["--bootstrap-mode"]
                    if self.debug:
                        argv += ["--debug"]
                argv += ["-o", output]
            else:
                joined = self._concat(sandbox, inputs[first : last + 1], f"{name}.{step}-in{exts[0]}", install_root)
                argv = [self.tools[tool], joined, output]
            self._run(sandbox, argv, install_root)
            inputs[first : last + 1] = [output]

            if self.footer_flags is not None and tool == "M2":
                footer = os.path.join(WORKDIR, f"{name}.{step}-footer{out_ext}")
                argv = [self.blood_elf] + self.footer_flags + ["-f", output, "-o", footer]
                self._run(sandbox, argv, install_root)
                inputs.insert(first + 1, footer)

        target = os.path.join(install_root, self.target.lstrip("/"))
        root.open_directory(os.path.dirname(target).strip("/"), create=True)

        if self.link_flags is not None:
            # hex2-1 --architecture ARCH [FLAGS] -f FILE... -o TARGET
            argv = [self.assembler, "--architecture", self.architecture] + self.link_flags
            for path in inputs:
                argv += ["-f", path]
            self._run(sandbox, argv + ["-o", target], install_root)
        else:
            source = self._concat(sandbox, inputs, f"{name}.hex", install_root)
            self._run(sandbox, [self.assembler, source, target], install_root)

        return install_root

    # Whether a tool is given each input file itself, not a joined one
    @staticmethod
    def _takes_many(tool):
        return tool in MULTI_FILE_TOOLS

    # Return (first, last) indices of the run of files with one of
    # 'exts', or None. The run must be contiguous, so it's clear where
    # the output goes.
    def _find_run(self, names, exts):
        idx = [i for i, path in enumerate(names) if path.endswith(exts)]
        if not idx:
            return None
        if idx != list(range(idx[0], idx[-1] + 1)):
            raise ElementError(f"{self}: {'/'.join(exts)} sources must be listed together")
        return idx[0], idx[-1]

    # One input is used as is; more are joined with catm into WORKDIR
    def _concat(self, sandbox, inputs, output_name, install_root):
        if len(inputs) == 1:
            return inputs[0]
        output = os.path.join(WORKDIR, output_name)
        # catm usage: catm OUTPUT INPUT1 [INPUT2 ...]
        self._run(sandbox, [self.catm, output] + inputs, install_root)
        return output

    # Resolve a path the way the sandbox will (relative to build-root),
    # returned relative to the sandbox root for the virtual directory API
    @staticmethod
    def _sandbox_path(build_root, path):
        return os.path.normpath(os.path.join(build_root, path)).lstrip("/")

    def _run(self, sandbox, argv, install_root):
        label = " ".join(argv)
        if sandbox.run(argv, root_read_only=True, label=label) != 0:
            raise ElementError(f"{self}: Command failed: {label}", collect=install_root)


def setup():
    return Stage0Element
