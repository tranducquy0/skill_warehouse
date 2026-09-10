# dotagent

a cross-agent skill vault — plain markdown files that teach any agent how you work.
no framework lock-in. no proprietary formats. just `SKILL.md` files that any
agent can read and follow.

## what's in here

```
dotagent/
├── skills/
│   ├── python-style-guide/     # Python conventions for Flask projects
│   ├── css-style-guide/        # CSS conventions for framework-layered apps
│   ├── html-style-guide/       # Jinja2 template conventions, vanilla JS
│   ├── bash-project-org/       # Bash: sourced modules, exit codes, security
│   └── docs-writing-voice/     # Docs tone, structure, plain-text/Markdown format
└── cmds/
    └── <command-name>.json     # Custom agent commands (name, desc, prompt)
```

## agents supported

each skill file is plain markdown with YAML frontmatter. the format is simple
enough that any agent can load and follow it:

- **OpenCode** — reads `.opencode/skills/` from your repo
- **Hermes Agent** — loads from `~/.hermes/skills/<category>/`
- **Pi Harness** — lightweight agent that accepts inline skill files
- **Codex CLI** — reads `COGNITO_RULES.md` / `AGENTS.md` or inline instructions

all of these can consume the `SKILL.md` format. copy the files into whichever
directory your agent expects and you're done.

## how it works

each skill is a single `SKILL.md` file with this structure:

```markdown
---
name: skill-name
category: software-development
description: one-line trigger (60 chars max)
---

# Skill Title

## Overview
brief explanation of what this covers and when to use it

## rules
conventions, patterns, examples — the actual useful stuff
```

the frontmatter tells the agent **when** to load this skill. the body tells it
**what** to do.

## custom commands

the `cmds/` directory holds JSON files that define custom agent commands.
each file has three keys:

```json
{
    "name": "my-command",
    "desc": "One-line description of what the command does",
    "prompt": "Full prompt template. use {{var}} for substitution."
}
```

run `tools/build-cmd` to generate a command file for your agent:

```bash
# For OpenCode (writes to .opencode/commands/)
tools/build-cmd cmds/my-command.json --opencode

# For Hermes (writes to ~/.hermes/plugins/)
tools/build-cmd cmds/my-command.json --hermes

# For Pi Harness (writes to .pi/commands/)
tools/build-cmd cmds/my-command.json --pi

# For Codex (writes to .codex/commands/)
tools/build-cmd cmds/my-command.json --codex
```

## writing your own

**Skills:**
- keep descriptions under 60 characters — used as routing triggers
- one skill per concern — don't merge unrelated conventions
- use concrete examples, not abstract principles
- if two skills overlap, merge into the broader one — no fragmentation

**Commands:**
- use `{{var}}` in prompt templates for parameter substitution
- keep prompts focused — one command does one thing
- name should match the agent's command naming convention

## sync

to deploy all skills into an agent's expected location:

```bash
# Hermes
cp -r skills/* ~/.hermes/skills/software-development/

# OpenCode
ln -s ../../dotagent/skills .opencode/skills

# Pi Harness
cp -r skills/* .pi/skills/

# Codex
cp -r skills/* .codex/skills/
```

## tooling

`tools/build-cmd` generates agent-specific command files from JSON definitions:

```bash
tools/build-cmd cmds/some-command.json --hermes
# => ~/.hermes/plugins/some-command.sh
#    (a plugin script that runs the command's prompt)
```

## license

unlicense. do what you want with these — fork, remix, steal a line. this is
your playbook, not mine.
