kind: manual
(@): elements/gcc/tools-new.yml

description: |
  perl 5.30.3, built by gcc 4.7.4 with the Configure that metaconfig makes, and every generated header and table made again by perl 5.24.4.

build-depends:
  (>):
  - bison/bison-2.3.bst
  - bison/bison-3.6.4.bst
  - bison/bison-3.7.6.bst
  - dist/dist-3.5.bst
  - perl/devel-tokenizer-c-5.24.4.bst
  - perl/perl-5.24.4.bst

sources:
- kind: tar
  url: "http://www.cpan.org/src/5.0/perl-5.30.3.tar.xz"
  ref: 6967595f2e3f3a94544c35152f9a25e0cb8ea24ae45f4bf1882f2e33f4a400f4
- kind: tar
  url: "github:Perl/metaconfig/archive/5.30.3.tar.gz"
  ref: 5cf99c51bbec95192e1b9b1e0d8f62d9413cabf64d0f4be0845c1fab3c4c1c9c
  directory: metaconfig

variables:
  lb: "%{libdir}/live-bootstrap/perl-5.30.3"

config:
  configure-commands:
  - |
    chmod -R u+w .
    patch -Np1 -i %{lb}/patches/PPPort-pm-reproducible.patch
    patch -Np1 -i %{lb}/patches/reproducible-mktables.patch
    cp %{lb}/files/* .
    sed -i 's/i686/%{cpu}/g' config.over
    chmod 644 cpan/Compress-Raw-Zlib/config.in
    sed "s:%LIBDIR%:%{libdir}:" Compress-Raw-Zlib_config.in > cpan/Compress-Raw-Zlib/config.in
    rm Porting/Glossary \
        dist/Devel-PPPort/parts/apidoc.fnc Configure config_h.SH \
        cpan/Win32API-File/cFile.pc cpan/Sys-Syslog/win32/Win32.pm \
        dist/ExtUtils-CBuilder/Makefile.PL \
        cpan/Test-Simple/lib/Test2/Util/HashBase.pm
    rm win32/perlexe.ico
    rm -r cpan/Compress-Raw-Zlib/zlib-src
    rm cpan/Unicode-Collate/Collate/keys.txt \
        dist/Devel-PPPort/t/*.t
    rm lib/warnings.pm warnings.h regnodes.h reentr.h reentr.c overload.h \
        opcode.h opnames.h pp_proto.h keywords.h embed.h embedvar.h \
        perlapi.{c,h} proto.h lib/overload/numbers.pm regcharclass.h \
        perly.{tab,h,act} mg_{raw.h,vtable.h} keywords.c l1_char_class_tab.h \
        lib/feature.pm lib/B/Op_private.pm miniperlmain.c unicode_constants.h \
        charclass_invlists.h ebcdic_tables.h mg_names.inc overload.inc \
        packsizetables.inc uni_keywords.h
    touch lib/unicore/mktables.lst
    perl regen.pl
    perl regen_perly.pl -b bison-2.3
    perl regen/keywords.pl
    perl regen/mk_PL_charclass.pl
    perl regen/regcharclass.pl
    perl regen/genpacksizetables.pl
    perl regen/ebcdic.pl
    perl regen/miniperlmain.pl
    perl regen/unicode_constants.pl
    perl lib/unicore/mktables -C lib/unicore -P pod -maketest -makelist -p
    perl regen/mk_invlists.pl
    mconf_dir=$(echo metaconfig)
    ln -s "$mconf_dir"/.package .
    ln -s "$mconf_dir"/U .
    metaconfig -m
    ln -s $PWD "$mconf_dir"/perl
    "$mconf_dir"/U/mkglossary > Porting/Glossary
    bash dist/Devel-PPPort/devel/mkapidoc.sh . \
        dist/Devel-PPPort/parts/apidoc.fnc \
        dist/Devel-PPPort/parts/embed.fnc
    while read -r line; do
        f="$(echo "${line}" | cut -d' ' -f1)"
        if [ -e "${f}" ]; then
            echo "${line}"
        fi
    done < MANIFEST > MANIFEST.new
    mv MANIFEST.new MANIFEST
    ./Configure -des \
        -Dprefix="%{prefix}" \
        -Dcc=gcc \
        -Dusedl=false \
        -Ddate=':' \
        -Darchname="%{cpu}-linux" \
        -Dmyhostname="(none)" \
        -Dmaildomain="(none)" \
        -Dccflags='-DPERL_BUILD_DATE="null"'
  build-commands:
  - |
    make
  install-commands:
  - |
    make -f Makefile install PREFIX=%{prefix} DESTDIR=%{install-root}
    rm "%{install-root}/"*.0
