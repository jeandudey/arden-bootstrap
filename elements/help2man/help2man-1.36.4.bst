kind: manual

description: |
  help2man 1.36.4, configured by the autoconf and the automake that are built
  before it, with the patch live-bootstrap has that leaves the date out of the
  manuals it makes.

build-depends:
- autoconf/autoconf-2.59.bst
- automake/automake-1.8.5.bst
- bash/bash.bst
- coreutils/coreutils-5.0.bst
- gawk/gawk.bst
- grep/grep.bst
- live-bootstrap/source.bst
- m4/m4.bst
- make/make.bst
- patch/patch.bst
- perl/perl-5.6.2.bst
- sed/sed.bst
- tcc/musl/toolchain.bst

sources:
- kind: tar
  url: "kernel-mirror:gnu/help2man/help2man-1.36.4.tar.gz"
  ref: a4adadf76b496a6bc50795702253ecfcb6f0d159b68038f31a5362009340bca2

config:
  configure-commands:
  - |
    patch -Np1 -i %{libdir}/live-bootstrap/help2man-1.36.4/patches/date.patch
    ACLOCAL=aclocal-1.8 autoreconf-2.59 -f
    rm help2man.info
    touch help2man.info
    rm help2man*.1
    rm po/*.gmo
    CC=tcc ./configure --prefix=%{prefix} --disable-nls
  build-commands:
  - make MAKEINFO=true
  install-commands:
  - make MAKEINFO=true DESTDIR=%{install-root} install
