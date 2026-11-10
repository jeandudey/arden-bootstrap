kind: exec

description: |
  make 3.82, compiled by tcc against the Mes C library: live-bootstrap's first
  make, enough to build the tools that follow.

build-depends:
- stage0/catm.bst
- stage0/chmod.bst
- stage0/cp.bst
- stage0/mkdir.bst
- make/source.bst
- tcc/tcc.bst

variables:
  libdir: "%{prefix}/lib"
  # Without these make declares string.h, stdlib.h and unistd.h functions
  # implicitly, as returning int, which truncates the pointers they return on
  # x86_64.
  make-defines: "-DSTDC_HEADERS=1 -DHAVE_STRING_H=1 -DHAVE_UNISTD_H=1 -DHAVE_ALLOCA_H=1"

config:
  commands:
  - cd: "%{libdir}/make-src"
  - catm config.h
  - tcc -c %{make-defines} getopt.c
  - tcc -c %{make-defines} getopt1.c
  - tcc -c %{make-defines} -I. -Iglob -DHAVE_INTTYPES_H -DHAVE_SA_RESTART -DHAVE_STDINT_H ar.c
  - tcc -c %{make-defines} -I. -DHAVE_INTTYPES_H -DHAVE_SA_RESTART -DHAVE_FCNTL_H arscan.c
  - tcc -c %{make-defines} -I. -DHAVE_INTTYPES_H -DHAVE_SA_RESTART -DFILE_TIMESTAMP_HI_RES=0 commands.c
  - tcc -c %{make-defines} -I. -DHAVE_INTTYPES_H -DHAVE_SA_RESTART -DSCCS_GET=\"/nullop\" default.c
  - tcc -c %{make-defines} -I. -Iglob -DHAVE_INTTYPES_H -DHAVE_SA_RESTART -DHAVE_DIRENT_H dir.c
  - tcc -c %{make-defines} -I. -DHAVE_INTTYPES_H -DHAVE_SA_RESTART expand.c
  - tcc -c %{make-defines} -I. -DHAVE_INTTYPES_H -DHAVE_SA_RESTART -DFILE_TIMESTAMP_HI_RES=0 file.c
  - tcc -c %{make-defines} -I. -DHAVE_INTTYPES_H -DHAVE_SA_RESTART -Dvfork=fork function.c
  - tcc -c %{make-defines} -I. -DHAVE_INTTYPES_H -DHAVE_SA_RESTART implicit.c
  - tcc -c %{make-defines} -I. -DHAVE_INTTYPES_H -DHAVE_SA_RESTART -DHAVE_DUP2 -DHAVE_STRCHR -Dvfork=fork job.c
  - tcc -c %{make-defines} -I. -DHAVE_INTTYPES_H -DHAVE_SA_RESTART -DLOCALEDIR=\"/fake-locale\" -DPACKAGE=\"fake-make\" -DHAVE_MKTEMP -DHAVE_GETCWD main.c
  - tcc -c %{make-defines} -I. -DHAVE_INTTYPES_H -DHAVE_SA_RESTART -DHAVE_STRERROR -DHAVE_VPRINTF -DHAVE_ANSI_COMPILER -DHAVE_STDARG_H misc.c
  - tcc -c %{make-defines} -I. -Iglob -DHAVE_INTTYPES_H -DHAVE_SA_RESTART -DINCLUDEDIR=\"%{prefix}/include\" read.c
  - tcc -c %{make-defines} -I. -DHAVE_INTTYPES_H -DHAVE_SA_RESTART -DFILE_TIMESTAMP_HI_RES=0 -DHAVE_FCNTL_H -DLIBDIR=\"%{prefix}/lib\" remake.c
  - tcc -c %{make-defines} -I. -DHAVE_INTTYPES_H -DHAVE_SA_RESTART rule.c
  - tcc -c %{make-defines} -I. -DHAVE_INTTYPES_H -DHAVE_SA_RESTART signame.c
  - tcc -c %{make-defines} -I. -DHAVE_INTTYPES_H -DHAVE_SA_RESTART strcache.c
  - tcc -c %{make-defines} -I. -DHAVE_INTTYPES_H -DHAVE_SA_RESTART variable.c
  - tcc -c %{make-defines} -I. -DVERSION=\"3.82\" version.c
  - tcc -c %{make-defines} -I. -DHAVE_INTTYPES_H -DHAVE_SA_RESTART vpath.c
  - tcc -c %{make-defines} -I. -DHAVE_INTTYPES_H -DHAVE_SA_RESTART hash.c
  - tcc -c %{make-defines} -I. -DHAVE_INTTYPES_H -DHAVE_SA_RESTART remote-stub.c
  - tcc -c %{make-defines} -DHAVE_FCNTL_H getloadavg.c
  - tcc -c %{make-defines} -Iglob -DSTDC_HEADERS glob/fnmatch.c
  - tcc -c %{make-defines} -Iglob -DHAVE_STRDUP -DHAVE_DIRENT_H glob/glob.c
  - tcc -static -o make getopt.o getopt1.o ar.o arscan.o commands.o default.o dir.o expand.o file.o function.o implicit.o job.o main.o misc.o read.o remake.o rule.o signame.o strcache.o variable.o version.o vpath.o hash.o remote-stub.o getloadavg.o fnmatch.o glob.o
  - ./make --version
  install:
  - from: "%{libdir}/make-src"
    to: "%{bindir}"
    files:
    - make
    mode: "755"
