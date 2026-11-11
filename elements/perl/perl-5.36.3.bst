kind: manual
(@): elements/gcc/tools-new.yml

description: |
  perl 5.36.3, built by gcc 4.7.4 with the Configure that metaconfig makes, and every generated header and table made again by perl 5.30.3.

build-depends:
  (>):
  - bison/bison-2.3.bst
  - bison/bison-3.6.4.bst
  - bison/bison-3.7.6.bst
  - dist/dist-3.5.bst
  - perl/devel-tokenizer-c-5.30.3.bst
  - perl/perl-5.30.3.bst

sources:
- kind: tar
  url: "http://www.cpan.org/src/5.0/perl-5.36.3.tar.xz"
  ref: 45a228daef66d02fdccc820e71f87e40d8e3df1fc4431f8d4580ec08033866bd
- kind: tar
  url: "github:Perl/metaconfig/archive/5.36.0.tar.gz"
  ref: 0767f0566067c9fd5d17f5ff53fa04b9c45a182afa189dc05b5f8418d5888d92
  directory: metaconfig

variables:
  lb: "%{libdir}/live-bootstrap/perl-5.36.3"

config:
  configure-commands:
  - |
    chmod -R u+w .
    patch -Np1 -i %{lb}/patches/Devel-PPPort-remove-sprintf.patch
    patch -Np1 -i %{lb}/patches/PPPort-pm-reproducible.patch
    patch -Np1 -i %{lb}/patches/Revert-mktables-Use-builtin-refaddr.patch
    patch -Np1 -i %{lb}/patches/remove-machine-generated.patch
    patch -Np1 -i %{lb}/patches/reproducible-mktables.patch
    cp %{lb}/files/* .
    sed -i 's/i686/%{cpu}/g' config.over
    chmod 644 cpan/Compress-Raw-Zlib/config.in
    sed "s:%LIBDIR%:%{libdir}:" Compress-Raw-Zlib_config.in > cpan/Compress-Raw-Zlib/config.in
    rm -f Porting/Glossary \
        dist/Devel-PPPort/parts/apidoc.fnc Configure config_h.SH \
        cpan/Win32API-File/cFile.pc cpan/Sys-Syslog/win32/Win32.pm \
        dist/ExtUtils-CBuilder/Makefile.PL \
        cpan/Test-Simple/lib/Test2/Util/HashBase.pm
    rm win32/perlexe.ico
    rm -r cpan/Compress-Raw-Zlib/zlib-src
    rm cpan/Unicode-Collate/Collate/keys.txt
    rm -f lib/warnings.pm warnings.h regnodes.h reentr.h reentr.c \
          overload.h opcode.h opnames.h pp_proto.h \
          keywords.h embed.h embedvar.h perlapi.{c,h} \
          proto.h lib/overload/numbers.pm regcharclass.h perly.{tab,h,act} \
          mg_{raw.h,vtable.h} keywords.c l1_char_class_tab.h \
          lib/feature.pm lib/B/Op_private.pm lib/unicore/uni_keywords.pl \
          miniperlmain.c unicode_constants.h uni_keywords.h \
          charclass_invlists.h ebcdic_tables.h mg_names.inc overload.inc \
          packsizetables.inc
    touch lib/unicore/mktables.lst
    perl regen.pl
    perl regen_perly.pl
    perl regen/keywords.pl
    perl regen/mk_PL_charclass.pl
    perl regen/regcharclass.pl
    perl regen/genpacksizetables.pl
    perl regen/ebcdic.pl
    perl regen/miniperlmain.pl
    perl regen/unicode_constants.pl
    perl lib/unicore/mktables -C lib/unicore -P pod -maketest -makelist -p
    perl -Ilib regen/mk_invlists.pl
    mconf_dir=$(echo metaconfig)
    ln -s "$mconf_dir"/.package .
    ln -s "$mconf_dir"/U .
    touch U/modified/{d_openat.U,d_vsnprintf.U,d_sched_yield.U} # null it
    metaconfig -m
    ln -s $PWD "$mconf_dir"/perl
    "$mconf_dir"/U/mkglossary > Porting/Glossary
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
    make pod/perlapi.pod
    pushd dist/Devel-PPPort
    perl devel/mkapidoc.pl
    popd
    make
  install-commands:
  - |
    make -f Makefile install PREFIX=%{prefix} DESTDIR=%{install-root}
    rm "%{install-root}/"*.0
