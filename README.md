# arden-bootstrap

live-bootstrap as a BuildStream project: the build host that a from-source system starts from.
`stage0.bst` (stage0-posix, a few bytes of hex that grow into a C compiler) and one element per
live-bootstrap step, chained so that each builds on the one before, ending in `live-bootstrap/all.bst`:
a root with a C compiler, make, a shell and the core tools (i686, musl).

## Use

Another project takes it as a junction and depends on `bootstrap.bst:live-bootstrap/all.bst`.
The project name is part of every cache key.

## Updating

The elements in `elements/live-bootstrap/` are generated, not written by hand:

    git clone https://github.com/fosslinux/live-bootstrap          # at the commit steps.bst pins
    tools/gen-lb-elements.py --lb PATH/TO/live-bootstrap

The generator pins the checkout's commit in `live-bootstrap/steps.bst`, writes `include/lb-aliases.yml`
and rewrites every generated element. Checksums live-bootstrap does not publish are in
`tools/lb-pinned-checksums.txt`. A host the generator has no name for goes into `HOST_ALIASES`
in the generator (an alias names the site, not the DNS name).

## Plugins

`plugins/lbstep.py` (the `lbstep` element: runs one step in the sandbox) and `plugins/raw.py`
(the `raw` element, for stage0). The `git` source comes from `buildstream-plugins`.
