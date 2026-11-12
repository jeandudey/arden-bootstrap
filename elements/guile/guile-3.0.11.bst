kind: manual
(@): elements/gcc/tools-new.yml

description: |
  guile 3.0.11, built by gcc 4.7.4.  Its psyntax-pp.scm is made again by the
  Guile 3.0.7 that the bootstrapping scripts of Michael Schierl support, and
  put into 3.0.11, as live-bootstrap does so that the build is the same with
  more than one job.

build-depends:
  (>):
  - autoconf/autoconf-2.71.bst
  - automake/automake-1.16.3.bst
  - bison/bison-3.8.2.bst
  - flex/flex-2.5.33.bst
  - gc/gc-8.2.12.bst
  - gettext/gettext-0.26.bst
  - gmp/gmp.bst
  - gperf/gperf-3.3.bst
  - gzip/gzip.bst
  - libffi/libffi-3.5.2.bst
  - libtool/libtool-2.4.7.bst
  - libunistring/libunistring-1.4.1.bst
  - musl/musl-1.2.5.bst
  - perl/perl-5.42.0.bst
  - texinfo/texinfo-7.2.bst
  - pkg-config/pkg-config-0.29.2.bst

sources:
- kind: tar
  url: "kernel-mirror:gnu/guile/guile-3.0.11.tar.xz"
  ref: 818c79d236657a7fa96fb364137cc7b41b3bdee0d65c6174ca03769559579460
  directory: guile-3.0.11
- kind: tar
  url: "kernel-mirror:gnu/guile/guile-3.0.7.tar.xz"
  ref: f57d86c70620271bfceb7a9be0c81744a033f08adc7ceba832c9917ab3e691b7
  directory: guile-3.0.7
- kind: tar
  url: "github:coreutils/gnulib/archive/901694b9.tar.gz"
  ref: c69bc9e986d6bc62225eb88636dc73ca4e3e4e8fa2225c54a5ef569be8ac8449
  directory: gnulib-901694b9
- kind: tar
  url: "github:coreutils/gnulib/archive/356a414e.tar.gz"
  ref: 1ff0f4191188e18d121ed3ca09efb3c97fdf0542623b539fb0c6c71aebcfdbf2
  directory: gnulib-356a414e
- kind: tar
  url: "github:schierlm/guile-psyntax-bootstrapping/archive/refs/tags/guile-3.0.7.tar.gz"
  ref: 14cda9c416506dfadf60c14fc623ff01ef99b87564a78d0a29c5d17143c97609
  directory: guile-psyntax-bootstrapping-guile-3.0.7
- kind: remote
  url: "unicode:Public/13.0.0/ucd/UnicodeData.txt"
  ref: bdbffbbfc8ad4d3a6d01b5891510458f3d36f7170422af4ea2bed3211a73e8bb
  filename: UnicodeData-13.0.0.txt

variables:
  lb: "%{libdir}/live-bootstrap/guile-3.0.11"
  command-subdir: guile-3.0.11
  guile-common-prepare: |
    find . -name '*.info*' -delete
    for f in doc/ref/*.pdf doc/ref/*.eps; do
      rm "$f"
      touch "$f"
    done
    rm -r prebuilt/*/ice-9
    rm libguile/c-tokenize.c libguile/vm-operations.h
    sed -i "s/\`date -u +'%Y-%m-%d %T'.*\`/1970-01-01 00:00:00/" libguile/Makefile.am
    AUTOMAKE=automake-1.16 ACLOCAL=aclocal-1.16 autoreconf-2.71 -fi

config:
  configure-commands:
  - |
    chmod -R u+w ..
    cd ../guile-3.0.7
    rm libguile/srfi-14.i.c
    cp ../UnicodeData-13.0.0.txt libguile/UnicodeData.txt
    (cd libguile
    sed -i '/indent /d' unidata_to_charset.pl
    perl unidata_to_charset.pl)
    sh %{lb}/import-gnulib-3.0.7.sh
    %{guile-common-prepare}
    rm module/ice-9/psyntax-pp.scm
    echo '(primitive-load-path "psyntax-bootstrap/allsteps")' > module/ice-9/psyntax-pp.scm
    mkdir -p module/psyntax-bootstrap
    cp ../guile-psyntax-bootstrapping-guile-3.0.7/psyntax-bootstrap/*.scm module/psyntax-bootstrap
    (cd module/ice-9
    cp psyntax.scm psyntax-patched.scm
    patch < ../../../guile-psyntax-bootstrapping-guile-3.0.7/stage2.patch)
    cd ../guile-3.0.11
    sh %{lb}/import-gnulib.sh
    %{guile-common-prepare}
    for d in . ../guile-3.0.7; do
      (cd $d
      PKG_CONFIG_PATH=%{libdir}/pkgconfig ./configure \
        --prefix=%{prefix} --libdir=%{libdir} --build=%{triple-musl} \
        --disable-shared --disable-jit)
    done
  build-commands:
  - |
    cd ../guile-3.0.7
    make config.h
    make libguile/scmconfig.h
    make .version
    make -C lib all
    make -C meta all
    make -C libguile all
    make -C module ice-9/psyntax-pp.scm.gen
    cd ../guile-3.0.11
    cp -f ../guile-3.0.7/module/ice-9/psyntax-pp.scm module/ice-9/
    make
  install-commands:
  - make DESTDIR=%{install-root} install
