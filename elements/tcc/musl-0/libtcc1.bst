kind: manual
(@): elements/tcc/libtcc1.yml

description: |
  libtcc1.a for the tcc that is built against musl-0, from tcc's own sources.

build-depends:
  (>):
  - musl/musl-1.1.24-pass0.bst
  - tcc/musl-0/tcc.bst
