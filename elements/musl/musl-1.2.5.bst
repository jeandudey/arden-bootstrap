kind: manual
(@): elements/gcc/tools-new.yml

description: |
  musl 1.2.5 again, built by gcc 4.7.4 and binutils 2.41 with its shared library,
  which is the dynamic linker, so that shared objects can be loaded.  The
  startup files are where the compiler finds them, and the dynamic linker looks
  for libraries where they are installed.

sources:
- kind: tar
  url: "musl:releases/musl-1.2.5.tar.gz"
  ref: a9a118bbe84d8764da0ea0d28b3ab3fae8477fc7e4085d90102b8596fc7c75e4

config:
  configure-commands:
  - |
    CC=gcc ./configure --host=%{triple} --prefix=%{prefix} --libdir=%{libdir} \
      --includedir=%{prefix}/include/
  build-commands:
  - make CROSS_COMPILE=
  install-commands:
  - |
    make DESTDIR=%{install-root} install
    mkdir -p %{install-root}%{bindir} %{install-root}/etc
    ln -s ../lib/libc.so %{install-root}%{bindir}/ldd
    echo %{libdir} > %{install-root}/etc/ld-musl-%{cpu}.path
