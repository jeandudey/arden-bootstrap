kind: manual
(@): elements/autoconf/autoconf.yml

description: |
  autoconf 2.57, configured and built by the autoconf and the automake before
  it, as live-bootstrap does.  The manuals and the tests that were made
  before are left out, and the data files go in a directory with its version.

build-depends:
  (>):
  - autoconf/autoconf-2.55.bst
  - automake/automake-1.7.8.bst

sources:
- kind: tar
  url: "kernel-mirror:gnu/autoconf/autoconf-2.57.tar.bz2"
  ref: e1035aa2c21fae2a934d1ab56c774ce9d22717881dab8a1a5b16d294fb793489

variables:
  ac-version: "2.57"
  ac-prepare: |
    rm bin/autoconf.in
    rm doc/*.info
    rm man/*.1
    rm -f tests/*.at
    sed -i '/SUBDIRS/s/ man//' Makefile.am
    AUTOMAKE=automake-1.7 ACLOCAL=aclocal-1.7 AUTOCONF=autoconf-2.55 autoreconf-2.55 -f
