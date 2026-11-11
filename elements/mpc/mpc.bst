kind: manual
(@): elements/gcc/tools.yml

description: |
  mpc 1.2.1, built by gcc as a static library, with its configure made again.

build-depends:
  (>):
  - gmp/gmp.bst
  - mpfr/mpfr.bst

sources:
- kind: tar
  url: "kernel-mirror:gnu/mpc/mpc-1.2.1.tar.gz"
  ref: 17503d2c395dfcf106b622dc142683c1199431d095367c6aacba6eec30340459

config:
  configure-commands:
  - |
    find . -name '*.info' -delete
    %{autoreconf-1-15}
    ./configure --prefix=%{prefix} --libdir=%{libdir} --disable-shared
  build-commands:
  - make MAKEINFO=true
  install-commands:
  - make MAKEINFO=true DESTDIR=%{install-root} install
