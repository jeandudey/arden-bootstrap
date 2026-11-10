kind: stage0
build-depends:
  - stage0/hex1.bst
  - stage0/posix.bst
config:
  assembler: "%{bindir}/hex1"
  target: "%{bindir}/hex2-0"
  (?):
    - buildarch == "aarch64":
        sources: ["%{libdir}/stage0-posix/hex2_AArch64.hex1"]
    - buildarch == "rv64g":
        sources: ["%{libdir}/stage0-posix/hex2_riscv64.hex1"]
    - buildarch == "x86-64":
        sources: ["%{libdir}/stage0-posix/hex2_AMD64.hex1"]
