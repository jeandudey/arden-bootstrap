kind: manual
(@): elements/gcc/tools-new.yml

description: |
  file 5.44, built as a static library and program by gcc 4.7.4, with the test files left out and its configure made again.

build-depends:
  (>):
  - autoconf/autoconf-2.71.bst
  - automake/automake-1.16.3.bst
  - perl/perl-5.42.0.bst

sources:
- kind: tar
  url: "astron:pub/file/file-5.44.tar.gz"
  ref: 3751c7fba8dbc831cb8d7cc8aff21035459b8ce5155ef8b0880a27d028475f3b

variables:
  lb: "%{libdir}/live-bootstrap/file-5.44"

config:
  configure-commands:
  - |
    chmod -R u+w .
    
    rm tests/*.testfile
    AUTOMAKE=automake-1.15 ACLOCAL=aclocal-1.15 autoreconf-2.69 -fi
    CFLAGS="-std=gnu99" \
    ./configure --prefix="%{prefix}" \
        --libdir="%{libdir}" \
        --disable-shared
  build-commands:
  - |
    make
  install-commands:
  - |
    make -f Makefile install PREFIX=%{prefix} DESTDIR=%{install-root}
