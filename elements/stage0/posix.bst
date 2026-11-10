kind: import
sources:
- kind: git_repo
  url: github:oriansj/stage0-posix-aarch64
  track: master
  ref: cedcddd24e74d10d0e41dd647e413fd7ee476530
  directory: aarch64
- kind: git_repo
  url: github:oriansj/stage0-posix-riscv64
  track: master
  ref: 7446a846e3e5b97eba5227e4b756f4ef257aa9e5
  directory: riscv64
- kind: git_repo
  url: github:oriansj/stage0-posix-amd64
  track: master
  ref: 15535f88e25825f01a0de275b6d45f77e618bd6b
  directory: amd64
config:
  target: "%{libdir}/stage0-posix"
  (?):
    - buildarch == "aarch64":
        source: aarch64
    - buildarch == "rv64g":
        source: riscv64
    - buildarch == "x86-64":
        source: amd64
