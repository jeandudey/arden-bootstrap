# Arden Bootstrap

This is the bootstrap for the Arden operating system.

This uses the Apache BuildStream 2.0 build system.

## Layout

- `elements` The Apache BuildStream 2.0 elements.
- `elements/stage0` Where the bootstrap starts, it uses the hex0-seed from `elements/bootstrap-seeds.bst`.
- `elements/final` The final version of each tool, under its plain name, for projects that take
  elements from here (junctions).

## Final names

Elements are named for the version they build (`gcc-15.2.0.bst`), and an older build of a tool
keeps the plain or a suffixed name that other elements depend on (`make/make.bst` is make 3.82 built
by tcc, `musl/musl.bst` is 1.1.24).  Those names are not the final tools.

`final/<tool>.bst` is a `kind: stack` that depends only on the versioned element live-bootstrap ends
with.  Depend on `final/gcc.bst` and not on `gcc/gcc-15.2.0.bst`.  When a tool gets a newer final
version, change the dependency of its `final/` element and nothing else.  No element in the chain
depends on `final/`.

## Style

- Comments say what the code cannot: a constraint, a workaround, a reason that is not
  obvious. Do not write comments that restate the command or describe what a tool
  does in general (such as how M2-Mesoplanet finds its toolchain on PATH). When in
  doubt, leave the comment out.

- Use GNU Coding Standards for VCS commits (Git), for example:

```
Handle completely undecoded input in term (Bug#29918)

* lisp/term.el (term-emulate-terminal): Avoid errors if the whole
	decoded string is eight-bit characters.  Don't attempt to save the
	string for next iteration in that case.
```

Use `[conditional]` for conditional changes, for example:

```
* frame.h [HAVE_X_WINDOWS] (FRAME_WINDOW_P): Macro defined.
```
