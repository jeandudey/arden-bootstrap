kind: manual
(@): elements/gcc/tools-new.yml

description: |
  gperf 3.3, built by gcc 4.7.4 and its C++ compiler, with its gnulib imported and its generated files made again.

build-depends:
  (>):
  - autoconf/autoconf-2.71.bst
  - automake/automake-1.16.3.bst
  - perl/perl-5.42.0.bst

sources:
- kind: tar
  url: "kernel-mirror:gnu/gperf/gperf-3.3.tar.gz"
  ref: fd87e0aba7e43ae054837afd6cd4db03a3f2693deb3619085e6ed9d8d9604ad8
  directory: gperf-3.3
- kind: tar
  url: "github:coreutils/gnulib/archive/b08ee1d.tar.gz"
  ref: d6a9fc0db34ebba01c37fa3250c4127e8175af3dbf32c435e24a9185f0f42a99
  directory: gnulib-b08ee1d

variables:
  lb: "%{libdir}/live-bootstrap/gperf-3.3"
  command-subdir: gperf-3.3

config:
  configure-commands:
  - |
    chmod -R u+w ..
    patch -Np1 -i %{lb}/patches/reproducible-docs.patch
    rm doc/gperf.{1,dvi,info,pdf,ps} doc/*.html
    touch doc/gperf.info doc/gperf.pdf
    rm tests/*.exp tests/{languages,charsets}.gperf tests/lang-ucs2.in
    sed -i 's/"$date" //' doc/help2man
    chmod +x doc/help2man
    GNULIB_SRCDIR=$(cd ../gnulib-b08ee1d && pwd) \
        AUTOCONF=autoconf-2.71 \
        ./autogen.sh
    ./configure --prefix="%{prefix}"
  build-commands:
  - |
    make MAKEINFO=true PREFIX="%{prefix}"
  install-commands:
  - |
    make MAKEINFO=true PREFIX="%{prefix}" DESTDIR="%{install-root}" install
