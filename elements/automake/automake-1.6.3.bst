kind: manual

description: |
  automake 1.6.3 configured by autoconf 2.52 and the aclocal that was made
  before it, and installed by the steps live-bootstrap has for it.

build-depends:
- autoconf/autoconf-2.52.bst
- automake/automake-1.6.3-pass0.bst
- bash/bash.bst
- coreutils/coreutils-5.0.bst
- gawk/gawk.bst
- grep/grep.bst
- m4/m4.bst
- make/make.bst
- perl/perl-5.6.2.bst
- sed/sed.bst
- tcc/musl/toolchain.bst

runtime-depends:
- autoconf/autoconf-2.52.bst

sources:
- kind: tar
  url: "kernel-mirror:gnu/automake/automake-1.6.3.tar.bz2"
  ref: 0dbafacaf21e135cab35d357a14bdcd981d2f2d00e1387801be8091a31b7bb81

config:
  configure-commands:
  - |
    sed -i '/Makefile/d' configure.in
    rm -- configure Makefile.in */Makefile.in */*/Makefile.in aclocal.m4 automake.info*
    aclocal-1.6
    autoconf-2.52
    ./configure --prefix=%{prefix}
  build-commands:
  - |
    cp m4/amversion.in m4/amversion.m4
    sed -i -e 's/@VERSION@/1.6.3/' -e 's/@APIVERSION@/1.6/' m4/amversion.m4
  install-commands:
  - |
    install -D automake %{install-root}%{bindir}/automake-1.6
    mkdir -p %{install-root}%{prefix}/share/automake-1.6/am
    mkdir -p %{install-root}%{prefix}/share/automake-1.6/Automake
    cp lib/Automake/*.pm %{install-root}%{prefix}/share/automake-1.6/Automake/
    cp -r lib/am/*.am %{install-root}%{prefix}/share/automake-1.6/am/
    install -D aclocal %{install-root}%{bindir}/aclocal-1.6
    mkdir -p %{install-root}%{prefix}/share/aclocal-1.6
    cp -r m4/*.m4 %{install-root}%{prefix}/share/aclocal-1.6/
