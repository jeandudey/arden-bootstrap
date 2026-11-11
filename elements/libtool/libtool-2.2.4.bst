kind: manual

description: |
  libtool 2.2.4, bootstrapped by autoconf 2.61 and automake 1.10.3 and built
  by the tcc that is built against musl, as live-bootstrap does, with its two
  patches.  There are no shared libraries, so the archiver is not run.

build-depends:
- autoconf/autoconf-2.61.bst
- automake/automake-1.10.3.bst
- bash/bash.bst
- coreutils/coreutils-5.0.bst
- gawk/gawk.bst
- grep/grep.bst
- help2man/help2man-1.36.4.bst
- live-bootstrap/source.bst
- m4/m4.bst
- make/make.bst
- patch/patch.bst
- perl/perl-5.6.2.bst
- sed/sed.bst
- tcc/musl/toolchain.bst

sources:
- kind: tar
  url: "kernel-mirror:gnu/libtool/libtool-2.2.4.tar.lzma"
  ref: d81839fa4d566dbef7c286fdca9b430d3530983fff6d389fac0f08baf27e4c3a

variables:
  lb-libtool: "%{libdir}/live-bootstrap/libtool-2.2.4"
  libtool-env: >-
    AUTOMAKE=automake-1.10 ACLOCAL=aclocal-1.10 AUTOM4TE=autom4te-2.61
    AUTOCONF=autoconf-2.61 AUTOHEADER=autoheader-2.61 AUTORECONF=autoreconf-2.61

config:
  configure-commands:
  - |
    for p in %{lb-libtool}/patches/*.patch; do patch -Np1 -i $p; done
    rm libtoolize.in
    rm -f libltdl/config/ltmain.sh libtool libltdl/m4/ltversion.m4
    rm -f doc/*.info
    rm -f tests/testsuite tests/defs.in tests/package.m4
    find tests -name configure | while read d; do
      rm -r "$(dirname "$d")"
    done
    %{libtool-env} ./bootstrap
    LD=tcc CC=tcc AR=true RANLIB=true ./configure \
      --prefix=%{prefix} --libdir=%{libdir} \
      --disable-shared --disable-ltdl-install \
      --host=%{triple} --target=%{triple} --build=%{triple} \
      ac_path_EGREP=egrep ac_path_FGREP=fgrep ac_path_GREP=grep ac_path_SED=sed
  build-commands:
  - make AUTOM4TE=autom4te-2.61 MAKEINFO=true
  install-commands:
  - |
    make install MAKEINFO=true DESTDIR=%{install-root}
    sed -i -e "s/{EGREP=.*/{EGREP='egrep'}/" -e "s/{FGREP=.*/{FREGP='fgrep'}/" \
      -e "s/{GREP=.*/{GREP='grep'}/" -e "s/{SED=.*/{SED='sed'}/" \
      %{install-root}%{bindir}/libtool
