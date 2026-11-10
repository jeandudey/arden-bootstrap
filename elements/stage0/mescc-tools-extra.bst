kind: import
sources:
- kind: git_repo
  url: github:oriansj/mescc-tools-extra
  track: "Release_*"
  exclude: ["debian/*"]
  ref-format: git-describe
  ref: Release_1.4.0-0-ga151c245e512076971a3c85bb1502cf92cfa83b6
config:
  target: "%{libdir}/mescc-tools-extra"
