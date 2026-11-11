kind: manual

description: |
  binutils 2.30, built by the tcc that is built against musl as live-bootstrap
  does it: everything that is generated is made again, from the grammars, the
  scanners and the tables, by bison, flex, autoconf 2.64 and automake 1.11, and
  each directory is configured and built by itself.

build-depends:
- autoconf/autoconf-2.64.bst
- automake/automake-1.11.2.bst
- bash/bash.bst
- bison/bison.bst
- coreutils/coreutils-5.0.bst
- flex/flex.bst
- gawk/gawk.bst
- grep/grep.bst
- libtool/libtool-2.2.4.bst
- live-bootstrap/source.bst
- m4/m4.bst
- make/make.bst
- patch/patch.bst
- perl/perl-5.6.2.bst
- sed/sed.bst
- tar/tar.bst
- tcc/musl/toolchain.bst

sources:
- kind: tar
  url: "kernel-mirror:gnu/binutils/binutils-2.30.tar.xz"
  ref: 6e46b8aeae2f727a36f0bd9505e405768a72218f1796f0d09757d45209871ae6

variables:
  lb-binutils: "%{libdir}/live-bootstrap/binutils-2.30"
  autoreconf: AUTOPOINT=true ACLOCAL=aclocal-1.11 AUTOMAKE=automake-1.11 autoreconf-2.64 -fi
  # zlib is told to make its tables when it runs, and libiberty its crc table.
  binutils-cflags: -DBUILDFIXED=1 -DDYNAMIC_CRC_TABLE=1
  binutils-dirs: libiberty zlib bfd opcodes binutils gas gprof ld

config:
  configure-commands:
  - |
    chmod -R u+w .
    for p in %{lb-binutils}/patches/*.patch; do patch -Np1 -i $p; done
    rm etc/Makefile.in etc/configure
    touch -- */*.y
    rm binutils/arparse.c binutils/arparse.h binutils/defparse.c \
      binutils/defparse.h binutils/mcparse.c binutils/mcparse.h \
      binutils/nlmheader.c binutils/rcparse.c binutils/rcparse.h \
      binutils/sysinfo.c binutils/sysinfo.h gas/bfin-parse.c \
      gas/bfin-parse.h gas/m68k-parse.c gas/rl78-parse.c gas/rl78-parse.h \
      gas/rx-parse.c gas/rx-parse.h gas/itbl-parse.c gas/itbl-parse.h \
      gold/yyscript.c gold/yyscript.h intl/plural.c ld/deffilep.c \
      ld/deffilep.h ld/ldgram.c ld/ldgram.h
    touch -- */*.l */*/*.l
    rm binutils/arlex.c binutils/deflex.c binutils/syslex.c gas/bfin-lex.c \
      gas/itbl-lex.c ld/ldlex.c
    rm bfd/doc/bfd.info binutils/doc/binutils.info
    rm gas/doc/as.info gprof/gprof.info ld/ld.info
    rm */*.1 */*/*.1 */*/*.man
    rm libiberty/functions.texi
    rm */po/*.gmo
    rm opcodes/i386-init.h opcodes/i386-tbl.h opcodes/ia64-asmtab.c \
      opcodes/z8k-opc.h opcodes/aarch64-asm-2.c opcodes/aarch64-opc-2.c \
      opcodes/aarch64-dis-2.c
    rm $(grep -l 'MACHINE GENERATED' opcodes/*.c opcodes/*.h)
    rm include/opcode/riscv-opc.h
    rm bfd/go32stub.h bfd/libbfd.h bfd/bfd-in2.h bfd/libcoff.h \
      ld/emultempl/spu_icache.o_c ld/emultempl/spu_ovl.o_c \
      gprof/fsf_callg_bl.c gprof/bsd_callg_bl.c gprof/flat_bl.c
    rm gas/testsuite/gas/sh/arch/*.s \
      gas/testsuite/gas/sh/arch/arch_expected.txt \
      ld/testsuite/ld-sh/arch/*.s \
      ld/testsuite/ld-sh/arch/arch_expected.txt \
      ld/testsuite/ld-versados/*.ro \
      gas/testsuite/gas/xstormy16/allinsn.sh \
      gas/testsuite/gas/tic4x/opcodes.s \
      binutils/testsuite/binutils-all/x86-64/pr22451.o.bz2
    rm zlib/contrib/masmx86/*.obj \
      zlib/contrib/infback9/inffix9.h \
      zlib/contrib/blast/test.pk \
      zlib/contrib/puff/zeros.raw \
      zlib/contrib/dotzlib/DotZLib.chm \
      zlib/crc32.h zlib/inffixed.h
    (cd libiberty
    sed -n '/^   #include <stdio.h>/,/^   \}$/p' crc32.c > crcgen.c
    tcc -o crcgen crcgen.c
    sed '/crc_v3\.txt/{n; q}' crc32.c > crc32.c.new
    ./crcgen >> crc32.c.new
    sed '1,/^};$/d' crc32.c >> crc32.c.new
    mv crc32.c.new crc32.c)
    (cd bfd
    cp configure.ac configure.ac.bak
    sed -i "s/bfd-in3.h:bfd-in2.h //" configure.ac
    %{autoreconf}
    CC=tcc LD=true ./configure
    make headers
    mv configure.ac.bak configure.ac
    make clean)
    for dir in bfd binutils gas gprof gold intl ld libiberty opcodes zlib; do
      (cd $dir && %{autoreconf})
    done
    rm Makefile.in
    ACLOCAL=aclocal-1.11 autoreconf-2.64 -fi
    (cd libiberty
    CC=tcc ./configure --enable-maintainer-mode
    make maint-deps
    make clean)
    ./bfd/mep-relocs.pl
    for dir in intl libiberty opcodes bfd binutils gas gprof ld zlib; do
      (cd $dir
      LD=true AR="tcc -ar" CC=tcc CFLAGS="%{binutils-cflags}" ./configure \
        --disable-nls \
        --enable-deterministic-archives \
        --enable-64-bit-bfd \
        --build=%{triple} --host=%{triple} --target=%{triple} \
        --program-prefix= \
        --prefix=%{prefix} --libdir=%{libdir} \
        --with-sysroot= \
        --srcdir=. \
        --enable-compressed-debug-sections=all \
        lt_cv_sys_max_cmd_len=32768)
    done
  build-commands:
  - |
    make -C bfd headers
    for dir in %{binutils-dirs}; do
      make -C $dir tooldir=%{prefix} CPPFLAGS=-DPLUGIN_LITTLE_ENDIAN MAKEINFO=true
    done
  install-commands:
  - |
    for dir in %{binutils-dirs}; do
      make -C $dir tooldir=%{prefix} DESTDIR=%{install-root} install MAKEINFO=true
    done
    cd %{install-root}%{bindir}
    for f in *; do
      ln -s %{bindir}/$f %{triple}-$f
    done
