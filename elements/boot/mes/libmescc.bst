(@): include/mes.yml

kind: exec

description: |
  libmescc.a, the support library of mescc's output.

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
      output: libmescc.c
      files:
      - lib/mes/globals.c
      - lib/linux/%{arch}-mes-mescc/syscall-internal.c
  - "%{mescc} libmescc.c"
  install:
  - from: "%{mes-prefix}"
    to: "%{mes-lib}"
    rename:
      libmescc.o: libmescc.a
      libmescc.s: libmescc.s
