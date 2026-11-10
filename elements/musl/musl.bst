kind: autotools
(@): elements/musl/musl.yml

description: |
  musl 1.1.24 again, built by the tcc that is built against musl-0, so that
  floating point literals in it are read by musl's strtod and not the Mes C
  library's, which does not scale fractions.

build-depends:
  (>):
  - tcc/musl-0/toolchain.bst
