kind: exec

description: |
  bzip2 1.0.8, built by make and the tcc of the Mes world, with the two
  patches live-bootstrap applies for the Mes C library.

build-depends:
- bzip2/source.bst
- stage0/chmod.bst
- stage0/cp.bst
- stage0/mkdir.bst
- stage0/rm.bst
- live-bootstrap/source.bst
- make/make.bst
- patch/patch.bst
- tcc/tcc.bst

variables:
  libdir: "%{prefix}/lib"
  lb-bzip2: "%{libdir}/live-bootstrap/bzip2-1.0.8"

config:
  commands:
  - cd: "%{libdir}/bzip2-src"
  - patch -Np1 -i %{lb-bzip2}/patches/mes-libc.patch
  - patch -Np1 -i %{lb-bzip2}/patches/coreutils.patch
  - make CC=tcc "AR=tcc -ar" LDFLAGS=-static bzip2
  - cp bzip2 bunzip2
  - ./bzip2 --help
  install:
  - from: "%{libdir}/bzip2-src"
    to: "%{bindir}"
    files:
    - bzip2
    - bunzip2
    mode: "755"
