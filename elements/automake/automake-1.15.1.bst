kind: manual
(@): elements/automake/automake-bootstrap.yml

description: |
  automake 1.15.1, bootstrapped, configured and built by the autoconf and the
  automake before it, as live-bootstrap does, without the programs that
  would hide those of the version before.

build-depends:
  (>):
  - autoconf/autoconf-2.69.bst
  - automake/automake-1.11.2.bst

runtime-depends:
- autoconf/autoconf-2.69.bst

sources:
- kind: tar
  url: "kernel-mirror:gnu/automake/automake-1.15.1.tar.xz"
  ref: af6ba39142220687c500f79b4aa2f181d9b24e4f8d8ec497cea4ba26c64bedaf

variables:
  am-remove: "automake aclocal"
  am-env: >-
    AUTORECONF=autoreconf-2.69 AUTOM4TE=autom4te-2.69 AUTOHEADER=autoheader-2.69 AUTOCONF="autoconf-2.69 -f"
  am-prepare: |
    patch -Np1 -i %{libdir}/live-bootstrap/automake-1.15.1/patches/aclocal_glob.patch
    patch -Np1 -i %{libdir}/live-bootstrap/automake-1.15.1/patches/bootstrap.patch
    patch -Np1 -i %{libdir}/live-bootstrap/automake-1.15.1/patches/shellcheck-bypass.patch
    rm doc/amhello-1.0.tar.gz doc/automake-history.info doc/automake.info*
    grep "DO NOT EDIT BY HAND" -r t -l | while read f; do
      rm "$f"
    done
    sed -i '/doc\/Makefile.inc/d' Makefile.am
    sed -i '/t\/Makefile.inc/d' Makefile.am
    export AUTOCONF="autoconf-2.69 -f" AUTOM4TE=autom4te-2.69
