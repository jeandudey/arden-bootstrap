kind: make

description: |
  perl 5.6.2, built by perl 5.005_03 and the tcc that is built against musl,
  with the makefile and the files live-bootstrap ships.  It has its own
  libperl, and the extensions that live-bootstrap builds with it.

build-depends:
- bash/bash.bst
- bison/bison.bst
- coreutils/coreutils-5.0.bst
- live-bootstrap/source.bst
- make/make.bst
- perl/perl-5.005_03.bst
- sed/sed.bst
- tcc/musl/toolchain.bst

sources:
- kind: tar
  url: "cpan:src/5.0/perl-5.6.2.tar.gz"
  ref: a5e66f6ebf701b0567f569f57cae82abf5ce57af70a2b45ae71323b61f49134e

variables:
  lb-perl: "%{libdir}/live-bootstrap/perl-5.6.2"
  make: make -j1 -f Makefile %{make-args}
  make-install: make -j1 -f Makefile %{make-args} install DESTDIR="%{install-root}"
  make-args: PREFIX=%{prefix}

config:
  build-commands:
    (<):
    - |
      cp %{lb-perl}/mk/main.mk Makefile
      cp %{lb-perl}/files/config.h %{lb-perl}/files/config.sh .
      # live-bootstrap's are for 32 bits.
      sed -i -e 's/define UVSIZE 4/define UVSIZE 8/' -e 's/define IVSIZE 4/define IVSIZE 8/' \
        -e 's/define PTRSIZE 4/define PTRSIZE 8/' -e 's/i686-linux/%{build-arch}-linux/' \
        -e 's/BYTEORDER 0x4321/BYTEORDER 0x12345678/' config.h
      echo '#define LONGSIZE 8' >> config.h
      echo '#define I64TYPE long' >> config.h
      echo '#define U64TYPE unsigned long' >> config.h
      echo '#define Quad_t long' >> config.h
      echo '#define HAS_HTONL' >> config.h
      echo '#define HAS_HTONS' >> config.h
      echo '#define HAS_NTOHL' >> config.h
      echo '#define HAS_NTOHS' >> config.h
      echo '#define Uquad_t unsigned long' >> config.h
      sed -i "s#/usr/lib/i686-unknown-linux-musl#%{libdir}#" config.sh
      sed -i '/yydestruct/d' perly.y
      rm -f perly.c perly.h
      bison -d perly.y
      mv perly.tab.c perly.c
      mv perly.tab.h perly.h
      rm -f proto.h pp.sym pp_proto.h perlapi.c perlapi.h opnames.h opcode.h \
        objXSUB.h embedvar.h global.sym
      for file in opcode embed keywords; do
        rm -f $file.h
        perl $file.pl
      done
      rm -f regnodes.h
      perl regcomp.pl
      rm -f ext/ByteLoader/byterun.h ext/ByteLoader/byterun.c ext/B/B/Asmdata.pm
      perl bytecode.pl
      rm -f warnings.h lib/warnings.pm
      perl warnings.pl
      rm -rf lib/unicode/Is lib/unicode/In lib/unicode/To lib/unicode/*.pl
      rm -f lib/Pod/Man.pm
      sed -i 's/perl_call_method/Perl_call_method/' ext/Data/Dumper/Dumper.xs
      sed -i 's/perl_call_sv/Perl_call_sv/' ext/Data/Dumper/Dumper.xs
      sed -i 's/sv_setptrobj/Perl_sv_setref_iv/' ext/POSIX/POSIX.xs
      sed -i "s#/usr/include/errno.h#%{prefix}/include/bits/errno.h#" ext/Errno/Errno_pm.PL
    (>):
    - |
      cd lib/unicode
      ../../miniperl -I../../lib mktables.PL
