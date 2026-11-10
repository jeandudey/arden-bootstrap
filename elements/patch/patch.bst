kind: exec

description: |
  patch 2.5.9, built by make and tcc with the makefile live-bootstrap ships.

build-depends:
- stage0/catm.bst
- stage0/chmod.bst
- stage0/cp.bst
- stage0/mkdir.bst
- live-bootstrap/source.bst
- make/make.bst
- patch/source.bst
- tcc/tcc.bst

variables:
  libdir: "%{prefix}/lib"
  # Without HAVE_VPRINTF patch prints through a vfprintf of its own that reads
  # the va_list as an array of ints, which is only so on 32-bit x86.
  patch-cflags: -I . -DHAVE_VPRINTF=1

config:
  commands:
  - cd: "%{libdir}/patch-src"
  - cp %{libdir}/live-bootstrap/patch-2.5.9/mk/main.mk Makefile
  - catm config.h
  - catm patchlevel.h
  - make -f Makefile PREFIX=%{prefix} "CFLAGS=%{patch-cflags}"
  install:
  - from: "%{libdir}/patch-src"
    to: "%{bindir}"
    files:
    - patch
    mode: "755"
