(@): include/mes.yml

kind: exec

description: |
  crt1.o, the C runtime start-up object.

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
  - "%{mescc} lib/linux/%{arch}-mes-mescc/crt1.c -o lib/%{arch}-mes/crt1.o"
  install:
  - from: "%{mes-prefix}/lib/%{arch}-mes"
    to: "%{mes-lib}"
    files:
    - crt1.o
    - crt1.s
