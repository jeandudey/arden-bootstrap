kind: manual
(@): elements/gcc/tools-final.yml

description: |
  gawk 5.3.0, built by gcc 15.2.0 as live-bootstrap does, with its parsers made
  again by bison.

sources:
- kind: tar
  url: "kernel-mirror:gnu/gawk/gawk-5.3.0.tar.xz"
  ref: ca9c16d3d11d0ff8c69d79dc0b47267e1329a69b39b799895604ed447d3ca90b

config:
  configure-commands:
  - |
    rm doc/*.info
    rm awkgram.c command.c
    CFLAGS=-std=gnu11 LDFLAGS=-static ./configure --prefix=%{prefix} --disable-nls
  build-commands:
  - make MAKEINFO=true
  install-commands:
  - make install MAKEINFO=true DESTDIR=%{install-root}
