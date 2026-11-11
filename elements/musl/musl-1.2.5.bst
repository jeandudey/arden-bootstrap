kind: manual

description: |
  musl 1.2.5, built by the gcc 4.0.4 that is built by tcc, with the assembler
  and the linker of binutils.  The patches live-bootstrap has for it are for
  32 bits and not needed.

build-depends:
- bash/bash.bst
- binutils/binutils-2.30.bst
- coreutils/coreutils-5.0.bst
- gcc/gcc-4.0.4-pass0.bst
- grep/grep.bst
- make/make.bst
- musl/musl.bst
- sed/sed.bst

sources:
- kind: tar
  url: "musl:releases/musl-1.2.5.tar.gz"
  ref: a9a118bbe84d8764da0ea0d28b3ab3fae8477fc7e4085d90102b8596fc7c75e4

config:
  configure-commands:
  - |
    CC=gcc ./configure --host=%{triple} --disable-shared \
      --prefix=%{prefix} --libdir=%{libdir} --includedir=%{prefix}/include/
  build-commands:
  - make CROSS_COMPILE=
  install-commands:
  - make DESTDIR=%{install-root} install
