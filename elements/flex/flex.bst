kind: make

description: |
  flex 2.6.4, built with flex 2.5.11 and m4, from the makefile live-bootstrap
  ships, which goes in the src directory: the parser and the scanner that came
  with the sources are removed, and made again.

build-depends:
- bash/bash.bst
- coreutils/coreutils.bst
- flex/flex-0.bst
- live-bootstrap/source.bst
- m4/m4.bst
- make/make.bst
- oyacc/oyacc.bst
- sed/sed.bst
- tcc/musl/toolchain.bst

sources:
- kind: tar
  url: "github:westes/flex/releases/download/v2.6.4/flex-2.6.4.tar.gz"
  ref: e87aae032bf07c26f85ac0ed3250998c37621d95f8bd748b31f15b33c45ee995

variables:
  command-subdir: src
  # Each step needs the one before it.
  make: make -j1 %{make-args}

config:
  build-commands:
    (<):
    - |
      cp %{libdir}/live-bootstrap/flex-2.6.4/mk/main.mk Makefile
      touch config.h
      rm parse.c parse.h scan.c skel.c
