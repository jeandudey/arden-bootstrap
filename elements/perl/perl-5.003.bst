kind: make
(@): elements/perl/perl.yml

description: |
  perl 5.003, the miniperl of it, built by perl 5.000 and the tcc that is built
  against musl, with the makefile live-bootstrap ships.  The parser is made by
  bison, and the headers that perl makes by perl 5.000.

build-depends:
  (>):
  - perl/perl-5.000.bst

sources:
- kind: tar
  url: "github:Perl/perl5/archive/perl-5.003.tar.gz"
  ref: 9fa29beb2fc4a3c373829fc051830796de301f32a719d0b52a400d1719bbd7b1

variables:
  lb-perl: perl-5.003
