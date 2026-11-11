kind: manual
(@): elements/gcc/tools-new.yml

description: |
  bison 3.8.2, with gnulib imported by the script live-bootstrap has, the files that were made before taken out, and its configure made again.

build-depends:
  (>):
  - bison/bison-3.7.6.bst
  - autoconf/autoconf-2.71.bst
  - automake/automake-1.16.3.bst
  - perl/perl-5.36.3.bst

sources:
- kind: tar
  url: "kernel-mirror:gnu/bison/bison-3.8.2.tar.xz"
  ref: 9bba0214ccf7f1079c5d59210045227bcf619519840ebfa80cd3849cff5a5bf2
- kind: tar
  url: "github:coreutils/gnulib/archive/7818455.tar.gz"
  ref: ea02ff3d3e797a7ae8817e60f77e9338fdc10621c98b8d0471905b7dc22b8d19
  directory: gnulib-7818455

variables:
  lb: "%{libdir}/live-bootstrap/bison-3.8.2"

config:
  configure-commands:
  - |
    chmod -R u+w .
    patch -Np1 -i %{lb}/patches/defines-header.patch
    patch -Np1 -i %{lb}/patches/our-bison.patch
    patch -Np1 -d gnulib-7818455 -i %{lb}/patches/po-files.patch
    rm src/parse-gram.c src/parse-gram.h
    rm src/scan-code.c
    rm src/scan-gram.c
    rm src/scan-skel.c
    rm doc/bison.info*
    rm runtime-po/*.gmo
    for f in lib/iconv_open-*.h; do
        rm "$f"
        touch "$f"
    done
    sed 's#\.\./gnulib#gnulib#g' %{lb}/import-gnulib.sh > import-gnulib.sh
    . ./import-gnulib.sh
    AUTOPOINT=true AUTOMAKE=automake-1.15 ACLOCAL=aclocal-1.15 autoreconf-2.71 -fi
    ./configure --prefix="%{prefix}" \
        --libdir="%{libdir}" \
        --disable-nls \
        --program-suffix=-3.8 \
        --datarootdir="%{prefix}/share/bison-3.8"
  build-commands:
  - |
    make -j1 MAKEINFO=true
  install-commands:
  - |
    make MAKEINFO=true DESTDIR="%{install-root}" install
    ln -s bison-3.8 "%{install-root}%{prefix}/bin/bison"
