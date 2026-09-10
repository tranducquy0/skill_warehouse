# dotagent

a personal skill vault for my agents — plain markdown, zero framework, one job:
teach the agent how you work so it stops guessing.

## what's in here

```
dotagent/
└── skills/
    ├── python-style-guide/     # Flask Python: naming, imports, patterns
    ├── css-style-guide/        # CSS layering on lightweight frameworks
    ├── html-style-guide/       # Jinja2 templates, vanilla JS, no icon fonts
    ├── bash-project-org/       # Bash conventions: sourced modules, exit codes, security
    └── docs-writing-voice/     # Plain-text/Markdown docs: tone, structure, examples
```

each skill lives in its own directory with a `SKILL.md` file. the frontmatter
at the top describes what to use it for and how it triggers.

## how they get loaded

skills in this repo are manually copied into `~/.hermes/skills/software-development/`
where hermes picks them up automatically. no install step, no package manager,
no configuration — just drop the directory in and restart your session.

## structure of a skill

every `SKILL.md` follows the same format:

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

## writing your own

- keep descriptions under 60 characters — they're used as routing signals
- one skill per concern — don't merge unrelated conventions
- use concrete examples, not abstract principles
- if two skills overlap, merge them into the broader one — no fragmentation

## sync

to push updated skills into your hermes environment:

```bash
cp -r skills/* ~/.hermes/skills/software-development/
```

## license

unlicense. do what you want with these — fork, remix, steal a line. this is
your playbook, not mine.
