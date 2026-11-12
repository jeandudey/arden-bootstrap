kind: manual
(@): elements/gcc/tools-new.yml

description: |
  gcc 10.5.0, with C and C++, built in one stage by gcc 4.7.4, as the next
  gcc is built by it.  What the tree has that is generated is made again:
  Makefile.in by autogen, the fixincludes tables by genfixes, the autotools
  files by autoconf 2.69 and automake 1.15, and the C++ name table by gperf.

build-depends:
  (>):
  - autogen/autogen-5.18.16.bst
  - coreutils/coreutils-9.4.bst
  - gettext/gettext-0.26.bst
  - gperf/gperf-3.3.bst
  - gzip/gzip.bst
  - grep/grep-3.12.bst
  - guile/guile-3.0.11.bst
  - libtool/libtool-2.4.7.bst
  - musl/musl-1.2.5.bst
  - perl/perl-5.42.0.bst
  - sed/sed-4.8.bst
  - tar/tar-1.34.bst
  - texinfo/texinfo-7.2.bst

sources:
- kind: tar
  url: "kernel-mirror:gnu/gcc/gcc-10.5.0/gcc-10.5.0.tar.xz"
  ref: 25109543fdf46f397c347b5d8b7a2c7e5694a5a51cce4b9c6e1ea8a71ca307c1
  directory: gcc-10.5.0

variables:
  lb: "%{libdir}/live-bootstrap/gcc-10.5.0"
  command-subdir: gcc-10.5.0

config:
  configure-commands:
  - |
    chmod -R u+w ..
    for p in %{lb}/patches/*.patch; do patch -d .. -Np0 -i $p; done
    cp %{lb}/files/* .
    rm libsanitizer/include/sanitizer/netbsd_syscall_hooks.h \
        libsanitizer/sanitizer_common/sanitizer_syscalls_netbsd.inc
    rm -r libgfortran/generated
    rm gcc/testsuite/go.test/test/bench/go1/jsondata_test.go \
        gcc/testsuite/go.test/test/bench/go1/parserdata_test.go \
        gcc/testsuite/go.test/test/bench/shootout/mandelbrot.txt
    rm gcc/testsuite/go.test/test/cmplxdivide1.go
    rm gcc/testsuite/gcc.target/x86_64/abi/test_3_element_struct_and_unions.c \
        gcc/testsuite/gcc.target/x86_64/abi/test_basic_returning.c \
        gcc/testsuite/gcc.target/x86_64/abi/test_passing_floats.c \
        gcc/testsuite/gcc.target/x86_64/abi/test_passing_integers.c
    rm gcc/config/rs6000/rs6000-tables.opt \
        gcc/config/h8300/mova.md \
        gcc/config/aarch64/aarch64-tune.md \
        gcc/config/nios2/ldstwm.md \
        gcc/config/riscv/t-elf-multilib \
        gcc/config/riscv/t-linux-multilib \
        gcc/config/arm/arm-tune.md \
        gcc/config/arm/arm-tables.opt \
        gcc/config/arm/ldmstm.md \
        gcc/config/arc/t-multilib \
        gcc/config/m68k/m68k-tables.opt \
        gcc/config/c6x/c6x-mult.md \
        gcc/config/c6x/c6x-tables.opt \
        gcc/config/c6x/c6x-sched.md \
        gcc/config/csky/csky_tables.opt \
        gcc/config/mips/mips-tables.opt
    rm libphobos/src/std/internal/unicode_tables.d
    rm libgo/go/math/bits/example_test.go \
        libgo/go/math/bits/bits_tables.go \
        libgo/go/math/big/accuracy_string.go \
        libgo/go/math/big/roundingmode_string.go \
        libgo/go/strconv/isprint.go \
        libgo/go/sort/zfuncversion.go \
        libgo/go/golang.org/x/net/route/zsys_*.go \
        libgo/go/golang.org/x/net/idna/*.go \
        libgo/go/golang.org/x/text/unicode/bidi/t*.go \
        libgo/go/golang.org/x/text/unicode/norm/tables*.go \
        libgo/go/internal/syscall/windows/registry/zsyscall_windows.go \
        libgo/go/internal/syscall/windows/zsyscall_windows.go \
        libgo/go/encoding/gob/*_helpers.go \
        libgo/go/index/suffixarray/sais2.go \
        libgo/go/net/http/*_bundle.go \
        libgo/go/runtime/sizeclasses.go \
        libgo/go/runtime/fastlog2table.go \
        libgo/go/html/template/*_string.go \
        libgo/go/crypto/x509/root_darwin_armx.go \
        libgo/go/crypto/md5/md5block.go \
        libgo/go/time/zoneinfo_abbrs_windows.go \
        libgo/go/unicode/tables.go \
        libgo/go/regexp/syntax/doc.go \
        libgo/go/regexp/syntax/op_string.go \
        libgo/go/regexp/syntax/perl_groups.go \
        libgo/go/image/internal/imageutil/impl.go \
        libgo/go/image/color/palette/palette.go \
        libgo/go/cmd/internal/objabi/*_string.go \
        libgo/go/debug/dwarf/*_string.go \
        libgo/go/debug/macho/reloctype_string.go
    rm libgo/go/internal/xcoff/testdata/bigar* \
        libgo/go/internal/xcoff/testdata/gcc* \
        libgo/go/internal/trace/testdata/* \
        libgo/go/compress/bzip2/testdata/*.bin \
        libgo/go/go/internal/gccgoimporter/testdata/v1reflect.gox \
        libgo/go/go/internal/gccgoimporter/testdata/time.gox \
        libgo/go/go/internal/gccgoimporter/testdata/unicode.gox \
        libgo/go/go/internal/gccgoimporter/testdata/escapeinfo.gox \
        libgo/go/go/internal/gccgoimporter/testdata/libimportsar.a \
        libgo/go/go/internal/gcimporter/testdata/versions/*.a
    rm -r libgo/go/compress/flate/testdata \
        libgo/go/runtime/pprof/testdata \
        libgo/go/debug/*/testdata
    find fixincludes/tests -name "*.h" -delete
    rm libgcc/config/sh/lib1funcs.S \
        libgcc/config/sh/lib1funcs-4-300.S \
        libgcc/config/arc/lib1funcs.S
    rm -r zlib/
    rm gcc/cp/cfns.h
    gperf -o -C -E -k '1-6,$' -j1 -D -N 'libc_name_p' -L C++ \
        gcc/cp/cfns.gperf --output-file gcc/cp/cfns.h
    rm Makefile.in fixincludes/fixincl.x
    autogen Makefile.def
    pushd fixincludes
    ./genfixes
    popd
    find . -name configure | sed 's:/configure::' | while read d; do
        pushd "${d}"
        AUTOMAKE=automake-1.15 ACLOCAL=aclocal-1.15 autoreconf-2.69 -fiv
        popd
    done
    cp "%{prefix}/share/automake-1.15/depcomp" .
    BACK="${PWD}"
    find . -type d \
        -exec test -e "{}/Makefile.am" -a ! -e "{}/configure" \; \
        -print | while read d; do
        d="$(readlink -f "${d}")"
        cd "${d}"
        while [ ! -e configure ]; do
            cd ..
        done
        automake-1.15 -fai "${d}/Makefile"
        cd "${BACK}"
    done
    rm intl/plural.c
    rm gcc/gengtype-lex.c
    sed -i 's/@USE_INCLUDED_LIBINTL@/no/' intl/Makefile.in
    pushd libiberty
    sed -n '/^   #include <stdio.h>/,/^   \}$/p' crc32.c > crcgen.c
    gcc -o crcgen crcgen.c
    sed '/crc_v3\.txt/{n; q}' crc32.c > crc32.c.new
    ./crcgen >> crc32.c.new
    sed '1,/^};$/d' crc32.c >> crc32.c.new
    mv crc32.c.new crc32.c
    popd
    rm libdecnumber/decDPD.h
    gcc -std=c99 -o decDPD_generate decDPD_generate.c
    cp decDPD.h.preamble libdecnumber/decDPD.h
    ./decDPD_generate >> libdecnumber/decDPD.h
    find . -name "*.gmo" -delete
    find . -name "*.info" -delete
    find . -type f -name '*.[1-9]' -delete
    rm libiberty/functions.texi
    rm gcc/jit/docs/conf.py
    rm gcc/jit/docs/_build/texinfo/libgccjit.texi \
        gcc/ada/gnat_rm.texi \
        gcc/ada/gnat_ugn.texi
    rm gcc/doc/avr-mmcu.texi
    gcc -o gen-avr-mmcu-texi gcc/config/avr/gen-avr-mmcu-texi.c
    ./gen-avr-mmcu-texi > gcc/doc/avr-mmcu.texi
    mkdir build
    cd build
    CFLAGS=-std=gnu11 LDFLAGS=-static \
    ../configure \
      --prefix=%{prefix} --libdir=%{libdir} \
      --build=%{triple-musl} --target=%{triple-musl} --host=%{triple-musl} \
      --disable-bootstrap --disable-shared --enable-static --program-transform-name= \
      --enable-languages=c,c++ --with-system-zlib --disable-sjlj-exceptions \
      --disable-multilib --enable-threads=posix --disable-libsanitizer --disable-libssp
  build-commands:
  - make -C build
  install-commands:
  - make -C build install DESTDIR=%{install-root}
