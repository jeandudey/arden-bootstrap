# arden-bootstrap

live-bootstrap as a BuildStream project: the build host that a from-source system starts from.
`stage0.bst` (stage0-posix, a few bytes of hex that grow into a C compiler) and one element per
live-bootstrap step, chained so that each builds on the one before, ending in `live-bootstrap/all.bst`:
a root with a C compiler, make, a shell and the core tools (i686, musl).

## Use

Another project takes it as a junction and depends on `bootstrap.bst:live-bootstrap/all.bst`.
The project name is part of every cache key.

## Plugins

`plugins/stage0.py` (the `stage0` element: the stage0 tools, from hex0 up) and `plugins/exec.py`
(the `exec` element: a step's commands run directly, with no shell), as well as `plugins/kaem.py` and
`plugins/raw.py`. The `git` source comes from `buildstream-plugins`.
