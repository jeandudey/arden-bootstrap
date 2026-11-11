kind: manual
(@): elements/automake/automake.yml

description: |
  automake 1.7, configured and built by the autoconf and the automake before
  it, as live-bootstrap does, without the programs that would hide those
  of the version before.

build-depends:
  (>):
  - autoconf/autoconf-2.53.bst
  - automake/automake-1.6.3.bst

sources:
- kind: tar
  url: "kernel-mirror:gnu/automake/automake-1.7.tar.bz2"
  ref: 6633ee1202375e3c8798a92e1b7f46894f78d541aeea7f49654503fdc0b28835

variables:
  am-autoconf: autoconf-2.53
  am-prepare: |
    rm -- configure Makefile.in */Makefile.in */*/Makefile.in aclocal.m4 automake.info*
    sed -i -e 's/2.54/2.53/' -e '/AC_PROG_EGREP/d' -e '/AC_PROG_FGREP/d' configure.in
    aclocal-1.6
    autoconf-2.53
    automake-1.6
