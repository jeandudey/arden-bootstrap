kind: import

description: |
  The bash 2.05b source tree at %{libdir}/bash-src.

sources:
- kind: tar
  url: "kernel-mirror:gnu/bash/bash-2.05b.tar.gz"
  ref: ba03d412998cc54bd0b0f2d6c32100967d3137098affdc2d32e6e7c11b163fe4

config:
  target: "%{libdir}/bash-src"
