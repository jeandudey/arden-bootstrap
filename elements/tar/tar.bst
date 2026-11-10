kind: exec

description: |
  tar 1.12, built by make and tcc as live-bootstrap does, with its stat
  override and a stub for the date parser.

build-depends:
- stage0/catm.bst
- stage0/chmod.bst
- stage0/cp.bst
- stage0/mkdir.bst
- live-bootstrap/source.bst
- make/make.bst
- tar/files.bst
- tar/source.bst
- tcc/tcc.bst

variables:
  libdir: "%{prefix}/lib"
  lb-tar: "%{libdir}/live-bootstrap/tar-1.12"

config:
  commands:
  - cd: "%{libdir}/tar-src"
  - cp %{lb-tar}/mk/main.mk Makefile
  - cp %{lb-tar}/files/getdate_stub.c lib/getdate_stub.c
  - catm src/create.c.new %{libdir}/tar-files/stat_override.c src/create.c
  - cp src/create.c.new src/create.c
  - make -f Makefile
  install:
  - from: "%{libdir}/tar-src"
    to: "%{bindir}"
    files:
    - tar
    mode: "755"
