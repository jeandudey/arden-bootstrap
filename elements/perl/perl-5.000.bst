kind: make

description: |
  perl 5.000, the miniperl of it, built by make and the tcc that is built
  against musl, with the makefile and the files live-bootstrap ships.  The
  parser is made by bison, and the headers that perl makes with itself by
  scripts that stand for those.

build-depends:
- bash/bash.bst
- bison/bison.bst
- coreutils/coreutils-5.0.bst
- gawk/gawk.bst
- live-bootstrap/source.bst
- make/make.bst
- sed/sed.bst
- tcc/musl/toolchain.bst

sources:
- kind: tar
  url: "github:Perl/perl5/archive/perl-5.000.tar.gz"
  ref: 1ae43c8d2983404b9eec61c96e3ffa27e7b07e08215c95c015a4ab0095373ef3

variables:
  lb-perl: "%{libdir}/live-bootstrap/perl-5.000"
  make: make -j1 -f Makefile %{make-args}
  make-install: make -j1 -f Makefile %{make-args} install DESTDIR="%{install-root}"
  make-args: PREFIX=%{prefix}

config:
  build-commands:
    (<):
    - |
      cp %{lb-perl}/mk/main.mk Makefile
      cp %{lb-perl}/files/* .
      rm -f perly.c perly.h embed.h keywords.h opcode.h
      bison -d perly.y
      mv perly.tab.c perly.c
      mv perly.tab.h perly.h
      ./embed_h.SH
      chmod +x keywords.sh opcode.sh
      ./keywords.sh
      ./opcode.sh
