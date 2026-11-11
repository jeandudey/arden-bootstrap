kind: make

description: |
  gawk 3.0.4, built by make and the tcc that is built against musl, with the
  makefile live-bootstrap ships.  Its parser is made again by bison.

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
  url: "kernel-mirror:gnu/gawk/gawk-3.0.4.tar.gz"
  ref: 5cc35def1ff4375a8b9a98c2ff79e95e80987d24f0d42fdbb7b7039b3ddb3fb0

variables:
  make: make -j1 -f Makefile %{make-args}
  make-install: make -j1 -f Makefile %{make-args} install DESTDIR="%{install-root}"
  make-args: PREFIX=%{prefix}

config:
  build-commands:
    (<):
    - |
      rm awktab.c pc/config.h
      cp %{libdir}/live-bootstrap/gawk-3.0.4/mk/main.mk Makefile
      # The tcc has alloca, and musl declares it differently from the one in the sources.
      sed -i -e 's/ -DC_ALLOCA=1//' -e 's/= alloca /= /' -e 's/-DSTDC_HEADERS=1/& -DHAVE_ALLOCA_H=1/' Makefile
  install-commands:
    (>):
    - |
      install -d %{install-root}%{prefix}/share/awk
      for file in awklib/eg/lib/*.awk; do
        install -m 644 $file %{install-root}%{prefix}/share/awk
      done
