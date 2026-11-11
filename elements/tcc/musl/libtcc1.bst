kind: manual
(@): elements/tcc/libtcc1.yml

description: |
  libtcc1.a for the tcc that is built against musl, from tcc's own sources, with
  a patch that is only needed here: the C library is linked before libtcc1.a.

build-depends:
  (>):
  - musl/musl.bst
  - patch/patch.bst
  - tcc/musl/tcc.bst

sources:
- kind: local
  path: files/tinycc-mes-0.28/va-list-memmove.patch

variables:
  libtcc1-lib: lib

config:
  build-commands:
    (<):
    - |
      mkdir lib
      cp %{tcc-src}/lib/*.c lib
      chmod u+w lib/*.c
      patch -Np1 -d lib -i ../va-list-memmove.patch
