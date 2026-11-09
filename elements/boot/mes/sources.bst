kind: import

description: |
  The Mes and nyacc source trees, with the edits live-bootstrap makes to them,
  at /src. Everything that builds Mes, and tcc after it, starts from this.

sources:
- kind: tar
  url: "kernel-mirror:gnu/mes/mes-0.27.1.tar.gz"
  ref: 183a40ea47ea49f8a1e3bd1b9d12e676374d64d63bc79e7bc1ae7d673dfdf25d
  directory: mes-0.27.1
- kind: tar
  url: "github:Googulator/nyacc/releases/download/V1.00.2-lb1/nyacc-1.00.2-lb1.tar.gz"
  ref: 708c943f89c972910e9544ee077771acbd0a2c0fc6d33496fe158264ddb65327
  directory: nyacc-1.00.2
# Applied to the Mes tree, in this order.
- kind: patch
  path: files/mes-0.27.1/patches/kaem-base-address.patch
  directory: mes-0.27.1
- kind: patch
  path: files/mes-0.27.1/patches/config-h.patch
  directory: mes-0.27.1
- kind: patch
  path: files/mes-0.27.1/patches/wait4.patch
  directory: mes-0.27.1
- kind: patch
  path: files/mes-0.27.1/patches/mescc-scm.patch
  directory: mes-0.27.1

config:
  source: /
  target: /src
