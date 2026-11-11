kind: manual
(@): elements/gcc/tools.yml

description: |
  autoconf-archive 2021.02.19, the macros, with its configure made again.

sources:
- kind: tar
  url: "kernel-mirror:gnu/autoconf-archive/autoconf-archive-2021.02.19.tar.xz"
  ref: e8a6eb9d28ddcba8ffef3fa211653239e9bf239aba6a01a6b7cfc7ceaec69cbd

config:
  configure-commands:
  - |
    %{autoreconf-1-15}
    rm doc/*.info*
    ./configure --prefix=%{prefix}
  build-commands:
  - make MAKEINFO=true
  install-commands:
  - make MAKEINFO=true DESTDIR=%{install-root} install
