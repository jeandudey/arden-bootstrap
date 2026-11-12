kind: manual
(@): elements/gcc/tools-new.yml

description: |
  binutils 2.41, built by gcc 10.5.0 with every generated file made again, as
  live-bootstrap does for the final one: static, with gold, the system zlib,
  and links in the triple's name.

build-depends:
  (>):
  - autogen/autogen-5.18.16.bst
  - bison/bison-3.8.2.bst
  - coreutils/coreutils-9.4.bst
  - gcc/gcc-10.5.0.bst
  - gettext/gettext-0.26.bst
  - gc/gc-8.2.12.bst
  - gmp/gmp.bst
  - grep/grep-3.12.bst
  - guile/guile-3.0.11.bst
  - gzip/gzip.bst
  - libffi/libffi-3.5.2.bst
  - libtool/libtool-2.4.7.bst
  - libunistring/libunistring-1.4.1.bst
  - musl/musl-1.2.5.bst
  - perl/perl-5.42.0.bst
  - sed/sed-4.8.bst
  - tar/tar-1.34.bst
  - texinfo/texinfo-7.2.bst

sources:
- kind: tar
  url: "kernel-mirror:gnu/binutils/binutils-2.41.tar.xz"
  ref: ae9a5789e23459e59606e6714723f2d3ffc31c03174191ef0d015bdf06007450
  directory: binutils-2.41

variables:
  lb: "%{libdir}/live-bootstrap/binutils-2.41"
  command-subdir: binutils-2.41

config:
  configure-commands:
  - |
    chmod -R u+w ..
    for p in %{lb}/patches/*.patch; do patch -d .. -Np0 -i $p; done
    rm etc/Makefile.in etc/configure
    rm -r zlib
    sed -i 's/@USE_INCLUDED_LIBINTL@/no/' intl/Makefile.in
    sed -i 's:\(--mode=link $(CCLD)\):\1 -all-static:' {bfd,binutils,opcodes,ld,libctf,gas,gprof}/Makefile.in
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
    find . -type f -name '*.info*' \
                   -not -wholename './binutils/sysroff.info' \
                   -delete
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
    cd libiberty
    sed -n '/^   #include <stdio.h>/,/^   \}$/p' crc32.c > crcgen.c
    gcc -o crcgen crcgen.c
    sed '/crc_v3\.txt/{n; q}' crc32.c > crc32.c.new
    ./crcgen >> crc32.c.new
    sed '1,/^};$/d' crc32.c >> crc32.c.new
    mv crc32.c.new crc32.c
    cd ..
    cd bfd
    cp configure.ac configure.ac.bak
    sed -i "s/bfd-in3.h:bfd-in2.h //" configure.ac
    AUTOPOINT=true ACLOCAL=aclocal-1.15 AUTOMAKE=automake-1.15 autoreconf-2.69 -fi
    ./configure
    make headers
    mv configure.ac.bak configure.ac
    make distclean
    cd ..
    autogen Makefile.def
    ACLOCAL=aclocal-1.15 autoreconf-2.69 -fi
    for dir in bfd binutils gas gold gprof intl ld libctf libiberty libsframe opcodes; do
        cd $dir
        ACLOCAL=aclocal-1.15 AUTOMAKE=automake-1.15 autoreconf-2.69 -fi
        cd ..
    done
    cd gprofng
    LIBTOOLIZE=true ACLOCAL=aclocal-1.15 AUTOMAKE=automake-1.15 autoreconf-2.69 -fi
    cd ..
    cd libiberty
    ./configure --enable-maintainer-mode
    make maint-deps
    make distclean
    cd ..
    ./bfd/mep-relocs.pl
    mkdir build
    cd build
    LDFLAGS=-static \
    ../configure \
      --prefix=%{prefix} --libdir=%{libdir} \
      --build=%{triple-musl} --host=%{triple-musl} --target=%{triple-musl} \
      --enable-static --disable-nls --disable-multilib --disable-plugins \
      --disable-gprofng --enable-threads --enable-64-bit-bfd --enable-gold \
      --enable-ld=default --enable-install-libiberty \
      --enable-deterministic-archives --with-system-zlib \
      --program-prefix= --with-sysroot= --srcdir=..
  build-commands:
  - make -C build
  install-commands:
  - |
    make -C build install DESTDIR=%{install-root}
    for f in $(ls %{install-root}%{bindir}); do
      ln -s %{bindir}/$f %{install-root}%{bindir}/%{triple-musl}-$f
    done
    rm -r %{install-root}%{prefix}/share/man
