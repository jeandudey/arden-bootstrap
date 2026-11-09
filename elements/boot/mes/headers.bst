(@): include/mes.yml

kind: exec

description: |
  Mes's C library headers and its hex2 and M1 support files.

build-depends:
- stage0.bst
- boot/mes/sources.bst

config:
  commands:
  # Mes's config.h is installed empty.
  - mkdir -p %{destdir}%{incdir}/mes
  - catm %{destdir}%{incdir}/mes/config.h
  install:
  - from: "%{mes-prefix}/lib/%{arch}-mes"
    to: "%{mes-lib}"
    files:
    - "%{arch}.M1"
  - from: "%{mes-prefix}/lib/linux/%{arch}-mes"
    to: "%{prefix}/lib/linux/%{arch}-mes"
    files:
    - elf32-footer-single-main.hex2
    - elf32-header.hex2
  - from: "%{mes-prefix}/include"
    to: "%{incdir}"
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
  # The architecture's headers go under arch/.
  - from: "%{mes-prefix}/include/linux/%{arch}"
    to: "%{incdir}/arch"
    files:
    - kernel-stat.h
    - signal.h
    - syscall.h
