kind: manual
(@): elements/automake/automake.yml

description: |
  automake 1.8.5, configured and built by the autoconf and the automake before
  it, as live-bootstrap does, without the programs that would hide those
  of the version before.

build-depends:
  (>):
  - autoconf/autoconf-2.59.bst
  - automake/automake-1.7.8.bst

runtime-depends:
- autoconf/autoconf-2.59.bst

sources:
- kind: tar
  url: "kernel-mirror:gnu/automake/automake-1.8.5.tar.bz2"
  ref: 84c93aaa3c3651a9e7474b721b0e6788318592509e7de604bafe4ea8049dc410

variables:
  am-autoconf: autoconf-2.59
  am-prepare: |
    rm doc/automake.info*
    AUTOMAKE=automake-1.7 ACLOCAL=aclocal-1.7 AUTOCONF=autoconf-2.59 autoreconf-2.59 -f
