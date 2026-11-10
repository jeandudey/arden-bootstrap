kind: make
(@): elements/bison/bison.yml

description: |
  bison 3.4.1 for the first time, with a parser for its own grammar that was
  written by hand, as live-bootstrap does, as there is no bison to build it.

variables:
  bison-parser: cp %{lb-bison}/files/parse-gram.c %{lb-bison}/files/parse-gram.h src/
