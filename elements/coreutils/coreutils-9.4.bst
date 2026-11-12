kind: manual
(@):
- elements/gcc/tools-new.yml
- elements/gnulib/unicode-15.0.0.yml

description: |
  coreutils 9.4, built statically by gcc 4.7.4 from its git tree, with its
  gnulib imported after the Unicode tables of gnulib are made again.  It has
  realpath, mktemp, sha256sum and the other programs coreutils 5.0 does not.

build-depends:
  (>):
  - help2man/help2man-1.36.4.bst
  - gzip/gzip.bst

sources:
  (>):
  - kind: git
    url: "savannah-git:coreutils.git"
    ref: 9530a14420fc1a267e90d45e8a0d710c3668382d
    directory: coreutils-9.4
    checkout-submodules: false
  - kind: tar
    url: "github:coreutils/gnulib/archive/bb5bb43.tar.gz"
    ref: 7f21dde90632c21937d7eab8eb8f7aebc8c34b8823737e1904f045fc26c943fa
    directory: gnulib-bb5bb43

variables:
  lb: "%{libdir}/live-bootstrap/coreutils-9.4"
  command-subdir: coreutils-9.4

config:
  configure-commands:
  - |
    chmod -R u+w ..
    for p in %{lb}/patches/*.patch; do patch -d .. -Np0 -i $p; done
    build-aux/gen-lists-of-programs.sh --autoconf > m4/cu-progs.m4
    build-aux/gen-lists-of-programs.sh --automake > src/cu-progs.mk
    build-aux/gen-single-binary.sh src/local.mk > src/single-binary.mk
    touch ChangeLog
    cp ../gnulib-bb5bb43/build-aux/po/Makefile.in.in po/Makefile.in.in
    rm man/help2man
    ln -s %{bindir}/help2man man/
    (cd ../gnulib-bb5bb43
    rm lib/uniwidth/width*.h lib/unictype/ctype*.h lib/unicase/tolower.h)
    bash %{lb}/import-gnulib.sh
    echo 9.4 > .tarball-version
    rm gl/tests/test-rand-isaac.c
    AUTOPOINT=true AUTOMAKE=automake-1.15 ACLOCAL=aclocal-1.15 autoreconf-2.69 -fi
    FORCE_UNSAFE_CONFIGURE=1 ./configure CFLAGS=-static \
      --prefix=%{prefix} --build=%{triple-musl} \
      gl_cv_func_getcwd_path_max="no, but it is partly working" \
      gl_cv_prog_perl=no
  build-commands:
  - make MAKEINFO=true GPERF=true
  install-commands:
  - make install MAKEINFO=true DESTDIR=%{install-root}
