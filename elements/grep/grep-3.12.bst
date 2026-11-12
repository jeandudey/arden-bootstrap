kind: manual
(@):
- elements/gcc/tools-new.yml
- elements/gnulib/unicode-16.0.0.yml

description: |
  grep 3.12, built by gcc 4.7.4 with its gnulib imported by the script
  live-bootstrap has, after the Unicode tables of gnulib are made again.

build-depends:
  (>):
  - autoconf/autoconf-2.71.bst
  - automake/automake-1.16.3.bst
  - gettext/gettext-0.26.bst
  - gzip/gzip.bst
  - libtool/libtool-2.4.7.bst
  - perl/perl-5.42.0.bst

sources:
  (>):
  - kind: tar
    url: "kernel-mirror:gnu/grep/grep-3.12.tar.xz"
    ref: 2649b27c0e90e632eadcd757be06c6e9a4f48d941de51e7c0f83ff76408a07b9
    directory: grep-3.12
  - kind: tar
    url: "github:coreutils/gnulib/archive/3773db6.tar.gz"
    ref: 5a49898fa69632cae1877241a40d421a88be7c5b863f97ec39ee28cac871c457
    directory: gnulib-3773db6

variables:
  lb: "%{libdir}/live-bootstrap/grep-3.12"
  command-subdir: grep-3.12

config:
  configure-commands:
  - |
    chmod -R u+w ..
    find gnulib-tests -not -name Makefile.am -delete
    rm doc/grep.info po/*.gmo
    find . \( -name Makefile.in -o -name configure \) -delete
    autopoint -f
    libtoolize -fi
    sed 's/^local //; s#$(realpath \(\.\./gnulib-3773db6\))#$(cd \1 \&\& pwd)#' %{lb}/import-gnulib.sh > ../import-gnulib.sh
    bash ../import-gnulib.sh
    AUTOPOINT=true LIBTOOLIZE=true AUTOMAKE=automake-1.16 ACLOCAL=aclocal-1.16 autoreconf-2.71 -fi
    ./configure --prefix=%{prefix}
  build-commands:
  - make MAKEINFO=true
  install-commands:
  - make MAKEINFO=true DESTDIR=%{install-root} install
