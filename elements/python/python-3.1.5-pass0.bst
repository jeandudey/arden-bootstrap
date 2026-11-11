kind: manual
(@): elements/gcc/tools-new.yml

description: |
  Python 3.1.5, a first time, built by gcc 4.7.4, with what is made from its sources made again by Python 2.5.6.

build-depends:
  (>):
  - musl/musl-1.2.5.bst
  - zlib/zlib-shared.bst
  - autoconf/autoconf-2.71.bst
  - automake/automake-1.16.3.bst
  - libffi/libffi-3.5.2.bst
  - linux-headers/linux-headers-4.14.341.bst
  - perl/perl-5.18.4.bst
  - python/python-2.5.6.bst

sources:
- kind: tar
  url: "python:ftp/python/3.1.5/Python-3.1.5.tar.bz2"
  ref: 3a72a21528f0751e89151744350dd12004131d312d47b935ce8041b070c90361
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
  url: "unicode:Public/5.1.0/ucd/UnicodeData.txt"
  ref: 8bd83e9c4e339728ecd532c5b174de5beb9cb4bab5db14e44fcd03ccb2e2c1b5
  filename: UnicodeData-5.1.0.txt
  directory: data
- kind: remote
  url: "unicode:Public/5.1.0/ucd/CompositionExclusions.txt"
  ref: 683b094f2bdd0ab132c0bac293a5404626dd858a53b5364b3b6b525323c5a5e4
  filename: CompositionExclusions-5.1.0.txt
  directory: data
- kind: remote
  url: "unicode:Public/5.1.0/ucd/EastAsianWidth.txt"
  ref: a0d8abf08d08f3e61875aed6011cb70c61dd8ea61089e6ad9b6cf524d8fba0f2
  filename: EastAsianWidth-5.1.0.txt
  directory: data
- kind: remote
  url: "unicode:Public/5.1.0/ucd/DerivedCoreProperties.txt"
  ref: 8f54c77587fee99facc2f28b94e748dfdda5da44f42adab31a65f88b63587ae0
  filename: DerivedCoreProperties-5.1.0.txt
  directory: data
- kind: remote
  url: "unicode:Public/5.1.0/ucd/DerivedNormalizationProps.txt"
  ref: 4fc8cbfa1eed578cdda0768fb4a4ace5443f807c1f652e36a6bd768e81c2c2a3
  filename: DerivedNormalizationProps-5.1.0.txt
  directory: data
- kind: remote
  url: "unicode:Public/MAPPINGS/VENDORS/MICSFT/PC/CP437.TXT"
  ref: 6bad4dabcdf5940227c7d81fab130dcb18a77850b5d79de28b5dc4e047b0aaac
  filename: CP437.TXT
  directory: data

environment:
  LC_ALL: C.UTF-8

variables:
  lb: "%{libdir}/live-bootstrap/python-3.1.5"

config:
  configure-commands:
  - |
    chmod -R u+w .
    patch -Np1 -i %{lb}/patches/install-perms.patch
    patch -Np1 -i %{lb}/patches/openssl.patch
    patch -Np1 -i %{lb}/patches/posixmodule.patch
    cp %{lb}/files/* .
    patch -Np1 -i py2.patch
    rm Include/Python-ast.h Python/Python-ast.c
    rm Lib/stringprep.py
    rm Lib/pydoc_data/topics.py
    rm Misc/Vim/python.vim
    rm -r Modules/_ctypes/libffi
    mv Lib/plat-generic .
    rm -r Lib/plat-*
    mv plat-generic Lib/
    grep generated -r . -l | grep encodings | xargs rm
    rm Modules/unicodedata_db.h Modules/unicodename_db.h Objects/unicodetype_db.h
    for f in UnicodeData CompositionExclusions EastAsianWidth DerivedCoreProperties DerivedNormalizationProps; do
        mv "data/${f}-3.2.0.txt" .
        mv "data/${f}-5.1.0.txt" "${f}.txt"
    done
    python Tools/unicode/makeunicodedata.py
    rm Modules/sre_constants.h
    python Lib/sre_constants.py
    autoreconf-2.71 -fi
    MACHDEP=linux ac_sys_system=Linux \
    CFLAGS="-U__DATE__ -U__TIME__" \
    LDFLAGS="-L%{libdir}" \
        ./configure \
        --prefix="%{prefix}" \
        --libdir="%{libdir}" \
        --build="%{triple-musl}" \
        --host="%{triple-musl}" \
        --with-pydebug \
        --with-system-ffi \
        --enable-ipv6
  build-commands:
  - |
    patch -Np1 -i graminit-regen.patch
    make Parser/pgen
    make Include/graminit.h
    cp Lib/{symbol,keyword,token}.py .
    python symbol.py
    python keyword.py
    python token.py
    patch -Np1 -R -i graminit-regen.patch
    make CFLAGS="-U__DATE__ -U__TIME__"
  install-commands:
  - |
    make -f Makefile install PREFIX=%{prefix} DESTDIR=%{install-root}
    ln -s python3.1 %{install-root}%{prefix}/bin/python
    find "%{install-root}" -name "*.pyc" -delete
    find "%{install-root}" -name "*.pyo" -delete
    rm -f "%{install-root}/%{prefix}/lib/python3.1/lib2to3/"{Pattern,}"Grammar3.1.5.final.0.pickle"
