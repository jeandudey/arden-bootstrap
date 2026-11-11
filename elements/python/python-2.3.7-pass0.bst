kind: manual
(@): elements/gcc/tools-new.yml

description: |
  Python 2.3.7 without unicode, built by gcc 4.7.4, with the files that are made from its sources made again by Python 2.0.1.

build-depends:
  (>):
  - autoconf/autoconf-2.71.bst
  - automake/automake-1.16.3.bst
  - perl/perl-5.18.4.bst
  - python/python-2.0.1.bst

sources:
- kind: tar
  url: "python:ftp/python/2.3.7/Python-2.3.7.tgz"
  ref: 969a9891dce9f50b13e54f9890acaf2be66715a5895bf9b11111f320c205b90e
- kind: remote
  url: "unicode:Public/3.2-Update/UnicodeData-3.2.0.txt"
  ref: 5e444028b6e76d96f9dc509609c5e3222bf609056f35e5fcde7e6fb8a58cd446
  filename: UnicodeData-3.2.0.txt
- kind: remote
  url: "unicode:Public/3.2-Update/CompositionExclusions-3.2.0.txt"
  ref: 1d3a450d0f39902710df4972ac4a60ec31fbcb54ffd4d53cd812fc1200c732cb
  filename: CompositionExclusions-3.2.0.txt

variables:
  lb: "%{libdir}/live-bootstrap/python-2.3.7"

config:
  configure-commands:
  - |
    chmod -R u+w .
    patch -Np1 -i %{lb}/patches/posixmodule.patch
    patch -Np1 -i %{lb}/patches/pyc.patch
    cp %{lb}/files/* .
    rm Lib/test/test_pep263.py
    rm Modules/glmodule.c
    rm Modules/unicodedata_db.h Objects/unicodetype_db.h
    rm Lib/stringprep.py
    mv Lib/plat-generic .
    rm -r Lib/plat-*
    mv plat-generic Lib/
    grep generated -r . -l | grep encodings | xargs rm
    patch -Np1 -i disable-unicode.patch
    rm Modules/sre_constants.h
    python Lib/sre_constants.py
    rm Lib/compiler/ast.py
    pushd Tools/compiler
    python astgen.py > ../../Lib/compiler/ast.py
    popd
    autoreconf-2.71 -fi
    MACHDEP=linux ac_sys_system=Linux \
    CFLAGS="-U__DATE__ -U__TIME__" \
        ./configure \
        --prefix="%{prefix}" \
        --libdir="%{libdir}" \
        --with-wctype-functions \
        --enable-ipv6
  build-commands:
  - |
    make Parser/pgen
    make Include/graminit.h
    cp Lib/{symbol,keyword,token}.py .
    python symbol.py
    python keyword.py
    python token.py
    make CFLAGS="-U__DATE__ -U__TIME__"
  install-commands:
  - |
    make -f Makefile install PREFIX=%{prefix} DESTDIR=%{install-root}
    find "%{install-root}" -name "*.pyc" -delete
    find "%{install-root}" -name "*.pyo" -delete
