kind: manual
(@): elements/gcc/tools-new.yml

description: |
  bison 3.7.6, with gnulib imported by the script live-bootstrap has, the files that were made before taken out, and its configure made again.

build-depends:
  (>):
  - bison/bison-3.6.4.bst

sources:
- kind: tar
  url: "kernel-mirror:gnu/bison/bison-3.7.6.tar.xz"
  ref: 67d68ce1e22192050525643fc0a7a22297576682bef6a5c51446903f5aeef3cf
- kind: tar
  url: "github:coreutils/gnulib/archive/839ed05.tar.gz"
  ref: 70a5c70fe8af9f441b205fbcf30980d0c7d26f4ecfb0bab3e47871326d6100b8
  directory: gnulib-839ed05

variables:
  lb: "%{libdir}/live-bootstrap/bison-3.7.6"

config:
  configure-commands:
  - |
    chmod -R u+w .
    patch -Np1 -i %{lb}/patches/our-bison.patch
    patch -Np1 -d gnulib-839ed05 -i %{lb}/patches/po-files.patch
    rm src/parse-gram.c src/parse-gram.h
    rm src/scan-code.c
    rm src/scan-gram.c
    rm src/scan-skel.c
    rm doc/bison.info*
    rm runtime-po/*.gmo
    sed 's#\.\./gnulib#gnulib#g' %{lb}/import-gnulib.sh > import-gnulib.sh
    . ./import-gnulib.sh
    for f in lib/iconv_open-*.h; do
        rm "$f"
        touch "$f"
    done
    AUTOPOINT=true AUTOMAKE=automake-1.15 ACLOCAL=aclocal-1.15 autoreconf-2.69 -fi
    ./configure --prefix="%{prefix}" \
        --libdir="%{libdir}" \
        --disable-nls \
        --program-suffix=-3.7 \
        --datarootdir="%{prefix}/share/bison-3.7"
  build-commands:
  - |
    make -j1 MAKEINFO=true
  install-commands:
  - |
    make MAKEINFO=true DESTDIR="%{install-root}" install
    ln -s bison-3.7 "%{install-root}%{prefix}/bin/bison"
