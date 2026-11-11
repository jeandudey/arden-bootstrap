kind: manual

description: |
  Devel::Tokenizer::C 0.11, the one module that the script which makes the
  keyword function of perl 5.18.4 needs, installed for perl 5.17.4.

build-depends:
- bash/bash-5.2.15.bst
- coreutils/coreutils-5.0.bst

sources:
- kind: tar
  url: "cpan-authors:authors/id/M/MH/MHX/Devel-Tokenizer-C-0.11.tar.gz"
  ref: 5222da582ba59be26a9443a11c525c52aa070daf3bff08516805142b362ba48c

config:
  build-commands:
  - "true"
  install-commands:
  - install -D lib/Devel/Tokenizer/C.pm %{install-root}%{libdir}/perl5/5.17.4/Devel/Tokenizer/C.pm
