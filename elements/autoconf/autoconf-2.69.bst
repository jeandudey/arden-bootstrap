kind: manual
(@): elements/autoconf/autoconf.yml

description: |
  autoconf 2.69, configured and built by the autoconf and the automake before
  it, as live-bootstrap does.  The manuals and the tests that were made
  before are left out, and the data files go in a directory with its version.

build-depends:
  (>):
  - autoconf/autoconf-2.64.bst
  - automake/automake-1.11.2.bst
  - help2man/help2man-1.36.4.bst

sources:
- kind: tar
  url: "kernel-mirror:gnu/autoconf/autoconf-2.69.tar.xz"
  ref: 64ebcec9f8ac5b2487125a86a7760d2591ac9e1d3dbd59489633f9de62a57684

variables:
  ac-version: "2.69"
  ac-prebuild: "true"
  ac-prepare: |
    rm doc/*.info
    rm man/*.1
    rm -f tests/*.at
    AUTOMAKE=automake-1.11 ACLOCAL=aclocal-1.11 autoreconf-2.64 -f
