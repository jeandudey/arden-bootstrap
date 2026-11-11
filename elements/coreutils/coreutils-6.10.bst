kind: make

description: |
  coreutils 6.10, built by make and the tcc that is built against musl, with
  the makefile live-bootstrap ships: only date, mktemp and sha256sum, which are
  what 5.0 does not have.  The date parser is made by bison.

build-depends:
- bash/bash.bst
- bison/bison.bst
- coreutils/coreutils-5.0.bst
- live-bootstrap/source.bst
- make/make.bst
- sed/sed.bst
- tcc/musl/toolchain.bst

sources:
- kind: tar
  url: "kernel-mirror:gnu/coreutils/coreutils-6.10.tar.lzma"
  ref: 8b05bba1b2726a164e444c314e3f359604b58216be704bed8f2e028449cc6204

variables:
  make: make -j1 -f Makefile %{make-args}
  make-install: make -j1 -f Makefile %{make-args} install DESTDIR="%{install-root}"
  make-args: PREFIX=%{prefix}

config:
  build-commands:
    (<):
    - |
      mv lib/fnmatch.in.h lib/fnmatch.h
      rm lib/iconv_open-hpux.h lib/iconv_open-aix.h lib/iconv_open-irix.h lib/iconv_open-osf.h
      rm lib/getdate.c
      (cd lib
      bison --update getdate.y
      bison getdate.y
      mv getdate.tab.c getdate.c)
      touch config.h lib/configmake.h
      cp %{libdir}/live-bootstrap/coreutils-6.10/mk/main.mk Makefile
      # musl has readlink, and the copy in lib declares it differently.
      sed -i 's/ readlink / /' Makefile
