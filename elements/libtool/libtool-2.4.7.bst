kind: manual
(@): elements/gcc/tools-new.yml

description: |
  libtool 2.4.7, built by gcc 4.7.4 with its gnulib imported by the script
  live-bootstrap has and its bootstrap made again.  Shared libraries are not
  built, and the tools libtool is told to use are named without a path.

build-depends:
  (>):
  - autoconf/autoconf-2.69.bst
  - automake/automake-1.15.1.bst
  - gettext/gettext-0.26.bst
  - gzip/gzip.bst
  - help2man/help2man-1.36.4.bst

sources:
- kind: tar
  url: "kernel-mirror:gnu/libtool/libtool-2.4.7.tar.xz"
  ref: 4f7f217f057ce655ff22559ad221a0fd8ef84ad1fc5fcb6990cecc333aa1635d
  directory: libtool-2.4.7
- kind: tar
  url: "github:coreutils/gnulib/archive/a521820.tar.gz"
  ref: d9e5c38d9d25763b058c458bcfcd681d4d32ea8948d2204d3cbf9d6f6d97a55e
  directory: gnulib-a521820

variables:
  lb: "%{libdir}/live-bootstrap/libtool-2.4.7"
  command-subdir: libtool-2.4.7
  libtool-autoreconf: >-
    LIBTOOLIZE=true AUTOPOINT=true AUTOMAKE=automake-1.15 ACLOCAL=aclocal-1.15
    AUTOCONF=autoconf-2.69 AUTOHEADER=autoheader-2.69 autoreconf-2.69 -fi

config:
  configure-commands:
  - |
    chmod -R u+w ..
    patch -d .. -Np0 -i %{lb}/patches/hostname.patch
    rm -f build-aux/ltmain.sh bootstrap tests/testsuite tests/package.m4
    rm -f doc/*.info doc/*.1
    sh %{lb}/import-gnulib.sh
    LIBTOOLIZE=true AUTOPOINT=true sh %{lb}/bootstrap-helper.sh
    %{libtool-autoreconf}
    %{libtool-autoreconf} libltdl
    ./configure --prefix=%{prefix} --libdir=%{libdir} --disable-shared \
      --host=%{triple-musl} --target=%{triple-musl} --build=%{triple-musl} \
      ac_path_EGREP=egrep ac_path_FGREP=fgrep ac_path_GREP=grep ac_path_SED=sed
  build-commands:
  - make AUTOM4TE=autom4te-2.69 MAKEINFO=true
  install-commands:
  - |
    make install MAKEINFO=true DESTDIR=%{install-root}
    sed -i -e "s/{EGREP=.*/{EGREP='egrep'}/" \
        -e "s/{FGREP=.*/{FGREP='fgrep'}/" \
        -e "s/{GREP=.*/{GREP='grep'}/" \
        -e "s/{SED=.*/{SED='sed'}/" \
        %{install-root}%{bindir}/libtool
    chmod 755 %{install-root}%{bindir}/libtool
