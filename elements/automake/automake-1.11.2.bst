kind: manual
(@): elements/automake/automake-bootstrap.yml

description: |
  automake 1.11.2, bootstrapped, configured and built by the autoconf and the
  automake before it, as live-bootstrap does, without the programs that
  would hide those of the version before.

build-depends:
  (>):
  - autoconf/autoconf-2.64.bst
  - automake/automake-1.10.3.bst

runtime-depends:
- autoconf/autoconf-2.64.bst

sources:
- kind: tar
  url: "kernel-mirror:gnu/automake/automake-1.11.2.tar.bz2"
  ref: 4f46d1f9380c8a3506280750f630e9fc915cb1a435b724be56b499d016368718

variables:
  am-remove: "automake"
  am-env: >-
    AUTORECONF=autoreconf-2.64 AUTOM4TE=autom4te-2.64 AUTOHEADER=autoheader-2.64 AUTOCONF=autoconf-2.64
  am-prepare: |
    patch -Np1 -i %{libdir}/live-bootstrap/automake-1.11.2/patches/aclocal_glob.patch
    rm -f doc/amhello-1.0.tar.gz doc/automake.info* doc/aclocal-1.11.1 doc/automake-1.11.1
    rm tests/parallel-tests.am
    awk '/SUBDIRS/{sub("doc ", "", $0)} {print}' Makefile.am > Makefile.am.tmp
    mv Makefile.am.tmp Makefile.am
    export AUTOCONF=autoconf-2.64 AUTOM4TE=autom4te-2.64
