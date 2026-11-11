kind: manual
(@): elements/gcc/tools-new.yml

description: |
  Python 2.5.6, built by gcc 4.7.4, with what is made from its sources made again by Python 2.3.7.

build-depends:
  (>):
  - musl/musl-1.2.5.bst
  - zlib/zlib-shared.bst
  - autoconf/autoconf-2.71.bst
  - automake/automake-1.16.3.bst
  - libffi/libffi-3.5.2.bst
  - linux-headers/linux-headers-4.14.341.bst
  - perl/perl-5.18.4.bst
  - python/python-2.3.7.bst

sources:
- kind: tar
  url: "python:ftp/python/2.5.6/Python-2.5.6.tar.bz2"
  ref: 57e04484de051decd4741fb4a4a3f543becc9a219af8b8063b5541e270f26dcc
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
  url: "unicode:Public/4.1.0/ucd/UnicodeData.txt"
  ref: a9f03f6a061ee210c53e33782288a208bed48c65c70d307b2b214989cedfdab0
  filename: UnicodeData-4.1.0.txt
  directory: data
- kind: remote
  url: "unicode:Public/4.1.0/ucd/CompositionExclusions.txt"
  ref: 1003a6896078e77532a017b135762501ff0a540ba33694e32b6177f093ebe6b2
  filename: CompositionExclusions-4.1.0.txt
  directory: data
- kind: remote
  url: "unicode:Public/4.1.0/ucd/EastAsianWidth.txt"
  ref: 089ed5b2becd3196e61124d36e968474d3b7152cb5a3fb56594c34ab1e698e92
  filename: EastAsianWidth-4.1.0.txt
  directory: data

environment:
  LC_ALL: C.UTF-8

variables:
  lb: "%{libdir}/live-bootstrap/python-2.5.6"

config:
  configure-commands:
  - |
    chmod -R u+w .
    patch -Np1 -i %{lb}/patches/keyword.patch
    patch -Np1 -i %{lb}/patches/pgen-timestamp.patch
    patch -Np1 -i %{lb}/patches/posixmodule.patch
    patch -Np1 -i %{lb}/patches/pyc.patch
    patch -Np1 -i %{lb}/patches/sorted.patch
    patch -Np1 -i %{lb}/patches/sre_constants.patch
    cp %{lb}/files/* .
    rm Lib/test/test_pep263.py
    rm Modules/glmodule.c
    rm Include/Python-ast.h Python/Python-ast.c
    rm Lib/stringprep.py
    rm Misc/Vim/python.vim
    mv Lib/plat-generic .
    rm -r Lib/plat-*
    rm -r Modules/_ctypes/libffi
    mv plat-generic Lib/
    grep generated -r . -l | grep encodings | xargs rm
    rm Modules/unicodedata_db.h Modules/unicodename_db.h Objects/unicodetype_db.h
    for f in UnicodeData CompositionExclusions EastAsianWidth; do
        mv "data/${f}-3.2.0.txt" .
        mv "data/${f}-4.1.0.txt" "${f}.txt"
    done
    python Tools/unicode/makeunicodedata.py
    rm Modules/sre_constants.h
    python Lib/sre_constants.py
    rm Lib/compiler/ast.py
    pushd Tools/compiler
    python astgen.py > ../../Lib/compiler/ast.py
    popd
    autoreconf-2.71 -fi
    MACHDEP=linux ac_sys_system=Linux \
    CFLAGS="-U__DATE__ -U__TIME__" \
    LDFLAGS="-L%{libdir}" \
        ./configure \
        --build="%{triple-musl}" \
        --host="%{triple-musl}" \
        --prefix="%{prefix}" \
        --libdir="%{libdir}" \
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
    find "%{install-root}" -name "*.pyc" -delete
    find "%{install-root}" -name "*.pyo" -delete
