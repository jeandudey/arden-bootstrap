kind: manual
(@): elements/gcc/tools-final.yml

description: |
  gzip 1.13, built by gcc 15.2.0 with its gnulib imported by the script
  live-bootstrap has and its configure made again.

sources:
- kind: tar
  url: "kernel-mirror:gnu/gzip/gzip-1.13.tar.xz"
  ref: 7454eb6935db17c6655576c2e1b0fabefd38b4d0936e0f87f48cd062ce91a057
  directory: gzip-1.13
- kind: tar
  url: "github:coreutils/gnulib/archive/5651802.tar.gz"
  ref: 55e07c6f01173abd45faf2eeadc39c81de91a65d5cdd22ba73f8e6a6a124c6ca
  directory: gnulib-5651802

variables:
  lb: "%{libdir}/live-bootstrap/gzip-1.13"
  command-subdir: gzip-1.13

config:
  configure-commands:
  - |
    chmod -R u+w ..
    AUTOPOINT=true autoreconf-2.71 -fi
    sh %{lb}/import-gnulib.sh
    LDFLAGS=-static ./configure --prefix=%{prefix}
  build-commands:
  - make MAKEINFO=true
  install-commands:
  - make install MAKEINFO=true DESTDIR=%{install-root}
