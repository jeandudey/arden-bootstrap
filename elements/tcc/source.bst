kind: import

description: |
  The tcc source tree at %{libdir}/tcc-src: Mes's tinycc, the branch that
  tracks the Mes release, with one patch: negative float constants.

sources:
- kind: git_repo
  url: gitlab:janneke/tinycc
  track: "refs/heads/mes-*"
  ref-format: git-describe
  ref: release_0_9_26-1188-gbb3a5029420c79220b7794ae45b728274661d752
- kind: patch
  path: files/tinycc-mes-0.28/negative-zero.patch

config:
  target: "%{libdir}/tcc-src"
