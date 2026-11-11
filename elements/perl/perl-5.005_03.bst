kind: make
(@): elements/perl/perl.yml

description: |
  perl 5.005_03, the miniperl of it, built by perl 5.004_05 and the tcc that is
  built against musl, with the makefile live-bootstrap ships.  The parser is
  made by bison, and the headers and the byte code files that perl makes by
  perl 5.004_05.

build-depends:
  (>):
  - perl/perl-5.004_05.bst

sources:
- kind: tar
  url: "cpan:src/5.0/perl5.005_03.tar.gz"
  ref: 93f41cd87ab8ee83391cfa39a63b076adeb7c3501d2efa31b98d0ef037122bd1

variables:
  lb-perl: perl5.005-03
  perl-prepare: |
    rm -f embedvar.h
    for file in embed keywords opcode; do
      rm -f $file.h
      perl $file.pl
    done
    rm -f regnodes.h
    perl regcomp.pl
    rm -f byterun.h byterun.c ext/B/B/Asmdata.pm
    perl bytecode.pl
