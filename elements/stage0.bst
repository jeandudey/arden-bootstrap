kind: raw
description: |
  stage0-posix, the smallest binary seed the bootstrap starts from, which
  builds up to a C compiler.

sources:
- kind: git
  url: github:oriansj/stage0-posix
  track: master
  ref: 643598041bf7639883874fe2cdc9d9693c9b03d5
config:
  command:
  - ./bootstrap-seeds/POSIX/x86/kaem-optional-seed
  # The build tree is the whole stage0-posix checkout (33M); everything later
  # steps use is the tools and the M2libc headers.
  keep:
  - x86/bin
  - M2libc
