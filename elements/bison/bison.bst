kind: make
(@): elements/bison/bison.yml

description: |
  bison 3.4.1 for the third time, built with bison-3.4.1-pass1 and its own grammar.

build-depends:
  (>):
  - bison/bison-3.4.1-pass1.bst

variables:
  bison-parser: "true"
