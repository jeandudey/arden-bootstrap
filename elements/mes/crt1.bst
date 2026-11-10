kind: exec
(@): elements/mes/mes.yml

description: |
  crt1.o, the C runtime start-up object.

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
  - "%{mescc} lib/linux/%{mes-cpu}-mes-mescc/crt1.c -o lib/%{mes-cpu}-mes/crt1.o"
  install:
  - from: "%{mes-prefix}/lib/%{mes-cpu}-mes"
    to: "%{mes-lib}"
    files:
    - crt1.o
    - crt1.s
