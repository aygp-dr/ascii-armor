# CLAUDE.md — ascii-armor

## Scope

This CLAUDE.md governs the `ascii-armor` repository.
Root aygp-dr CLAUDE.md governs org-wide conventions.
Do not duplicate org-level conventions here.

## Your Role

Coding agent, not planning agent.

## Confirmation Gate

Before writing any code, confirm you understand:
1. The foundational axiom (binary → text channel survival)
2. The three-layer pattern (HEADER / PAYLOAD / FOOTER)
3. The primary output (self-hosting org-mode demo)
4. The first artifact: `mordhau-inline.org`

## Foundational Axiom

**A binary artifact must survive transit through a channel that only tolerates text.**

Every encoding system in this survey solves the same constraint: 7-bit
channels, text editors, patch utilities, and email headers all reject
or corrupt raw binary. The solutions converge on the same three-layer
structure: named header, ASCII-safe payload, boundary footer.

## What This Builds

| Artifact            | Format   | Purpose                                    |
|---------------------|----------|--------------------------------------------|
| `spec.org`          | org-mode | Survey of binary-in-text patterns 1980–present |
| `mordhau-inline.org`| org-mode | Self-hosting demo with named base64 blocks |
| `bin/armor-check`   | bash     | Validate encoded blocks round-trip cleanly |
| `examples/`         | various  | Sample encoded files (uuencode, base64, XPM) |

## Explicit Anti-Goals

| Anti-Goal                        | Mechanical Failure Mode                      |
|----------------------------------|----------------------------------------------|
| Build an encoding library        | Creates maintenance burden, duplicates stdlib|
| Convert spec.org to Markdown     | Loses babel eval, literate programming value |
| Generate binary image files      | Mermaid blocks and text descriptions suffice |
| Add CI/CD or pre-commit hooks    | This is documentation, not a release artifact|
| Create new encoding schemes      | Survey existing patterns, don't invent new   |

## Pipeline Stages

### Stage 1: Complete spec.org Survey
- **Input**: Current spec.org
- **Output**: All sections filled, no TODOs
- **Acceptance**: `grep -c TODO spec.org` returns 0

### Stage 2: Create mordhau-inline.org Demo
- **Input**: A JPEG image, spec.org as reference
- **Output**: `mordhau-inline.org` with named base64 block + babel decode
- **Acceptance**: `C-c C-c` on decode block produces `/tmp/mordhau-1.jpg`, `org-toggle-inline-images` displays it

### Stage 3: Create Examples Directory
- **Input**: spec.org encoding examples
- **Output**: `examples/` with working samples: `.uu`, `.b64`, `.hqx`, `.xbm`, `.xpm`
- **Acceptance**: Each example round-trips via its native decoder

### Stage 4: Build armor-check Validator
- **Input**: `examples/` files
- **Output**: `bin/armor-check` script
- **Acceptance**: `./bin/armor-check examples/*` exits 0

### Stage 5: HTML Export
- **Input**: `spec.org`, `mordhau-inline.org`
- **Output**: Self-contained HTML with embedded images
- **Acceptance**: HTML renders correctly in browser with no external requests

**Failure Handler**: If an acceptance test fails, stop. Document what
failed, what you tried, and the blocker. Do not proceed to the next stage.

## Domain Tags

| Tag          | Description                          | Max % |
|--------------|--------------------------------------|-------|
| unix         | uuencode, shar, pipeline idioms      | 30%   |
| email        | MIME, PEM, quoted-printable          | 25%   |
| web          | data URI, favicon, build tools       | 20%   |
| x11          | XBM, XPM, X-Face                     | 15%   |
| notes        | org-mode, Jupyter, Obsidian          | 15%   |
| mac          | BinHex, MacBinary, resource fork     | 10%   |

## Output Contract

- `spec.org`: UTF-8 org-mode, `:eval no` on example blocks
- `mordhau-inline.org`: UTF-8 org-mode, one named base64 block, one babel decode block
- `examples/*`: Native format per encoding type
- `bin/armor-check`: POSIX shell, exit 0 on success

## Open Conjectures

### C1: Named-block + babel is the most portable org embedding pattern
- **Falsification**: Find an org-mode-compatible embedding that works on
  older Emacs versions AND requires fewer manual steps.
- **Evidence needed**: Test on Emacs 27, 28, 29 with org 9.x.

### C2: 4KB threshold for data URI inlining is still optimal
- **Falsification**: Measure HTTP/2 + Brotli overhead; if negligible,
  threshold should increase.
- **Evidence needed**: Benchmark with modern CDN (Cloudflare, Fastly).

### C3: XPM format is still actively used in 2026
- **Falsification**: Survey major Linux DEs; if no XPM files ship, mark
  as historical only.
- **Evidence needed**: Check GNOME 46, KDE 6, Xfce sources.

## Research Context (Implement After Core Stages)

The following are noted for future expansion but should NOT be
implemented until stages 1-5 are stable:

- QR codes as binary-in-visual channel (same constraint, different medium)
- WebP/AVIF base64 performance vs PNG/JPEG
- WASM binary embedding in JavaScript

## Instrumentation Requirement

`bin/armor-check` must log results to stdout in parseable format:
```
armor-check: examples/test.uu OK (round-trip 1024 bytes)
armor-check: examples/broken.b64 FAIL (decode error: invalid padding)
```

## Acceptance: End-to-End Test

Given the completed artifacts:
1. `spec.org` tangles cleanly (`org-babel-tangle`)
2. `mordhau-inline.org` displays image after eval
3. `./bin/armor-check examples/*` exits 0
4. HTML export of both files opens in Firefox with no console errors

This is the repository's definition of done.

## Quick Reference

```bash
# Session start
bd ready                  # See unblocked issues
bd show <id>              # Issue details

# Org-mode workflow
emacs spec.org            # Edit
C-c C-c                   # Eval block under cursor
C-c C-x C-v               # Toggle inline images
C-c C-e h h               # Export to HTML

# Validation
./bin/armor-check examples/*
grep -c TODO spec.org

# Commit (stage specific files, never git add .)
git add spec.org mordhau-inline.org
git commit -m "docs: expand encoding survey"
bd sync && git push
```
