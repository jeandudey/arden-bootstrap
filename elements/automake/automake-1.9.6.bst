kind: manual
(@): elements/automake/automake.yml

description: |
  automake 1.9.6, configured and built by the autoconf and the automake before
  it, as live-bootstrap does, without the programs that would hide those
  of the version before.

build-depends:
  (>):
  - autoconf/autoconf-2.61.bst
  - automake/automake-1.8.5.bst

runtime-depends:
- autoconf/autoconf-2.61.bst

sources:
- kind: tar
  url: "kernel-mirror:gnu/automake/automake-1.9.6.tar.bz2"
  ref: 8eccaa98e1863d10e4a5f861d8e2ec349a23e88cb12ad10f6b6f79022ad2bb8d

variables:
  am-autoconf: autoconf-2.61
  am-prepare: |
    rm doc/automake.info*
    sed -i 's/1.8a/1.8.5/; s/ filename-length-max=99//' configure.ac
    AUTOMAKE=automake-1.8 ACLOCAL=aclocal-1.8 AUTOM4TE=autom4te-2.61 AUTOCONF=autoconf-2.61 autoreconf-2.61 -f
