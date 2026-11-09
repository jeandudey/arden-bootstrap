kind: kaem

build-depends:
- boot/base.bst

sources:
- kind: local
  path: files/simple-patch-1.0

config:
  commands:
  - mkdir -p ${DESTDIR}${BINDIR}
  - M2-Mesoplanet --architecture ${ARCH} -f src/simple-patch.c -o ${DESTDIR}${BINDIR}/simple-patch
