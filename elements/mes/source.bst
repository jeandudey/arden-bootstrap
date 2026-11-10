kind: import

description: |
  The Mes source tree at %{libdir}/mes, as released, with one patch: a va_list
  for tcc on x86_64.

sources:
- kind: tar
  url: "kernel-mirror:gnu/mes/mes-0.28.tar.gz"
  ref: 22d92e0b76d413dacd2eaa6db864093926f111389aa515a447555d4a2ff07842
- kind: patch
  path: files/mes-0.28/stdarg-tcc-x86_64.patch

config:
  target: "%{libdir}/mes"
