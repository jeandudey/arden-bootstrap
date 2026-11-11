kind: manual
(@): elements/gcc/tools-new.yml

description: |
  Python 3.8.16, built by gcc 4.7.4, with what is made from its sources made again by Python 3.4.10.

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
  - python/python-3.4.10.bst

sources:
- kind: tar
  url: "python:ftp/python/3.8.16/Python-3.8.16.tar.xz"
  ref: d85dbb3774132473d8081dcb158f34a10ccad7a90b96c7e50ea4bb61f5ce4562
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
  url: "unicode:Public/12.1.0/ucd/UnicodeData.txt"
  ref: 93ab1acd8fd9d450463b50ae77eab151a7cda48f98b25b56baed8070f80fc936
  filename: UnicodeData-12.1.0.txt
  directory: data
- kind: remote
  url: "unicode:Public/12.1.0/ucd/CompositionExclusions.txt"
  ref: abc8394c5bde62453118b00c1c5842160a04d7fffb2e829ee5426b846596d081
  filename: CompositionExclusions-12.1.0.txt
  directory: data
- kind: remote
  url: "unicode:Public/12.1.0/ucd/EastAsianWidth.txt"
  ref: 904500178b2e752635bef27aaed3a2a3718a100bce35ff96b3890be7a8315d8f
  filename: EastAsianWidth-12.1.0.txt
  directory: data
- kind: remote
  url: "unicode:Public/12.1.0/ucd/DerivedCoreProperties.txt"
  ref: a6eb7a8671fb532fbd88c37fd7b20b5b2e7dbfc8b121f74c14abe2947db0da68
  filename: DerivedCoreProperties-12.1.0.txt
  directory: data
- kind: remote
  url: "unicode:Public/12.1.0/ucd/DerivedNormalizationProps.txt"
  ref: 92dcdda84142194a1596f22180fcdf8c0e7f86897f09cc9203c7dc636c549f5f
  filename: DerivedNormalizationProps-12.1.0.txt
  directory: data
- kind: remote
  url: "unicode:Public/12.1.0/ucd/LineBreak.txt"
  ref: 961f842fc70b5afd1d82c6645e68c10d1f701382aed38ae38cb2ff27f671903c
  filename: LineBreak-12.1.0.txt
  directory: data
- kind: remote
  url: "unicode:Public/12.1.0/ucd/NameAliases.txt"
  ref: ff61a0687d2f32c0dd1094254b8bde967883b43c2d4d50fd17531d498e41ab2c
  filename: NameAliases-12.1.0.txt
  directory: data
- kind: remote
  url: "unicode:Public/12.1.0/ucd/NamedSequences.txt"
  ref: d3eb9a288ebeaf9de1237989f490705e287b6f610b59d2459fb1b7c2d8e39c39
  filename: NamedSequences-12.1.0.txt
  directory: data
- kind: remote
  url: "unicode:Public/12.1.0/ucd/SpecialCasing.txt"
  ref: 817ce2e9edca8e075a153f54b8f3b020345e37652cd2bda9b1495c366af17e7e
  filename: SpecialCasing-12.1.0.txt
  directory: data
- kind: remote
  url: "unicode:Public/12.1.0/ucd/CaseFolding.txt"
  ref: 9c772627c6ee77eea6a17b42927b8ee28ca05dc65d6a511062104baaf3d12294
  filename: CaseFolding-12.1.0.txt
  directory: data
- kind: remote
  url: "unicode:Public/12.1.0/ucd/Unihan.zip"
  ref: 6e4553f3b5fffe0d312df324d020ef1278d9595932ae03f4e8a2d427de83cdcd
  filename: Unihan-12.1.0.zip
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

environment:
  LC_ALL: C.UTF-8

variables:
  lb: "%{libdir}/live-bootstrap/python-3.8.16"

config:
  configure-commands:
  - |
    chmod -R u+w .
    patch -Np1 -i %{lb}/patches/empty-date.patch
    patch -Np1 -i %{lb}/patches/maxgroups.patch
    patch -Np1 -i %{lb}/patches/refractor.patch
    rm Lib/pydoc_data/topics.py
    rm Modules/_ssl_data*.h # Breaks _ssl module, but it fails anyways
    grep generated -r . -l | grep encodings | xargs rm
    mkdir Tools/unicode/in Tools/unicode/out
    mv data/CP437.TXT Tools/unicode/in/
    pushd Tools/unicode
    python -B gencodec.py in/ ../../Lib/encodings/
    popd
    rm Modules/unicodedata_db.h Modules/unicodename_db.h Objects/unicodetype_db.h
    mv data/*.txt data/*.zip .
    python -B Tools/unicode/makeunicodedata.py
    rm Modules/sre_constants.h
    cp Lib/sre_constants.py .
    python -B sre_constants.py
    rm sre_constants.py
    mv sre_constants.h Modules/
    rm Lib/stringprep.py
    python -B Tools/unicode/mkstringprep.py > Lib/stringprep.py
    autoreconf-2.71 -fi
    MACHDEP=linux ac_sys_system=Linux \
    CPPFLAGS="-U__DATE__ -U__TIME__" \
    LDFLAGS="-L%{libdir}" \
    PYTHON_FOR_BUILD="python -B" \
        ./configure \
        --build="%{triple-musl}" \
        --host="%{triple-musl}" \
        --prefix="%{prefix}" \
        --libdir="%{libdir}" \
        --with-system-ffi
  build-commands:
  - |
    rm Modules/_blake2/blake2s_impl.c
    PYTHONDONTWRITEBYTECODE=1 make regen-all
    PYTHONDONTWRITEBYTECODE=1 make CPPFLAGS="-U__DATE__ -U__TIME__"
  install-commands:
  - |
    make -f Makefile install PREFIX=%{prefix} DESTDIR=%{install-root}
    ln -s python3.8 %{install-root}%{prefix}/bin/python
    find "%{install-root}" -name "*.pyc" -delete
    find "%{install-root}" -name "*.pyo" -delete
