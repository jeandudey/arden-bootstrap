kind: exec
(@): elements/mes/mes.yml

description: |
  libc-mini.a, the smallest C library: what libc and libmescc are built on.

build-depends:
- stage0/catm.bst
- stage0/cp.bst
- stage0/mkdir.bst
- stage0/rm.bst
- mes/mescc.bst

config:
  commands:
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
      - lib/linux/%{mes-cpu}-mes-mescc/_exit.c
      - lib/linux/%{mes-cpu}-mes-mescc/_write.c
      - lib/stdlib/puts.c
      - lib/string/strlen.c
      - lib/mes/write.c
  - "%{mescc} libc-mini.c"
  install:
  - from: "%{mes-prefix}"
    to: "%{mes-lib}"
    rename:
      libc-mini.o: libc-mini.a
      libc-mini.s: libc-mini.s
