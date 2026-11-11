kind: manual

description: |
  The aclocal of automake 1.6.3, which is all of it that is made before there
  is an autoconf to configure automake with, assembled by the steps
  live-bootstrap has for it.

build-depends:
- bash/bash.bst
- coreutils/coreutils-5.0.bst
- perl/perl-5.6.2.bst
- sed/sed.bst

sources:
- kind: tar
  url: "kernel-mirror:gnu/automake/automake-1.6.3.tar.bz2"
  ref: 0dbafacaf21e135cab35d357a14bdcd981d2f2d00e1387801be8091a31b7bb81

config:
  build-commands:
  - |
    rm -- configure Makefile.in */Makefile.in */*/Makefile.in aclocal.m4 automake.info*
    cp aclocal.in aclocal
    cp m4/amversion.in m4/amversion.m4
    sed -i -e 's/@VERSION@/1.6.3/' -e 's/@APIVERSION@/1.6/' m4/amversion.m4
    sed -i -e "s#@PERL@#%{bindir}/perl#" -e 's/@PACKAGE@/automake/' \
      -e 's/@APIVERSION@/1.6/' -e 's/@VERSION@/1.6.3/' \
      -e "s#@prefix@#%{prefix}#" -e "s#@datadir@#%{prefix}/share#" aclocal
  install-commands:
  - |
    mkdir -p %{install-root}%{prefix}/share/automake-1.6/Automake
    cp lib/Automake/*.pm %{install-root}%{prefix}/share/automake-1.6/Automake/
    install -D aclocal %{install-root}%{bindir}/aclocal-1.6
    mkdir -p %{install-root}%{prefix}/share/aclocal-1.6
    cp -r m4/*.m4 %{install-root}%{prefix}/share/aclocal-1.6/
