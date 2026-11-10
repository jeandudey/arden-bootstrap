kind: import

description: |
  The coreutils 5.0 source tree at %{libdir}/coreutils-src.

sources:
- kind: tar
  url: "kernel-mirror:gnu/coreutils/coreutils-5.0.tar.bz2"
  ref: c25b36b8af6e0ad2a875daf4d6196bd0df28a62be7dd252e5f99a4d5d7288d95

config:
  target: "%{libdir}/coreutils-src"
