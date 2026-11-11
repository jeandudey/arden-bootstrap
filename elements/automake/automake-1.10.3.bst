kind: manual
(@): elements/automake/automake-bootstrap.yml

description: |
  automake 1.10.3, bootstrapped, configured and built by the autoconf and the
  automake before it, as live-bootstrap does, without the programs that
  would hide those of the version before.

build-depends:
  (>):
  - autoconf/autoconf-2.61.bst
  - automake/automake-1.9.6.bst

runtime-depends:
- autoconf/autoconf-2.61.bst

sources:
- kind: tar
  url: "kernel-mirror:gnu/automake/automake-1.10.3.tar.bz2"
  ref: e98ab43bb839c31696a4202e5b6ff388b391659ef2387cf9365019fad17e1adc

variables:
  am-remove: "automake aclocal"
  am-env: >-
    AUTORECONF=autoreconf-2.61 AUTOHEADER=autoheader-2.61 AUTOCONF=autoconf-2.61 AUTOM4TE=autom4te-2.61 CC=tcc
  am-prepare: |
    patch -Np1 -i %{libdir}/live-bootstrap/automake-1.10.3/patches/aclocal_glob.patch
    rm doc/amhello-1.0.tar.gz doc/automake.info*
    awk '/SUBDIRS/{sub("doc ", "", $0)} {print}' Makefile.am > Makefile.am.tmp
    mv Makefile.am.tmp Makefile.am
    export AUTOM4TE=autom4te-2.61 AUTOCONF=autoconf-2.61 AUTOHEADER=autoheader-2.61 AUTORECONF=autoreconf-2.61
