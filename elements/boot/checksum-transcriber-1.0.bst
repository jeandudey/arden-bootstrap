kind: kaem

build-depends:
- boot/base.bst

sources:
- kind: local
  path: files/checksum-transcriber-1.0

config:
  commands:
  - mkdir -p ${DESTDIR}${BINDIR}
  - M2-Mesoplanet --architecture ${ARCH} -f src/checksum-transcriber.c -o ${DESTDIR}${BINDIR}/checksum-transcriber
