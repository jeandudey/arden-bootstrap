kind: import

description: |
  The sed 4.0.9 source tree at %{libdir}/sed-src.

sources:
- kind: tar
  url: "kernel-mirror:gnu/sed/sed-4.0.9.tar.gz"
  ref: c365874794187f8444e5d22998cd5888ffa47f36def4b77517a808dec27c0600

config:
  target: "%{libdir}/sed-src"
