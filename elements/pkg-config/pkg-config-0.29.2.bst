kind: manual
(@): elements/gcc/tools.yml

description: |
  pkg-config 0.29.2, built by gcc with the glib it has inside it, as there is
  no other.  The Unicode tables that glib has are made again, from the data
  files of Unicode 6.2.0, by the perl scripts it has.

sources:
- kind: tar
  url: "pkgconfig:releases/pkg-config-0.29.2.tar.gz"
  ref: 6fc69c01688c9458a57eb9a1664c9aba372ccda420a02bf4429fe610e7e7d591
- kind: remote
  url: "unicode:Public/6.2.0/ucd/UnicodeData.txt"
  ref: 8b2cd18247527aa08ec320c3352b6a01b95d63199f20b3b593ea5d5217bdd170
  filename: UnicodeData-6.2.0.txt
  directory: unidata
- kind: remote
  url: "unicode:Public/6.2.0/ucd/LineBreak.txt"
  ref: 5e2eb009b078569e7954789b2d7b5c026b0b40be6fb9400c6e1ecc7d13f4a13f
  filename: LineBreak-6.2.0.txt
  directory: unidata
- kind: remote
  url: "unicode:Public/6.2.0/ucd/SpecialCasing.txt"
  ref: 707209a69d7f760e3cc461ce26d789f83d6fb694336c83b14652cd44413aa334
  filename: SpecialCasing-6.2.0.txt
  directory: unidata
- kind: remote
  url: "unicode:Public/6.2.0/ucd/CaseFolding.txt"
  ref: 5cbd9afdddd91fee53871c9b36a34899b0a5bcdf4569ca1a3c98cae3ec3d6333
  filename: CaseFolding-6.2.0.txt
  directory: unidata
- kind: remote
  url: "unicode:Public/6.2.0/ucd/CompositionExclusions.txt"
  ref: 3b3f5051bd74e21df7f2b1b264ead48be626cdeefb061c04ce7280a2358efff9
  filename: CompositionExclusions-6.2.0.txt
  directory: unidata
- kind: remote
  url: "unicode:Public/6.2.0/ucd/Scripts.txt"
  ref: 4cdeb69b6bfead1c170a81b544e7488549575493715ab632bd7492bc92c4823e
  filename: Scripts-6.2.0.txt
  directory: unidata

config:
  configure-commands:
  - |
    rm glib/glib/gunidecomp.h glib/glib/gunibreak.h glib/glib/gscripttable.h \
      glib/glib/gunichartables.h
    (cd glib/glib
    mkdir unidata
    mv ../../unidata/*.txt unidata/
    perl gen-unicode-tables.pl -both 6.2.0 unidata
    perl gen-script-table.pl unidata/Scripts-6.2.0.txt > gscripttable.h)
    %{autoreconf-1-15}
    ./configure --prefix=%{prefix} --build=%{triple} --with-internal-glib
  build-commands:
  - make
  install-commands:
  - make DESTDIR=%{install-root} install
