kind: import

description: |
  What bash needs that live-bootstrap's own patches do not give it, at
  %{libdir}/bash-files.

sources:
- kind: local
  path: files/bash-2.05b

config:
  target: "%{libdir}/bash-files"
