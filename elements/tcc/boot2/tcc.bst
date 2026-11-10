kind: exec
(@): elements/tcc/boot.yml

description: |
  tcc-boot2, tcc built by tcc-boot1: the final tcc 0.9.27.

build-depends:
- stage0/catm.bst
- stage0/chmod.bst
- stage0/cp.bst
- stage0/mkdir.bst
- mes/mes.bst
- tcc/boot1/tcc.bst
- tcc/boot1/libs.bst
- tcc/source.bst

variables:
  tcc-cc: tcc-boot1
  tcc-out: tcc-boot2
