kind: import

description: |
  What gzip needs that live-bootstrap's own files cannot give on every
  architecture, at %{libdir}/gzip-files.

sources:
- kind: local
  path: files/gzip-1.2.4

config:
  target: "%{libdir}/gzip-files"
