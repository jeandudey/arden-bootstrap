kind: exec

build-depends:
- stage0.bst

sources:
- kind: local
  path: files/checksum-transcriber-1.0

config:
  commands:
  - mkdir -p %{install-root}%{bindir}
  - M2-Mesoplanet --architecture %{arch} -f src/checksum-transcriber.c -o %{install-root}%{bindir}/checksum-transcriber
