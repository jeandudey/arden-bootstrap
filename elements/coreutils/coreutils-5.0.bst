kind: make

description: |
  coreutils 5.0 again, built by make and the tcc that is built against musl,
  with live-bootstrap's second makefile.  The date parser of touch is still
  left out, as bison is not yet there to make getdate.c with.

build-depends:
- bash/bash.bst
- coreutils/coreutils-5.0-mes.bst
- live-bootstrap/source.bst
- make/make.bst
- patch/patch.bst
- sed/sed-4.0.9-mes.bst
- tcc/musl/toolchain.bst

sources:
- kind: tar
  url: "kernel-mirror:gnu/coreutils/coreutils-5.0.tar.bz2"
  ref: c25b36b8af6e0ad2a875daf4d6196bd0df28a62be7dd252e5f99a4d5d7288d95

variables:
  lb-coreutils: "%{libdir}/live-bootstrap/coreutils-5.0"
  make: make -j1 -f Makefile %{make-args}
  make-install: make -j1 -f Makefile %{make-args} install DESTDIR="%{install-root}"
  make-args: PREFIX=%{prefix}

config:
  build-commands:
    (<):
    - |
      cp lib/fnmatch_.h lib/fnmatch.h
      cp lib/ftw_.h lib/ftw.h
      cp lib/search_.h lib/search.h
      touch config.h
      rm -f src/false.c src/dircolors.h src/wheel.h lib/getdate.c
      for p in %{lb-coreutils}/patches-pass2/*.patch; do patch -Np1 -i $p; done
      cp %{lb-coreutils}/mk/pass2.mk Makefile
      sed -i 's/ getline / /' Makefile
      sed -i 's/__GLIBC__ < 2/0/' lib/getline.h
