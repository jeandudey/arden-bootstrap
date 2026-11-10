kind: stage0
build-depends:
  - stage0/catm-0.bst
  - stage0/hex2-0.bst
  - stage0/posix.bst
config:
  assembler: "%{bindir}/hex2-0"
  target: "%{bindir}/M0"
  (?):
    - buildarch == "aarch64":
        sources:
          - "%{libdir}/stage0-posix/ELF-aarch64.hex2"
          - "%{libdir}/stage0-posix/M0_AArch64.hex2"
    - buildarch == "rv64g":
        sources:
          - "%{libdir}/stage0-posix/ELF-riscv64.hex2"
          - "%{libdir}/stage0-posix/M0_riscv64.hex2"
    - buildarch == "x86-64":
        sources:
          - "%{libdir}/stage0-posix/ELF-amd64.hex2"
          - "%{libdir}/stage0-posix/M0_AMD64.hex2"
