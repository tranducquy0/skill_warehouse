---
name: bash-project-org
category: software-development
description: Bash project organization and conventions skill.
---

# Bash Project Organization

## Overview
Conventions for organizing Bash projects with sourced modules, CLI entry points, and package systems. Extracted from the `yapm/manager` project structure but applicable to any Bash project.

## Project Structure
```
project/
├── main.sh              # Entry point: #!/usr/bin/env bash + set -euo pipefail
├── modules/
│   ├── core/*.sh         # Core library: namespace:function naming (e.g. core:download)
│   ├── utils/log.sh      # Logging: log:info/error/debug/section
│   ├── i18n/i18n.sh      # Internationalization: __ [key] [args...]
│   └── net/net.sh        # Networking helpers
├── opts/
│   ├── errorcheck.sh     # Error code explanations
│   └── viewlog.sh        # Log viewing utilities
├── packages/*/build.sh   # Package scripts: sourced, no shebang, define package_* funcs
├── .config/
│   ├── cli.conf          # Shell-sourced config fragment (YOLO, DEBUG, etc.)
│   └── make.conf         # Compiler/make flags (CC, CXX, CFLAGS, etc.)
├── tests/
│   ├── main.sh           # Test runner entry point
│   └── *_tests.sh        # Individual test suites
├── docs/                 # Plain-text documentation (no Markdown)
└── AGENTS.md             # Agent/developer guide
```

## File Conventions

### Entry Points
- `main.sh` and standalone tools: `#!/usr/bin/env bash` shebang
- Immediately followed by `set -euo pipefail` and `IFS=$'\n\t'`
- Exported globals at top: `PROJECT_ROOT`, `PACKAGE_ROOT`, `DOWNLOAD_CACHE_DIR`, etc.

### Sourced Modules
- `modules/*`, `opts/*`, test scripts, package build scripts: **no shebang**
- They are `source`d, never executed directly
- Config files (`.config/*`): no shebang, sourced as shell fragments

### Package Build Scripts (`packages/*/build.sh`)
- No shebang (sourced by main.sh)
- Define 3 required variables: `NAME`, `VERSION`, `TARBALL_LINK`
- Define 3 required functions: `package_prepare`, `package_compile`, `package_install`
- Optional: `package_patch` (called if defined)
- All `core:*`, `log:*`, `__()`, and global variables are available

## Bash Conventions

### Function Style
- Define as `name() { ... }` — no `function` keyword, brace on same line
- Sourced modules use no indentation for function declarations
- Use tabs for indentation inside function bodies (1 tab per level)
- Namespace with colons: `log:info`, `core:download`, `security:scan`
- Private functions: leading underscore (`log:_color`)
- Package API: plain `package_prepare`, `package_compile`, `package_install`
- Entry function: `main()`

### Variable Naming
- **Global/exported**: `UPPERCASE_SNAKE_CASE` — `PACKAGE_ROOT`, `LOG_DIR`, `CURRENT_PHASE`, `NAME`, `VERSION`, `TARBALL_LINK`, `YOLO`, `DEBUG`
- **Local/temporary**: `lowercase_snake_case` — `pkg_name`, `pkg`, `file_remote`, `file_loc`
- No `readonly` or `declare` — even for constants

### Quoting & Substitution
- Always double-quote variables: `"$var"`, `"$1"`, `"${NAME:-}"`
- Use `$(...)` for command substitution, never backticks
- Use `$'\n\t'` for special chars in IFS

### Conditionals
- Use POSIX `[ ]` for tests, not `[[ ]]`
- Use `=` for string comparison inside `[ ]`
- No `(( ))` arithmetic expressions

### Error Handling
- Explicit `exit N` with documented codes
- Check function existence with `type -t`:
  ```bash
  if ! type -t package_prepare >/dev/null; then
      log:error "package_prepare not defined"
      exit 6
  fi
  ```
- Use `|| true` when failure is acceptable (e.g. cleanup)
- Error messages are playful — match project tone

### Argument Parsing
- Use `case "$1" in ... esac`, not `getopts`
- Include `--help|-h)`, `--*)` catch-all, and `*)` default

### Logging
- Use the `log:*` namespace for all output
- `printf` for colored output (ANSI escapes), `echo` for plain text
- Always validate args: `if [ -z "$1" ]; then ...`

### Sourcing
- Use `source` builtin (not `.`)
- Use relative paths starting with `./`
- Config lifecycle: source then `unset` the path var

## Exit Codes
- 0: success
- 1: internal errors
- 2: invalid/missing args
- 3: package not found
- 4: security check failed
- 6: required function not defined
- 130: Ctrl-C (SIGINT)

## Security
- Scan sourced package files for dangerous commands before sourcing:
  ```bash
  if grep -nE "rm|dd|sudo|doas|mkfs|-(rf|fr)([[:space:]]|$)" "$pkg"; then
      log:error "found possibly malicious command(s) in $pkg_name"
      exit 4
  fi
  ```
- Use word boundaries `-w` to avoid false positives
- Catch variable tricks like `R="rm"`
