kind: exec
(@): elements/tcc/boot.yml

description: |
  tcc configured for musl, built by the tcc of the Mes world, which is given
  musl's headers and libraries by hand, as it looks for the Mes C library's.
  Its libtcc1.a is the Mes world's for this one link only.

build-depends:
- stage0/catm.bst
- stage0/chmod.bst
- stage0/cp.bst
- stage0/mkdir.bst
- musl/musl-1.1.24-pass0.bst
- tcc/source.bst
- tcc/tcc.bst

variables:
  tcc-cc: tcc
  tcc-out: tcc
  incdir: "%{prefix}/include"
  tcc-lib: "%{prefix}/lib"
  tcc-extra-flags: -nostdinc -nostdlib
  tcc-inputs: "%{tcc-lib}/crt1.o %{tcc-lib}/libc.a %{prefix}/lib/mes/tcc/libtcc1.a"
