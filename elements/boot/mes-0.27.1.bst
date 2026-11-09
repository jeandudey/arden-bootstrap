kind: kaem

description: |
  GNU Mes: mes-m2 built with M2-Planet, then Mes's C library built with mescc.

build-depends:
- boot/base.bst
- boot/simple-patch-1.0.bst

sources:
- kind: local
  path: files/mes-0.27.1
- kind: remote
  url: "kernel-mirror:gnu/mes/mes-0.27.1.tar.gz"
  filename: "mes-0.27.1.tar.gz"
  ref: 183a40ea47ea49f8a1e3bd1b9d12e676374d64d63bc79e7bc1ae7d673dfdf25d
  directory: distfiles
- kind: remote
  url: "github:Googulator/nyacc/releases/download/V1.00.2-lb1/nyacc-1.00.2-lb1.tar.gz"
  filename: "nyacc-1.00.2-lb1.tar.gz"
  ref: 708c943f89c972910e9544ee077771acbd0a2c0fc6d33496fe158264ddb65327
  directory: distfiles

config:
  env:
    SRCDIR: /build
    DISTFILES: /build/distfiles
    NYACC_PKG: nyacc-1.00.2
    MES_PKG: mes-0.27.1
    MES_VERSION: 0.27.1
    MES_PREFIX: ${SRCDIR}/build/${MES_PKG}
    GUILE_LOAD_PATH: ${MES_PREFIX}/mes/module:${MES_PREFIX}/module:${SRCDIR}/build/${NYACC_PKG}/module
  commands:
  - kaem --file build.kaem
