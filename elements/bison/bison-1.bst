kind: make
(@): elements/bison/bison.yml

description: |
  bison 3.4.1 for the second time, built with bison-0 and a simplified
  grammar for itself.

build-depends:
  (>):
  - bison/bison-0.bst

variables:
  bison-parser: cp %{lb-bison}/files/parse-gram.y src/
