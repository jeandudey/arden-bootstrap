kind: import

description: |
  The nyacc source tree at %{libdir}/nyacc, the 1.00.2 that Mes is known to
  work with, as live-bootstrap builds it.

sources:
- kind: tar
  url: "github:Googulator/nyacc/releases/download/V1.00.2-lb1/nyacc-1.00.2-lb1.tar.gz"
  ref: 708c943f89c972910e9544ee077771acbd0a2c0fc6d33496fe158264ddb65327

config:
  target: "%{libdir}/nyacc"
