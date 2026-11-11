kind: manual
(@): elements/gcc/tools-new.yml

description: |
  Python 3.3.7, built by gcc 4.7.4, with what is made from its sources made again by Python 3.1.5.

build-depends:
  (>):
  - musl/musl-1.2.5.bst
  - zlib/zlib-shared.bst
  - autoconf/autoconf-2.71.bst
  - automake/automake-1.16.3.bst
  - libffi/libffi-3.5.2.bst
  - linux-headers/linux-headers-4.14.341.bst
  - perl/perl-5.18.4.bst
  - python/python-3.1.5.bst

sources:
- kind: tar
  url: "python:ftp/python/3.3.7/Python-3.3.7.tar.xz"
  ref: 85f60c327501c36bc18c33370c14d472801e6af2f901dafbba056f61685429fe
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
  url: "unicode:Public/6.1.0/ucd/UnicodeData.txt"
  ref: 3066262585a3c4f407b16db787e6d3a6e033b90f27405b6c76d1babefffca6ad
  filename: UnicodeData-6.1.0.txt
  directory: data
- kind: remote
  url: "unicode:Public/6.1.0/ucd/CompositionExclusions.txt"
  ref: 21124f9d38372d68e09c67bcb64694fd4bca0c9cb39c576b1f095554c4ea9693
  filename: CompositionExclusions-6.1.0.txt
  directory: data
- kind: remote
  url: "unicode:Public/6.1.0/ucd/EastAsianWidth.txt"
  ref: d591c24b702c1b025b58ca6168746f713b657c6e252c268f52cb07758f428067
  filename: EastAsianWidth-6.1.0.txt
  directory: data
- kind: remote
  url: "unicode:Public/6.1.0/ucd/DerivedCoreProperties.txt"
  ref: a03e62ba5fa9c6f327b6e6cfc5d014f59af9b262b768dd9a6aaa39d205dd8b7a
  filename: DerivedCoreProperties-6.1.0.txt
  directory: data
- kind: remote
  url: "unicode:Public/6.1.0/ucd/DerivedNormalizationProps.txt"
  ref: d028f7eccab4998f8d7a6b15703b088e26ff6ee1f2dbc0939ae872c213de8620
  filename: DerivedNormalizationProps-6.1.0.txt
  directory: data
- kind: remote
  url: "unicode:Public/6.1.0/ucd/LineBreak.txt"
  ref: 7b7e2cf582ef7f24fd2747a4ef1a50934c15a0fc0ab10ce737d5e3e47bebde0d
  filename: LineBreak-6.1.0.txt
  directory: data
- kind: remote
  url: "unicode:Public/6.1.0/ucd/NameAliases.txt"
  ref: 7253bd84e20d34491b2b124a85ca84bd2cd5d113e4957aebae92f0e3c21f0a45
  filename: NameAliases-6.1.0.txt
  directory: data
- kind: remote
  url: "unicode:Public/6.1.0/ucd/NamedSequences.txt"
  ref: 60c88b6e3ceec871cc6b7e2d552453f88eef0f40ff2188d9cec7021c2debd36a
  filename: NamedSequences-6.1.0.txt
  directory: data
- kind: remote
  url: "unicode:Public/6.1.0/ucd/SpecialCasing.txt"
  ref: 7d047fe1aa8a68cc12101427cf03bfbce83201ee277e907822901735f0bfee3c
  filename: SpecialCasing-6.1.0.txt
  directory: data
- kind: remote
  url: "unicode:Public/6.1.0/ucd/CaseFolding.txt"
  ref: 4c0bece13821a24f469bb8d16ea33fc7da6436b7ebe64c78635673dbfaa88edc
  filename: CaseFolding-6.1.0.txt
  directory: data
- kind: remote
  url: "unicode:Public/6.1.0/ucd/Unihan.zip"
  ref: 8ca508ef1bc7eba8c102710016d8510f871f69bdcc74ff877c33d01bb799a38f
  filename: Unihan-6.1.0.zip
  directory: data
- kind: remote
  url: "unicode:Public/MAPPINGS/VENDORS/MICSFT/PC/CP437.TXT"
  ref: 6bad4dabcdf5940227c7d81fab130dcb18a77850b5d79de28b5dc4e047b0aaac
  filename: CP437.TXT
  directory: data

environment:
  LC_ALL: C.UTF-8

variables:
  lb: "%{libdir}/live-bootstrap/python-3.3.7"

config:
  configure-commands:
  - |
    chmod -R u+w .
    patch -Np1 -i %{lb}/patches/install-perms.patch
    patch -Np1 -i %{lb}/patches/symbol.patch
    rm Include/Python-ast.h Python/Python-ast.c
    rm Lib/stringprep.py
    rm Lib/pydoc_data/topics.py
    rm Misc/Vim/python.vim
    rm -r Modules/_ctypes/libffi
    rm Python/importlib.h
    mv Lib/plat-generic .
    rm -r Lib/plat-*
    mv plat-generic Lib/
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
    python -B Tools/ssl/make_ssl_data.py /usr/include/openssl Modules/_ssl_data.h
    autoreconf-2.71 -fi
    MACHDEP=linux ac_sys_system=Linux \
    CFLAGS="-U__DATE__ -U__TIME__" \
    LDFLAGS="-L%{libdir}" \
        ./configure \
        --build="%{triple-musl}" \
        --host="%{triple-musl}" \
        --prefix="%{prefix}" \
        --libdir="%{libdir}" \
        --with-system-ffi
  build-commands:
  - |
    PYTHONDONTWRITEBYTECODE=1 make Parser/pgen
    PYTHONDONTWRITEBYTECODE=1 make Include/graminit.h
    cp Lib/{symbol,keyword,token}.py .
    cp token.py _token.py
    python -B symbol.py
    python -B keyword.py
    python -B token.py
    PYTHONDONTWRITEBYTECODE=1 make -j1 CFLAGS="-U__DATE__ -U__TIME__"
  install-commands:
  - |
    make -f Makefile install PREFIX=%{prefix} DESTDIR=%{install-root}
    ln -s python3.3 %{install-root}%{prefix}/bin/python
    find "%{install-root}" -name "*.pyc" -delete
    find "%{install-root}" -name "*.pyo" -delete
    rm -f "%{install-root}/%{prefix}/lib/python3.3/lib2to3/"{Pattern,}"Grammar3.3.7.final.0.pickle"
