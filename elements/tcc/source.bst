kind: import

description: |
  The tcc source tree at %{libdir}/tcc-src: Mes's tinycc, the branch that
  tracks the Mes release, with the changes that let mescc build it.

sources:
- kind: git_repo
  url: gitlab:janneke/tinycc
  track: mes-0.28
  ref: bb3a5029420c79220b7794ae45b728274661d752

config:
  target: "%{libdir}/tcc-src"
