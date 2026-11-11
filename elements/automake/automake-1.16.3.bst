kind: manual
(@): elements/gcc/tools-new.yml

description: |
  automake 1.16.3, bootstrapped by autoconf 2.69 and automake 1.15, with the manual that is not reproducible left out.

build-depends:
  (>):
  - help2man/help2man-1.36.4.bst
  - perl/perl-5.18.4.bst

runtime-depends:
- autoconf/autoconf-2.69.bst

sources:
- kind: tar
  url: "kernel-mirror:gnu/automake/automake-1.16.3.tar.xz"
  ref: ff2bf7656c4d1c6fdda3b8bebb21f09153a736bcba169aaf65eab25fa113bf3a

variables:
  lb: "%{libdir}/live-bootstrap/automake-1.16.3"

config:
  configure-commands:
  - |
    chmod -R u+w .
    rm doc/amhello-1.0.tar.gz
    sed -i "/^dist_doc_DATA =/d" doc/local.mk
    AUTOMAKE=automake-1.15 ACLOCAL=aclocal-1.15 AUTOCONF=autoconf-2.69 AUTOM4TE=autom4te-2.69 ./bootstrap
    rm doc/automake-history.info doc/automake.info*
    grep "DO NOT EDIT BY HAND" -r t -l | while read f; do
        rm "$f"
    done
    cp "%{prefix}/bin/help2man" doc/
    perl ./gen-testsuite-part --srcdir . > t/testsuite-part.am
    touch Makefile.in # timestamps for make rules
    AUTOCONF=autoconf-2.69 ./configure --prefix="%{prefix}"
  build-commands:
  - |
    make MAKEINFO=true
  install-commands:
  - |
    make install MAKEINFO=true DESTDIR="%{install-root}"
