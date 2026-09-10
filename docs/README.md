# What is this?

Your personal cross-agent skill vault — plain markdown files that teach *your*
agents how *you* work. No framework lock-in, no proprietary formats. Just
`SKILL.md` files that any agent can read and follow.

This is a personal config repo. You can fork it for yourself, but it's not
designed for contributions — it reflects your own conventions, voice, and
setup.

## Repo structure

```
dotagent/
├── skills/              # SKILL.md files — prompts/voice/conventions for agents
│   ├── python-style-guide/
│   ├── css-style-guide/
│   └── ...
├── cmds/                # JSON command definitions (build-cmd turns these into agent plugins)
│   └── draft-commit.json
├── tools/
│   ├── build-cmd         # Generates agent-specific command files from JSON
│   └── validate-skills   # Validates SKILL.md frontmatter against schema
├── schemas/              # JSON schemas for skills, commands, and tracker
├── docs/                 # This directory — documentation, not CONTRIBUTING.md
├── install.sh            # Deploy skills/commands to target agents
├── skills_list.json      # Machine-readable catalog of all skills
├── skill_tracker.json    # Tracks which skills/commands are deployed where
└── README.md             # Overview
```

## How skills work

Each skill is a single `SKILL.md` file with YAML frontmatter:

```yaml
---
name: skill-name
category: software-development
description: One-line trigger under 60 chars — used for agent routing
---
```

The frontmatter tells the agent **when** to load this skill. The body tells it
**what** to do.

### Supported agents

- **Hermes Agent** — loads from `~/.hermes/skills/<category>/`
- **OpenCode** — reads from `$XDG_CONFIG_HOME/opencode/skills/` (default `~/.config/opencode/skills/`)
- **Pi Harness** — accepts inline skill files
- **Codex CLI** — reads `AGENTS.md` or inline instructions

### Writing your own skills

- Keep descriptions under 60 characters — used as routing triggers
- One skill per concern — don't merge unrelated conventions
- Use concrete examples, not abstract principles
- If two skills overlap, merge into the broader one — no fragmentation

## How commands work

The `cmds/` directory holds JSON files that define custom agent commands:

```json
{
    "name": "my-command",
    "desc": "One-line description of what the command does",
    "prompt": "Full prompt template. May use [arg_name] and [args] for arguments."
}
```

### Universal argument syntax

Commands can use two argument forms in their `prompt` field:

| Form | Meaning |
|------|---------|
| `[arg_name]` | A single named argument (e.g. `[file]`, `[scope]`) |
| `[args]` | All arguments as a single string |

These get translated to each agent's native form by `tools/build-cmd`:

| Universal | Hermes | OpenCode | Pi | Codex |
|-----------|--------|----------|-----|-------|
| `[args]` | `{{ args }}` | `$ARGUMENTS` | `$@` | `$ARGUMENTS` |
| `[file]` | `{{ file }}` | `<file from $ARGUMENTS>` | `${1}` | `<file from $ARGUMENTS>` + hint |
| `[scope]` | `{{ scope }}` | `<scope from $ARGUMENTS>` | `${2}` | `<scope from $ARGUMENTS>` + hint |

- **Hermes** — Jinja2-like `{{ var }}` interpolation, env-var substitution at runtime
- **OpenCode** — only `$ARGUMENTS` available; named args become extraction hints
- **Pi** — shell-like positional `${1}`..`${9}` and `$@`
- **Codex** — like OpenCode + `arguments:` frontmatter list

### Building commands

```bash
# Build for a specific agent
./tools/build-cmd cmds/my-command.json --hermes
./tools/build-cmd cmds/my-command.json --opencode
./tools/build-cmd cmds/my-command.json --pi
./tools/build-cmd cmds/my-command.json --codex

# Build for all agents
./tools/build-cmd cmds/my-command.json --all
```

Output locations:
- Hermes → `~/.hermes/plugins/<name>.sh`
- OpenCode → `$XDG_CONFIG_HOME/opencode/commands/<name>.md`
- Pi → `$HOME/.pi/commands/<name>.md`
- Codex → `$HOME/.codex/commands/<name>.md`

## Validation

```bash
./tools/validate-skills
```

Validates all `skills/*/SKILL.md` files against `schemas/skill-frontmatter.schema.json`.
Checks: required fields, kebab-case name, valid category, description ≤60 chars.

## Deployment

```bash
# Install all skills and commands to all agents
./install.sh

# Install to a specific agent
./install.sh --agent=hermes
./install.sh --agent=opencode

# Install specific skills only
./install.sh --skills=python-style-guide,css-style-guide

# Filter by category
./install.sh --category=software-development

# Preview without copying
./install.sh --dry-run --agent=all
```

## Tracking deployments

`skill_tracker.json` records where each skill and command is deployed:

```json
{
  "skills": [
    {
      "name": "python-style-guide",
      "category": "software-development",
      "installed": {
        "hermes": {
          "path": "/root/.hermes/skills/python-style-guide",
          "version": "1.0.0"
        }
      }
    }
  ],
  "commands": [...],
  "last_updated": "2026-09-10T07:00:00Z"
}
```

Use this to audit what's deployed where. Update it after running `install.sh`.
