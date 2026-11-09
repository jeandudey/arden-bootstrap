(@): include/mes.yml

kind: exec

description: |
  mes-m2, built by M2-Planet from Mes's own kaem.run, and mescc.scm.

build-depends:
- stage0.bst
- boot/mes/sources.bst

config:
  env:
    cc_cpu: i386
    mes_cpu: "%{arch}"
    stage0_cpu: "%{arch}"
  commands:
  # Pregenerated, so that it is rebuilt from source.
  - rm %{mes-prefix}/mes/module/mes/psyntax.pp %{mes-prefix}/mes/module/mes/psyntax.pp.header
  - cd: "%{mes-prefix}"
  # Mes's build script, as upstream wrote it.
  - script: kaem.run
  install:
  - from: "%{mes-prefix}/bin"
    to: "%{bindir}"
    files:
    - mes-m2
    mode: "755"
  # mescc.scm is scripts/mescc.scm.in with its @...@ filled in by a patch.
  - from: "%{mes-prefix}/scripts"
    to: "%{bindir}"
    rename:
      mescc.scm.in: mescc.scm
    mode: "755"
