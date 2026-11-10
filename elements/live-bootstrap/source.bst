kind: import

description: |
  live-bootstrap's steps/ directory, from upstream, at %{libdir}/live-bootstrap:
  the sources of its own tools (simple-patch-1.0/src) and the files and
  simple-patches each step ships (mes-0.27.1/files, mes-0.27.1/simple-patches).

sources:
- kind: git
  url: github:fosslinux/live-bootstrap
  track: master
  ref: b1ceced7ea8a819a26f23796f6dd7ae8496a33a4

config:
  source: steps
  target: "%{libdir}/live-bootstrap"
