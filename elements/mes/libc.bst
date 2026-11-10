kind: exec
(@): elements/mes/mes.yml

description: |
  libc.a: libc-mini.a and the rest of the C library.

build-depends:
- stage0/catm.bst
- stage0/cp.bst
- stage0/mkdir.bst
- stage0/rm.bst
- mes/libc-mini.bst
- mes/mescc.bst

config:
  commands:
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
      - lib/stub/__raise.c
      - lib/ctype/isdigit.c
      - lib/ctype/isspace.c
      - lib/ctype/isxdigit.c
      - lib/mes/assert_msg.c
      - lib/posix/write.c
      - lib/stdlib/atoi.c
      - lib/linux/lseek.c
      - lib/dirent/__getdirentries.c
      - lib/dirent/closedir.c
      - lib/dirent/opendir.c
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
      - lib/%{mes-cpu}-mes-mescc/setjmp.c
      - lib/linux/access.c
      - lib/linux/brk.c
      - lib/linux/chdir.c
      - lib/linux/chmod.c
      - lib/linux/clock_gettime.c
      - lib/linux/close.c
      - lib/linux/dup.c
      - lib/linux/dup2.c
      - lib/linux/execve.c
      - lib/linux/fcntl.c
      - lib/linux/fork.c
      - lib/linux/fstat.c
      - lib/linux/fsync.c
      - lib/linux/_getcwd.c
      - lib/linux/getdents.c
      - lib/linux/gettimeofday.c
      - lib/linux/ioctl3.c
      - lib/linux/link.c
      - lib/linux/lstat.c
      - lib/linux/_open3.c
      - lib/linux/malloc.c
      - lib/linux/mkdir.c
      - lib/linux/nanosleep.c
      - lib/linux/pipe.c
      - lib/linux/_read.c
      - lib/linux/readdir.c
      - lib/linux/rename.c
      - lib/linux/rmdir.c
      - lib/linux/stat.c
      - lib/linux/symlink.c
      - lib/linux/time.c
      - lib/linux/umask.c
      - lib/linux/uname.c
      - lib/linux/unlink.c
      - lib/linux/utimensat.c
      - lib/linux/wait4.c
      - lib/linux/waitpid.c
      - lib/linux/%{mes-cpu}-mes-mescc/syscall.c
      - lib/linux/getpid.c
      - lib/linux/kill.c
  - "%{mescc} libc.c"
  - concat:
      output: "lib/%{mes-cpu}-mes/libc.a"
      files:
      - "%{mes-lib}/libc-mini.a"
      - libc.o
  - concat:
      output: "lib/%{mes-cpu}-mes/libc.s"
      files:
      - "%{mes-lib}/libc-mini.s"
      - libc.s
  install:
  - from: "%{mes-prefix}/lib/%{mes-cpu}-mes"
    to: "%{mes-lib}"
    files:
    - libc.a
    - libc.s
