kind: stage0
build-depends:
- stage0/catm-0.bst
- stage0/cc.bst
- stage0/hex2-0.bst
- stage0/m0.bst
- stage0/m2-planet.bst
- stage0/m2libc.bst
variables:
  (?):
    - buildarch == "aarch64":
        m2libc-arch: aarch64
    - buildarch == "rv64g":
        m2libc-arch: riscv64
    - buildarch == "x86-64":
        m2libc-arch: amd64
config:
  assembler: "%{bindir}/hex2-0"
  sources:
  - "%{libdir}/m2libc/%{m2libc-arch}/ELF-%{m2libc-arch}.hex2"
  - "%{libdir}/m2libc/%{m2libc-arch}/%{m2libc-arch}_defs.M1"
  - "%{libdir}/m2libc/%{m2libc-arch}/libc-core.M1"
  - "%{libdir}/m2libc/%{m2libc-arch}/linux/bootstrap.c"
  - "%{libdir}/m2libc/bootstrap.c"
  - "%{libdir}/m2-planet/cc.h"
  - "%{libdir}/m2libc/bootstrappable.c"
  - "%{libdir}/m2-planet/cc_globals.c"
  - "%{libdir}/m2-planet/cc_reader.c"
  - "%{libdir}/m2-planet/cc_strings.c"
  - "%{libdir}/m2-planet/cc_types.c"
  - "%{libdir}/m2-planet/cc_emit.c"
  - "%{libdir}/m2-planet/cc_core.c"
  - "%{libdir}/m2-planet/cc_macro.c"
  - "%{libdir}/m2-planet/cc.c"
  target: "%{bindir}/M2"
