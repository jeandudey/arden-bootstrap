kind: stage0
build-depends:
  - stage0/hex0.bst
  - stage0/posix.bst
config:
  assembler: "%{bindir}/hex0"
  target: "%{bindir}/hex1"
  (?):
    - buildarch == "aarch64":
        sources: ["%{libdir}/stage0-posix/hex1_AArch64.hex0"]
    - buildarch == "rv64g":
        sources: ["%{libdir}/stage0-posix/hex1_riscv64.hex0"]
    - buildarch == "x86-64":
        sources: ["%{libdir}/stage0-posix/hex1_AMD64.hex0"]
