kind: import

description: |
  The Mes source tree at %{libdir}/mes, as released, with four patches that
  let tcc build its C library on x86_64: a va_list, the clobbers of _exit, a
  signal restorer and the width of printf's integers.

sources:
- kind: tar
  url: "kernel-mirror:gnu/mes/mes-0.28.tar.gz"
  ref: 22d92e0b76d413dacd2eaa6db864093926f111389aa515a447555d4a2ff07842
- kind: patch
  path: files/mes-0.28/stdarg-tcc-x86_64.patch
- kind: patch
  path: files/mes-0.28/exit-clobbers-x86_64.patch
- kind: patch
  path: files/mes-0.28/signal-restorer-tcc-x86_64.patch
- kind: patch
  path: files/mes-0.28/printf-int-x86_64.patch

config:
  target: "%{libdir}/mes"
