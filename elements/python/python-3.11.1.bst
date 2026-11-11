kind: manual
(@): elements/gcc/tools-new.yml

description: |
  Python 3.11.1, built by gcc 4.7.4, with what is made from its sources made again by Python 3.8.16.

build-depends:
  (>):
  - autoconf-archive/autoconf-archive-2021.02.19.bst
  - musl/musl-1.2.5.bst
  - zlib/zlib-shared.bst
  - autoconf/autoconf-2.71.bst
  - automake/automake-1.16.3.bst
  - libffi/libffi-3.5.2.bst
  - openssl/openssl-3.6.0.bst
  - linux-headers/linux-headers-4.14.341.bst
  - perl/perl-5.18.4.bst
  - python/python-3.8.16.bst
  - xz/xz-5.6.4.bst

runtime-depends:
- musl/musl-1.2.5.bst
- zlib/zlib-shared.bst

sources:
- kind: tar
  url: "python:ftp/python/3.11.1/Python-3.11.1.tar.xz"
  ref: 85879192f2cffd56cb16c092905949ebf3e5e394b7f764723529637901dfb58f
- kind: remote
  url: "unicode:Public/3.2-Update/UnicodeData-3.2.0.txt"
  ref: 5e444028b6e76d96f9dc509609c5e3222bf609056f35e5fcde7e6fb8a58cd446
  filename: UnicodeData-3.2.0.txt
  directory: data
- kind: remote
  url: "unicode:Public/3.2-Update/CompositionExclusions-3.2.0.txt"
  ref: 1d3a450d0f39902710df4972ac4a60ec31fbcb54ffd4d53cd812fc1200c732cb
  filename: CompositionExclusions-3.2.0.txt
  directory: data
- kind: remote
  url: "unicode:Public/3.2-Update/EastAsianWidth-3.2.0.txt"
  ref: ce19f35ffca911bf492aab6c0d3f6af3d1932f35d2064cf2fe14e10be29534cb
  filename: EastAsianWidth-3.2.0.txt
  directory: data
- kind: remote
  url: "unicode:Public/3.2-Update/DerivedCoreProperties-3.2.0.txt"
  ref: 787419dde91701018d7ad4f47432eaa55af14e3fe3fe140a11e4bbf3db18bb4c
  filename: DerivedCoreProperties-3.2.0.txt
  directory: data
- kind: remote
  url: "unicode:Public/3.2-Update/DerivedNormalizationProps-3.2.0.txt"
  ref: bab49295e5f9064213762447224ccd83cea0cced0db5dcfc96f9c8a935ef67ee
  filename: DerivedNormalizationProps-3.2.0.txt
  directory: data
- kind: remote
  url: "unicode:Public/3.2-Update/LineBreak-3.2.0.txt"
  ref: d693ef2a603d07e20b769ef8ba29afca39765588a03e3196294e5be8638ca735
  filename: LineBreak-3.2.0.txt
  directory: data
- kind: remote
  url: "unicode:Public/3.2-Update/SpecialCasing-3.2.0.txt"
  ref: 1f7913b74dddff55ee566f6220aa9e465bae6f27709fc21d353b04adb8572b37
  filename: SpecialCasing-3.2.0.txt
  directory: data
- kind: remote
  url: "unicode:Public/3.2-Update/CaseFolding-3.2.0.txt"
  ref: 370f3d1e79a52791c42065946711f4eddb6d9820726afd0e436a3c50360475a9
  filename: CaseFolding-3.2.0.txt
  directory: data
- kind: remote
  url: "unicode:Public/3.2-Update/Unihan-3.2.0.zip"
  ref: 0582b888c4ebab6e3ce8d340c74788f1a68ca662713a1065b9a007f24bb4fe46
  filename: Unihan-3.2.0.zip
  directory: data
- kind: remote
  url: "unicode:Public/14.0.0/ucd/UnicodeData.txt"
  ref: 36018e68657fdcb3485f636630ffe8c8532e01c977703d2803f5b89d6c5feafb
  filename: UnicodeData-14.0.0.txt
  directory: data
- kind: remote
  url: "unicode:Public/14.0.0/ucd/CompositionExclusions.txt"
  ref: 3360762fc3295cea54ab251c31df621d05ba4b94d46c60eaac29aa16d70ad1e0
  filename: CompositionExclusions-14.0.0.txt
  directory: data
- kind: remote
  url: "unicode:Public/14.0.0/ucd/EastAsianWidth.txt"
  ref: f901ac011aa32a09224d6555da71e2532c59c1d3381322829de0e3b880507250
  filename: EastAsianWidth-14.0.0.txt
  directory: data
- kind: remote
  url: "unicode:Public/14.0.0/ucd/DerivedCoreProperties.txt"
  ref: e3eddd7d469cd1b0feed7528defad1a1cc7c6a9ceb0ae4446a6d10921ed2e7bc
  filename: DerivedCoreProperties-14.0.0.txt
  directory: data
- kind: remote
  url: "unicode:Public/14.0.0/ucd/DerivedNormalizationProps.txt"
  ref: b2c444c20730b097787fdf50bd7d6dd3fc5256ab8084f5b35b11c8776eca674c
  filename: DerivedNormalizationProps-14.0.0.txt
  directory: data
- kind: remote
  url: "unicode:Public/14.0.0/ucd/LineBreak.txt"
  ref: 9e06e9f35c6959fb91dcc7993f90d58523c3079bc62c6b25f828b4cdebc5d70c
  filename: LineBreak-14.0.0.txt
  directory: data
- kind: remote
  url: "unicode:Public/14.0.0/ucd/NameAliases.txt"
  ref: 14b3b677d33f95c51423dce6eef4a6a28b4b160451ecedee4b91edb6745cf4a3
  filename: NameAliases-14.0.0.txt
  directory: data
- kind: remote
  url: "unicode:Public/14.0.0/ucd/NamedSequences.txt"
  ref: db5745688affcdc0c3927a1ee0667018a96a7b24513f866d5235e98fef6c2436
  filename: NamedSequences-14.0.0.txt
  directory: data
- kind: remote
  url: "unicode:Public/14.0.0/ucd/SpecialCasing.txt"
  ref: c667b45908fd269af25fd55d2fc5bbc157fb1b77675936e25c513ce32e080334
  filename: SpecialCasing-14.0.0.txt
  directory: data
- kind: remote
  url: "unicode:Public/14.0.0/ucd/CaseFolding.txt"
  ref: a566cd48687b2cd897e02501118b2413c14ae86d318f9abbbba97feb84189f0f
  filename: CaseFolding-14.0.0.txt
  directory: data
- kind: remote
  url: "unicode:Public/14.0.0/ucd/Unihan.zip"
  ref: 2ae4519b2b82cd4d15379c17e57bfb12c33c0f54da4977de03b2b04bcf11852d
  filename: Unihan-14.0.0.zip
  directory: data
- kind: remote
  url: "unicode:Public/MAPPINGS/VENDORS/MICSFT/PC/CP437.TXT"
  ref: 6bad4dabcdf5940227c7d81fab130dcb18a77850b5d79de28b5dc4e047b0aaac
  filename: CP437.TXT
  directory: data
- kind: remote
  url: "https://www.ietf.org/rfc/rfc3454.txt"
  ref: eb722fa698fb7e8823b835d9fd263e4cdb8f1c7b0d234edf7f0e3bd2ccbb2c79
  filename: rfc3454.txt
  directory: data
- kind: tar
  url: "github:openssl/openssl/releases/download/openssl-3.6.0/openssl-3.6.0.tar.gz"
  ref: b6a5f44b7eb69e3fa35dbf15524405b44837a481d43d81daddde3ff21fcbb8e9
  directory: openssl-3.6.0

environment:
  LC_ALL: C.UTF-8

variables:
  lb: "%{libdir}/live-bootstrap/python-3.11.1"

config:
  configure-commands:
  - |
    chmod -R u+w .
    patch -Np1 -i %{lb}/patches/empty-date.patch
    patch -Np1 -i %{lb}/patches/multiarch.patch
    cp %{lb}/files/* .
    rm Lib/pydoc_data/topics.py \
        Misc/stable_abi.toml
    rm Modules/_ssl_data_111.h Modules/_ssl_data.h
    python -B Tools/ssl/make_ssl_data.py openssl-3.6.0 Modules/_ssl_data_300.h
    sed -i 's#$(srcdir)/Modules/_ssl_data.h ##' Makefile.pre.in
    sed -i 's#$(srcdir)/Modules/_ssl_data_111.h ##' Makefile.pre.in
    grep generated -r . -l | grep encodings | xargs rm
    mkdir Tools/unicode/in Tools/unicode/out
    mv data/CP437.TXT Tools/unicode/in/
    pushd Tools/unicode
    python -B gencodec.py in/ ../../Lib/encodings/
    popd
    rm Lib/stringprep.py
    mv data/rfc3454.txt .
    python -B Tools/unicode/mkstringprep.py > Lib/stringprep.py
    rm Modules/unicodedata_db.h Modules/unicodename_db.h Objects/unicodetype_db.h
    mkdir -p Tools/unicode/data
    mv data/*.txt data/*.zip Tools/unicode/data/
    python -B Tools/unicode/makeunicodedata.py
    rm Lib/re/_casefix.py
    python -B Tools/scripts/generate_re_casefix.py Lib/re/_casefix.py
    rm Programs/test_frozenmain.h
    python -B Programs/freeze_test_frozenmain.py Programs/test_frozenmain.h
    echo 'static const char* _Py_stdlib_module_names[] = {};' > Python/stdlib_module_names.h
    autoreconf-2.71 -fi
    mv Setup.local Modules
    MACHDEP=linux ac_sys_system=Linux \
    CPPFLAGS="-U__DATE__ -U__TIME__" \
    PKG_CONFIG_PATH="%{libdir}/pkgconfig/" \
        ./configure \
        --build="%{triple-musl}" \
        --host="%{triple-musl}" \
        --prefix="%{prefix}" \
        --libdir="%{libdir}" \
        --with-system-ffi
  build-commands:
  - |
    rm Modules/_blake2/blake2s_impl.c
    PYTHONDONTWRITEBYTECODE=1 \
        make \
        regen-opcode \
        regen-opcode-targets \
        regen-typeslots \
        regen-token \
        regen-ast \
        regen-keyword \
        regen-sre \
        clinic \
        regen-pegen-metaparser \
        regen-pegen \
        regen-global-objects
    PYTHONDONTWRITEBYTECODE=1 make regen-frozen
    PYTHONDONTWRITEBYTECODE=1 make regen-deepfreeze
    PYTHONDONTWRITEBYTECODE=1 make regen-global-objects
    make CPPFLAGS="-U__DATE__ -U__TIME__"
    PYTHONDONTWRITEBYTECODE=1 make regen-stdlib-module-names
    PYTHONDONTWRITEBYTECODE=1 make CPPFLAGS="-U__DATE__ -U__TIME__"
  install-commands:
  - |
    make -f Makefile install PREFIX=%{prefix} DESTDIR=%{install-root}
    ln -s python3.11 %{install-root}%{prefix}/bin/python
