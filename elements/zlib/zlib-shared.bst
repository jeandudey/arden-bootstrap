kind: manual
(@): elements/gcc/tools-new.yml

build-depends:
  (>):
  - musl/musl-1.2.5.bst

description: |
  zlib 1.3.1, built by gcc with its shared library as well as the static one,
  for what is loaded with dlopen, with the tables that came with it made again
  by programs built from its own sources.

sources:
- kind: tar
  url: "zlib:fossils/zlib-1.3.1.tar.gz"
  ref: 9a93b2b7dfdac77ceba5a558a580e74667dd6fede4585b91eefb60f03b72df23

config:
  configure-commands:
  - |
    rm zlib.3.pdf doc/crc-doc.1.0.pdf contrib/puff/zeros.raw contrib/blast/test.pk \
      contrib/dotzlib/DotZLib.chm
    rm crc32.h
    gcc -DMAKECRCH crc32.c -o gen_crc32h
    ./gen_crc32h
    echo "void makefixed(void); int main() { makefixed(); }" > makefixed_main.c
    gcc -DMAKEFIXED inflate.c crc32.c zutil.c inftrees.c \
      adler32.c inffast.c makefixed_main.c -o gen_inffixedh
    ./gen_inffixedh > inffixed.h
    echo "void makefixed9(void); int main() { makefixed9(); }" > makefixed9_main.c
    gcc -DMAKEFIXED -I. contrib/infback9/infback9.c zutil.c \
      contrib/infback9/inftree9.c makefixed9_main.c -o gen_inffix9h
    ./gen_inffix9h > contrib/infback9/inffix9.h
    ./configure --prefix=%{prefix} --libdir=%{libdir} 
  build-commands:
  - make
  install-commands:
  - make DESTDIR=%{install-root} install
