kind: manual
(@): elements/gcc/tools-new.yml

description: |
  libunistring 1.4.1, built as a static library by gcc 4.7.4, with every Unicode table made again from the data files of Unicode 17.0.0 by the programs it has, and Python 3.11.1 for its name table.

build-depends:
  (>):
  - autoconf/autoconf-2.71.bst
  - automake/automake-1.16.3.bst
  - gperf/gperf-3.3.bst
  - perl/perl-5.42.0.bst
  - python/python-3.11.1.bst

sources:
- kind: tar
  url: "kernel-mirror:gnu/libunistring/libunistring-1.4.1.tar.xz"
  ref: 67d88430892527861903788868c77802a217b0959990f7449f2976126a307763
  directory: libunistring-1.4.1
- kind: tar
  url: "github:coreutils/gnulib/archive/6d64a31.tar.gz"
  ref: 52226aa6e00401dc41412e336ca4760f193219e4e4d7f4566ee9af69701dd7c6
  directory: gnulib-6d64a31
- kind: remote
  url: "unicode:Public/17.0.0/ucd/UnicodeData.txt"
  ref: 2e1efc1dcb59c575eedf5ccae60f95229f706ee6d031835247d843c11d96470c
  filename: UnicodeData-17.0.0.txt
- kind: remote
  url: "unicode:Public/17.0.0/ucd/PropList.txt"
  ref: 130dcddcaadaf071008bdfce1e7743e04fdfbc910886f017d9f9ac931d8c64dd
  filename: PropList-17.0.0.txt
- kind: remote
  url: "unicode:Public/17.0.0/ucd/DerivedCoreProperties.txt"
  ref: 24c7fed1195c482faaefd5c1e7eb821c5ee1fb6de07ecdbaa64b56a99da22c08
  filename: DerivedCoreProperties-17.0.0.txt
- kind: remote
  url: "unicode:Public/17.0.0/ucd/emoji/emoji-data.txt"
  ref: 2cb2bb9455cda83e8481541ecf5b6dfda66a3bb89efa3fa7c5297eccf607b72b
  filename: emoji-data-17.0.0.txt
- kind: remote
  url: "unicode:Public/17.0.0/ucd/ArabicShaping.txt"
  ref: 39afa01e680e27d0fd10b67a9b27be13fbaa3d0efecfb5be45991de9a0d267d0
  filename: ArabicShaping-17.0.0.txt
- kind: remote
  url: "unicode:Public/17.0.0/ucd/Scripts.txt"
  ref: 9f5e50d3abaee7d6ce09480f325c706f485ae3240912527e651954d2d6b035bf
  filename: Scripts-17.0.0.txt
- kind: remote
  url: "unicode:Public/17.0.0/ucd/Blocks.txt"
  ref: c0edefaf1a19771e830a82735472716af6bf3c3975f6c2a23ffbe2580fbbcb15
  filename: Blocks-17.0.0.txt
- kind: remote
  url: "unicode:Public/3.0-Update1/PropList-3.0.1.txt"
  ref: 909eef4adbeddbdddcd9487c856fe8cdbb8912aa8eb315ed7885b6ef65f4dc4c
  filename: PropList-3.0.1.txt
- kind: remote
  url: "unicode:Public/17.0.0/ucd/BidiMirroring.txt"
  ref: a2f16fb873ab4fcdf3221cb1a8a85a134ddd6ed03603181823ff5206af3741ce
  filename: BidiMirroring-17.0.0.txt
- kind: remote
  url: "unicode:Public/17.0.0/ucd/EastAsianWidth.txt"
  ref: ea7ce50f3444a050333448dffef1cadd9325af55cbb764b4a2280faf52170a33
  filename: EastAsianWidth-17.0.0.txt
- kind: remote
  url: "unicode:Public/17.0.0/ucd/LineBreak.txt"
  ref: e6a18fa91f8f6a6f8e534b1d3f128c21ada45bfe152eb6b1bcc5e15fd8ac92e6
  filename: LineBreak-17.0.0.txt
- kind: remote
  url: "unicode:Public/17.0.0/ucd/auxiliary/WordBreakProperty.txt"
  ref: 72274cac1e6b919507db35655c3e175aa27274668a1ece95c28d2069f2ad9852
  filename: WordBreakProperty-17.0.0.txt
- kind: remote
  url: "unicode:Public/17.0.0/ucd/auxiliary/GraphemeBreakProperty.txt"
  ref: d6b51d1d2ae5c33b451b7ed994b48f1f4dc62b2272a5831e7fd418514a6bae89
  filename: GraphemeBreakProperty-17.0.0.txt
- kind: remote
  url: "unicode:Public/17.0.0/ucd/CompositionExclusions.txt"
  ref: 2f239196ef3b5b61db5cc476e9bd80f534d15aa1b74e1be1dea5d042a344c85f
  filename: CompositionExclusions-17.0.0.txt
- kind: remote
  url: "unicode:Public/17.0.0/ucd/SpecialCasing.txt"
  ref: efc25faf19de21b92c1194c111c932e03d2a5eaf18194e33f1156e96de4c9588
  filename: SpecialCasing-17.0.0.txt
- kind: remote
  url: "unicode:Public/17.0.0/ucd/CaseFolding.txt"
  ref: ff8d8fefbf123574205085d6714c36149eb946d717a0c585c27f0f4ef58c4183
  filename: CaseFolding-17.0.0.txt
- kind: remote
  url: "unicode:Public/17.0.0/ucd/NameAliases.txt"
  ref: 793f6f1e4d15fd90f05ae66460191dc4d75d1fea90136a25f30dd6a4cb950eac
  filename: NameAliases-17.0.0.txt

variables:
  lb: "%{libdir}/live-bootstrap/libunistring-1.4.1"
  command-subdir: libunistring-1.4.1

config:
  configure-commands:
  - |
    chmod -R u+w ..
    patch -Np1 -i %{lb}/patches/reproducible-texi2html.patch
    cp %{lb}/files/* .
    find . \( -name '*.info*' -o -name "*.html" \) -delete
    GNULIB=../gnulib-6d64a31
    rm lib/unictype/*_byname.h \
        lib/unicase/locale-languages.h \
        lib/iconv_open-*.h
    rm {$GNULIB,.}/lib/unictype/{digit,pr_*,ctype_*,categ_*,combiningclass,numeric,blocks,[bij]*_of,sy_*,scripts,decdigit,mirror}.h
    rm {$GNULIB,.}/lib/unictype/scripts_byname.gperf \
        {$GNULIB,.}/lib/uniwbrk/wbrkprop.h \
        {$GNULIB,.}/lib/uniwidth/width*.h \
        {$GNULIB,.}/lib/unimetadata/u-version.c \
        {$GNULIB,.}/lib/uninorm/{decomposition-table[12].h,composition-table.gperf,composition-table-bounds.h} \
        lib/uninorm/composition-table.h \
        {$GNULIB,.}/lib/unigbrk/gbrkprop.h \
        {$GNULIB,.}/lib/uniname/uninames.h \
        {$GNULIB,.}/lib/unilbrk/{lbrkprop[12].h,lbrktables.c} \
        {$GNULIB,.}/lib/unicase/{special-casing-table.*,to*.h,ignorable.h,cased.h}
    find {$GNULIB,.}/tests/{unicase,unigbrk,unictype} -name "test-*.{c,h}" -delete -exec touch {} +
    touch $GNULIB/lib/uniname/uninames.h
    mv gen-uninames.py "$GNULIB/lib"
    pushd "$GNULIB/lib"
    mv ../../*.txt .
    gcc -Iunictype -o gen-uni-tables gen-uni-tables.c
    ./gen-uni-tables UnicodeData-17.0.0.txt \
        PropList-17.0.0.txt \
        DerivedCoreProperties-17.0.0.txt \
        emoji-data-17.0.0.txt \
        ArabicShaping-17.0.0.txt \
        Scripts-17.0.0.txt \
        Blocks-17.0.0.txt \
        PropList-3.0.1.txt \
        BidiMirroring-17.0.0.txt \
        EastAsianWidth-17.0.0.txt \
        LineBreak-17.0.0.txt \
        WordBreakProperty-17.0.0.txt \
        GraphemeBreakProperty-17.0.0.txt \
        CompositionExclusions-17.0.0.txt \
        SpecialCasing-17.0.0.txt \
        CaseFolding-17.0.0.txt \
        17.0.0
    python3 gen-uninames.py \
        UnicodeData-17.0.0.txt NameAliases-17.0.0.txt \
        uniname/uninames.h
    popd
    GNULIB_SRCDIR=$GNULIB ./autogen.sh
    autoreconf -fi
    ./configure \
        --prefix="%{prefix}" \
        --libdir="%{libdir}" \
        --disable-shared
  build-commands:
  - |
    make MAKEINFO=true
  install-commands:
  - |
    make MAKEINFO=true install DESTDIR=%{install-root}
