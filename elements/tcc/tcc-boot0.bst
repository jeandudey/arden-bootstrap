kind: exec
(@): elements/tcc/boot.yml

description: |
  tcc-boot0, tcc built by tcc-mes.

build-depends:
- stage0/catm.bst
- stage0/chmod.bst
- stage0/cp.bst
- stage0/mkdir.bst
- mes/mes.bst
- tcc/tcc-mes.bst
- tcc/libs-mes.bst
- tcc/source.bst

variables:
  tcc-cc: tcc-mes
  tcc-out: tcc-boot0
  tcc-extra-flags: "-L %{tcc-lib}"
