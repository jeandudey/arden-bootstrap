kind: manual
(@): elements/autoconf/autoconf.yml

description: |
  autoconf 2.61, configured and built by the autoconf and the automake before
  it, as live-bootstrap does.  The manuals and the tests that were made
  before are left out, and the data files go in a directory with its version.

build-depends:
  (>):
  - autoconf/autoconf-2.59.bst
  - automake/automake-1.8.5.bst
  - help2man/help2man-1.36.4.bst

sources:
- kind: tar
  url: "kernel-mirror:gnu/autoconf/autoconf-2.61.tar.bz2"
  ref: 93a2ceab963618b021db153f0c881a2de82455c1dc7422be436fcd5c554085a1

variables:
  ac-version: "2.61"
  ac-prebuild: "true"
  ac-prepare: |
    rm doc/*.info
    rm man/*.1
    rm -f tests/*.at
    sed -i -e '/AC_PROG_GREP/d' -e '/AC_PROG_SED/d' configure.ac
    AUTOMAKE=automake-1.8 ACLOCAL=aclocal-1.8 AUTOM4TE=autom4te-2.59 AUTOCONF=autoconf-2.59 autoreconf-2.59 -f
