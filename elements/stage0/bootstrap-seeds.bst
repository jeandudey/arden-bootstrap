kind: import
description: Bootstrap binaries.
sources:
- kind: git_repo
  url: github:oriansj/bootstrap-seeds
  track: master
  ref: cedec6b8066d1db229b6c77d42d120a23c6980ed
config:
  target: "%{libdir}/bootstrap-seeds"
  (?):
    - buildarch == "aarch64":
        source: POSIX/AArch64
    - buildarch == "rv64g":
        source: POSIX/riscv64
    - buildarch == "x86-64":
        source: POSIX/AMD64
