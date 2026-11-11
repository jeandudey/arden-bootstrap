kind: exec

description: |
  coreutils 5.0, built by make and tcc with the makefile and the patches
  live-bootstrap ships, and installed by the install it builds.

build-depends:
- coreutils/source.bst
- live-bootstrap/source.bst
- make/make.bst
- patch/patch.bst
- sed/sed-0.bst
- stage0/catm.bst
- stage0/chmod.bst
- stage0/cp.bst
- stage0/mkdir.bst
- stage0/rm.bst
- tcc/tcc.bst

variables:
  libdir: "%{prefix}/lib"
  lb-coreutils: "%{libdir}/live-bootstrap/coreutils-5.0"

config:
  dirs:
  - "%{install-root}%{bindir}"
  commands:
  - cd: "%{libdir}/coreutils-src"
  - cp %{lb-coreutils}/mk/main.mk Makefile
  - cp lib/fnmatch_.h lib/fnmatch.h
  - cp lib/ftw_.h lib/ftw.h
  - cp lib/search_.h lib/search.h
  - catm config.h
  - rm src/false.c src/dircolors.h
  - patch -Np1 -i %{lb-coreutils}/patches/modechange.patch
  - patch -Np1 -i %{lb-coreutils}/patches/mbstate.patch
  - patch -Np1 -i %{lb-coreutils}/patches/ls-strcmp.patch
  - patch -Np1 -i %{lb-coreutils}/patches/touch-getdate.patch
  - patch -Np1 -i %{lb-coreutils}/patches/touch-dereference.patch
  - patch -Np1 -i %{lb-coreutils}/patches/tac-uint64.patch
  - patch -Np1 -i %{lb-coreutils}/patches/expr-strcmp.patch
  - patch -Np1 -i %{lb-coreutils}/patches/sort-locale.patch
  - patch -Np1 -i %{lb-coreutils}/patches/uniq-fopen.patch
  - make -f Makefile PREFIX=%{prefix}
  - make -f Makefile PREFIX=%{prefix} bindir=%{install-root}%{bindir} install
