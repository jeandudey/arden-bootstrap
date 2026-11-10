kind: stage0
build-depends:
  - stage0/bootstrap-seeds.bst
config:
  assembler: "%{libdir}/bootstrap-seeds/hex0-seed"
  target: "%{bindir}/hex0"
  (?):
    - buildarch == "aarch64":
        sources: ["%{libdir}/bootstrap-seeds/hex0_AArch64.hex0"]
    - buildarch == "rv64g":
        sources: ["%{libdir}/bootstrap-seeds/hex0_riscv64.hex0"]
    - buildarch == "x86-64":
        sources: ["%{libdir}/bootstrap-seeds/hex0_AMD64.hex0"]
