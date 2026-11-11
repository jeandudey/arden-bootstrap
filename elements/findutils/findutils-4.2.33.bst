kind: manual

description: |
  findutils 4.2.33, built by the tcc that is built against musl, with a gnulib
  that is imported by the script live-bootstrap has, and autoreconf made
  again.  musl is not known to it, so it is told it is uClibc.
  A patch of live-bootstrap's makes getcwd the same on every file system.

build-depends:
- autoconf/autoconf-2.61.bst
- automake/automake-1.10.3.bst
- bash/bash.bst
- binutils/binutils-2.30.bst
- bison/bison.bst
- coreutils/coreutils-5.0.bst
- gawk/gawk.bst
- grep/grep.bst
- help2man/help2man-1.36.4.bst
- libtool/libtool-2.2.4.bst
- live-bootstrap/source.bst
- m4/m4.bst
- make/make.bst
- patch/patch.bst
- perl/perl-5.6.2.bst
- sed/sed.bst
- tar/tar.bst
- tcc/musl/toolchain.bst

sources:
- kind: tar
  url: "kernel-mirror:gnu/findutils/findutils-4.2.33.tar.gz"
  ref: 813cd9405aceec5cfecbe96400d01e90ddad7b512d3034487176ce5258ab0f78
- kind: tar
  url: "github:coreutils/gnulib/archive/8e128ebf42e16c8631f971a68f188c30962818be.tar.gz"
  ref: fc95ecba2bf5adc667346fa6aa6263bbe79a1e1665dd95031c0cc0635fc3b8c5
  directory: gnulib-8e128e

variables:
  lb-findutils: "%{libdir}/live-bootstrap/findutils-4.2.33"

config:
  configure-commands:
  - |
    chmod -R u+w .
    sed 's#\.\./\.\./import-gnulib.sh#x#; s#\.\./gnulib-8e128e#gnulib-8e128e#' %{lb-findutils}/import-gnulib.sh > import-gnulib.sh
    . ./import-gnulib.sh
    patch -Np1 -i %{lb-findutils}/patches/force-getcwd-fallback.patch
    AUTOMAKE=automake-1.10 ACLOCAL=aclocal-1.10 AUTOM4TE=autom4te-2.61 AUTOCONF=autoconf-2.61 autoreconf-2.61 -f
    rm doc/find.info
    rm po/*.gmo
    CC=tcc ./configure --prefix=%{prefix} --host=%{triple} CPPFLAGS=-D__UCLIBC__
  build-commands:
  - make MAKEINFO=true
  install-commands:
  - make MAKEINFO=true DESTDIR=%{install-root} install
