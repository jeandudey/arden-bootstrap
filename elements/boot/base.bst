kind: kaem

description: |
  The directory layout and the stage0 tools in /usr/bin, which is where every
  later step looks for them.

# A runtime dependency: whatever stages base also gets stage0's tools and M2libc.
depends:
- stage0.bst

config:
  commands:
  # stage0's cp drops the executable bit: copy with the originals, then chmod.
  - PATH=/${ARCH_DIR}/bin
  - mkdir -p ${DESTDIR}${BINDIR} ${DESTDIR}${LIBDIR} ${DESTDIR}${INCDIR}
  - cp /${ARCH_DIR}/bin/blood-elf ${DESTDIR}${BINDIR}/blood-elf
  - cp /${ARCH_DIR}/bin/catm ${DESTDIR}${BINDIR}/catm
  - cp /${ARCH_DIR}/bin/chmod ${DESTDIR}${BINDIR}/chmod
  - cp /${ARCH_DIR}/bin/cp ${DESTDIR}${BINDIR}/cp
  - cp /${ARCH_DIR}/bin/get_machine ${DESTDIR}${BINDIR}/get_machine
  - cp /${ARCH_DIR}/bin/hex2 ${DESTDIR}${BINDIR}/hex2
  - cp /${ARCH_DIR}/bin/kaem ${DESTDIR}${BINDIR}/kaem
  - cp /${ARCH_DIR}/bin/match ${DESTDIR}${BINDIR}/match
  - cp /${ARCH_DIR}/bin/M1 ${DESTDIR}${BINDIR}/M1
  - cp /${ARCH_DIR}/bin/M2-Mesoplanet ${DESTDIR}${BINDIR}/M2-Mesoplanet
  - cp /${ARCH_DIR}/bin/M2-Planet ${DESTDIR}${BINDIR}/M2-Planet
  - cp /${ARCH_DIR}/bin/mkdir ${DESTDIR}${BINDIR}/mkdir
  - cp /${ARCH_DIR}/bin/replace ${DESTDIR}${BINDIR}/replace
  - cp /${ARCH_DIR}/bin/rm ${DESTDIR}${BINDIR}/rm
  - cp /${ARCH_DIR}/bin/sha256sum ${DESTDIR}${BINDIR}/sha256sum
  - cp /${ARCH_DIR}/bin/unbz2 ${DESTDIR}${BINDIR}/unbz2
  - cp /${ARCH_DIR}/bin/ungz ${DESTDIR}${BINDIR}/ungz
  - cp /${ARCH_DIR}/bin/untar ${DESTDIR}${BINDIR}/untar
  - cp /${ARCH_DIR}/bin/unxz ${DESTDIR}${BINDIR}/unxz
  - chmod 755 ${DESTDIR}${BINDIR}/blood-elf ${DESTDIR}${BINDIR}/catm ${DESTDIR}${BINDIR}/chmod ${DESTDIR}${BINDIR}/cp
  - chmod 755 ${DESTDIR}${BINDIR}/get_machine ${DESTDIR}${BINDIR}/hex2 ${DESTDIR}${BINDIR}/kaem ${DESTDIR}${BINDIR}/match
  - chmod 755 ${DESTDIR}${BINDIR}/M1 ${DESTDIR}${BINDIR}/M2-Mesoplanet ${DESTDIR}${BINDIR}/M2-Planet ${DESTDIR}${BINDIR}/mkdir
  - chmod 755 ${DESTDIR}${BINDIR}/replace ${DESTDIR}${BINDIR}/rm ${DESTDIR}${BINDIR}/sha256sum ${DESTDIR}${BINDIR}/unbz2
  - chmod 755 ${DESTDIR}${BINDIR}/ungz ${DESTDIR}${BINDIR}/untar ${DESTDIR}${BINDIR}/unxz
