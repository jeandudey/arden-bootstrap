kind: manual
(@): elements/gcc/tools-new.yml

description: |
  sed 4.8, built statically by gcc 4.7.4, with its gnulib imported by the script
  live-bootstrap has and its configure made again.

build-depends:
  (>):
  - gettext/gettext-0.26.bst
  - gzip/gzip.bst

sources:
- kind: tar
  url: "kernel-mirror:gnu/sed/sed-4.8.tar.xz"
  ref: f79b0cfea71b37a8eeec8490db6c5f7ae7719c35587f21edb0617f370eeff633
  directory: sed-4.8
- kind: tar
  url: "github:coreutils/gnulib/archive/d279bc.tar.gz"
  ref: c2f4a618bdcbfad9e9e710fe7b8bc04067e4fc43460e95bac922f8b2e010c957
  directory: gnulib-d279bc

variables:
  lb: "%{libdir}/live-bootstrap/sed-4.8"
  command-subdir: sed-4.8

config:
  configure-commands:
  - |
    chmod -R u+w ..
    rm configure
    find . -name Makefile.in -delete
    sh %{lb}/import-gnulib.sh
    %{autoreconf-1-15}
    GL_GENERATE_ALLOCA_H_TRUE=0 LDFLAGS=-static ./configure --prefix=%{prefix}
  build-commands:
  - make MAKEINFO=true
  install-commands:
  - make MAKEINFO=true DESTDIR=%{install-root} install
