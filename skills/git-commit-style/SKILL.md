---
name: git-commit-style
category: software-development
description: "Commit style: voice, types, grouped multi-line format."
---

# Git Commit Style

## Overview
Conventions for writing commit messages. Use when drafting a commit message, splitting a diff into commits, or reviewing messages before push. Live examples in the [nixos-config](https://codeberg.org/quy/nixos-config) repo.

## Voice
- Short and human-readable above all. Lowercase, no trailing period.
- Imperative not required — the line reads like a headline, not a command:
  - `feat(shells): a shell for vibe coding`
  - `chore: spawn chaos`
- Playful is fine when it still says what changed. Never vague.
- No filler ("update", "misc", "stuff") — name the actual thing.

## Format

### Single change
```
type(scope): summary
```
- `type`: one of the list below
- `scope`: area/folder when it adds context (`shells`, `tidy`), omit when it doesn't
- `summary`: concise, lowercase, no trailing period

Real examples:
- `feat(shells): a shell for vibe coding`
- `feat(shells): add a shell for agentic coding sessions`
- `chore(tidy): format`
- `chore: regen hardware-configuration`

### Multi-category change
When the work touches several categories, no title line. Open with one
umbrella `chore:` line that names the major pieces, then one `type:` line per
concrete change, grouped by type. Close with the `Co-authored-by` trailer.

```
chore: import/require loader, i18n module + string wrapping, ninja package

feat: add core_import.sh with import(), require(), import:tree()
feat: add i18n module with __(), i18n:tr(), i18n:init(), i18n:lang()
feat: en/vi locale files with ~60 translation keys each
feat: wrap all user-facing strings across main.sh and 7 module files
feat: add ninja (1.12.1) package with tcc compat patch
fix: test files source i18n.sh for __() availability
fix: CLI tests match both raw-key fallback and translated output
docs: exported-utils with I18N section, usage with jq dep + --show-imports

Co-authored-by: quy <tranducquy@disroot.org>
```

## Types
- `feat` — new feature or functionality
- `fix` — bug fix
- `chore` — formatting, maintenance, tooling, dependency bumps, lockfile regen (`chore(tidy): format`)
- `docs` — documentation only
- `refactor` — code restructuring, no behavior change
- `style` — formatting, whitespace, semicolons
- `test` — adding or fixing tests
- `perf` — performance improvement
- `build` — build system or external dependency changes

## Trailer
Always close with:
```
Co-authored-by: quy <tranducquy@disroot.org>
```
Pull the identity from `git config user.name` / `user.email`, don't hardcode.