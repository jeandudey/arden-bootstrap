kind: make

description: |
  diffutils 2.7, built by make and the tcc that is built against musl, with
  the makefile live-bootstrap ships: cmp and diff.

build-depends:
- bash/bash.bst
- coreutils/coreutils.bst
- live-bootstrap/source.bst
- make/make.bst
- tcc/musl/toolchain.bst

sources:
- kind: tar
  url: "kernel-mirror:gnu/diffutils/diffutils-2.7.tar.gz"
  ref: d5f2489c4056a31528e3ada4adacc23d498532b0af1a980f2f76158162b139d6

config:
  build-commands:
    (<):
    - cp %{libdir}/live-bootstrap/diffutils-2.7/mk/main.mk Makefile
    - touch config.h
