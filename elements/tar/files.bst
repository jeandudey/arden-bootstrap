kind: import

description: |
  What tar needs that live-bootstrap's own files cannot give on every
  architecture, at %{libdir}/tar-files.

sources:
- kind: local
  path: files/tar-1.12

config:
  target: "%{libdir}/tar-files"
