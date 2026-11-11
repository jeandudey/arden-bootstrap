kind: manual
(@): elements/gcc/tools-new.yml

description: |
  autoconf 2.71, made again by autoconf 2.69, with its data files in a directory with its version.

build-depends:
  (>):
  - help2man/help2man-1.36.4.bst
  - perl/perl-5.18.4.bst

sources:
- kind: tar
  url: "kernel-mirror:gnu/autoconf/autoconf-2.71.tar.xz"
  ref: f14c83cfebcc9427f2c3cea7258bd90df972d92eb26752da4ddad81c87a0faa4

variables:
  lb: "%{libdir}/live-bootstrap/autoconf-2.71"

config:
  configure-commands:
  - |
    chmod -R u+w .
    rm doc/*.info
    rm man/*.1
    rm tests/*.at
    %{autoreconf-1-15}
    sed -i '/^pkgdatadir/s:$:-@VERSION@:' Makefile.in
    ./configure --prefix="%{prefix}" --program-suffix=-2.71
  build-commands:
  - |
    make MAKEINFO=true
  install-commands:
  - |
    make install MAKEINFO=true DESTDIR="%{install-root}"
    ln -s autoconf-2.71 "%{install-root}%{prefix}/bin/autoconf"
    ln -s autoheader-2.71 "%{install-root}%{prefix}/bin/autoheader"
    ln -s autom4te-2.71 "%{install-root}%{prefix}/bin/autom4te"
    ln -s autoreconf-2.71 "%{install-root}%{prefix}/bin/autoreconf"
