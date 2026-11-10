kind: make
(@): elements/bison/bison.yml

description: |
  bison 3.4.1 for the third time, built with bison-1 and its own grammar.

build-depends:
  (>):
  - bison/bison-1.bst

variables:
  bison-parser: "true"
