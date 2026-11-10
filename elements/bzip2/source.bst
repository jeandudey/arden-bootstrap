kind: import

description: |
  The bzip2 1.0.8 source tree at %{libdir}/bzip2-src.

sources:
- kind: tar
  url: "sourceware:pub/bzip2/bzip2-1.0.8.tar.gz"
  ref: ab5a03176ee106d3f0fa90e381da478ddae405918153cca248e682cd0c4a2269

config:
  target: "%{libdir}/bzip2-src"
