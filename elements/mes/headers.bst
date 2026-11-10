kind: exec
(@): elements/mes/mes.yml

description: |
  Mes's C library headers, and the hex2 and M1 files that go with them.

build-depends:
- stage0/cp.bst
- stage0/mkdir.bst
- mes/config.bst
- mes/sources.bst

config:
  install:
  - from: "%{mes-prefix}/lib/%{mes-cpu}-mes"
    to: "%{mes-lib}"
    files:
    - "%{mes-cpu}.M1"
  - from: "%{mes-prefix}/lib/linux/%{mes-cpu}-mes"
    to: "%{prefix}/lib/linux/%{mes-cpu}-mes"
    files:
    - elf64-footer-single-main.hex2
    - elf64-header.hex2
  - from: "%{mes-prefix}/include"
    to: "%{incdir}"
    files:
    - alloca.h
    - ar.h
    - argz.h
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
    - linux/%{mes-cpu}/syscall.h
    - linux/syscall.h
    - locale.h
    - math.h
    - memory.h
    - mes/builtins.h
    - mes/config.h
    - mes/constants.h
    - mes/lib-cc.h
    - mes/lib-mini.h
    - mes/lib.h
    - mes/mes.h
    - mes/mescc-builtins.h
    - mes/symbols.h
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
    - sys/cdefs.h
    - sys/dir.h
    - sys/file.h
    - sys/ioctl.h
    - sys/mman.h
    - sys/param.h
    - sys/resource.h
    - sys/select.h
    - sys/stat.h
    - sys/time.h
    - sys/timeb.h
    - sys/times.h
    - sys/types.h
    - sys/ucontext.h
    - sys/user.h
    - sys/utsname.h
    - sys/wait.h
    - termio.h
    - time.h
    - unistd.h
  - from: "%{mes-prefix}/include/linux/%{mes-cpu}"
    to: "%{incdir}/arch"
    files:
    - kernel-stat.h
    - signal.h
    - syscall.h
