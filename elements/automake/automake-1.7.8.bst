kind: manual
(@): elements/automake/automake.yml

description: |
  automake 1.7.8, configured and built by the autoconf and the automake before
  it, as live-bootstrap does, without the programs that would hide those
  of the version before.

build-depends:
  (>):
  - autoconf/autoconf-2.55.bst
  - automake/automake-1.7.bst

runtime-depends:
- autoconf/autoconf-2.55.bst

sources:
- kind: tar
  url: "kernel-mirror:gnu/automake/automake-1.7.8.tar.bz2"
  ref: 2dddc3b51506e702647ccc6757e15c05323fa67245d2d53e81ed36a832f9be42

variables:
  am-autoconf: autoconf-2.55
  am-prepare: |
    rm -- configure Makefile.in */Makefile.in */*/Makefile.in aclocal.m4 automake.info*
    AUTOMAKE=automake-1.7 ACLOCAL=aclocal-1.7 AUTOCONF=autoconf-2.55 autoreconf-2.55
