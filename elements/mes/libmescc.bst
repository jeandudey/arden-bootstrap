kind: exec
(@): elements/mes/mes.yml

description: |
  libmescc.a, the support library of mescc's output.

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
      output: libmescc.c
      files:
      - lib/mes/globals.c
      - lib/linux/%{mes-cpu}-mes-mescc/syscall-internal.c
  - "%{mescc} libmescc.c"
  install:
  - from: "%{mes-prefix}"
    to: "%{mes-lib}"
    rename:
      libmescc.o: libmescc.a
      libmescc.s: libmescc.s
