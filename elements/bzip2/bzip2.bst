kind: make

description: |
  bzip2 1.0.8 again, built by make and the tcc that is built against musl,
  without the patches for the Mes C library; bunzip2 and bzcat are links.

build-depends:
- bash/bash.bst
- coreutils/coreutils-5.0-mes.bst
- make/make.bst
- tcc/musl/toolchain.bst

sources:
- kind: tar
  url: "sourceware:pub/bzip2/bzip2-1.0.8.tar.gz"
  ref: ab5a03176ee106d3f0fa90e381da478ddae405918153cca248e682cd0c4a2269

variables:
  make: make CC=tcc "AR=tcc -ar" bzip2

config:
  install-commands:
  - |
    install -D bzip2 %{install-root}%{bindir}/bzip2
    ln -sf %{bindir}/bzip2 %{install-root}%{bindir}/bunzip2
    ln -sf %{bindir}/bzip2 %{install-root}%{bindir}/bzcat
