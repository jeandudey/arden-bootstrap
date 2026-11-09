kind: exec

build-depends:
- stage0.bst

sources:
- kind: local
  path: files/simple-patch-1.0

config:
  commands:
  - mkdir -p %{destdir}%{bindir}
  - M2-Mesoplanet --architecture %{arch} -f src/simple-patch.c -o %{destdir}%{bindir}/simple-patch
