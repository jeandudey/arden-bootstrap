kind: manual
(@): elements/gcc/tools-new.yml

description: |
  perl 5.18.4, built by gcc 4.7.4 with the Configure that metaconfig makes, and every generated header and table made again by perl 5.17.4.

build-depends:
  (>):
  - bison/bison-2.3.bst
  - dist/dist-3.5.bst
  - perl/devel-tokenizer-c-5.17.4.bst
  - perl/perl-5.17.4.bst

sources:
- kind: tar
  url: "cpan:src/5.0/perl-5.18.4.tar.bz2"
  ref: 1fb4d27b75cd244e849f253320260efe1750641aaff4a18ce0d67556ff1b96a5
- kind: tar
  url: "github:Perl/metaconfig/archive/79b14e84d83fb88c2b1a07e0dec3b62ccb9a388c.tar.gz"
  ref: 857e295a3e3ff3121339b348fd295e03459ce8dc3a382870e94f98c2da99a573
  directory: metaconfig

variables:
  lb: "%{libdir}/live-bootstrap/perl-5.18.4"

config:
  configure-commands:
  - |
    chmod -R u+w .
    patch -Np1 -i %{lb}/patches/0001-Unicode-UCD-Allow-internal-properties-in-invmap.patch
    patch -Np1 -i %{lb}/patches/0002-Unicode-UCD-Add-prop_values-function.patch
    patch -Np1 -i %{lb}/patches/0003-Refactor-ExtUtils-Embed-to-work-with-miniperl.patch
    patch -Np1 -i %{lb}/patches/0004-Tweak-ExtUtils-Embed-s-generated-C-code-to-be-closer.patch
    patch -Np1 -i %{lb}/patches/0005-Move-an-inversion-list-generation-to-mktables.patch
    patch -Np1 -i %{lb}/patches/0006-Partial-backport-Work-properly-under-UTF-8-LC_CTYPE-.patch
    patch -Np1 -i %{lb}/patches/Encode-reproducible-includes.patch
    patch -Np1 -i %{lb}/patches/Generate-Errno-and-Pod-Functions-with-deterministic-.patch
    patch -Np1 -i %{lb}/patches/PPPort-pm-reproducible.patch
    patch -Np1 -i %{lb}/patches/ParseXS-reproducible.patch
    patch -Np1 -i %{lb}/patches/Revert-regen-mk_PL_charclass-pl.patch
    patch -Np1 -i %{lb}/patches/Sort-files-returned-from-all_files_in_dir-for-consis.patch
    patch -Np1 -i %{lb}/patches/Unicode-UCD-search_invlist.patch
    patch -Np1 -i %{lb}/patches/a2p-c-bison.patch
    patch -Np1 -i %{lb}/patches/reproducible-mktables.patch
    cp %{lb}/files/* .
    sed -i 's/i686/%{cpu}/g' config.over
    chmod 644 cpan/Compress-Raw-Zlib/config.in
    sed "s:%LIBDIR%:%{libdir}:" Compress-Raw-Zlib_config.in > cpan/Compress-Raw-Zlib/config.in
    rm Porting/Glossary \
        cpan/Devel-PPPort/parts/apidoc.fnc Configure config_h.SH \
        x2p/a2p.c cpan/Win32API-File/cFile.pc cpan/Sys-Syslog/win32/Win32.pm \
        utils/Makefile
    rm win32/perlexe.ico
    rm -r cpan/Compress-Raw-Zlib/zlib-src
    rm cpan/Devel-PPPort/t/*.t cpan/Unicode-Collate/Collate/keys.txt
    rm lib/warnings.pm warnings.h regnodes.h reentr.h reentr.c \
          overload.h overload.c opcode.h opnames.h pp_proto.h \
          keywords.h embed.h embedvar.h perlapi.c perlapi.h \
          proto.h lib/overload/numbers.pm regcharclass.h perly.{tab,h,act} \
          mg_{raw.h,vtable.h,names.c} keywords.c l1_char_class_tab.h \
          lib/feature.pm unicode_constants.h charclass_invlists.h
    perl regen.pl
    perl regen_perly.pl -b bison-2.3
    perl regen/keywords.pl
    perl regen/mk_PL_charclass.pl
    perl regen/mk_invlists.pl
    perl regen/unicode_constants.pl
    perl regen/regcharclass.pl
    sed -i "s/_Perl_Multi_Char_Folds_invlist/_Perl_Folds_To_Multi_Char_invlist/" charclass_invlists.h
    ln -s metaconfig/.package .
    ln -s metaconfig/U .
    metaconfig -m
    pushd Porting
    ln -s /usr/lib/perl5/5.6.2/U .
    makegloss
    popd
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
    pushd x2p
    ./Makefile.SH
    make depend
    popd
    pushd utils
    bash Makefile.SH
    popd
  build-commands:
  - |
    pushd x2p
    make BYACC=yacc run_byacc
    popd
    make miniperl lib/unicore/Name.pm
    patch -Np1 -R -i %{lb}/patches/Revert-regen-mk_PL_charclass-pl.patch
    rm l1_char_class_tab.h
    ./miniperl -Ilib regen/mk_PL_charclass.pl
    make -j1 PREFIX="%{prefix}"
  install-commands:
  - |
    make -f Makefile install PREFIX=%{prefix} DESTDIR=%{install-root}
    rm "%{install-root}/"*.0
