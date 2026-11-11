kind: manual
(@): elements/gcc/tools-4.7.4.yml

description: |
  binutils 2.41, built by gcc 4.7.4 as live-bootstrap does it: everything that
  is generated is made again by bison, flex, autoconf 2.69 and automake 1.15,
  and each directory is configured and built by itself, with the system zlib.

build-depends:
  (>):
  - automake/automake-1.11.2.bst
  - bison/bison.bst
  - live-bootstrap/source.bst
  - patch/patch.bst
  - zlib/zlib.bst

sources:
- kind: tar
  url: "kernel-mirror:gnu/binutils/binutils-2.41.tar.xz"
  ref: ae9a5789e23459e59606e6714723f2d3ffc31c03174191ef0d015bdf06007450

variables:
  lb-binutils: "%{libdir}/live-bootstrap/binutils-2.41"
  autoreconf: AUTOPOINT=true ACLOCAL=aclocal-1.15 AUTOMAKE=automake-1.15 autoreconf-2.69 -fi
  binutils-dirs: libiberty libsframe bfd opcodes libctf binutils gas gprof ld

config:
  configure-commands:
  - |
    chmod -R u+w .
    for p in %{lb-binutils}/patches/*.patch; do patch -Np1 -i $p; done
    rm etc/Makefile.in etc/configure
    rm -r gprofng zlib
    touch -- */*.y
    rm binutils/arparse.c binutils/arparse.h binutils/defparse.c \
      binutils/defparse.h binutils/mcparse.c binutils/mcparse.h \
      binutils/rcparse.c binutils/rcparse.h binutils/sysinfo.c \
      binutils/sysinfo.h gas/config/bfin-parse.c gas/config/bfin-parse.h \
      gas/config/loongarch-parse.c gas/config/loongarch-parse.h \
      gas/config/m68k-parse.c gas/config/rl78-parse.c \
      gas/config/rl78-parse.h gas/config/rx-parse.c gas/config/rx-parse.h \
      gas/itbl-parse.c gas/itbl-parse.h gold/yyscript.c gold/yyscript.h \
      intl/plural.c ld/deffilep.c ld/deffilep.h ld/ldgram.c ld/ldgram.h
    touch -- */*.l */*/*.l
    rm binutils/arlex.c binutils/deflex.c binutils/syslex.c \
      gas/config/bfin-lex.c gas/config/loongarch-lex.c gas/itbl-lex.c \
      ld/ldlex.c
    find . -type f -name '*.info*' -not -wholename './binutils/sysroff.info' -delete
    find . -type f \( -name '*.1' -or -name '*.man' \) -delete
    rm libiberty/functions.texi
    find . -type f -name '*.gmo' -delete
    rm opcodes/i386-init.h opcodes/i386-tbl.h opcodes/i386-mnem.h \
      opcodes/ia64-asmtab.c opcodes/z8k-opc.h opcodes/aarch64-asm-2.c \
      opcodes/aarch64-opc-2.c opcodes/aarch64-dis-2.c \
      opcodes/msp430-decode.c opcodes/rl78-decode.c opcodes/rx-decode.c
    rm $(grep -l 'MACHINE GENERATED' opcodes/*.c opcodes/*.h)
    rm ld/emultempl/*.o_c
    rm gprof/bsd_callg_bl.c gprof/flat_bl.c gprof/fsf_callg_bl.c
    rm bfd/libcoff.h bfd/libbfd.h bfd/go32stub.h bfd/bfd-in2.h
    rm libsframe/testsuite/libsframe.decode/DATA* \
      ld/testsuite/ld-x86-64/*.obj.bz2 ld/testsuite/ld-sh/arch/*.s \
      ld/testsuite/ld-sh/arch/arch_expected.txt \
      ld/testsuite/ld-i386/pr27193a.o.bz2 \
      gas/testsuite/gas/xstormy16/allinsn.sh \
      gas/testsuite/gas/tic4x/opcodes.s gas/testsuite/gas/sh/arch/*.s \
      gas/testsuite/gas/sh/arch/arch_expected.txt \
      binutils/testsuite/binutils-all/x86-64/pr22451.o.bz2 \
      binutils/testsuite/binutils-all/x86-64/pr26808.dwp.bz2 \
      binutils/testsuite/binutils-all/x86-64/pr27708.exe.bz2 \
      binutils/testsuite/binutils-all/nfp/*.nffw \
      binutils/testsuite/binutils-all/pr26112.o.bz2 \
      binutils/testsuite/binutils-all/pr26160.dwp.bz2
    (cd libiberty
    sed -n '/^   #include <stdio.h>/,/^   \}$/p' crc32.c > crcgen.c
    gcc -o crcgen crcgen.c
    sed '/crc_v3\.txt/{n; q}' crc32.c > crc32.c.new
    ./crcgen >> crc32.c.new
    sed '1,/^};$/d' crc32.c >> crc32.c.new
    mv crc32.c.new crc32.c)
    (cd bfd
    cp configure.ac configure.ac.bak
    sed -i "s/bfd-in3.h:bfd-in2.h //" configure.ac
    %{autoreconf}
    ./configure
    make headers
    mv configure.ac.bak configure.ac
    make distclean)
    for dir in bfd binutils gas gold gprof intl ld libctf libiberty libsframe opcodes; do
      (cd $dir && %{autoreconf})
    done
    rm Makefile.in
    ACLOCAL=aclocal-1.15 autoreconf-2.69 -fi
    (cd libiberty
    ./configure --enable-maintainer-mode
    make maint-deps
    make distclean)
    ./bfd/mep-relocs.pl
    for dir in intl libctf libiberty libsframe opcodes bfd binutils gas gprof ld; do
      (cd $dir
      ./configure \
        --disable-nls --disable-shared --disable-plugins --enable-install-libiberty --enable-deterministic-archives \
        --with-system-zlib \
        --build=%{triple-musl} --host=%{triple-musl} --target=%{triple-musl} \
        --program-prefix= --prefix=%{prefix} --libdir=%{libdir} \
        --with-sysroot= --srcdir=.)
    done
  build-commands:
  - |
    make -C bfd headers
    for dir in %{binutils-dirs}; do
      make -C $dir tooldir=%{prefix} CFLAGS=-std=c99 MAKEINFO=true
    done
  install-commands:
  - |
    for dir in libiberty bfd opcodes libctf libsframe binutils gas gprof ld; do
      make -C $dir tooldir=%{prefix} DESTDIR=%{install-root} MAKEINFO=true install
    done
    cd %{install-root}%{bindir}
    for f in *; do
      ln -s %{bindir}/$f %{triple-musl}-$f
    done
    rm -r %{install-root}%{prefix}/share/man
