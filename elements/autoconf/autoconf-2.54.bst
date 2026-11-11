kind: manual
(@): elements/autoconf/autoconf.yml

description: |
  autoconf 2.54, configured and built by the autoconf and the automake before
  it, as live-bootstrap does.  The manuals and the tests that were made
  before are left out, and the data files go in a directory with its version.

build-depends:
  (>):
  - autoconf/autoconf-2.53.bst
  - automake/automake-1.7.bst

sources:
- kind: tar
  url: "kernel-mirror:gnu/autoconf/autoconf-2.54.tar.bz2"
  ref: a74aea954f36c7beeb6cc47b96a408c3e04e7ad635f614e65250dbcd8ec0bd28

variables:
  ac-version: "2.54"
  ac-prepare: |
    rm bin/autoconf.in
    rm -- Makefile.in */Makefile.in */*/Makefile.in aclocal.m4 configure
    rm doc/*.info
    rm man/*.1
    rm -f tests/*.at
    sed -i '/SUBDIRS/s/ man//' Makefile.am
    aclocal-1.7
    sed -i 's/2.54/2.53/' aclocal.m4
    cat config/m4.m4 >> aclocal.m4
    autoconf-2.53
    automake-1.7
