kind: manual
(@): elements/gcc/tools-4.7.4.yml

description: |
  bash 5.2.15, built by gcc 4.7.4 and linked static, with the files that
  bison made taken out and its configure made again.  Its documents are not
  built, and the device files are told to configure so that the output does
  not depend on them.

build-depends:
  (>):
  - bison/bison.bst

sources:
- kind: tar
  url: "kernel-mirror:gnu/bash/bash-5.2.15.tar.gz"
  ref: 13720965b5f4fc3a0d4b61dd37e7565c741da9a5be24edc2ae00182fc1b3588c

config:
  configure-commands:
  - |
    rm y.tab.c y.tab.h
    rm po/*.gmo
    mv doc/Makefile.in Makefile.in.doc
    rm doc/*
    mv Makefile.in.doc doc/Makefile.in
    rm lib/sh/strtoimax.c
    touch lib/sh/strtoimax.c
    rm configure
    autoconf-2.69
    printf '%s\n%s\n' '#!/bin/sh' 'echo "#define PIPESIZE 65536"' > builtins/psize.sh
    ./configure --prefix=%{prefix} --without-bash-malloc --disable-nls \
      --build=%{triple-musl} --enable-static-link \
      bash_cv_dev_stdin=absent bash_cv_dev_fd=whacky
  build-commands:
  - make
  install-commands:
  - |
    install -D bash %{install-root}%{bindir}/bash
    install bash %{install-root}%{bindir}/sh
    ln -s usr/bin %{install-root}/bin
