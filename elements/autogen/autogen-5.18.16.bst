kind: manual
(@): elements/gcc/tools-new.yml

description: |
  autogen 5.18.16, built by gcc 4.7.4 with the bootstrapping scripts of Michael
  Schierl, which make a first autogen from the git tree with the Guile that is
  built, and then the autogen that is installed from the tarball the tree makes.

build-depends:
  (>):
  - autoconf/autoconf-2.71.bst
  - automake/automake-1.16.3.bst
  - coreutils/coreutils-9.4.bst
  - gc/gc-8.2.12.bst
  - gmp/gmp.bst
  - gperf/gperf-3.3.bst
  - grep/grep-3.12.bst
  - guile/guile-3.0.11.bst
  - gzip/gzip.bst
  - libffi/libffi-3.5.2.bst
  - libtool/libtool-2.4.7.bst
  - libunistring/libunistring-1.4.1.bst
  - musl/musl-1.2.5.bst
  - perl/perl-5.42.0.bst
  - pkg-config/pkg-config-0.29.2.bst
  - sed/sed-4.8.bst
  - tar/tar-1.34.bst
  - which/which-2.23.bst
  - xz/xz-5.6.4.bst

sources:
- kind: tar
  url: "github:schierlm/gnu-autogen-bootstrapping/archive/refs/tags/autogen-5.18.16-v1.0.1.tar.gz"
  ref: 953ba180b18acff188a0a8700770c7cf2fc97e1683c7b9699a5a748b542ccdd5
  directory: gnu-autogen-bootstrapping
- kind: git
  url: "savannah-git:autogen.git"
  ref: 5d22bdb4bafe5ec3f21dcbfc64b61e48ea63c5a5
  directory: autogen-5.18.16
  checkout-submodules: false
- kind: remote
  url: "kernel-mirror:gnu/autogen/rel5.18.16/autogen-5.18.16.tar.xz"
  ref: f8a13466b48faa3ba99fe17a069e71c9ab006d9b1cfabe699f8c60a47d5bb49a
  filename: autogen-5.18.16.tar.xz
- kind: tar
  url: "github:coreutils/gnulib/archive/8f4538a5.tar.gz"
  ref: af14dc39bf5a3332da11e551bc97d02de15864c9e8688f2d7120ffc87c414af2
  directory: gnulib-8f4538a5

variables:
  lb: "%{libdir}/live-bootstrap/autogen-5.18.16"
  command-subdir: gnu-autogen-bootstrapping

config:
  configure-commands:
  - |
    chmod -R u+w ..
    cp %{lb}/files/gperf-3.3.patch .
    mkdir build
    mv ../autogen-5.18.16 build/src
    cp ../autogen-5.18.16.tar.xz build/
    rm -f build/src/add-on/char-mapper/cm.tar
  build-commands:
  - |
    bash -e <<'SCRIPT'
    export PKG_CONFIG_PATH=%{libdir}/pkgconfig
    sed -i "s/make install/make install DESTDIR=\${DESTDIR}/" bootstrap_tarball.sh
    sed -i "/make check/d" bootstrap_tarball.sh
    export FINALPREFIX=%{prefix}
    export GUILE_STATIC="--static"
    export GNULIBDIR="$PWD"/../gnulib-8f4538a5
    export MAN_PAGE_DATE=1970-01-01
    SKIP_MAIN=1 . ./bootstrap_tarball.sh
    prepare_tarball
    patch -Np1 -i ../../gperf-3.3.patch -d build/autogen-5.18.16
    bootstrap_columns
    bootstrap_getdefs
    bootstrap_autogen
    bootstrap_tpl_config
    rm -R build/tarball
    cp -ar build/autogen-5.18.16 build/tarball
    cd build/tarball
    sed -i "s/+%Y/+1970/; s/%m/01/; s/%d'/01'/; s/%Y/2018/" autoopts/aoconf.tpl
    sed -i 's/%Y/2018/' autoopts/options_h.tpl
    SOURCE_DIR="$PWD" ./config/bootstrap
    CPPFLAGS=-D_LARGEFILE64_SOURCE=1 ./configure \
      --prefix="$FINALPREFIX" \
      --libdir="$FINALPREFIX/lib/%{triple-musl}" \
      --disable-shared \
      --enable-timeout=15
    touch doc/agdoc.texi
    make -j1 CFLAGS=-Wno-error
    awk '{gsub("\\(/tmp/.*", "", $7); print}' agen5/autogen.1 > autogen.1
    mv autogen.1 agen5/autogen.1
    SCRIPT
  install-commands:
  - |
    cd build/tarball
    make DESTDIR=%{install-root} install MAN_PAGE_DATE=1970-01-01
    rm %{install-root}%{prefix}/share/autogen/libopts-*.tar.gz
