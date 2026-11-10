kind: exec
(@): elements/mes/mes.yml

description: |
  mescc.scm, scripts/mescc.scm.in with its @...@ filled in.

build-depends:
- stage0/chmod.bst
- stage0/cp.bst
- stage0/mkdir.bst
- stage0/replace.bst
- mes/sources.bst

runtime-depends:
- stage0/blood-elf.bst
- stage0/hex2.bst
- stage0/m1.bst
- mes/arch-headers.bst
- mes/config.bst
- mes/mes-m2.bst
- mes/sources.bst
- nyacc/nyacc.bst
- nyacc/source.bst

config:
  commands:
  - cd: "%{mes-prefix}/scripts"
  - replace --file mescc.scm.in --output mescc.scm.in --match-on @prefix@ --replace-with %{prefix}
  - replace --file mescc.scm.in --output mescc.scm.in --match-on @VERSION@ --replace-with 0.28
  - replace --file mescc.scm.in --output mescc.scm.in --match-on @mes_cpu@ --replace-with %{mes-cpu}
  - replace --file mescc.scm.in --output mescc.scm.in --match-on @mes_kernel@ --replace-with linux
  install:
  - from: "%{mes-prefix}/scripts"
    to: "%{bindir}"
    rename:
      mescc.scm.in: mescc.scm
    mode: "755"
