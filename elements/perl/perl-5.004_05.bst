kind: make
(@): elements/perl/perl.yml

description: |
  perl 5.004_05, the miniperl of it, built by perl 5.003 and the tcc that is built
  against musl, with the makefile live-bootstrap ships.  The parser is made by
  bison, and the headers that perl makes by perl 5.003.

build-depends:
  (>):
  - perl/perl-5.003.bst

sources:
- kind: tar
  url: "cpan:src/5.0/perl5.004_05.tar.gz"
  ref: 1184478b298978b164a383ed5661e3a117c48ab97d6d0ab7ef614cdbe918b9eb

variables:
  lb-perl: perl5.004-05
