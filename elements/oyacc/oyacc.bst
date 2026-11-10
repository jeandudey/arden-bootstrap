kind: exec

description: |
  oyacc 6.6, the yacc that live-bootstrap builds first, made by make and tcc
  with its makefile and two patches, and installed by the coreutils install.

build-depends:
- coreutils/coreutils.bst
- live-bootstrap/source.bst
- make/make.bst
- oyacc/source.bst
- patch/patch.bst
- stage0/catm.bst
- tcc/tcc.bst

variables:
  libdir: "%{prefix}/lib"
  lb-oyacc: "%{libdir}/live-bootstrap/oyacc-6.6"

config:
  dirs:
  - "%{install-root}%{bindir}"
  commands:
  - cd: "%{libdir}/oyacc-src"
  - cp %{lb-oyacc}/mk/main.mk Makefile
  - catm config.h
  - patch -Np1 -i %{lb-oyacc}/patches/meslibc.patch
  - patch -Np1 -i %{lb-oyacc}/patches/tcc.patch
  - make
  - make install DESTDIR=%{install-root}
