kind: manual
(@): elements/gcc/tools-new.yml

description: |
  Python 3.4.10, built by gcc 4.7.4, with what is made from its sources made again by Python 3.3.7.

build-depends:
  (>):
  - musl/musl-1.2.5.bst
  - zlib/zlib-shared.bst
  - autoconf/autoconf-2.71.bst
  - automake/automake-1.16.3.bst
  - libffi/libffi-3.5.2.bst
  - openssl/openssl-3.6.0.bst
  - linux-headers/linux-headers-4.14.341.bst
  - perl/perl-5.18.4.bst
  - python/python-3.3.7.bst

sources:
- kind: tar
  url: "python:ftp/python/3.4.10/Python-3.4.10.tar.xz"
  ref: d46a8f6fe91679e199c671b1b0a30aaf172d2acb5bcab25beb35f16c3d195b4e
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
  url: "unicode:Public/6.3.0/ucd/UnicodeData.txt"
  ref: 3f76924f0410ca8ae0e9b5c59bd1ba03196293c32616204b393300f091f52013
  filename: UnicodeData-6.3.0.txt
  directory: data
- kind: remote
  url: "unicode:Public/6.3.0/ucd/CompositionExclusions.txt"
  ref: 4ba8ea079ffbffc0025fc31009e95726864feda90d2845c9363c0c40ded8511c
  filename: CompositionExclusions-6.3.0.txt
  directory: data
- kind: remote
  url: "unicode:Public/6.3.0/ucd/EastAsianWidth.txt"
  ref: bbdf9281767ca4601af3623b62c26ecb834a9f4c46eec629d82339b006da00d8
  filename: EastAsianWidth-6.3.0.txt
  directory: data
- kind: remote
  url: "unicode:Public/6.3.0/ucd/DerivedCoreProperties.txt"
  ref: 790826f4cfa82c5845ab4040b5e811f1e67bf1ec4c88cdbf722795c3292b0102
  filename: DerivedCoreProperties-6.3.0.txt
  directory: data
- kind: remote
  url: "unicode:Public/6.3.0/ucd/DerivedNormalizationProps.txt"
  ref: c5e867ae043fe5d1cf713150d859356bfdcdba291c39f584af0bfb943f1a9743
  filename: DerivedNormalizationProps-6.3.0.txt
  directory: data
- kind: remote
  url: "unicode:Public/6.3.0/ucd/LineBreak.txt"
  ref: 6a38069025127a60f4a809e788fbbd1bb6b95ac8d1bd62e6a78d7870357f3486
  filename: LineBreak-6.3.0.txt
  directory: data
- kind: remote
  url: "unicode:Public/6.3.0/ucd/NameAliases.txt"
  ref: a11bed87ec6f264edcf84d581dd2d7ac8ed7ac1c3b2ccb54a83077fdbd34133e
  filename: NameAliases-6.3.0.txt
  directory: data
- kind: remote
  url: "unicode:Public/6.3.0/ucd/NamedSequences.txt"
  ref: 91fc69ff68b1a89e5f7270545547c747624bc96b0e6c23a791d4265d2fa1f988
  filename: NamedSequences-6.3.0.txt
  directory: data
- kind: remote
  url: "unicode:Public/6.3.0/ucd/SpecialCasing.txt"
  ref: 9edafba261e23e72f6e21e3d85d7f15dd4866f38004ab3bfdc6f7057c589d034
  filename: SpecialCasing-6.3.0.txt
  directory: data
- kind: remote
  url: "unicode:Public/6.3.0/ucd/CaseFolding.txt"
  ref: 21323e682a2b34400c6af4ab57b9775b7e716150428f092bac5b005a88ab8f42
  filename: CaseFolding-6.3.0.txt
  directory: data
- kind: remote
  url: "unicode:Public/6.3.0/ucd/Unihan.zip"
  ref: 9e408d71e3aba4ff68f5085569bc1c31c9751f9779f55cf877c222467732991f
  filename: Unihan-6.3.0.zip
  directory: data
- kind: remote
  url: "unicode:Public/MAPPINGS/VENDORS/MICSFT/PC/CP437.TXT"
  ref: 6bad4dabcdf5940227c7d81fab130dcb18a77850b5d79de28b5dc4e047b0aaac
  filename: CP437.TXT
  directory: data

environment:
  LC_ALL: C.UTF-8

variables:
  lb: "%{libdir}/live-bootstrap/python-3.4.10"

config:
  configure-commands:
  - |
    chmod -R u+w .
    patch -Np1 -i %{lb}/patches/install-perms.patch
    patch -Np1 -i %{lb}/patches/symbol.patch
    rm Include/Python-ast.h Python/Python-ast.c
    rm Lib/stringprep.py
    rm Lib/pydoc_data/topics.py
    rm -r Modules/_ctypes/libffi
    rm Python/importlib.h
    rm Modules/_ssl_data.h # Breaks _ssl module, but it fails anyways
    mv Lib/plat-generic .
    rm -r Lib/plat-*
    mv plat-generic Lib/
    grep generated -r . -l | grep encodings | xargs rm
    mkdir Tools/unicode/in Tools/unicode/out
    mv data/CP437.TXT Tools/unicode/in/
    pushd Tools/unicode
    python -B gencodec.py in/ ../../Lib/encodings/
    popd
    find . -name "*.c" -or -name "*.h" | \
        xargs grep 'clinic input' -l | \
        xargs -L 1 python -B Tools/clinic/clinic.py
    rm Modules/unicodedata_db.h Modules/unicodename_db.h Objects/unicodetype_db.h
    mv data/*.txt data/*.zip .
    python -B Tools/unicode/makeunicodedata.py
    rm Modules/sre_constants.h
    cp Lib/sre_constants.py .
    python -B sre_constants.py
    mv sre_constants.h Modules/
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
    PYTHONDONTWRITEBYTECODE=1 make -j1 Parser/pgen
    PYTHONDONTWRITEBYTECODE=1 make -j1 Include/graminit.h
    cp Lib/{symbol,keyword,token}.py .
    cp token.py _token.py
    python -B symbol.py
    python -B keyword.py
    python -B token.py
    PYTHONDONTWRITEBYTECODE=1 make -j1 CFLAGS="-U__DATE__ -U__TIME__"
  install-commands:
  - |
    make -f Makefile install PREFIX=%{prefix} DESTDIR=%{install-root}
    ln -s python3.4 %{install-root}%{prefix}/bin/python
    find "%{install-root}" -name "*.pyc" -delete
    find "%{install-root}" -name "*.pyo" -delete
    rm -f "%{install-root}/%{prefix}/lib/python3.4/lib2to3/"{Pattern,}"Grammar3.4.10.final.0.pickle"
