kind: stage0
build-depends:
  - stage0/hex2-0.bst
  - stage0/posix.bst
config:
  assembler: "%{bindir}/hex2-0"
  target: "%{bindir}/catm"
  (?):
    - buildarch == "aarch64":
        sources: ["%{libdir}/stage0-posix/catm_AArch64.hex2"]
    - buildarch == "rv64g":
        sources: ["%{libdir}/stage0-posix/catm_riscv64.hex2"]
    - buildarch == "x86-64":
        sources: ["%{libdir}/stage0-posix/catm_AMD64.hex2"]
