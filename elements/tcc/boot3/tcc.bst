kind: exec
(@): elements/tcc/boot.yml

description: |
  tcc-boot3, tcc built by tcc-boot2 and linked with the final libraries, so
  that it uses tcc's own libtcc1.a: boot2 has Mes's, whose conversions between
  floating point and 64 bit integers return 0, and folds constants with them.

build-depends:
- stage0/catm.bst
- stage0/chmod.bst
- stage0/cp.bst
- stage0/mkdir.bst
- mes/mes.bst
- tcc/boot2/tcc.bst
- tcc/libs.bst
- tcc/source.bst

variables:
  tcc-cc: tcc-boot2
  tcc-out: tcc-boot3
  tcc-extra-flags: ""
