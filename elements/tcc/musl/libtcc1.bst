kind: manual
(@): elements/tcc/target.yml

description: |
  libtcc1.a for the tcc that is built against musl, from tcc's own sources.

build-depends:
- bash/bash.bst
- coreutils/coreutils.bst
- musl/musl-0.bst
- tcc/musl/tcc.bst
- tcc/source.bst

config:
  build-commands:
  - |
    for o in %{tcc-libtcc1-objects}; do
      tcc -c -D TCC_TARGET_%{tcc-target}=1 -o $o.o %{tcc-src}/lib/$o.c
      objects="$objects $o.o"
    done
    tcc -ar cr libtcc1.a $objects
  install-commands:
  - |
    mkdir -p %{install-root}%{libdir}/tcc
    cp libtcc1.a %{install-root}%{libdir}/tcc/libtcc1.a
