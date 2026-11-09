kind: kaem

description: |
  GNU Mes: mes-m2 built with M2-Planet, then Mes's C library built with mescc.

build-depends:
- boot/base.bst

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
# Applied to the unpacked Mes tree, in this order.
- kind: patch
  path: files/mes-0.27.1/patches/kaem-base-address.patch
  directory: build/mes-0.27.1
- kind: patch
  path: files/mes-0.27.1/patches/config-h.patch
  directory: build/mes-0.27.1
- kind: patch
  path: files/mes-0.27.1/patches/wait4.patch
  directory: build/mes-0.27.1
- kind: patch
  path: files/mes-0.27.1/patches/mescc-scm.patch
  directory: build/mes-0.27.1

config:
  env:
    SRCDIR: /build
    NYACC_PKG: nyacc-1.00.2
    MES_PKG: mes-0.27.1
    MES_VERSION: 0.27.1
    MES_PREFIX: ${SRCDIR}/build/${MES_PKG}
    MES_ARCH: x86
    MES_ARENA: 20000000
    MES_MAX_ARENA: 20000000
    MES_STACK: 6000000
    MES: ${BINDIR}/mes-m2
    LIBDIR: ${MES_PREFIX}/lib
    GUILE_LOAD_PATH: ${MES_PREFIX}/mes/module:${MES_PREFIX}/module:${SRCDIR}/build/${NYACC_PKG}/module
  commands:
  # Builds mes-m2, regenerates nyacc and puts mescc.scm in /usr/bin to run.
  - kaem --file build.kaem
  - cd ${MES_PREFIX}
  # Recompile Mes and its C library with the mes-m2 bootstrapped Mes.
  - 'alias mescc="${MES} -e main ${BINDIR}/mescc.scm -D HAVE_CONFIG_H=1 -I include -I include/linux/${MES_ARCH} -c"'
  - mescc lib/linux/${MES_ARCH}-mes-mescc/crt1.c -o lib/${MES_ARCH}-mes/crt1.o
  - concat:
      output: libc-mini.c
      files:
      - lib/mes/__init_io.c
      - lib/mes/eputs.c
      - lib/mes/oputs.c
      - lib/mes/globals.c
      - lib/stdlib/exit.c
      - lib/linux/${MES_ARCH}-mes-mescc/_exit.c
      - lib/linux/${MES_ARCH}-mes-mescc/_write.c
      - lib/stdlib/puts.c
      - lib/string/strlen.c
  - mescc libc-mini.c
  - cp libc-mini.o ${LIBDIR}/${MES_ARCH}-mes/libc-mini.a
  - cp libc-mini.s ${LIBDIR}/${MES_ARCH}-mes/libc-mini.s
  - concat:
      output: libmescc.c
      files:
      - lib/mes/globals.c
      - lib/linux/${MES_ARCH}-mes-mescc/syscall-internal.c
  - mescc libmescc.c
  - cp libmescc.o ${LIBDIR}/${MES_ARCH}-mes/libmescc.a
  - cp libmescc.s ${LIBDIR}/${MES_ARCH}-mes/libmescc.s
  - concat:
      output: libc.c
      files:
      - lib/ctype/isnumber.c
      - lib/mes/abtol.c
      - lib/mes/cast.c
      - lib/mes/eputc.c
      - lib/mes/fdgetc.c
      - lib/mes/fdputc.c
      - lib/mes/fdputs.c
      - lib/mes/fdungetc.c
      - lib/mes/itoa.c
      - lib/mes/ltoa.c
      - lib/mes/ltoab.c
      - lib/mes/mes_open.c
      - lib/mes/ntoab.c
      - lib/mes/oputc.c
      - lib/mes/ultoa.c
      - lib/mes/utoa.c
      - lib/ctype/isdigit.c
      - lib/ctype/isspace.c
      - lib/ctype/isxdigit.c
      - lib/mes/assert_msg.c
      - lib/posix/write.c
      - lib/stdlib/atoi.c
      - lib/linux/lseek.c
      - lib/mes/__assert_fail.c
      - lib/mes/__buffered_read.c
      - lib/mes/__mes_debug.c
      - lib/posix/execv.c
      - lib/posix/getcwd.c
      - lib/posix/getenv.c
      - lib/posix/isatty.c
      - lib/posix/open.c
      - lib/posix/buffered-read.c
      - lib/posix/setenv.c
      - lib/posix/wait.c
      - lib/dirent/closedir.c
      - lib/dirent/opendir.c
      - lib/stdio/fgetc.c
      - lib/stdio/fputc.c
      - lib/stdio/fputs.c
      - lib/stdio/getc.c
      - lib/stdio/getchar.c
      - lib/stdio/putc.c
      - lib/stdio/putchar.c
      - lib/stdio/ungetc.c
      - lib/stdlib/calloc.c
      - lib/stdlib/free.c
      - lib/stdlib/realloc.c
      - lib/string/memchr.c
      - lib/string/memcmp.c
      - lib/string/memcpy.c
      - lib/string/memmove.c
      - lib/string/memset.c
      - lib/string/strcmp.c
      - lib/string/strcpy.c
      - lib/string/strncmp.c
      - lib/posix/raise.c
      - lib/linux/access.c
      - lib/linux/brk.c
      - lib/linux/chdir.c
      - lib/linux/chmod.c
      - lib/linux/clock_gettime.c
      - lib/linux/dup.c
      - lib/linux/dup2.c
      - lib/linux/execve.c
      - lib/linux/fork.c
      - lib/linux/fsync.c
      - lib/linux/_getcwd.c
      - lib/linux/gettimeofday.c
      - lib/linux/ioctl3.c
      - lib/linux/malloc.c
      - lib/linux/_open3.c
      - lib/linux/_read.c
      - lib/linux/readdir.c
      - lib/linux/rename.c
      - lib/linux/time.c
      - lib/linux/umask.c
      - lib/linux/uname.c
      - lib/linux/unlink.c
      - lib/linux/utimensat.c
      - lib/linux/wait4.c
      - lib/linux/waitpid.c
      - lib/linux/${MES_ARCH}-mes-mescc/syscall.c
      - lib/linux/getpid.c
      - lib/linux/kill.c
      - lib/linux/pipe.c
      - lib/linux/stat.c
      - lib/linux/lstat.c
      - lib/linux/mkdir.c
      - lib/linux/rmdir.c
      - lib/linux/link.c
      - lib/linux/symlink.c
      - lib/linux/close.c
      - lib/linux/nanosleep.c
      - lib/linux/fcntl.c
      - lib/linux/fstat.c
      - lib/linux/getdents.c
  - mescc libc.c
  - concat:
      output: ${LIBDIR}/${MES_ARCH}-mes/libc.a
      files:
      - ${LIBDIR}/${MES_ARCH}-mes/libc-mini.a
      - libc.o
  - concat:
      output: ${LIBDIR}/${MES_ARCH}-mes/libc.s
      files:
      - ${LIBDIR}/${MES_ARCH}-mes/libc-mini.s
      - libc.s
  - concat:
      output: libc+tcc.c
      files:
      - lib/ctype/islower.c
      - lib/ctype/isupper.c
      - lib/ctype/tolower.c
      - lib/ctype/toupper.c
      - lib/mes/abtod.c
      - lib/mes/dtoab.c
      - lib/mes/search-path.c
      - lib/posix/execvp.c
      - lib/stdio/fclose.c
      - lib/stdio/fdopen.c
      - lib/stdio/ferror.c
      - lib/stdio/fflush.c
      - lib/stdio/fopen.c
      - lib/stdio/fprintf.c
      - lib/stdio/fread.c
      - lib/stdio/fseek.c
      - lib/stdio/ftell.c
      - lib/stdio/fwrite.c
      - lib/stdio/printf.c
      - lib/stdio/remove.c
      - lib/stdio/snprintf.c
      - lib/stdio/sprintf.c
      - lib/stdio/sscanf.c
      - lib/stdio/vfprintf.c
      - lib/stdio/vprintf.c
      - lib/stdio/vsnprintf.c
      - lib/stdio/vsprintf.c
      - lib/stdio/vsscanf.c
      - lib/stdlib/abort.c
      - lib/stdlib/qsort.c
      - lib/stdlib/strtod.c
      - lib/stdlib/strtof.c
      - lib/stdlib/strtol.c
      - lib/stdlib/strtold.c
      - lib/stdlib/strtoll.c
      - lib/stdlib/strtoul.c
      - lib/stdlib/strtoull.c
      - lib/string/memmem.c
      - lib/string/strcat.c
      - lib/string/strchr.c
      - lib/string/strlwr.c
      - lib/string/strncpy.c
      - lib/string/strrchr.c
      - lib/string/strstr.c
      - lib/string/strupr.c
      - lib/stub/sigaction.c
      - lib/stub/ldexp.c
      - lib/stub/mprotect.c
      - lib/stub/localtime.c
      - lib/stub/sigemptyset.c
      - lib/${MES_ARCH}-mes-mescc/setjmp.c
      - lib/linux/close.c
      - lib/linux/rmdir.c
      - lib/linux/stat.c
  - mescc libc+tcc.c
  - concat:
      output: ${LIBDIR}/${MES_ARCH}-mes/libc+tcc.a
      files:
      - ${LIBDIR}/${MES_ARCH}-mes/libc.a
      - libc+tcc.o
  - concat:
      output: ${LIBDIR}/${MES_ARCH}-mes/libc+tcc.s
      files:
      - ${LIBDIR}/${MES_ARCH}-mes/libc.s
      - libc+tcc.s
  # Mes's config.h is installed empty.
  - mkdir -p ${DESTDIR}${INCDIR}/mes
  - catm ${DESTDIR}${INCDIR}/mes/config.h
  install:
  - from: ${MES_PREFIX}/scripts
    to: ${BINDIR}
    rename:
      mescc.scm.in: mescc.scm
    mode: "755"
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
