kind: exec

description: |
  gzip 1.2.4, built by make and tcc as live-bootstrap does: its stat override
  and its CRC table, which a helper program writes, are put into the sources.

build-depends:
- stage0/catm.bst
- stage0/chmod.bst
- stage0/cp.bst
- stage0/mkdir.bst
- gzip/files.bst
- gzip/source.bst
- live-bootstrap/source.bst
- make/make.bst
- patch/patch.bst
- tcc/tcc.bst

variables:
  libdir: "%{prefix}/lib"
  lb-gzip: "%{libdir}/live-bootstrap/gzip-1.2.4"

config:
  commands:
  - cd: "%{libdir}/gzip-src"
  - cp %{lb-gzip}/mk/main.mk Makefile
  - catm gzip.c.new %{libdir}/gzip-files/stat_override.c gzip.c
  - cp gzip.c.new gzip.c
  - patch -Np1 -i %{lb-gzip}/patches/removecrc.patch
  - patch -Np1 -i %{lb-gzip}/patches/makecrc-write-to-file.patch
  - tcc -static -o makecrc sample/makecrc.c
  - ./makecrc
  - catm util.c.new util.c crc.c
  - cp util.c.new util.c
  - make
  - cp gzip gunzip
  install:
  - from: "%{libdir}/gzip-src"
    to: "%{bindir}"
    files:
    - gzip
    - gunzip
    mode: "755"
