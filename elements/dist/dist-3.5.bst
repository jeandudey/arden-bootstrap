kind: manual
(@): elements/gcc/tools-4.7.4.yml

description: |
  dist 3.5, which has metaconfig and makegloss, which the perls from 5.8.9 use
  to make their Configure.  It is built and run by perl 5.6.2, with the
  config.sh and the patch live-bootstrap has.

build-depends:
  (>):
  - live-bootstrap/source.bst
  - patch/patch.bst

sources:
- kind: tar
  url: "github:rmanfredi/dist/archive/99eb95e214b87a84b0a7752adba30e9b0fec977f.tar.gz"
  ref: 20cfcd13d588abdcb502c1c4682fb1f33ffefd307625b3b877d21ad938a7b705

variables:
  lb-dist: "%{libdir}/live-bootstrap/dist-3.5"

config:
  configure-commands:
  - |
    patch -Np1 -i %{lb-dist}/patches/env.patch
    cp %{lb-dist}/files/config.sh.in .
    sed 's/@PERLVER@/5.6.2/' config.sh.in > config.sh
    find . -name Makefile.SH -delete
    rm -f Configure
  build-commands:
  - |
    cd mcon
    ./mconfig.SH
    perl ../bin/perload -o mconfig > metaconfig
    ./makegloss.SH
    cd ..
    cd kit
    ./manifake.SH
  install-commands:
  - |
    mkdir -p %{install-root}%{bindir} %{install-root}%{libdir}/perl5/5.6.2
    install mcon/metaconfig %{install-root}%{bindir}/
    install mcon/makegloss %{install-root}%{bindir}/
    install kit/manifake %{install-root}%{bindir}/
    cp -r mcon/U/ %{install-root}%{libdir}/perl5/5.6.2/
