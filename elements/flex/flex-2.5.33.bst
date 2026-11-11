kind: manual
(@): elements/gcc/tools-new.yml

description: |
  flex 2.5.33, from a snapshot of its sources, with its configure made again.

sources:
- kind: tar
  url: "github:westes/flex/archive/e6f147b7a5f2ec2dc862dc9d30b3734b9555a1ea.tar.gz"
  ref: baec69069ff58b7cdbe0103ffc16f29d4857428c29efcdf685c574d8300fd838

variables:
  lb: "%{libdir}/live-bootstrap/flex-2.5.33"

config:
  configure-commands:
  - |
    chmod -R u+w .
    patch -Np1 -i %{lb}/patches/disable-unavailables.patch
    AUTOPOINT=true AUTOMAKE=automake-1.15 ACLOCAL=aclocal-1.15 autoreconf-2.69 -fi
    ./configure \
        --prefix="%{prefix}" \
        --libdir="%{libdir}" \
        --program-suffix=-2.5.33
  build-commands:
  - |
    make MAKEINFO=true SUBDIRS=.
  install-commands:
  - |
    make MAKEINFO=true SUBDIRS=. DESTDIR="%{install-root}" install
