(@): include/mes.yml

kind: exec

description: |
  libc-mini.a, the smallest C library: what libc and libmescc are built on.

build-depends:
- stage0.bst
- boot/mes/sources.bst
- boot/mes/arch-headers.bst
- boot/mes/mes-m2.bst
- boot/mes/nyacc.bst

config:
  commands:
  # Pregenerated, so that it is rebuilt from source.
  - rm %{mes-prefix}/mes/module/mes/psyntax.pp %{mes-prefix}/mes/module/mes/psyntax.pp.header
  - cd: "%{mes-prefix}"
  - concat:
      output: libc-mini.c
      files:
      - lib/mes/__init_io.c
      - lib/mes/eputs.c
      - lib/mes/oputs.c
      - lib/mes/globals.c
      - lib/stdlib/exit.c
      - lib/linux/%{arch}-mes-mescc/_exit.c
      - lib/linux/%{arch}-mes-mescc/_write.c
      - lib/stdlib/puts.c
      - lib/string/strlen.c
  - "%{mescc} libc-mini.c"
  install:
  - from: "%{mes-prefix}"
    to: "%{mes-lib}"
    rename:
      libc-mini.o: libc-mini.a
      libc-mini.s: libc-mini.s
