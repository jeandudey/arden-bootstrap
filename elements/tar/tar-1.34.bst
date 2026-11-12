kind: manual
(@): elements/gcc/tools-new.yml

description: |
  tar 1.34, built by gcc 4.7.4 with its gnulib imported by the script
  live-bootstrap has and its bison output and configure made again.

build-depends:
  (>):
  - coreutils/coreutils-9.4.bst
  - gzip/gzip.bst

sources:
- kind: tar
  url: "kernel-mirror:gnu/tar/tar-1.34.tar.xz"
  ref: 63bebd26879c5e1eea4352f0d03c991f966aeb3ddeb3c7445c902568d5411d28
  directory: tar-1.34
- kind: tar
  url: "github:coreutils/gnulib/archive/30820c.tar.gz"
  ref: f55b0c471061c9176c4f3bc486861f57a6348da0ef1ffcafab4c3e6d65d8b0bc
  directory: gnulib-30820c

variables:
  lb: "%{libdir}/live-bootstrap/tar-1.34"
  command-subdir: tar-1.34

config:
  configure-commands:
  - |
    chmod -R u+w ..
    bash %{lb}/import-gnulib.sh
    rm gnu/parse-datetime.c gnu/parse-datetime-gen.h
    rm po/*.gmo
    rm doc/tar.info*
    rm tests/testsuite
    AUTOPOINT=true AUTOMAKE=automake-1.15 ACLOCAL=aclocal-1.15 autoreconf-2.69 -fi
    FORCE_UNSAFE_CONFIGURE=1 ./configure --prefix=%{prefix} --disable-nls \
      gl_cv_func_getcwd_path_max="no, but it is partly working"
  build-commands:
  - make MAKEINFO=true
  install-commands:
  - make install MAKEINFO=true DESTDIR=%{install-root}
