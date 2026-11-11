kind: manual
(@): elements/gcc/tools-new.yml

description: |
  perl 5.15.7, built by gcc 4.7.4 with the Configure that metaconfig makes, and every generated header and table made again by perl 5.12.5.

build-depends:
  (>):
  - bison/bison-2.3.bst
  - dist/dist-3.5.bst
  - perl/devel-tokenizer-c-5.12.5.bst
  - perl/perl-5.12.5.bst

sources:
- kind: tar
  url: "cpan:src/5.0/perl-5.15.7.tar.bz2"
  ref: 331fcc356fccfc47e86ed09c20c081858f9466e419324007a7578441f861177c
- kind: tar
  url: "github:Perl/metaconfig/archive/79b14e84d83fb88c2b1a07e0dec3b62ccb9a388c.tar.gz"
  ref: 857e295a3e3ff3121339b348fd295e03459ce8dc3a382870e94f98c2da99a573
  directory: metaconfig

variables:
  lb: "%{libdir}/live-bootstrap/perl-5.15.7"

config:
  configure-commands:
  - |
    chmod -R u+w .
    patch -Np1 -i %{lb}/patches/5.14_mk_PL_charclass.patch
    patch -Np1 -i %{lb}/patches/Sort-files-returned-from-all_files_in_dir-for-consis.patch
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
          lib/feature.pm
    perl regen.pl
    perl regen_perly.pl -b bison-2.3
    perl regen/keywords.pl
    perl regen/mk_PL_charclass.pl
    perl regen/regcharclass.pl
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
        -Dusedevel \
        -Uversiononly \
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
    make -j1 PREFIX="%{prefix}"
  install-commands:
  - |
    make -f Makefile install PREFIX=%{prefix} DESTDIR=%{install-root}
    rm "%{install-root}/"*.0
    find "%{install-root}/usr/lib/perl5/5.15.7/" -name "*.pod" -delete
    find "%{install-root}/usr/lib/perl5/5.15.7/" -name ".packlist" -delete
