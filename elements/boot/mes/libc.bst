(@): include/mes.yml

kind: exec

description: |
  libc.a: libc-mini.a and the rest of the C library.

build-depends:
- stage0.bst
- boot/mes/sources.bst
- boot/mes/arch-headers.bst
- boot/mes/mes-m2.bst
- boot/mes/nyacc.bst
- boot/mes/libc-mini.bst

config:
  commands:
  # Pregenerated, so that it is rebuilt from source.
  - rm %{mes-prefix}/mes/module/mes/psyntax.pp %{mes-prefix}/mes/module/mes/psyntax.pp.header
  - cd: "%{mes-prefix}"
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
      - lib/linux/%{arch}-mes-mescc/syscall.c
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
  - "%{mescc} libc.c"
  - concat:
      output: "lib/%{arch}-mes/libc.a"
      files:
      - "%{mes-lib}/libc-mini.a"
      - libc.o
  - concat:
      output: "lib/%{arch}-mes/libc.s"
      files:
      - "%{mes-lib}/libc-mini.s"
      - libc.s
  install:
  - from: "%{mes-prefix}/lib/%{arch}-mes"
    to: "%{mes-lib}"
    files:
    - libc.a
    - libc.s
