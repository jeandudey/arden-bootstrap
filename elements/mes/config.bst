kind: import

description: |
  include/mes/config.h, which Mes's configure.sh writes and the tarball does
  not ship.

sources:
- kind: local
  path: files/mes-0.28

config:
  target: "%{libdir}/mes/include/mes"
