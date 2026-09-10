# Contributing to dotagent

dotagent is a cross-agent skill vault — plain markdown files that teach any agent how you work. No framework lock-in, no proprietary formats.

## Adding a New Skill

### 1. Create the skill directory
```
skills/your-skill-name/
└── SKILL.md
```

### 2. Write `SKILL.md` with this structure:

```markdown
---
name: your-skill-name
category: software-development
description: One-line trigger under 60 chars — used for agent routing
---

# Skill Title

## Overview
Brief explanation of what this covers and when to use it.

## rules
Conventions, patterns, examples — the actual useful stuff.
```

### 3. Frontmatter rules
- **name**: lowercase kebab-case (e.g., `python-style-guide`)
- **category**: one of `software-development`, `research`, `creative`, `productivity`, `web`, `media`, `email`, `social-media`, `note-taking`, `repo-style-guide-extractor`
- **description**: ≤60 characters, describes when the agent should load this skill

### 4. Body conventions
- Keep it practical: examples > principles
- One skill per concern — don't merge unrelated conventions
- If two skills overlap, merge into the broader one — no fragmentation
- Reference files go in `references/` subdirectory

### 5. Validate your skill
```bash
./tools/validate-skills
```

## Adding a New Command

### 1. Create JSON in `cmds/`
```json
{
  "name": "your-command",
  "desc": "One-line description",
  "prompt": "Full prompt template. Use {{var}} for runtime substitution (Hermes only)."
}
```

### 2. Test build for all agents
```bash
./tools/build-cmd cmds/your-command.json --all
```

### 3. Command prompt guidelines
- `{{var}}` placeholders only substitute at runtime for Hermes (from env vars)
- For OpenCode/Pi/Codex, the build script warns and leaves them literal
- Prefer wording prompts so the model figures out values itself
- Keep prompts focused — one command does one thing

## Updating skills_list.json

After adding/removing skills, regenerate the manifest:
```bash
python3 -c "
import json, os
skills = []
for d in sorted(os.listdir('skills')):
    path = f'skills/{d}/SKILL.md'
    if not os.path.exists(path): continue
    with open(path) as f:
        content = f.read()
    import yaml
    fm = yaml.safe_load(content.split('---')[1])
    skills.append({
        'name': fm['name'],
        'category': fm['category'],
        'description': fm['description'],
        'path': path,
        'references': []
    })
print(json.dumps({'version': '1.0.0', 'skills': skills, 'categories': sorted(set(s['category'] for s in skills))}, indent=2))
" > skills_list.json
```

## Testing Changes

```bash
# Validate all skills
./tools/validate-skills

# Test install (dry run)
./install.sh --dry-run --agent=all

# Build commands for all agents
./tools/build-cmd cmds/*.json --all
```

## Style Guide

- **Code**: Follow the relevant style guide skill (bash-project-org, python-style-guide, etc.)
- **Commits**: Follow `git-commit-style` (playful, lowercase, grouped multi-line format)
- **Docs**: Follow `docs-writing-voice` (conversational, playful, no emojis in code)
- **Replies**: `caveman` applies to chat — terse, drop filler, keep substance

## License

Unlicense. Do what you want with these — fork, remix, steal a line. This is your playbook, not mine.