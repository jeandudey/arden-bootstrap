kind: stage0
(@): elements/stage0/m2libc.yml

description: |
  mes-m2, Mes built by M2-Planet: the steps of Mes's kaem.run (M2-Planet,
  blood-elf, M1, hex2) as a stage0 element, with no kaem.

build-depends:
- stage0/blood-elf.bst
- stage0/hex2.bst
- stage0/m1.bst
- stage0/m2-0.bst
- stage0/m2libc.bst
- mes/sources.bst
- mes/config.bst

variables:
  mes-prefix: "%{libdir}/mes"
  (?):
    - buildarch == "rv64g":
        mes-cpu: riscv64
    - buildarch == "x86-64":
        mes-cpu: x86_64

config:
  (?):
    - buildarch == "rv64g":
        defines:
        - __riscv64__=1
        - __linux__=1
    - buildarch == "x86-64":
        defines:
        - __x86_64__=1
        - __linux__=1
  assembler: "%{bindir}/hex2"
  compiler: M2
  macro-assembler: M1
  architecture: "%{m2libc-arch}"
  bootstrap-mode: false
  debug: true
  macro-flags: ["--little-endian"]
  footer-tool: blood-elf
  footer-flags: ["--64", "--little-endian"]
  link-flags: ["--little-endian", "--base-address", "0x1000000"]
  sources:
  - "%{mes-prefix}/lib/m2/%{mes-cpu}/ELF-%{mes-cpu}.hex2"
  # M2libc's defs, not Mes's: this M2-Planet emits macros Mes's own defs lack,
  # such as lea_rax,[rdi+DWORD] on x86_64.
  - "%{libdir}/m2libc/%{m2libc-arch}/%{m2libc-arch}_defs.M1"
  - "%{mes-prefix}/lib/%{mes-cpu}-mes/%{mes-cpu}.M1"
  - "%{mes-prefix}/lib/linux/%{mes-cpu}-mes-m2/crt1.M1"
  - "%{mes-prefix}/include/mes/config.h"
  - "%{mes-prefix}/include/mes/lib-mini.h"
  - "%{mes-prefix}/include/mes/lib.h"
  - "%{mes-prefix}/lib/linux/%{mes-cpu}-mes-m2/crt1.c"
  - "%{mes-prefix}/lib/mes/__init_io.c"
  - "%{mes-prefix}/lib/linux/%{mes-cpu}-mes-m2/_exit.c"
  - "%{mes-prefix}/lib/linux/%{mes-cpu}-mes-m2/_write.c"
  - "%{mes-prefix}/lib/mes/globals.c"
  - "%{mes-prefix}/lib/m2/cast.c"
  - "%{mes-prefix}/lib/stdlib/exit.c"
  - "%{mes-prefix}/lib/mes/write.c"
  - "%{mes-prefix}/include/linux/%{mes-cpu}/syscall.h"
  - "%{mes-prefix}/lib/linux/%{mes-cpu}-mes-m2/syscall.c"
  - "%{mes-prefix}/lib/stub/__raise.c"
  - "%{mes-prefix}/lib/linux/brk.c"
  - "%{mes-prefix}/lib/linux/malloc.c"
  - "%{mes-prefix}/lib/string/memset.c"
  - "%{mes-prefix}/lib/linux/read.c"
  - "%{mes-prefix}/lib/mes/fdgetc.c"
  - "%{mes-prefix}/lib/stdio/getchar.c"
  - "%{mes-prefix}/lib/stdio/putchar.c"
  - "%{mes-prefix}/lib/stub/__buffered_read.c"
  - "%{mes-prefix}/include/errno.h"
  - "%{mes-prefix}/include/fcntl.h"
  - "%{mes-prefix}/lib/linux/_open3.c"
  - "%{mes-prefix}/lib/linux/open.c"
  - "%{mes-prefix}/lib/mes/mes_open.c"
  - "%{mes-prefix}/lib/string/strlen.c"
  - "%{mes-prefix}/lib/mes/eputs.c"
  - "%{mes-prefix}/lib/mes/fdputc.c"
  - "%{mes-prefix}/lib/mes/eputc.c"
  - "%{mes-prefix}/include/time.h"
  - "%{mes-prefix}/include/sys/time.h"
  - "%{mes-prefix}/include/m2/types.h"
  - "%{mes-prefix}/include/sys/types.h"
  - "%{mes-prefix}/include/sys/utsname.h"
  - "%{mes-prefix}/include/mes/constants.h"
  - "%{mes-prefix}/include/mes/mes.h"
  - "%{mes-prefix}/include/mes/builtins.h"
  - "%{mes-prefix}/include/mes/symbols.h"
  - "%{mes-prefix}/lib/mes/__assert_fail.c"
  - "%{mes-prefix}/lib/mes/assert_msg.c"
  - "%{mes-prefix}/lib/mes/fdputc.c"
  - "%{mes-prefix}/lib/string/strncmp.c"
  - "%{mes-prefix}/lib/posix/getenv.c"
  - "%{mes-prefix}/lib/mes/fdputs.c"
  - "%{mes-prefix}/lib/mes/ntoab.c"
  - "%{mes-prefix}/lib/ctype/isdigit.c"
  - "%{mes-prefix}/lib/ctype/isxdigit.c"
  - "%{mes-prefix}/lib/ctype/isspace.c"
  - "%{mes-prefix}/lib/ctype/isnumber.c"
  - "%{mes-prefix}/lib/mes/abtol.c"
  - "%{mes-prefix}/lib/stdlib/atoi.c"
  - "%{mes-prefix}/lib/string/memcpy.c"
  - "%{mes-prefix}/lib/stdlib/free.c"
  - "%{mes-prefix}/lib/stdlib/realloc.c"
  - "%{mes-prefix}/lib/string/strcpy.c"
  - "%{mes-prefix}/lib/mes/itoa.c"
  - "%{mes-prefix}/lib/mes/ltoa.c"
  - "%{mes-prefix}/lib/mes/fdungetc.c"
  - "%{mes-prefix}/lib/posix/setenv.c"
  - "%{mes-prefix}/lib/linux/access.c"
  - "%{mes-prefix}/include/linux/m2/kernel-stat.h"
  - "%{mes-prefix}/include/sys/stat.h"
  - "%{mes-prefix}/lib/linux/chmod.c"
  - "%{mes-prefix}/lib/linux/ioctl3.c"
  - "%{mes-prefix}/include/sys/ioctl.h"
  - "%{mes-prefix}/lib/m2/isatty.c"
  - "%{mes-prefix}/include/signal.h"
  - "%{mes-prefix}/lib/linux/fork.c"
  - "%{mes-prefix}/lib/m2/execve.c"
  - "%{mes-prefix}/lib/m2/execv.c"
  - "%{mes-prefix}/include/sys/resource.h"
  - "%{mes-prefix}/lib/linux/wait4.c"
  - "%{mes-prefix}/lib/linux/waitpid.c"
  - "%{mes-prefix}/lib/linux/gettimeofday.c"
  - "%{mes-prefix}/lib/linux/clock_gettime.c"
  - "%{mes-prefix}/lib/m2/time.c"
  - "%{mes-prefix}/lib/linux/_getcwd.c"
  - "%{mes-prefix}/include/limits.h"
  - "%{mes-prefix}/lib/m2/getcwd.c"
  - "%{mes-prefix}/lib/linux/dup.c"
  - "%{mes-prefix}/lib/linux/dup2.c"
  - "%{mes-prefix}/lib/string/strcmp.c"
  - "%{mes-prefix}/lib/string/memcmp.c"
  - "%{mes-prefix}/lib/linux/uname.c"
  - "%{mes-prefix}/lib/linux/unlink.c"
  - "%{mes-prefix}/src/builtins.c"
  - "%{mes-prefix}/src/core.c"
  - "%{mes-prefix}/src/display.c"
  - "%{mes-prefix}/src/eval-apply.c"
  - "%{mes-prefix}/src/gc.c"
  - "%{mes-prefix}/src/hash.c"
  - "%{mes-prefix}/src/lib.c"
  - "%{mes-prefix}/src/math.c"
  - "%{mes-prefix}/src/mes.c"
  - "%{mes-prefix}/src/module.c"
  - "%{mes-prefix}/src/posix.c"
  - "%{mes-prefix}/src/reader.c"
  - "%{mes-prefix}/src/string.c"
  - "%{mes-prefix}/src/struct.c"
  - "%{mes-prefix}/src/symbol.c"
  - "%{mes-prefix}/src/variable.c"
  - "%{mes-prefix}/src/compiler.c"
  - "%{mes-prefix}/src/vector.c"
  target: "%{bindir}/mes-m2"
