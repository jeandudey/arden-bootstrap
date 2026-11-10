kind: import

description: |
  The oyacc 6.6 source tree at %{libdir}/oyacc-src.

sources:
- kind: tar
  url: "github:ibara/yacc/releases/download/oyacc-6.6/oyacc-6.6.tar.gz"
  ref: eb0866e740b79bd3a23e0ca47885eb3148aab18d77a4bedba96e979d8b4ebfe1

config:
  target: "%{libdir}/oyacc-src"
