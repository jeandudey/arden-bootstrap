kind: import

description: |
  The gzip 1.2.4 source tree at %{libdir}/gzip-src.

sources:
- kind: tar
  url: "kernel-mirror:gnu/gzip/gzip-1.2.4.tar.gz"
  ref: 1ca41818a23c9c59ef1d5e1d00c0d5eaa2285d931c0fb059637d7c0cc02ad967

config:
  target: "%{libdir}/gzip-src"
