kind: manual
(@): elements/gcc/tools-final.yml

description: |
  m4 1.4.19, built by gcc 15.2.0 with its gnulib imported by the script
  live-bootstrap has and its configure made again.

sources:
- kind: tar
  url: "kernel-mirror:gnu/m4/m4-1.4.19.tar.xz"
  ref: 63aede5c6d33b6d9b13511cd0be2cac046f2e70fd0a07aa9573a04a82783af96
  directory: m4-1.4.19
- kind: tar
  url: "github:coreutils/gnulib/archive/3639c57.tar.gz"
  ref: 41cafb20f14f9b9bd1330d0208cc8e7daf233076cf4359c862f867c08b84daca
  directory: gnulib-3639c57

variables:
  lb: "%{libdir}/live-bootstrap/m4-1.4.19"
  command-subdir: m4-1.4.19

config:
  configure-commands:
  - |
    chmod -R u+w ..
    sh %{lb}/import-gnulib.sh
    rm doc/*.1 doc/*.info* po/*.gmo
    rm lib/iconv_open*.h
    rm bootstrap
    AUTOPOINT=true autoreconf-2.71 -fi
    CFLAGS=-std=gnu11 LDFLAGS="-static -latomic" ./configure --prefix=%{prefix} \
      --libdir=%{libdir} --disable-nls
  build-commands:
  - make MAKEINFO=true
  install-commands:
  - make install MAKEINFO=true DESTDIR=%{install-root}
