kind: exec

description: |
  sed 4.0.9, built by make and the tcc of the Mes world, against the Mes C
  library, with the makefile live-bootstrap ships.

build-depends:
- stage0/catm.bst
- stage0/chmod.bst
- stage0/cp.bst
- stage0/mkdir.bst
- live-bootstrap/source.bst
- make/make.bst
- sed/source.bst
- tcc/tcc.bst

variables:
  libdir: "%{prefix}/lib"
  # Without these sed declares malloc, getenv and the string functions
  # implicitly, as returning int, which truncates the pointers they return on
  # x86_64, and uses index for strchr.
  sed-cflags: -I . -I lib -DHAVE_STDLIB_H=1 -DHAVE_STRING_H=1 -DHAVE_STRCHR=1 -DHAVE_UNISTD_H=1

config:
  commands:
  - cd: "%{libdir}/sed-src"
  - cp %{libdir}/live-bootstrap/sed-4.0.9/mk/main.mk Makefile
  - catm config.h
  - make -f Makefile LIBC=mes "CFLAGS=%{sed-cflags}"
  install:
  - from: "%{libdir}/sed-src/sed"
    to: "%{bindir}"
    files:
    - sed
    mode: "755"
