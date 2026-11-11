kind: make

description: |
  m4 1.4.7, built by make and the tcc that is built against musl, with the
  makefile live-bootstrap ships.

build-depends:
- bash/bash.bst
- coreutils/coreutils-0.bst
- live-bootstrap/source.bst
- make/make.bst
- tcc/musl/toolchain.bst

sources:
- kind: tar
  url: "kernel-mirror:gnu/m4/m4-1.4.7.tar.bz2"
  ref: a88f3ddaa7c89cf4c34284385be41ca85e9135369c333fdfa232f3bf48223213

variables:
  # The tarball has a GNUmakefile, which make would read first.
  lb-makefile: "%{libdir}/live-bootstrap/m4-1.4.7/mk/main.mk"
  make: make -f %{lb-makefile} %{make-args}
  make-install: make -j1 -f %{lb-makefile} %{make-install-args}
