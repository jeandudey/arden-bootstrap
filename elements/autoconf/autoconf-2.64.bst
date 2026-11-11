kind: manual
(@): elements/autoconf/autoconf.yml

description: |
  autoconf 2.64, configured and built by the autoconf and the automake before
  it, as live-bootstrap does.  The manuals and the tests that were made
  before are left out, and the data files go in a directory with its version.

build-depends:
  (>):
  - autoconf/autoconf-2.61.bst
  - automake/automake-1.10.3.bst
  - help2man/help2man-1.36.4.bst

sources:
- kind: tar
  url: "kernel-mirror:gnu/autoconf/autoconf-2.64.tar.xz"
  ref: 32d977213320b8ae76c71175305301197f2b0e04e72d70694bc3d3e2ae6c7248

variables:
  ac-version: "2.64"
  ac-prebuild: "true"
  ac-prepare: |
    rm doc/*.info
    rm man/*.1
    rm -f tests/*.at
    AUTOMAKE=automake-1.10 ACLOCAL=aclocal-1.10 AUTOM4TE=autom4te-2.61 AUTOCONF=autoconf-2.61 autoreconf-2.61 -f
