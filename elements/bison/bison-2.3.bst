kind: manual
(@): elements/gcc/tools-new.yml

description: |
  bison 2.3, which perl's regen scripts ask for by name, with gnulib imported by live-bootstrap's script and its configure made again.

build-depends:
  (>):
  - flex/flex-2.5.33.bst

sources:
- kind: tar
  url: "kernel-mirror:gnu/bison/bison-2.3.tar.bz2"
  ref: b10d7e9e354be72aee4e4911cf19dd27b5c527d4e7200857365b5fcdeea0dffb
- kind: tar
  url: "github:coreutils/gnulib/archive/b28236b.tar.gz"
  ref: 58769285e8f4dec4a30af12032f30c0621d21aa61a01bd48a236aeae9f7b0276
  directory: gnulib-b28236b

variables:
  lb: "%{libdir}/live-bootstrap/bison-2.3"

config:
  configure-commands:
  - |
    chmod -R u+w .
    patch -Np1 -i %{lb}/patches/autover-mismatch.patch
    patch -Np1 -i %{lb}/patches/fopen-safer.patch
    patch -Np1 -i %{lb}/patches/gnulib-fix.patch
    patch -Np1 -i %{lb}/patches/our-bison.patch
    sed 's#\.\./gnulib#gnulib#g' %{lb}/import-gnulib.sh > import-gnulib.sh
    . ./import-gnulib.sh
    AUTOPOINT=true AUTOMAKE=automake-1.15 ACLOCAL=aclocal-1.15 autoreconf-2.69 -fi
    rm src/parse-gram.c src/parse-gram.h src/scan-skel.c src/scan-gram.c
    rm doc/bison.info
    LEX=flex-2.5.33 ./configure \
        --prefix="%{prefix}" \
        --libdir="%{libdir}" \
        --program-suffix=-2.3 \
        --datarootdir="%{prefix}/share/bison-2.3"
  build-commands:
  - |
    make -j1 MAKEINFO=true
  install-commands:
  - |
    make MAKEINFO=true DESTDIR="%{install-root}" install
