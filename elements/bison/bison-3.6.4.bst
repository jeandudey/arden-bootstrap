kind: manual
(@): elements/gcc/tools-new.yml

description: |
  bison 3.6.4, with gnulib imported by the script live-bootstrap has, the files that were made before taken out, and its configure made again.

sources:
- kind: tar
  url: "kernel-mirror:gnu/bison/bison-3.6.4.tar.xz"
  ref: 8b13473b31ca7fcf65e5e8a74224368ffd5df19275602a9c9567ba393f18577d
- kind: tar
  url: "github:coreutils/gnulib/archive/ffbb0ce.tar.gz"
  ref: 2078949ad412e9582f23f6c9942e8e4d4b236ae8748957988c1d0d85564f901e
  directory: gnulib-ffbb0ce

variables:
  lb: "%{libdir}/live-bootstrap/bison-3.6.4"

config:
  configure-commands:
  - |
    chmod -R u+w .
    patch -Np1 -i %{lb}/patches/0001-Revert-diagnostics-translate-bison-s-own-tokens.patch
    patch -Np1 -i %{lb}/patches/dangling-alias.patch
    patch -Np1 -i %{lb}/patches/iconv-autoconf.patch
    patch -Np1 -i %{lb}/patches/our-bison.patch
    patch -Np1 -i %{lb}/patches/parse-error.patch
    patch -Np1 -d gnulib-ffbb0ce -i %{lb}/patches/po-files.patch
    patch -Np1 -i %{lb}/patches/yycontext-remove.patch
    sed -i '/GRAM_error/d' src/scan-gram.l
    rm src/parse-gram.c src/parse-gram.h
    rm src/scan-code.c
    rm src/scan-gram.c
    rm src/scan-skel.c
    rm doc/bison.info*
    rm runtime-po/*.gmo
    sed 's#\.\./gnulib#gnulib#g' %{lb}/import-gnulib.sh > import-gnulib.sh
    . ./import-gnulib.sh
    for f in lib/iconv_open-*.gperf; do
        touch "$(basename "$f" .gperf).h"
    done
    AUTOPOINT=true AUTOMAKE=automake-1.15 ACLOCAL=aclocal-1.15 autoreconf-2.69 -fi
    ./configure --prefix="%{prefix}" \
        --libdir="%{libdir}" \
        --disable-nls \
        --program-suffix=-3.6 \
        --datarootdir="%{prefix}/share/bison-3.6"
  build-commands:
  - |
    make -j1 MAKEINFO=true
  install-commands:
  - |
    make MAKEINFO=true DESTDIR="%{install-root}" install
    ln -s bison-3.6 "%{install-root}%{prefix}/bin/bison"
