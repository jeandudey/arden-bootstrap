kind: manual
(@): elements/gcc/tools-new.yml

description: |
  Python 2.0.1, built by gcc 4.7.4 and the Python 2.0.1 that has no unicode, with unicode, and the tables and Python files that were made before made again.

build-depends:
  (>):
  - autoconf/autoconf-2.71.bst
  - automake/automake-1.16.3.bst
  - perl/perl-5.18.4.bst
  - python/python-2.0.1-pass0.bst

sources:
- kind: tar
  url: "python:ftp/python/2.0.1/Python-2.0.1.tgz"
  ref: 98557b819a42d2093b41d8637302d1311b81f627af9ad20036357d7eb2813872
- kind: remote
  url: "unicode:Public/3.0-Update/UnicodeData-3.0.0.txt"
  ref: f41d967bc458ee106f0c3948bfad71cd0860d96c49304e3fd02eaf2bbae4b6d9
  filename: UnicodeData-3.0.0.txt

variables:
  lb: "%{libdir}/live-bootstrap/python-2.0.1"

config:
  configure-commands:
  - |
    chmod -R u+w .
    patch -Np1 -i %{lb}/patches/destdir.patch
    patch -Np1 -i %{lb}/patches/posixmodule.patch
    patch -Np1 -i %{lb}/patches/pyc.patch
    patch -Np1 -i %{lb}/patches/undefs.patch
    cp %{lb}/files/* .
    rm Modules/glmodule.c
    mv Lib/plat-generic .
    rm -r Lib/plat-*
    mv plat-generic Lib/
    grep generated -r . -l | grep encodings | xargs rm
    rm Modules/unicodedata_db.h Objects/unicodetype_db.h
    mv UnicodeData-3.0.0.txt UnicodeData-Latest.txt
    python Tools/unicode/makeunicodedata.py
    rm Modules/sre_constants.h
    python Lib/sre_constants.py
    autoreconf-2.71 -fi
    MACHDEP=linux ac_sys_system=Linux \
    ./configure \
        --prefix="%{prefix}" \
        --libdir="%{libdir}"
  build-commands:
  - |
    pushd Parser
    make -j1 pgen
    popd
    pushd Grammar
    make -j1 graminit.c
    popd
    gcc -o keyword keyword.c
    gcc -o token token.c
    grep -E '\{1, "[^"]+"' Python/graminit.c | ./keyword > Lib/keyword.py.new
    mv Lib/keyword.py.new Lib/keyword.py
    ./token Lib/symbol.py < Include/graminit.h > Lib/symbol.py.new
    mv Lib/symbol.py.new Lib/symbol.py
    grep '#define[[:space:]][A-Z]*[[:space:]][[:space:]]*[0-9][0-9]*' Include/token.h | ./token Lib/token.py > Lib/token.py.new
    mv Lib/token.py.new Lib/token.py
    make -j1
  install-commands:
  - |
    mkdir -p "%{install-root}/usr"
    make -f Makefile install PREFIX=%{prefix} DESTDIR=%{install-root}
    find "%{install-root}" -name "*.pyc" -delete
    find "%{install-root}" -name "*.pyo" -delete
