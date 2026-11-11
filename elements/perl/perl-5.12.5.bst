kind: manual
(@): elements/gcc/tools-new.yml

description: |
  perl 5.12.5, built by gcc 4.7.4 with the Configure that metaconfig makes, and every generated header and table made again by perl 5.8.9.

build-depends:
  (>):
  - bison/bison-2.3.bst
  - dist/dist-3.5.bst
  - perl/devel-tokenizer-c-5.8.9.bst
  - perl/perl-5.8.9.bst

sources:
- kind: tar
  url: "cpan:src/5.0/perl-5.12.5.tar.bz2"
  ref: 10749417fd3010aae320a34181ad4cd6a4855c1fc63403b87fa4d630b18e966c
- kind: tar
  url: "github:Perl/metaconfig/archive/7ae9aa2926eed6b1f0b68b0e61c80a0f39b14a25.tar.gz"
  ref: 08a10e266927ebce7fe8cd24122b9d1274a173c57170414545633ebebd77d65c
  directory: metaconfig

variables:
  lb: "%{libdir}/live-bootstrap/perl-5.12.5"

config:
  configure-commands:
  - |
    chmod -R u+w .
    patch -Np1 -i %{lb}/patches/Sort-files-returned-from-all_files_in_dir-for-consis.patch
    patch -Np1 -i %{lb}/patches/a2p-c-bison.patch
    patch -Np1 -i %{lb}/patches/reproducible-mktables.patch
    cp %{lb}/files/* .
    sed -i 's/i686/%{cpu}/g' config.over
    chmod 644 cpan/Compress-Raw-Zlib/config.in
    sed "s:%LIBDIR%:%{libdir}:" Compress-Raw-Zlib_config.in > cpan/Compress-Raw-Zlib/config.in
    rm Porting/Glossary \
        cpan/Devel-PPPort/parts/apidoc.fnc Configure config_h.SH \
        x2p/a2p.c cpan/Win32API-File/cFile.pc cpan/Sys-Syslog/win32/Win32.pm
    rm win32/perlexe.ico
    rm -r cpan/Compress-Raw-Zlib/zlib-src
    rm cpan/Devel-PPPort/t/*.t cpan/Unicode-Collate/Collate/keys.txt
    sed '/The following code was generated/,$d' toke.c | sed '$d' > toke.c.new
    perl perl_keyword.pl >> toke.c.new
    sed '1,/The following code was generated/d' toke.c | sed '1,/^}$/d' >> toke.c.new
    mv toke.c.new toke.c
    rm lib/warnings.pm warnings.h regnodes.h reentr.h reentr.c pp.sym \
          overload.h overload.c opcode.h opnames.h pp_proto.h \
          keywords.h embed.h embedvar.h global.sym perlapi.c perlapi.h \
          proto.h lib/overload/numbers.pm regcharclass.h perly.{tab,h,act}
    perl regen.pl
    perl regen_perly.pl -b bison-2.3
    touch regcharclass.h
    perl Porting/regcharclass.pl
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
