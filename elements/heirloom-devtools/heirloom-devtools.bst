kind: manual

description: |
  The lex of heirloom-devtools 070527, which flex is built with: live-bootstrap
  builds only its lex directory, and removes it again once flex is there.

build-depends:
- bash/bash.bst
- coreutils/coreutils-0.bst
- make/make.bst
- oyacc/oyacc.bst
- tcc/musl/toolchain.bst

sources:
- kind: tar
  url: "sourceforge:project/heirloom/heirloom-devtools/070527/heirloom-devtools-070527.tar.bz2"
  ref: 9f233d8b78e4351fe9dd2d50d83958a0e5af36f54e9818521458a08e058691ba

config:
  build-commands:
  - |
    cd lex
    make -f Makefile.mk CC=tcc "AR=tcc -ar" LDFLAGS=-static RANLIB=true LIBDIR=%{libdir}
  install-commands:
  - |
    mkdir -p %{install-root}%{bindir} %{install-root}%{libdir}/lex
    install lex/lex %{install-root}%{bindir}
    install lex/libl.a %{install-root}%{libdir}
    install -m 644 lex/ncform %{install-root}%{libdir}/lex
