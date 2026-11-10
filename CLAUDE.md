# Arden Bootstrap

This is the bootstrap for the Arden operating system.

This uses the Apache BuildStream 2.0 build system.

## Layout

- `elements` The Apache BuildStream 2.0 elements.
- `elements/stage0` Where the bootstrap starts, it uses the hex0-seed from `elements/bootstrap-seeds.bst`.

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
