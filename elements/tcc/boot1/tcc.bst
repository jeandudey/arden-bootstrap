kind: exec
(@): elements/tcc/boot.yml

description: |
  tcc-boot1, tcc built by tcc-boot0.

build-depends:
- stage0/catm.bst
- stage0/chmod.bst
- stage0/cp.bst
- stage0/mkdir.bst
- mes/mes.bst
- tcc/boot0/tcc.bst
- tcc/boot0/libs.bst
- tcc/source.bst

variables:
  tcc-cc: tcc-boot0
  tcc-out: tcc-boot1
  tcc-extra-flags: ""
