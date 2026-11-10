kind: exec
(@): elements/mes/mes.yml

description: |
  include/arch, which mescc's builds look in: Mes's linux headers for the architecture.

build-depends:
- stage0/cp.bst
- stage0/mkdir.bst
- mes/sources.bst

config:
  install:
  - from: "%{mes-prefix}/include/linux/%{mes-cpu}"
    to: "%{mes-prefix}/include/arch"
    files:
    - kernel-stat.h
    - signal.h
    - syscall.h
