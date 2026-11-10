kind: exec
(@): elements/tcc/boot.yml

description: |
  tcc built by the tcc that is built against musl-0, and against musl, so
  that it is the first to be built with what it links: it finds musl's headers
  and libraries by itself, and there is nothing to give it by hand.

build-depends:
- musl/musl.bst
- stage0/catm.bst
- stage0/chmod.bst
- stage0/cp.bst
- stage0/mkdir.bst
- tcc/musl-0/libtcc1.bst
- tcc/musl-0/tcc.bst
- tcc/source.bst

variables:
  tcc-cc: tcc
  tcc-out: tcc
  incdir: "%{prefix}/include"
  tcc-lib: "%{prefix}/lib"
