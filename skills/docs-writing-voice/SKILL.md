---
name: docs-writing-voice
category: software-development
description: Docs writing voice, format, and structure conventions.
---

# Documentation Writing Style Guide

## Overview
Conventions for writing documentation and README files in technical projects. Covers voice/tone, plain-text formatting, recommended section ordering, and cross-file consistency.

## Voice and Tone
- **Conversational but direct** — talk like a person, not a corporation
- **Playful and self-aware** — use "bro", "yay!", "see for yourself", "wat did u expecting?"
- **Jokes land because they're true** — they reference real project details
- **Self-deprecating where appropriate** — "this project is for personal use, and is very optionated, so use at your own risk"
- **Concise** — no fluff, no corporate speech. One sentence for what something is and why it exists
- **No emojis in docs** (code stays clean)
- **Parenthetical asides** — "did you read the paragraph above?", "(jk, bug reports encouraged)"

## Formatting

### Plain-Text Docs
For plain-text documentation files (not Markdown):
- Section headers: ALL-CAPS word followed by a line of `=====` (equals signs)
  ```
  USAGE
  =====
  ```
- Subsection headers: dashes underline
  ```
  DEPS
  ----
  ```
- Sub-items use tabs for indentation, colons for definitions
  ```
  \t- grep: checking for "dangerous" commands
  ```
- Use backticks for code references (variables, filenames, commands)
- Use `[name]` for placeholders instead of single chars

### Markdown Docs
For Markdown README files:
- Start with `# project-name` as the title
- Short tagline that tells you what it does in one irreverent sentence
- Code blocks use fenced ```shell
- Link to relevant repos with `[name](url)` format
- Mention what's NOT needed: "No, you don't need Docker or Postgresql"
- Mention what was replaced: "(replacing Bootstrap 5)", "(no jQuery)"
- Keep the "how to deploy" section copy-paste ready

## Structure (Recommended Section Order)
When documenting a CLI/tool, follow this order:
1. **Title + tagline** (header with `=====` underline in plain-text, or `#` in Markdown)
2. **DEPS** — install deps, runtime deps, build deps
3. **USAGE** — commands and usage patterns
4. **CONFIG FLAGS** — environment variables and config files
5. **Feature-specific format docs** (e.g. EXTENSION FORMAT, PLUGIN FORMAT)
6. **SECURITY notes** if relevant
7. **EXPORTED UTILS** — for anything available to sourced/inherited scripts
8. **ERROR CODES**
9. **Auxiliary tools / testing**
10. **License / contributing pointers**

### Exported Utils Section
When documenting utilities available to sourced plugin files:
```
EXPORTED UTILS
--------------

because plugins are sourced during execution, these are available to use
without any imports.

LOG NAMESPACE
|------------
\t- log:info [msg] — print info log
\t- log:error [msg] — print error log
```

### Error Codes Section
Use a playful format for exit codes:
```
ERROR CODES
===========

`exit 1` — internal errors
`exit 2` — bro you have typos or you gave me nothing
`exit 3` — resource? what resource?
`exit 4` — vibe check failed, GET OUT!
`exit 6` — bro you forgot to define required entity!
```

## Cross-File Consistency
|- If the project uses Markdown for README but plain-text for docs/, switch format per file
|- Keep the tone consistent across all files in the same project
|- Error messages in code should match the docs voice — playful, not generic
|- No skill fragmentation — a narrow README-specific skill should be broadened into a class-level umbrella (e.g. `docs-writing-voice`) that covers all documentation types rather than splitting by incident or file type

## Cross-Agent Documentation
When documenting how a project integrates with multiple agent CLIs (Hermes, OpenCode, Codex, Pi):
|- Lead with a **capability table** (agent name + what it does for the user), not a prose dump
|- Include **agent-specific sync/copy commands** in code blocks per agent
|- Use **`.gitignore`** to exclude generated agent config dirs (`/.pi/`, `/.codex/`, `/.opencode/`)
|- Document the **generation workflow** (`tools/build-cmd`) once at the bottom — not per agent
|- Warn about **runtime-only features** (e.g. `{{var}}` substitution works in Hermes plugins but not OpenCode/Pi/Codex markdown) — use a callout or inline note

## References
- `references/plain-text-doc-formats.md` — detailed plain-text doc formatting rules, section ordering, and error code style

## Example Voice
> every tool ships with a `require` function that bails if a needed binary is missing. here's what expects on the host:

> no more manual cleanup and alters, yay!

> bro you forgot to define required functions!

> this project is for personal use, and is very optionated, so use at your own risk. but I'll make sure all the code is readable.

> hope it works ;) (jk, contributions encouraged)
