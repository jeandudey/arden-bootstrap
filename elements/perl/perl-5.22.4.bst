kind: manual
(@): elements/gcc/tools-new.yml

description: |
  perl 5.22.4, built by gcc 4.7.4 with the Configure that metaconfig makes, and every generated header and table made again by perl 5.18.4.

build-depends:
  (>):
  - bison/bison-2.3.bst
  - bison/bison-3.6.4.bst
  - bison/bison-3.7.6.bst
  - dist/dist-3.5.bst
  - perl/devel-tokenizer-c-5.18.4.bst
  - perl/perl-5.18.4.bst

sources:
- kind: tar
  url: "http://www.cpan.org/src/5.0/perl-5.22.4.tar.xz"
  ref: 713243dce27d7aa0bdbf52b2070de5ce449f9ffbcc14a93efbc6f2beff0f5ce8
- kind: tar
  url: "http://www.cpan.org/src/5.0/perl-5.24.4.tar.xz"
  ref: 7f080287ff64750270689843ae945f02159a33cb8f2fc910248c15befba5db84
  directory: perl-5.24.4
- kind: tar
  url: "github:Perl/metaconfig/archive/5.26.1.tar.gz"
  ref: 4641f5127a55cf2e1e8f9253ec27fba10b5b77076b4163e7f4bdc7f670d1aaf0
  directory: metaconfig

variables:
  lb: "%{libdir}/live-bootstrap/perl-5.22.4"

config:
  configure-commands:
  - |
    chmod -R u+w .
    mv perl-5.24.4/lib/unicore/{version,mktables,*.txt} lib/unicore/
    mv perl-5.24.4/lib/unicore/auxiliary/*.txt lib/unicore/auxiliary/
    mv perl-5.24.4/lib/unicore/extracted/*.txt lib/unicore/extracted/
    patch -Np1 -i %{lb}/patches/Allow-strictly-named-map-tables.patch
    patch -Np1 -i %{lb}/patches/Make-mktables-work-on-5.22.patch
    patch -Np1 -i %{lb}/patches/PPPort-pm-reproducible.patch
    patch -Np1 -i %{lb}/patches/Sort-files-returned-from-all_files_in_dir-for-consis.patch
    patch -Np1 -i %{lb}/patches/regcharclass-remove-experimental.patch
    patch -Np1 -i %{lb}/patches/reproducible-mktables.patch
    cp %{lb}/files/* .
    sed -i 's/i686/%{cpu}/g' config.over
    chmod 644 cpan/Compress-Raw-Zlib/config.in
    sed "s:%LIBDIR%:%{libdir}:" Compress-Raw-Zlib_config.in > cpan/Compress-Raw-Zlib/config.in
    rm Porting/Glossary \
        cpan/Devel-PPPort/parts/apidoc.fnc Configure config_h.SH \
        cpan/Win32API-File/cFile.pc cpan/Sys-Syslog/win32/Win32.pm \
        dist/ExtUtils-CBuilder/Makefile.PL
    rm win32/perlexe.ico
    rm -r cpan/Compress-Raw-Zlib/zlib-src
    rm cpan/Unicode-Collate/Collate/keys.txt \
        cpan/Devel-PPPort/t/*.t
    rm lib/warnings.pm warnings.h regnodes.h reentr.h reentr.c overload.h \
        opcode.h opnames.h pp_proto.h keywords.h embed.h embedvar.h \
        perlapi.{c,h} proto.h lib/overload/numbers.pm regcharclass.h \
        perly.{tab,h,act} mg_{raw.h,vtable.h} keywords.c l1_char_class_tab.h \
        lib/feature.pm lib/B/Op_private.pm miniperlmain.c unicode_constants.h \
        charclass_invlists.h ebcdic_tables.h packsizetables.c overload.c \
        mg_names.c
    touch lib/unicore/mktables.lst
    perl regen.pl
    perl regen_perly.pl -b bison-2.3
    perl regen/keywords.pl
    perl regen/mk_PL_charclass.pl
    perl regen/regcharclass.pl
    perl regen/genpacksizetables.pl
    perl regen/ebcdic.pl
    perl regen/mk_invlists.pl
    perl regen/miniperlmain.pl
    perl regen/unicode_constants.pl
    ln -s metaconfig/.package .
    ln -s metaconfig/U .
    metaconfig -m
    sed -i -e "s:/pro/3gl/CPAN/lib/dist:%{prefix}/lib/perl5/5.6.2:" \
        -e "s:/pro/3gl/CPAN/perl:$PWD:" \
        metaconfig/U/mkglossary
    chmod +x metaconfig/U/mkglossary
    metaconfig/U/mkglossary > Porting/Glossary
    bash cpan/Devel-PPPort/devel/mkapidoc.sh . \
        cpan/Devel-PPPort/parts/apidoc.fnc \
        cpan/Devel-PPPort/parts/embed.fnc
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
        -Dccflags="-U__DATE__ -U__TIME__" \
        -Darchname="%{cpu}-linux" \
        -Dmyhostname="(none)" \
        -Dmaildomain="(none)"
  build-commands:
  - |
    make
  install-commands:
  - |
    make -f Makefile install PREFIX=%{prefix} DESTDIR=%{install-root}
    rm "%{install-root}/"*.0
