(@): include/mes.yml

kind: exec

description: |
  include/arch, which mescc's builds look in: Mes's linux headers for the architecture.

build-depends:
- stage0.bst
- boot/mes/sources.bst

config:
  install:
  - from: "%{mes-prefix}/include/linux/%{arch}"
    to: "%{mes-prefix}/include/arch"
    files:
    - kernel-stat.h
    - signal.h
    - syscall.h
