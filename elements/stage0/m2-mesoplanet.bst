kind: stage0
(@): elements/stage0/m2libc.yml
sources:
- kind: git_repo
  url: github:oriansj/M2-Mesoplanet
  track: master
  ref: e9d604c1fe3430109939176eb38a5814845380f9
build-depends:
  - stage0/blood-elf-0.bst
  - stage0/hex2.bst
  - stage0/m1.bst
  - stage0/m2-0.bst
  - stage0/m2libc.bst
runtime-depends:
  - stage0/blood-elf.bst
  - stage0/hex2.bst
  - stage0/m1.bst
  - stage0/m2.bst
  - stage0/m2libc.bst
config:
  assembler: "%{bindir}/hex2"
  link-flags: ["--little-endian", "--base-address", "0x00600000"]
  compiler: M2
  macro-assembler: M1
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
  - "%{libdir}/m2libc/%{m2libc-arch}/linux/fcntl.c"
  - "%{libdir}/m2libc/fcntl.c"
  - "%{libdir}/m2libc/sys/utsname.h"
  - "%{libdir}/m2libc/%{m2libc-arch}/linux/unistd.c"
  - "%{libdir}/m2libc/%{m2libc-arch}/linux/sys/stat.c"
  - "%{libdir}/m2libc/ctype.c"
  - "%{libdir}/m2libc/stdlib.c"
  - "%{libdir}/m2libc/stdarg.h"
  - "%{libdir}/m2libc/stdio.h"
  - "%{libdir}/m2libc/stdio.c"
  - "%{libdir}/m2libc/string.c"
  - "%{libdir}/m2libc/bootstrappable.c"
  - "cc.h"
  - "cc_globals.c"
  - "cc_env.c"
  - "cc_reader.c"
  - "cc_spawn.c"
  - "cc_core.c"
  - "cc_macro.c"
  - "cc.c"
  target: "%{bindir}/M2-Mesoplanet"
