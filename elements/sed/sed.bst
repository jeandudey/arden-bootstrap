kind: make

description: |
  sed 4.0.9 again, built by make and the tcc that is built against musl, with
  the makefile live-bootstrap ships.

build-depends:
- bash/bash.bst
- coreutils/coreutils-5.0-mes.bst
- live-bootstrap/source.bst
- make/make.bst
- tcc/musl/toolchain.bst

sources:
- kind: tar
  url: "kernel-mirror:gnu/sed/sed-4.0.9.tar.gz"
  ref: c365874794187f8444e5d22998cd5888ffa47f36def4b77517a808dec27c0600

variables:
  # Without these sed declares malloc, getenv and the string functions
  # implicitly, as returning int, which truncates the pointers they return on
  # x86_64, and uses index for strchr.
  make-args: >-
    PREFIX="%{prefix}"
    "CFLAGS=-I . -I lib -DHAVE_STDLIB_H=1 -DHAVE_STRING_H=1 -DHAVE_STRCHR=1 -DHAVE_UNISTD_H=1"

config:
  build-commands:
    (<):
    - cp %{libdir}/live-bootstrap/sed-4.0.9/mk/main.mk Makefile
    - touch config.h
