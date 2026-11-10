kind: exec
(@): elements/tcc/libs.yml

description: |
  The libraries of the final tcc: crt1.o, libc.a, libgetopt.a and a libtcc1.a
  built from tcc's own libtcc1.c, whose conversions between floating point
  and 64 bit integers work, which Mes's stubs do not.

build-depends:
- stage0/catm.bst
- stage0/cp.bst
- stage0/mkdir.bst
- tcc/boot2/tcc.bst
- tcc/source.bst
- mes/mes.bst

variables:
  tcc-compiler: tcc-boot2
  libtcc1-src: "%{tcc-src}/lib/libtcc1.c"
  libtcc1-flags: -D TCC_TARGET_%{tcc-target}=1
