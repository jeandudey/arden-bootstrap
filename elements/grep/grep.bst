kind: make

description: |
  grep 2.4, built by make and the tcc that is built against musl, with the
  makefile live-bootstrap ships; egrep and fgrep are links to it.

build-depends:
- bash/bash.bst
- coreutils/coreutils-0.bst
- live-bootstrap/source.bst
- make/make.bst
- tcc/musl/toolchain.bst

sources:
- kind: tar
  url: "kernel-mirror:gnu/grep/grep-2.4.tar.gz"
  ref: a32032bab36208509466654df12f507600dfe0313feebbcd218c32a70bf72a16

variables:
  # Without these grep declares strerror and the string functions implicitly,
  # as returning int, which truncates the pointers they return on x86_64.
  make-args: >-
    PREFIX="%{prefix}"
    CPPFLAGS="-DSTDC_HEADERS=1 -DHAVE_STRING_H=1 -DHAVE_STDLIB_H=1"

config:
  build-commands:
    (<):
    - cp %{libdir}/live-bootstrap/grep-2.4/mk/main.mk Makefile
