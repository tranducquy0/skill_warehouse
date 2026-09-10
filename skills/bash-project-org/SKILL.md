---
name: bash-project-org
category: software-development
description: Bash project organization and conventions skill.
---

# Bash Project Organization

## Overview
Conventions for organizing Bash projects with sourced modules, CLI entry points, and plugin/package systems. These patterns apply to any Bash project that uses sourced libraries and a single entry point.

## Project Structure
```
project/
├── main.sh              # Entry point: #!/usr/bin/env bash + set -euo pipefail
├── lib/                 # Sourced libraries (no shebang)
│   ├── core/*.sh        # Core library: namespace:function naming
│   ├── utils/log.sh     # Logging: log:info/error/debug/section
├── opts/                # Optional utilities, error explainers
├── plugins/*/[api].sh   # Plugin scripts (sourced, no shebang)
├── .config/             # Shell-sourced config fragments
├── tests/               # Test scripts
├── docs/                # Plain-text documentation
└── AGENTS.md            # Agent/developer guide
```

## File Conventions

### Entry Points
- `main.sh` and standalone tools: `#!/usr/bin/env bash` shebang
- Immediately followed by `set -euo pipefail` and `IFS=$'\n\t'`
- Exported globals at top: `PROJECT_ROOT`, and any project-wide variables

### Sourced Modules
- Library files, plugin scripts, test scripts, config files: **no shebang**
- They are `source`d, never executed directly
- Config files: no shebang, sourced as shell fragments

### Plugin / Extension Scripts
- No shebang (sourced by the entry point)
- Define required variables and/or functions that the host expects
- All namespace functions and global variables from the host are available

## Bash Conventions

### Function Style
- Define as `name() { ... }` — no `function` keyword, brace on same line
- Sourced modules: no indentation for function declarations
- Use tabs for indentation inside function bodies (1 tab per level)
- Namespace with colons: `log:info`, `core:download`, `security:scan`
- Private functions: leading underscore (`log:_color`)
- Entry function: `main()`

### Variable Naming
- **Global/exported**: `UPPERCASE_SNAKE_CASE`
- **Local/temporary**: `lowercase_snake_case`
- No `readonly` or `declare` — even for constants

### Quoting & Substitution
|- Always double-quote variables: `"$var"`, `"$1"`, `"${VAR:-}"`
|- Use `$()` for command substitution, never backticks
|- Use `$'\n\t'` for special chars in IFS

### JSON Parsing in Bash
- Prefer `python3 -c` for JSON extraction over sed/regex — JSON strings with `\n`, unicode, or escaped quotes break sed-based parsers
- Minimal extraction pattern: `python3 -c 'import json,sys; print(json.load(open(sys.argv[1])).get(sys.argv[2],""))' "$file" "$key"`
- Validate JSON upfront in a dedicated function using `json.load()` with proper error handling

### Conditionals
- Use POSIX `[ ]` for tests, not `[[ ]]`
- Use `=` for string comparison inside `[ ]`
- No `(( ))` arithmetic expressions

### Error Handling
- Explicit `exit N` with documented codes
- Check function existence with `type -t`:
  ```bash
  if ! type -t required_func >/dev/null; then
      log:error "required_func not defined"
      exit 6
  fi
  ```
- Use `|| true` when failure is acceptable (e.g. cleanup)
- Error messages should match the project's tone

### Argument Parsing
|- Use `case "$1" in ... esac`, not `getopts`
|- Include `--help|-h)`, `--*)` catch-all, and `*)` default
|- For tools that target multiple agent formats, use `--all` to iterate over a list:
  ```bash
  case "${2:-}" in
      --hermes)   agents=(hermes) ;;
      --all)      agents=(hermes opencode pi codex) ;;
      *)          usage; exit 2 ;;
  esac
  for agent in "${agents[@]}"; do
      # generate per-agent output
  done
  ```

### Logging
- Use a `log:*` namespace for all user-facing output
- `printf` for colored output (ANSI escapes), `echo` for plain text
- Always validate args: `if [ -z "$1" ]; then ...`

### Sourcing
- Use `source` builtin (not `.`)
- Use relative paths starting with `./`
- Config lifecycle: source then `unset` the path variable

## Exit Codes
Standard exit codes to use:
- 0: success
- 1: internal errors
- 2: invalid/missing args
- 3: resource not found
- 4: security check failed
- 6: required entity not defined
- 130: interrupted (SIGINT)

## Security
- Scan sourced plugin/script files for dangerous commands:
  ```bash
  if grep -nE "rm|dd|sudo|doas|mkfs|-(rf|fr)([[:space:]]|$)" "$file"; then
      log:error "found possibly dangerous command(s) in $file"
      exit 4
  fi
  ```
- Use word boundaries to avoid false positives
- Catch variable tricks like `R="rm"`
- Validate required variables/functions are defined before sourcing a plugin
