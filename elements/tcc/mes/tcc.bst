kind: exec
(@): elements/tcc/tcc.yml

description: |
  tcc-mes, tcc built by mescc: the first compiler that is not Mes's own.

build-depends:
- stage0/catm.bst
- stage0/chmod.bst
- stage0/cp.bst
- stage0/mkdir.bst
- mes/mes.bst
- tcc/source.bst

config:
  commands:
  - cd: "%{tcc-src}"
  - catm config.h
  - >-
    mes-m2 -e main %{bindir}/mescc.scm -- -S -o tcc.s
    -I %{incdir} -D BOOTSTRAP=1 -D HAVE_LONG_LONG=1 -I .
    -D TCC_TARGET_%{tcc-target}=1 -D inline=
    -D CONFIG_TCCDIR=\"%{tcc-lib}/tcc\" -D CONFIG_SYSROOT=\"/\"
    -D CONFIG_TCC_CRTPREFIX=\"%{tcc-lib}\" -D CONFIG_TCC_ELFINTERP=\"/mes/loader\"
    -D CONFIG_TCC_SYSINCLUDEPATHS=\"%{incdir}\"
    -D TCC_LIBGCC=\"%{tcc-lib}/libc.a\" -D CONFIG_TCC_LIBTCC1_MES=0
    -D CONFIG_TCCBOOT=1 -D CONFIG_TCC_STATIC=1 -D CONFIG_USE_LIBGCC=1
    -D TCC_VERSION=\"0.9.27\" -D ONE_SOURCE=1 tcc.c
  - >-
    mes-m2 -e main %{bindir}/mescc.scm -- --base-address 0x08048000
    -o tcc-mes -L %{libdir} tcc.s -l c+tcc
  install:
  - from: "%{tcc-src}"
    to: "%{bindir}"
    files:
    - tcc-mes
    mode: "755"
