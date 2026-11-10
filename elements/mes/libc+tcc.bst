kind: exec
(@): elements/mes/mes.yml

description: |
  libc+tcc.a: libc.a and what tcc needs on top.

build-depends:
- stage0/catm.bst
- stage0/cp.bst
- stage0/mkdir.bst
- stage0/rm.bst
- mes/libc.bst
- mes/mescc.bst

config:
  commands:
  - rm %{mes-prefix}/mes/module/mes/psyntax.pp %{mes-prefix}/mes/module/mes/psyntax.pp.header
  - cd: "%{mes-prefix}"
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
      - lib/string/strerror.c
      - lib/string/strlwr.c
      - lib/string/strncpy.c
      - lib/string/strpbrk.c
      - lib/string/strrchr.c
      - lib/string/strstr.c
      - lib/string/strupr.c
      - lib/stub/sigaction.c
      - lib/stub/ldexp.c
      - lib/stub/mprotect.c
      - lib/stub/localtime.c
      - lib/stub/putenv.c
      - lib/stub/realpath.c
      - lib/stub/sigemptyset.c
  - "%{mescc} libc+tcc.c"
  - concat:
      output: "lib/%{mes-cpu}-mes/libc+tcc.a"
      files:
      - "%{mes-lib}/libc.a"
      - libc+tcc.o
  - concat:
      output: "lib/%{mes-cpu}-mes/libc+tcc.s"
      files:
      - "%{mes-lib}/libc.s"
      - libc+tcc.s
  install:
  - from: "%{mes-prefix}/lib/%{mes-cpu}-mes"
    to: "%{mes-lib}"
    files:
    - libc+tcc.a
    - libc+tcc.s
