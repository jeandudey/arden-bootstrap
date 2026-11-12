kind: manual
(@): elements/gcc/tools-new.yml

description: |
  which 2.23, as it is in git, built by gcc 4.7.4 with the cwm4 it needs for
  autogen.sh.

build-depends:
  (>):
  - autoconf/autoconf-2.71.bst
  - automake/automake-1.16.3.bst
  - coreutils/coreutils-9.4.bst
  - perl/perl-5.42.0.bst
  - texinfo/texinfo-7.2.bst

sources:
- kind: git
  url: "savannah-git:which.git"
  ref: 3e2c8f8acc3a333b66b06de234bc9324c6fe5500
  directory: which-2.23
  checkout-submodules: false
- kind: tar
  url: "github:CarloWood/cwm4/archive/3c2d71a3fa598cf336c2fa2d8e64332b62c1ffba.tar.gz"
  ref: aeffc74d35b7bc3c0ed636a784fee4daa05764c3c2a4f165841ece5c9095f9e6
  directory: cwm4

variables:
  command-subdir: which-2.23

config:
  configure-commands:
  - |
    chmod -R u+w ..
    rm -rf cwm4
    ln -s ../cwm4 cwm4
    touch ChangeLog which.1 which.info m4/submodules.m4 version.texi
    mkdir ../shim
    ln -s %{bindir}/automake-1.16 ../shim/automake
    ln -s %{bindir}/aclocal-1.16 ../shim/aclocal
    PATH=$PWD/../shim:$PATH ./autogen.sh
    sed -i 's/@CW_SUBDIRS@//' Makefile.in
    ./configure --prefix=%{prefix}
  build-commands:
  - make
  install-commands:
  - |
    make DESTDIR=%{install-root} install
    rm %{install-root}%{prefix}/share/man/man1/which.1
