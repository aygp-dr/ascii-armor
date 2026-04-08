# AGENTS.md — ascii-armor

## What Is This

Survey of binary-to-text encoding patterns from 1980 to present. Documents
uuencode, MIME Base64, data URIs, XBM/XPM, and org-mode embedding. Includes
a self-hosting demo (`mordhau-inline.org`) using named base64 blocks.

## Quick Reference

```bash
bd ready              # Find next stage to work on
bd show <id>          # View issue details
make health           # Check repo state
make todo             # Count TODOs in spec.org
make tangle           # Tangle org files
make export-html      # Export to HTML
```

## Build & Test

```bash
# Health check (JSON output)
./bin/armor-health

# Validate examples (after Stage 4)
./bin/armor-check examples/*

# Tangle + export
make tangle && make export-html
```

## Conventions

- Primary doc format: org-mode (`.org`)
- Example files: native encoding format (`.uu`, `.b64`, `.xpm`)
- Scripts: POSIX shell in `bin/`
- Diagrams: Mermaid blocks in org, not image files

## What NOT to Do

- Do not convert spec.org to Markdown
- Do not create image files when Mermaid suffices
- Do not build an encoding library — survey only
- Do not add CI/CD or pre-commit hooks
- Do not work on stages out of order — check `bd ready`
