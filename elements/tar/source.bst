kind: import

description: |
  The tar 1.12 source tree at %{libdir}/tar-src.

sources:
- kind: tar
  url: "kernel-mirror:gnu/tar/tar-1.12.tar.gz"
  ref: c6c37e888b136ccefab903c51149f4b7bd659d69d4aea21245f61053a57aa60a

config:
  target: "%{libdir}/tar-src"
