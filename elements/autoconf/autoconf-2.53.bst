kind: manual
(@): elements/autoconf/autoconf.yml

description: |
  autoconf 2.53, configured and built by the autoconf and the automake before
  it, as live-bootstrap does.  The manuals and the tests that were made
  before are left out, and the data files go in a directory with its version.

build-depends:
  (>):
  - autoconf/autoconf-2.52.bst
  - automake/automake-1.6.3.bst
  - live-bootstrap/source.bst
  - patch/patch.bst

sources:
- kind: tar
  url: "kernel-mirror:gnu/autoconf/autoconf-2.53.tar.bz2"
  ref: 6b217a064c6d06603d50a3ad05129aef9435367810c10894210b8dad965d2306

variables:
  ac-version: "2.53"
  ac-prebuild: "true"
  ac-prepare: |
    patch -Np1 -i %{libdir}/live-bootstrap/autoconf-2.53/patches/autoconf_252.patch
    rm -- Makefile.in */Makefile.in */*/Makefile.in aclocal.m4 configure
    rm doc/*.info
    rm man/*.1
    rm tests/*.at
    sed -i '/SUBDIRS/s/ man//' Makefile.am
    aclocal-1.6
    cat config/m4.m4 >> aclocal.m4
    autoconf-2.52
    automake-1.6
    sed -i "s#@abs_top_builddir@#$PWD#" tests/wrappl.in
    sed -i "s#@abs_top_srcdir@#$PWD#" tests/wrappl.in
