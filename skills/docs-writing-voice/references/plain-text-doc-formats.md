---
name: plain-text-doc-formats
category: references
---

# Plain-Text Documentation Formats

## Header Underlines

### Equals-sign top-level headers
```
SECTION_NAME
============
```
- Must use `=` characters spanning at least the length of the title
- Used for the document title and major top-level sections
- No space between the title text and the underline characters below

### Dash sub-headers
```
Subsection Name
---------------
```
- Must use `-` characters spanning at least the length of the title
- Used for subsections within a major section

## Definition Lists

Use tab-indented entries with hyphens and colons:
```
NAMESPACE
|----------------
\t- func_name: what it does (first sentence lowercase, no period)
\t- another_func: description here
```

- Tab indent the dash entry
- Use `func_name: description` format
- Descriptions start with lowercase, no trailing period

## Inline Formatting

- Backticks for code references: variables, filenames, commands
- `[placeholder]` for user-supplied values in usage examples
- No Markdown bold/italic in plain-text docs

## Section Ordering (CLI/TUI tools)

1. Title + tagline
2. DEPS (install, runtime, build)
3. USAGE (commands and examples)
4. CONFIG FLAGS (env vars, config files)
5. Feature-specific format docs
6. SECURITY notes if relevant
7. EXPORTED UTILS
8. ERROR CODES
9. Auxiliary tools / testing
10. License / contributing pointers

## Error Code Style

Use a playful but informative format:
```
ERROR CODES
===========

`exit 1` — internal error: whatever went wrong
`exit 2` — you gave me nothing to work with
`exit 3` — couldn't find what you asked for
`exit 4` — safety scan caught something sketchy
`exit 6` — required function missing from plugin
```

Each entry: exit code + short playful prefix + colon + brief explanation
Prefixes: internal error, typo/blank input, not-found, security, missing-requirement

## Cross-Format Rule

If README.md uses Markdown but docs/ uses plain-text, that's fine — match each file's format. Keep voice consistent across both.
