kind: manual
(@): elements/gcc/tools.yml

description: |
  mpfr 4.1.0, built by gcc as a static library.  The table in strtofr.c is
  taken out, and made by a program that is built from the rest of it and the
  library, and the library is built again with it.

build-depends:
  (>):
  - autoconf-archive/autoconf-archive-2021.02.19.bst
  - gmp/gmp.bst

sources:
- kind: tar
  url: "kernel-mirror:gnu/mpfr/mpfr-4.1.0.tar.xz"
  ref: 0c98a3f1732ff6ca4ea690552079da9c597872d30e96ec28414ee23c95558a7f

config:
  configure-commands:
  - |
    sed -i '/^  {/,/ };$/d' src/strtofr.c
    cp src/strtofr.c src/strtofr.c.old
    sed -i '/int RedInvLog2Table/ s/$/};/' src/strtofr.c
    rm doc/*.info
    rm tests/tfpif_*.dat tests/tstrtofr.c
    %{autoreconf-1-15}
    ./configure --prefix=%{prefix} --libdir=%{libdir} --disable-shared
  build-commands:
  - |
    make MAKEINFO=true
    cd src
    printf '#include <stdio.h>\n#include <gmp.h>\n#include <mpfr.h>\n' > strtofr_gen.c
    sed -n '/^#define N 8$/,/^}$/p' strtofr.c >> strtofr_gen.c
    gcc strtofr_gen.c -o strtofr_gen -std=gnu99 -I. -L.libs -lmpfr -lgmp
    ./strtofr_gen 2>strtofr_table >/dev/null
    echo "};" >> strtofr_table
    sed "/int RedInvLog2Table/ r strtofr_table" strtofr.c.old > strtofr.c
    cd ..
    make MAKEINFO=true
  install-commands:
  - make MAKEINFO=true DESTDIR=%{install-root} install
