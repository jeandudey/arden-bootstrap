kind: manual
(@): elements/gcc/tools-4.7.4.yml

description: |
  perl 5.8.9, built by gcc 4.7.4 with the Configure that metaconfig makes
  from the sources of the perl metaconfig, with every generated header and
  table made again by the perl before it.  The files for Digest::SHA are put
  where perl has them.  It is configured as x86_64 and not as live-bootstrap's
  i686 in config.over.

build-depends:
  (>):
  - bison/bison.bst
  - dist/dist-3.5.bst
  - live-bootstrap/source.bst
  - oyacc/oyacc.bst
  - patch/patch.bst
  - perl/devel-tokenizer-c-5.6.2.bst
  - perl/perl-5.6.2.bst

sources:
- kind: tar
  url: "cpan:src/5.0/perl-5.8.9.tar.bz2"
  ref: 1097fbcd48ceccb2bc735d119c9db399a02a8ab9f7dc53e29e47e6a8d0d72e79
- kind: tar
  url: "github:Perl/metaconfig/archive/40501436c87602cc17baae64ee6b3ca26d74e354.tar.gz"
  ref: 6b0c937e1aaef684a7b2f0c089bea293c7a9d255d6513e5108567f4c10e3f4dd
  directory: metaconfig
- kind: tar
  url: "cpan-authors:authors/id/M/MS/MSHELOR/Digest-SHA-6.04.tar.gz"
  ref: ee91f8f7db894ee7c6ee003daac10a99056c4948a674ef46acdbb63c81a4abeb
  directory: Digest-SHA-6.04

variables:
  lb-perl: "%{libdir}/live-bootstrap/perl-5.8.9"

config:
  configure-commands:
  - |
    chmod -R u+w .
    patch -Np1 -d metaconfig -i %{lb-perl}/patches/0001-Revert-Patch-Configure-doesn-t-pick-up-Hash-Util-Fie.patch
    patch -Np1 -i %{lb-perl}/patches/Sort-files-returned-from-all_files_in_dir-for-consis.patch
    patch -Np1 -i %{lb-perl}/patches/a2p-c-bison.patch
    mv Digest-SHA-6.04 ext/Digest/SHA/
    rm Porting/Glossary lib/unicore/mktables.lst \
      ext/Sys/Syslog/win32/Win32.pm ext/Win32API/File/cFile.pc \
      ext/Devel/PPPort/parts/apidoc.fnc Configure config_h.SH \
      x2p/a2p.c
    rm ext/Devel/PPPort/t/*.t
    rm -r jpl
    sed -i '/yydestruct/d' perly.y
    rm -f perly.c perly.h
    bison -d perly.y
    ln -s perly.tab.h perly.h
    ln -s perly.tab.c perly.c
    sed '/The following code was generated/,$d' toke.c | sed '$d' > toke.c.new
    perl perl_keyword.pl >> toke.c.new
    sed '1,/The following code was generated/d' toke.c | sed '1,/^}$/d' >> toke.c.new
    mv toke.c.new toke.c
    rm lib/warnings.pm warnings.h regnodes.h reentr.h reentr.c reentr.inc \
      overload.h overload.c opcode.h opnames.h pp_proto.h \
      pp.sym keywords.h embed.h embedvar.h global.sym perlapi.c perlapi.h \
      proto.h pod/perlintern.pod pod/perlapi.pod \
      pod/perlmodlib.pod ext/ByteLoader/byterun.h ext/ByteLoader/byterun.c \
      ext/B/B/Asmdata.pm
    perl regen.pl
    ln -s metaconfig/.package .
    ln -s metaconfig/U .
    metaconfig -m
    (cd Porting
    ln -s %{libdir}/perl5/5.6.2/U .
    makegloss)
    bash ext/Devel/PPPort/devel/mkapidoc.sh . \
      ext/Devel/PPPort/parts/apidoc.fnc \
      ext/Devel/PPPort/parts/embed.fnc
    rm MANIFEST
    sed 's/i686-linux/%{cpu}-linux/' %{lb-perl}/files/config.over > config.over
    ./Configure -des -Dprefix=%{prefix} -Dcc=gcc -Dusedl=false -Ddate=: \
      -Dccflags="-U__DATE__ -U__TIME__" \
      -Dmyhostname="(none)" -Dmaildomain="(none)"
  build-commands:
  - |
    (cd x2p && make BYACC=yacc run_byacc)
    make
  install-commands:
  - |
    make install DESTDIR=%{install-root}
    rm -f %{install-root}/*.0
