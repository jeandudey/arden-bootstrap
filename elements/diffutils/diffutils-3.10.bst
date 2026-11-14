kind: manual
(@): elements/gcc/tools-final.yml

description: |
  diffutils 3.10, built by gcc 15.2.0 with its gnulib imported by the script
  live-bootstrap has and its configure made again.

sources:
- kind: tar
  url: "kernel-mirror:gnu/diffutils/diffutils-3.10.tar.xz"
  ref: 90e5e93cc724e4ebe12ede80df1634063c7a855692685919bfe60b556c9bd09e
  directory: diffutils-3.10
- kind: tar
  url: "github:coreutils/gnulib/archive/5d2fe24.tar.gz"
  ref: 8274c1aaa679617f112893848e49356dee9ad78ced0726c17c42e95d92adfacf
  directory: gnulib-5d2fe24

variables:
  lb: "%{libdir}/live-bootstrap/diffutils-3.10"
  command-subdir: diffutils-3.10

config:
  configure-commands:
  - |
    chmod -R u+w ..
    AUTOPOINT=true autoreconf-2.71 -fi
    rm man/*.1
    rm doc/*.info
    rm lib/iconv_open*.h
    rm man/help2man
    ln -s %{bindir}/help2man man/help2man
    sh %{lb}/import-gnulib.sh
    LDFLAGS=-static ./configure --prefix=%{prefix} --disable-nls
  build-commands:
  - make MAKEINFO=true
  install-commands:
  - make install MAKEINFO=true DESTDIR=%{install-root}
