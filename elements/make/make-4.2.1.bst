kind: manual
(@): elements/gcc/tools.yml

description: |
  make 4.2.1, built by gcc, with its configure made again.  There is no
  autopoint yet, so it is told to do nothing.

build-depends:
  (>):
  - pkg-config/pkg-config-0.29.2.bst

sources:
- kind: tar
  url: "kernel-mirror:gnu/make/make-4.2.1.tar.gz"
  ref: e40b8f018c1da64edd1cc9a6fce5fa63b2e707e404e20cad91fbae337c98a5b7

config:
  configure-commands:
  - |
    rm doc/make.info* po/*.gmo
    AUTOPOINT=true %{autoreconf-1-15}
    ./configure --prefix=%{prefix} --build=%{triple} --disable-nls
  build-commands:
  - make MAKEINFO=true
  install-commands:
  - make install MAKEINFO=true DESTDIR=%{install-root}
