kind: manual
(@): elements/gcc/tools-new.yml

description: |
  gc 8.2.12, the Boehm collector, built as a static library by gcc 4.7.4, with the flags that musl needs.

build-depends:
  (>):
  - autoconf/autoconf-2.71.bst
  - automake/automake-1.16.3.bst
  - file/file-5.44.bst
  - perl/perl-5.42.0.bst
  - linux-headers/linux-headers-4.14.341.bst

sources:
- kind: tar
  url: "github:bdwgc/bdwgc/releases/download/v8.2.12/gc-8.2.12.tar.gz"
  ref: 42e5194ad06ab6ffb806c83eb99c03462b495d979cda782f3c72c08af833cd4e

variables:
  lb: "%{libdir}/live-bootstrap/gc-8.2.12"

config:
  configure-commands:
  - |
    chmod -R u+w .
    autoreconf-2.71 -fi
    ./configure \
        --prefix="%{prefix}" \
        --libdir="%{libdir}" \
        --disable-shared \
        CFLAGS='-D_GNU_SOURCE -DNO_GETCONTEXT -DSEARCH_FOR_DATA_START -DUSE_MMAP -DHAVE_DL_ITERATE_PHDR'
  build-commands:
  - |
    make
  install-commands:
  - |
    make -f Makefile install PREFIX=%{prefix} DESTDIR=%{install-root}
