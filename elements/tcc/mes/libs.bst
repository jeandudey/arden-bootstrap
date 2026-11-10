kind: exec
(@): elements/tcc/libs.yml

description: |
  crt1.o, libc.a, libtcc1.a and libgetopt.a, compiled by tcc-mes.

build-depends:
- stage0/catm.bst
- stage0/cp.bst
- stage0/mkdir.bst
- tcc/mes/tcc.bst
- tcc/source.bst
- mes/mes.bst

variables:
  tcc-compiler: tcc-mes
