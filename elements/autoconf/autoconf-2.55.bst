kind: manual
(@): elements/autoconf/autoconf.yml

description: |
  autoconf 2.55, configured and built by the autoconf and the automake before
  it, as live-bootstrap does.  The manuals and the tests that were made
  before are left out, and the data files go in a directory with its version.

build-depends:
  (>):
  - autoconf/autoconf-2.54.bst
  - automake/automake-1.7.bst

sources:
- kind: tar
  url: "kernel-mirror:gnu/autoconf/autoconf-2.55.tar.bz2"
  ref: f757158a04889b265203eecd8ca92568e2a67c3b9062fa6bff7a0a6efd2244ac

variables:
  ac-version: "2.55"
  ac-prepare: |
    rm bin/autoconf.in
    rm -- Makefile.in */Makefile.in */*/Makefile.in aclocal.m4 configure
    rm doc/*.info
    rm man/*.1
    rm -f tests/*.at
    sed -i '/SUBDIRS/s/ man//' Makefile.am
    AUTOMAKE=automake-1.7 ACLOCAL=aclocal-1.7 AUTOCONF=autoconf-2.54 autoreconf-2.54
