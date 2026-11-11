kind: manual
(@): elements/gcc/tools.yml

description: |
  gmp 6.2.1, built by gcc as a static library, with its configure made again and
  the files that bison and flex made for it taken out.

sources:
- kind: tar
  url: "kernel-mirror:gnu/gmp/gmp-6.2.1.tar.xz"
  ref: fd4829912cddd12f84181c3451cc752be224643e87fac497b69edddadc49b4f2

config:
  configure-commands:
  - |
    rm demos/calc/calc.c demos/calc/calc.h demos/calc/calclex.c demos/primes.h
    rm mpn/cray/cfp/mulwwc90.s mpn/cray/cfp/mulwwj90.s tests/rand/t-rand.c
    %{autoreconf-1-15}
    rm doc/*.info*
    ./configure --prefix=%{prefix} --libdir=%{libdir} --build=%{triple} --disable-shared
  build-commands:
  - make MAKEINFO=true
  install-commands:
  - make MAKEINFO=true DESTDIR=%{install-root} install
