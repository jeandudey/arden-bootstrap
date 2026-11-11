kind: manual

description: |
  autoconf 2.52, assembled by the steps live-bootstrap has for it, as there
  is no autoconf to configure it with: autoconf is made from its template, and
  the macros are frozen by m4.

build-depends:
- bash/bash.bst
- coreutils/coreutils-5.0.bst
- gawk/gawk.bst
- m4/m4.bst
- sed/sed.bst

sources:
- kind: tar
  url: "kernel-mirror:gnu/autoconf/autoconf-2.52.tar.bz2"
  ref: 4681bcbb9c9298c506f6405a7deb62c54fc3b339d3239a8f36a5df83daaec94f

config:
  build-commands:
  - |
    rm doc/*.info
    cp autoconf.in autoconf
    sed -i -e "s# @SHELL@#/bin/sh#" -e 's/@M4@/m4/' -e 's/@AWK@/awk/' \
      -e 's/@PACKAGE_NAME@/Autoconf/' -e 's/@VERSION@/2.52/' \
      -e "s#@datadir@#%{prefix}/share/autoconf-2.52#" autoconf
    chmod +x autoconf
    m4 autoconf.m4 --freeze-state=autoconf.m4f
  install-commands:
  - |
    install -D autoconf %{install-root}%{bindir}/autoconf-2.52
    mkdir -p %{install-root}%{prefix}/share/autoconf-2.52
    cp -r -- *.m4* %{install-root}%{prefix}/share/autoconf-2.52/
    ln -s autoconf-2.52 %{install-root}%{bindir}/autoconf
