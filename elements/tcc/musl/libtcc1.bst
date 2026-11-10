kind: manual
(@): elements/tcc/libtcc1.yml

description: |
  libtcc1.a for the tcc that is built against musl, from tcc's own sources.

build-depends:
  (>):
  - musl/musl.bst
  - tcc/musl/tcc.bst
