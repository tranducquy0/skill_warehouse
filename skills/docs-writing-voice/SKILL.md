---
name: docs-writing-voice
category: software-development
description: Docs writing voice: tone, format, and structure conventions.
---

# Documentation Writing Style Guide

## Overview
Conventions for writing documentation and README files in technical projects. Extracted from the `yapm/manager` project's docs/ directory and README voice, generalized for any project.

## Voice and Tone
- **Conversational but direct** — talk like a person, not a corporation
- **Playful and self-aware** — use "bro", "yay!", "see for yourself", "wat did u expecting?"
- **Jokes land because they're true** — "of course it's Git", "no more sudo rm -rf / and alters, yay!"
- **Self-deprecating where appropriate** — "this project is for personal use, and is very optionated, so use at your own risk"
- **Concise** — no fluff, no corporate speech. One sentence for what something is and why it exists
- **No emojis in docs** (code stays clean)
- **Parenthetical asides** — "did you read the paragraph above?", "(jk, bug reports encouraged)"

## Formatting (Plain-Text Docs)
Projects using this style use **plain-text docs, not Markdown**:
- Section headers: ALL-CAPS word followed by a line of `=====` (equals signs) or `-----` (dashes)
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
  \t- grep: checking for "malicious" commands
  ```
- Use backticks for code references (variables, filenames, commands)
- Use `[name]` for placeholders instead of single chars
- No bullet markers for top-level items in some formats; use direct dashes

## Structure (Recommended Order)
When documenting a CLI/tool, follow this section order:
1. **Title + tagline** (plain header with `=====` underline)
2. **DEPS** — install deps, runtime deps, build deps
3. **USAGE** — commands and usage patterns
4. **CONFIG FLAGS** — environment variables and config files
5. **Feature-specific format docs** (e.g. PACKAGE FORMAT)
6. **SECURITY notes** if relevant
7. **EXPORTED UTILS** — for anything sourced/inherited by other scripts
8. **ERROR CODES**
9. **HEALTH CHECKER / auxiliary tools**
10. **TEST SUITE**

### Exported Utils Section
When documenting utilities available to sourced submodules:
```
EXPORTED UTILS
--------------

because package files are sourced, these are available to use in your
`build.sh` without any imports.

LOADER NAMESPACE
|----------------
\t- require [binary] [required|optional] — check that a binary exists
\t- import [spec] — source a module by shorthand
```

### Error Codes Section
Use a playful format for exit codes:
```
ERROR CODES
===========

`exit 1` — internal errors
`exit 2` — bro you have typos or you gave me nothing
`exit 3` — package? what package?
`exit 4` — vibe check failed, GET OUT!
`exit 6` — bro you forgot to define `package_*!`
```

## Writing Rules for README Files
- Start with `# project-name` as the title
- Short tagline that tells you what it does in one irreverent sentence
- Use **bold** or backtick headers for sections
- Code blocks use fenced ```shell
- Link to relevant repos with `[name](url format)
- Mention what's NOT needed: "No, you don't need Docker or Postgresql"
- Mention what was replaced: "(replacing Bootstrap 5)", "(no jQuery)"
- Keep the "how to deploy" section copy-paste ready
- End with: Project progress / FAQ / License pointers

## Voice Examples
> every package manager ships with a `require` function that bails if a needed binary is missing. here's what YAPB expects on the host:

> no more sudo rm -rf / and alters, yay!

> bro you forgot to define `package_*!`

> this project is for personal use, and is very optionated, so use at your own risk. but I'll make sure all the code is readable.

> GO BACK WITH YOUR "LOVELY" `snapd`!

> hope it works ;) (jk, bug reports encouraged)

## Cross-Project Notes
- If the project uses Markdown for README but plain-text for docs/, switch format per file
- Keep the tone consistent across all files in the same project
- Error messages should match the docs voice — playful, not generic
