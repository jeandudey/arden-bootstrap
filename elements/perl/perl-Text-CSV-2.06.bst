kind: manual
(@): elements/gcc/tools-new.yml

description: |
  Text::CSV 2.06, the pure perl module, installed for perl 5.42.0.

build-depends:
  (>):
  - perl/perl-5.42.0.bst

sources:
- kind: tar
  url: "cpan-authors:authors/id/I/IS/ISHIGAKI/Text-CSV-2.06.tar.gz"
  ref: dfcaec925a788b0ba41e51bc6d16e21b0e98b4c7af9b79395090add75f5e506f

config:
  configure-commands:
  - perl Makefile.PL
  build-commands:
  - make
  install-commands:
  - make DESTDIR=%{install-root} PREFIX=%{prefix} pure_install
