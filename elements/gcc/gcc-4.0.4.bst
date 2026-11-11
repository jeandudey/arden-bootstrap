kind: manual

description: |
  gcc 4.0.4 again, built by the gcc that tcc built, against musl 1.2.5, with
  the same steps, and without the changes that are for tcc to build it.

build-depends:
- autoconf/autoconf-2.61.bst
- automake/automake-1.9.6.bst
- automake/automake-1.10.3.bst
- bash/bash.bst
- binutils/binutils-2.30.bst
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
- gcc/gcc-4.0.4-pass0.bst
- findutils/findutils-4.2.33.bst
- musl/musl-1.2.5-pass0.bst

sources:
- kind: tar
  url: "kernel-mirror:gnu/gcc/gcc-4.0.4/gcc-core-4.0.4.tar.bz2"
  ref: e9bf58c761a4f988311aef6b41f12fd5c7e51d09477468fb73826aecc1be32e7
- kind: tar
  url: "kernel-mirror:gnu/automake/automake-1.16.3.tar.xz"
  ref: ff2bf7656c4d1c6fdda3b8bebb21f09153a736bcba169aaf65eab25fa113bf3a
  directory: automake-1.16.3

variables:
  gcc-dirs: libiberty libcpp gcc

config:
  configure-commands:
  - |
    chmod -R u+w .
    sed -i 's/struct siginfo/siginfo_t/' gcc/config/i386/linux-unwind.h
    rm configure Makefile.in fixincludes/fixincl.x
    for dir in intl libcpp; do
      (cd $dir
      rm aclocal.m4
      AUTOM4TE=autom4te-2.61 aclocal-1.9 --acdir=../config)
    done
    for dir in fixincludes gcc intl libcpp libiberty; do
      (cd $dir
      rm configure
      autoconf-2.61)
    done
    (cd libmudflap
    AUTOMAKE=automake-1.10 ACLOCAL=aclocal-1.10 AUTOM4TE=autom4te-2.61 autoreconf-2.61 -f)
    for dir in fixincludes intl libmudflap; do
      (cd $dir
      rm -f config.in
      autoheader-2.61)
    done
    rm config.guess config.sub ltmain.sh
    libtoolize
    cp automake-1.16.3/lib/config.sub .
    rm gcc/c-parse.y libiberty/functions.texi libiberty/obstacks.texi
    touch libiberty/obstacks.texi
    rm libcpp/ucnid.h
    perl libcpp/ucnid.pl < libcpp/ucnid.tab > libcpp/ucnid.h
    sed -i 's/YYLEX/yylex()/' gcc/c-parse.in
    rm gcc/c-parse.c gcc/gengtype-yacc.c gcc/gengtype-yacc.h intl/plural.c
    rm gcc/gengtype-lex.c
    find . -name '*.gmo' -delete
    find . -name '*.info' -delete
    rm gcc/doc/*.1 gcc/doc/*.7
    mkdir build
    cd build
    for dir in %{gcc-dirs}; do
      mkdir $dir
      (cd $dir
      ../../$dir/configure \
        --prefix=%{prefix} --libdir=%{libdir} \
        --build=%{triple} --target=%{triple} --host=%{triple} \
        --disable-shared --disable-multilib --program-transform-name=)
    done
    cd ..
  build-commands:
  - |
    ln -s . build/build-%{triple}
    sed -i 's/^STMP_FIXINC = .*/STMP_FIXINC =/' build/gcc/Makefile
    for dir in %{gcc-dirs}; do
      make -C build/$dir LIBGCC2_INCLUDES=-I%{prefix}/include STMP_FIXINC=
    done
  install-commands:
  - |
    mkdir -p %{install-root}%{libdir}/gcc/%{triple}/4.0.4/install-tools/include
    make -C build/gcc install STMP_FIXINC= DESTDIR=%{install-root}
    cp gcc/gsyslimits.h %{install-root}%{libdir}/gcc/%{triple}/4.0.4/include/syslimits.h
