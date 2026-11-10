kind: exec
(@): elements/tcc/tcc.yml

description: |
  tcc 0.9.27, as tcc and tcc-0.9.27, with the C library it was built with.

build-depends:
- stage0/chmod.bst
- stage0/cp.bst
- stage0/mkdir.bst
- tcc/boot3/tcc.bst

runtime-depends:
- tcc/libs.bst
- mes/headers.bst

config:
  install:
  - from: "%{bindir}"
    to: "%{bindir}"
    rename:
      tcc-boot3: tcc
    mode: "755"
  - from: "%{bindir}"
    to: "%{bindir}"
    rename:
      tcc-boot3: tcc-0.9.27
    mode: "755"
