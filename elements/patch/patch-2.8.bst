kind: manual
(@):
- elements/gcc/tools-new.yml
- elements/gnulib/unicode-16.0.0.yml

description: |
  patch 2.8, built by gcc 4.7.4 with its gnulib imported by the script
  live-bootstrap has, after the Unicode tables of gnulib are made again, and
  its date parser made again by bison.

build-depends:
  (>):
  - autoconf/autoconf-2.71.bst
  - automake/automake-1.16.3.bst
  - bison/bison-3.8.2.bst
  - coreutils/coreutils-9.4.bst
  - gettext/gettext-0.26.bst
  - libtool/libtool-2.4.7.bst
  - perl/perl-5.42.0.bst

sources:
  (>):
  - kind: tar
    url: "kernel-mirror:gnu/patch/patch-2.8.tar.xz"
    ref: f87cee69eec2b4fcbf60a396b030ad6aa3415f192aa5f7ee84cad5e11f7f5ae3
    directory: patch-2.8
  - kind: tar
    url: "github:coreutils/gnulib/archive/9829f0a.tar.gz"
    ref: 50380e3d1a9f8bfdf7560b1161fe2aa466ff593de60921d7248bc2799ddef9c9
    directory: gnulib-9829f0a

variables:
  lb: "%{libdir}/live-bootstrap/patch-2.8"
  command-subdir: patch-2.8

config:
  configure-commands:
  - |
    chmod -R u+w ..
    rm lib/unictype/ctype_print.h
    bash %{lb}/import-gnulib.sh
    rm lib/parse-datetime.c
    AUTOPOINT=true autoreconf -fi
    LDFLAGS=-static ./configure --prefix=%{prefix}
  build-commands:
  - make MAKEINFO=true
  install-commands:
  - make install MAKEINFO=true DESTDIR=%{install-root}
