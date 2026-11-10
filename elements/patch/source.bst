kind: import

description: |
  The patch 2.5.9 source tree at %{libdir}/patch-src.

sources:
- kind: tar
  url: "kernel-mirror:gnu/patch/patch-2.5.9.tar.gz"
  ref: ecb5c6469d732bcf01d6ec1afe9e64f1668caba5bfdb103c28d7f537ba3cdb8a

config:
  target: "%{libdir}/patch-src"
