kind: stack

description: |
  What building with the tcc that is built against musl needs: that tcc, its
  libtcc1.a, and musl's headers and libraries.

depends:
- musl/musl-0.bst
- tcc/musl/libtcc1.bst
- tcc/musl/tcc.bst
