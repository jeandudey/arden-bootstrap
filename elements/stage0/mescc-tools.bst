kind: import
sources:
- kind: git_repo
  url: savannah-nongnu:mescc-tools.git
  track: "Release_*"
  exclude: ["debian/*"]
  ref-format: git-describe
  ref: Release_1.7.0-0-g5adfbf3364261a77109878a56b100aeeb6ef9ac4
config:
  target: "%{libdir}/mescc-tools"
