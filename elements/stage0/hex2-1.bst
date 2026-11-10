kind: stage0
build-depends:
  - stage0/blood-elf-0.bst
  - stage0/catm-0.bst
  - stage0/hex2-0.bst
  - stage0/m1-0.bst
  - stage0/m2-0.bst
  - stage0/m2libc.bst
  - stage0/mescc-tools.bst
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
  compiler: M2
  macro-assembler: M1-0
  macro-flags: ["--little-endian"]
  architecture: "%{m2libc-arch}"
  bootstrap-mode: false
  debug: true
  footer-flags: ["--64", "--little-endian"]
  sources:
  - "%{libdir}/m2libc/%{m2libc-arch}/ELF-%{m2libc-arch}-debug.hex2"
  - "%{libdir}/m2libc/%{m2libc-arch}/%{m2libc-arch}_defs.M1"
  - "%{libdir}/m2libc/%{m2libc-arch}/libc-full.M1"
  - "%{libdir}/m2libc/sys/types.h"
  - "%{libdir}/m2libc/stddef.h"
  - "%{libdir}/m2libc/sys/utsname.h"
  - "%{libdir}/m2libc/%{m2libc-arch}/linux/unistd.c"
  - "%{libdir}/m2libc/%{m2libc-arch}/linux/fcntl.c"
  - "%{libdir}/m2libc/fcntl.c"
  - "%{libdir}/m2libc/%{m2libc-arch}/linux/sys/stat.c"
  - "%{libdir}/m2libc/ctype.c"
  - "%{libdir}/m2libc/stdlib.c"
  - "%{libdir}/m2libc/stdarg.h"
  - "%{libdir}/m2libc/stdio.h"
  - "%{libdir}/m2libc/stdio.c"
  - "%{libdir}/m2libc/bootstrappable.c"
  - "%{libdir}/mescc-tools/hex2.h"
  - "%{libdir}/mescc-tools/hex2_linker.c"
  - "%{libdir}/mescc-tools/hex2_word.c"
  - "%{libdir}/mescc-tools/hex2.c"
  target: "%{bindir}/hex2-1"
