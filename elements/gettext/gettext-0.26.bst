kind: manual
(@):
- elements/gcc/tools-new.yml
- elements/gnulib/unicode-16.0.0.yml

description: |
  gettext 0.26, built statically by gcc 4.7.4, with every file it generates
  made again: the libxml2 tables by Python 2.5.6, the Unicode tables of gnulib
  by its own generator, and the grammars by bison.

build-depends:
  (>):
  - autoconf/autoconf-2.71.bst
  - automake/automake-1.16.3.bst
  - bison/bison-3.8.2.bst
  - gperf/gperf-3.3.bst
  - gzip/gzip.bst
  - libunistring/libunistring-1.4.1.bst
  - musl/musl-1.2.5.bst
  - perl/perl-5.42.0.bst
  - python/python-2.5.6.bst

sources:
  (>):
  - kind: tar
    url: "kernel-mirror:gnu/gettext/gettext-0.26.tar.xz"
    ref: d1fb86e260cfe7da6031f94d2e44c0da55903dbae0a2fa0fae78c91ae1b56f00
    directory: gettext-0.26
  - kind: tar
    url: "github:coreutils/gnulib/archive/b5eb878.tar.gz"
    ref: 15dbc4233655e398a7cc28d0a9de13288962973268e74cd697ec6945e175bfdb
    directory: gnulib-b5eb878
  - kind: tar
    url: "github:GNOME/libxml2/archive/refs/tags/v2.9.9.tar.gz"
    ref: d673f0284cec867ee00872a8152e0c3c09852f17fd9aa93f07579a37534f0bfe
    directory: libxml2-v2.9.9
  - kind: remote
    url: "unicode:Public/4.0-Update1/Blocks-4.0.1.txt"
    ref: c9dba71655b8787c381b3421ba2bf9a3df9e6168b5835f93fd3931c1eeff90cf
    filename: Blocks-4.0.1.txt
  - kind: remote
    url: "unicode:Public/4.0-Update1/UnicodeData-4.0.1.txt"
    ref: de54d68f2df927a20ea4a83dfd74a543ca7f3e3df2441576e7f6a185ec6fa217
    filename: UnicodeData-4.0.1.txt

variables:
  lb: "%{libdir}/live-bootstrap/gettext-0.26"
  command-subdir: gettext-0.26

config:
  configure-commands:
  - |
    chmod -R u+w ..
    patch -d .. -Np0 -i %{lb}/patches/build_glob.patch
    find . \( -name '*.info*' \
        -o -name '*.gmo' \
        -o -name '*.mo' \) -delete
    find . \( -name '*.html*' -o -name '*.1*' \) \
        -not -path "./gettext-runtime/intl-csharp/doc/*" \
        -not -path "./gettext-tools/doc/tutorial.html" \
        -not -path "./gettext-tools/doc/FAQ.html" \
        -delete \
        -exec touch {} +
    rm gettext-runtime/intl/plural.{c,h} \
        gettext-tools/src/{read-po-gram,cldr-plural}.{c,h}
    find . -name "*.class" -delete -exec touch {} +
    touch gettext-tools/gnulib-lib/javaversion.class
    rm gettext-tools/m4/csharpexec-test.exe
    touch gettext-tools/m4/csharpexec-test.exe
    rm -r gettext-tools/tests/testdata/repo.tar.gz \
        gettext-tools/tests/testdata/dprog.*.d \
        gettext-tools/tests/mm-viet.comp.po \
        gettext-tools/tests/qttest*.qm \
        libtextstyle/{,gnulib-local}/tests/test-term-ostream-xterm-xf86-v32.out
    touch libtextstyle/{,gnulib-local}/tests/test-term-ostream-xterm-xf86-v32.out
    libxml2=$(cd ../libxml2-v2.9.9 && pwd)
    cp %{lb}/files/post-global-regen.patch "$libxml2"
    pushd "$libxml2"
    for i in include/libxml/globals.h globals.c; do
        sed "/Everything starting from the line below/q" $i > $i.top
        mv $i.top $i
    done
    rm include/libxml/xmlunicode.h xmlunicode.c \
        include/libxml/chvalid.h chvalid.c
    mv ../*-4.0.1.txt .
    python2.5 genUnicode.py
    python2.5 genChRanges.py
    python2.5 build_glob.py
    patch -Np1 -i post-global-regen.patch
    popd
    pushd gnulib-local/lib/libxml
    for f in xmlunicode chvalid globals; do
        cp "$libxml2/$f.c" "$f.c"
        cp "$libxml2/include/libxml/$f.h" "$f.in.h"
    done
    popd
    rm {gettext-runtime,gettext-runtime/intl,gettext-runtime/libasprintf,gettext-tools}/gnulib-lib/uniwidth/width*.h \
        {gettext-runtime,gettext-runtime/intl,gettext-runtime/libasprintf,gettext-tools}/gnulib-lib/unictype/ctype*.h \
        {gettext-runtime,gettext-runtime/intl,gettext-runtime/libasprintf,gettext-tools}/gnulib-lib/unicase/tolower.h \
        gettext-tools/libgettextpo/uniwidth/width*.h \
        gettext-tools/libgettextpo/unictype/ctype*.h \
        gettext-tools/libgettextpo/unicase/tolower.h \
        gettext-tools/gnulib-lib/unicase/{tocasefold,ignorable,cased}.h \
        gettext-tools/gnulib-lib/unicase/special-casing-table.* \
        gettext-tools/gnulib-lib/unictype/combiningclass.h \
        gettext-tools/{gnulib-lib,libgettextpo}/unictype/pr_*.h \
        gettext-tools/{gnulib-lib,libgettextpo}/unilbrk/{lbrktables.c,lbrkprop*.h} \
        gettext-tools/gnulib-lib/uniname/{uninames.h,gen-uninames.lisp} \
        gettext-tools/gnulib-lib/uninorm/{de,}composition-table* \
        gettext-tools/gnulib-tests/unicase/test-{uc_tolower,ignorable,cased}.c \
        gettext-tools/gnulib-tests/unictype/test-{ctype,pr,sy}_*.c
    rm libtextstyle/lib/uniwidth/width*.h \
        libtextstyle/lib/unictype/ctype_*.h \
        libtextstyle/lib/unicase/tolower.h \
        libtextstyle/lib/*-ostream.{c,h} \
        libtextstyle/lib/*_ostream.* \
        libtextstyle/lib/ostream.{c,h,vt.h,priv.h}
    rm -r gettext-tools/gnulib-lib/libxml libtextstyle/lib/libxml
    pushd ../gnulib-b5eb878
    rm lib/unictype/ctype*.h \
        lib/unicase/tolower.h \
        lib/uniwidth/width*.h
    pushd lib
    gcc -Iunictype -o gen-uni-tables gen-uni-tables.c
    mv ../../*-16.0.0.txt ../../PropList-3.0.1.txt .
    ./gen-uni-tables UnicodeData-16.0.0.txt \
        PropList-16.0.0.txt \
        DerivedCoreProperties-16.0.0.txt \
        emoji-data-16.0.0.txt \
        ArabicShaping-16.0.0.txt \
        Scripts-16.0.0.txt \
        Blocks-16.0.0.txt \
        PropList-3.0.1.txt \
        BidiMirroring-16.0.0.txt \
        EastAsianWidth-16.0.0.txt \
        LineBreak-16.0.0.txt \
        WordBreakProperty-16.0.0.txt \
        GraphemeBreakProperty-16.0.0.txt \
        CompositionExclusions-16.0.0.txt \
        SpecialCasing-16.0.0.txt \
        CaseFolding-16.0.0.txt \
        16.0.0
    popd
    popd
    GNULIB_SRCDIR=$(cd ../gnulib-b5eb878 && pwd) ./autogen.sh
    archive="$PWD/gettext-tools/misc/archive.dir.tar"
    temp=$PWD/archive.tmp
    mkdir $temp
    pushd "$temp"
    tar -xf "$archive"
    sed -i.bak "s/%expect 10/%expect 7/" gettext-0.10.*/intl/plural.y
    for f in gettext-0.10.*/intl/plural.y; do
        touch -r "$f.bak" "$f"
        touch -r "$f.bak" "$(dirname "$f")"
    done
    find . -path "*/intl/plural.c" | while read -r file; do
        pushd "$(dirname "$file")"
        rm plural.c
        bison -o plural.c plural.y
        touch -r plural.y plural.c
        touch -r plural.y .
        popd
    done
    tar -cf "$archive" gettext-*
    popd
    rm -rf "$temp"
    ./configure --prefix=%{prefix} --libdir=%{libdir} --enable-static --disable-shared --disable-java
  build-commands:
  - make MAKEINFO=true
  install-commands:
  - make MAKEINFO=true DESTDIR=%{install-root} install

