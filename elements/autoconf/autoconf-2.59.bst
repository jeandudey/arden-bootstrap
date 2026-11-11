kind: manual
(@): elements/autoconf/autoconf.yml

description: |
  autoconf 2.59, configured and built by the autoconf and the automake before
  it, as live-bootstrap does.  The manuals and the tests that were made
  before are left out, and the data files go in a directory with its version.

build-depends:
  (>):
  - autoconf/autoconf-2.57.bst
  - automake/automake-1.7.8.bst

sources:
- kind: tar
  url: "kernel-mirror:gnu/autoconf/autoconf-2.59.tar.bz2"
  ref: f0cde70a8f135098a6a3e85869f2e1cc3f141beea766fa3d6636e086cd8b90a7

variables:
  ac-version: "2.59"
  ac-prepare: |
    rm bin/autoconf.in
    rm doc/*.info
    rm man/*.1
    rm -f tests/*.at
    sed -i '/SUBDIRS/s/ man//' Makefile.am
    AUTOMAKE=automake-1.7 ACLOCAL=aclocal-1.7 AUTOCONF=autoconf-2.57 autoreconf-2.57 -f
