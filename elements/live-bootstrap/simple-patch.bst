kind: exec
(@): elements/stage0/m2libc.yml

description: |
  simple-patch, which replaces the first occurrence of a text in a file with
  another: simple-patch FILE BEFORE_FILE AFTER_FILE. Built from live-bootstrap's
  own source by the stage0 toolchain.

build-depends:
- live-bootstrap/source.bst
- stage0/m2-mesoplanet.bst
- stage0/m2libc.bst

variables:
  # exec's libdir is Mes's; this is where the dependencies stage theirs
  libdir: "%{prefix}/lib"

config:
  env:
    M2LIBC_PATH: "%{libdir}/m2libc"
  dirs:
  - "%{install-root}%{bindir}"
  commands:
  - >-
    M2-Mesoplanet --operating-system Linux --architecture %{m2libc-arch}
    -f %{libdir}/live-bootstrap/simple-patch-1.0/src/simple-patch.c
    -o %{install-root}%{bindir}/simple-patch
