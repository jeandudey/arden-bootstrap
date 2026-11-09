kind: kaem

description: |
  GNU Mes: mes-m2 built with M2-Planet, then Mes's C library built with mescc.

build-depends:
- boot/base.bst
- boot/simple-patch-1.0.bst

sources:
- kind: local
  path: files/mes-0.27.1
- kind: tar
  url: "kernel-mirror:gnu/mes/mes-0.27.1.tar.gz"
  ref: 183a40ea47ea49f8a1e3bd1b9d12e676374d64d63bc79e7bc1ae7d673dfdf25d
  directory: build/mes-0.27.1
- kind: tar
  url: "github:Googulator/nyacc/releases/download/V1.00.2-lb1/nyacc-1.00.2-lb1.tar.gz"
  ref: 708c943f89c972910e9544ee077771acbd0a2c0fc6d33496fe158264ddb65327
  directory: build/nyacc-1.00.2

config:
  env:
    SRCDIR: /build
    NYACC_PKG: nyacc-1.00.2
    MES_PKG: mes-0.27.1
    MES_VERSION: 0.27.1
    MES_PREFIX: ${SRCDIR}/build/${MES_PKG}
    GUILE_LOAD_PATH: ${MES_PREFIX}/mes/module:${MES_PREFIX}/module:${SRCDIR}/build/${NYACC_PKG}/module
  commands:
  - kaem --file build.kaem
  install:
  - from: ${MES_PREFIX}/lib/x86-mes
    to: ${PREFIX}/lib/x86-mes
    files:
    - libc.a
    - libc+tcc.a
    - libmescc.a
    - libc.s
    - libc+tcc.s
    - libmescc.s
    - x86.M1
    - crt1.o
    - crt1.s
  - from: ${MES_PREFIX}/lib/linux/x86-mes
    to: ${PREFIX}/lib/linux/x86-mes
    files:
    - elf32-footer-single-main.hex2
    - elf32-header.hex2
  - from: ${MES_PREFIX}/include
    to: ${INCDIR}
    files:
    - alloca.h
    - argz.h
    - ar.h
    - assert.h
    - ctype.h
    - dirent.h
    - dirstream.h
    - dlfcn.h
    - endian.h
    - errno.h
    - fcntl.h
    - features.h
    - float.h
    - getopt.h
    - grp.h
    - inttypes.h
    - libgen.h
    - limits.h
    - locale.h
    - math.h
    - memory.h
    - pwd.h
    - setjmp.h
    - signal.h
    - stdarg.h
    - stdbool.h
    - stddef.h
    - stdint.h
    - stdio.h
    - stdlib.h
    - stdnoreturn.h
    - string.h
    - strings.h
    - termio.h
    - time.h
    - unistd.h
    - arch/kernel-stat.h
    - arch/syscall.h
    - linux/syscall.h
    - linux/x86/syscall.h
    - mes/builtins.h
    - mes/cc.h
    - mes/constants.h
    - mes/lib.h
    - mes/lib-cc.h
    - mes/lib-mini.h
    - mes/mes.h
    - mes/symbols.h
    - sys/cdefs.h
    - sys/dir.h
    - sys/file.h
    - sys/ioctl.h
    - sys/mman.h
    - sys/param.h
    - sys/resource.h
    - sys/select.h
    - sys/stat.h
    - sys/timeb.h
    - sys/time.h
    - sys/times.h
    - sys/types.h
    - sys/ucontext.h
    - sys/user.h
    - sys/wait.h
    - arch/signal.h
