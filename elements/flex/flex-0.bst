kind: make

description: |
  flex 2.5.11, the flex that flex 2.6.4 is built with: it is built with the
  lex of heirloom-devtools, and generates its own scanner after a temporary
  flex is made from a scanner prepared by hand, as live-bootstrap does.

build-depends:
- bash/bash.bst
- coreutils/coreutils-0.bst
- heirloom-devtools/heirloom-devtools.bst
- live-bootstrap/source.bst
- make/make.bst
- oyacc/oyacc.bst
- patch/patch.bst
- sed/sed.bst
- tcc/musl/toolchain.bst

sources:
- kind: tar
  url: "github:westes/flex/archive/d160f0247ba1611aa59d28f027d6292ba24abb50.tar.gz"
  ref: 68aa10c473b6010ffad680cada09fc4eec6b3cc6e415cc2339e5fc2385ccc142

variables:
  lb-flex: "%{libdir}/live-bootstrap/flex-2.5.11"
  # Each step needs the one before it.
  make: make -j1 %{make-args}

config:
  build-commands:
    (<):
    - |
      rm -r to.do
      touch config.h
      patch -Np1 -i %{lb-flex}/patches/scan_l.patch
      patch -Np1 -i %{lb-flex}/patches/yyin.patch
      cp %{lb-flex}/files/scan.lex.l .
      cp %{lb-flex}/mk/main.mk Makefile
