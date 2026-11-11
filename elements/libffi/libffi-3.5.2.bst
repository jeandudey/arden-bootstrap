kind: manual
(@): elements/gcc/tools-new.yml

description: |
  libffi 3.5.2, built as a static library by gcc 4.7.4.

build-depends:
  (>):
  - autoconf/autoconf-2.71.bst
  - automake/automake-1.16.3.bst
  - perl/perl-5.18.4.bst

sources:
- kind: tar
  url: "github:libffi/libffi/releases/download/v3.5.2/libffi-3.5.2.tar.gz"
  ref: f3a3082a23b37c293a4fcd1053147b371f2ff91fa7ea1b2a52e335676bac82dc

variables:
  lb: "%{libdir}/live-bootstrap/libffi-3.5.2"

config:
  configure-commands:
  - |
    chmod -R u+w .
    rm doc/libffi.{pdf,info}
    autoreconf-2.71 -fi
    touch doc/libffi.info
    ./configure \
        --prefix="%{prefix}" \
        --libdir="%{libdir}" \
        --build="%{triple-musl}" \
        --disable-shared \
        --with-gcc-arch=generic \
        --enable-pax_emutramp
  build-commands:
  - |
    make MAKEINFO=true
  install-commands:
  - |
    make MAKEINFO=true install DESTDIR=%{install-root}
