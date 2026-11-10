kind: stage0
build-depends:
  - stage0/catm-0.bst
  - stage0/hex2-0.bst
  - stage0/m0.bst
  - stage0/posix.bst
config:
  assembler: "%{bindir}/hex2-0"
  target: "%{bindir}/cc"
  (?):
    - buildarch == "aarch64":
        sources:
          - "%{libdir}/stage0-posix/ELF-riscv64.hex2"
          - "%{libdir}/stage0-posix/cc_aarch64.M1"
    - buildarch == "rv64g":
        sources:
          - "%{libdir}/stage0-posix/ELF-riscv64.hex2"
          - "%{libdir}/stage0-posix/cc_riscv64.M1"
    - buildarch == "x86-64":
        sources:
          - "%{libdir}/stage0-posix/ELF-amd64.hex2"
          - "%{libdir}/stage0-posix/cc_amd64.M1"
