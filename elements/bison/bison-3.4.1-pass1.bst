kind: make
(@): elements/bison/bison.yml

description: |
  bison 3.4.1 for the second time, built with bison-3.4.1-pass0 and a simplified
  grammar for itself.

build-depends:
  (>):
  - bison/bison-3.4.1-pass0.bst

variables:
  bison-parser: cp %{lb-bison}/files/parse-gram.y src/
