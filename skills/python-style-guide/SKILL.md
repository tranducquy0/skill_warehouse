---
name: python-style-guide
category: software-development
description: Python style guide for ant knowledge base project.
---

# Python Code Style Guide for `ant` Project

## Overview
`ant` is a small Flask-based single-user knowledge base system. Code style prioritizes readability, minimalism, and modularity over cleverness.

## File Structure
- `ant.py` — app entry point, blueprint registration, config loading
- `config.py` — all configuration as a `Config` class + module-level `HOST`/`PORT`
- `blueprints/` — Flask blueprint route handlers (`index.py`, `content.py`, `auth.py`)
- `services/` — business logic (`auth.py`, `content.py`, `auth_decorator.py`)
- `utilities/` — generic helpers (`markdown.py`, `file_operation.py`, `template.py`)
- `templates/` — Jinja2 templates (`.j2` extension)
- `static/` — CSS (`css/style.css`, `css/codehilite.css`) and JS (`js/script.js`)
- `docs/` — Markdown content files served as documentation

## Naming Conventions
- **Filenames**: snake_case (e.g., `auth_decorator.py`)
- **Variables/functions**: snake_case (e.g., `load_markdown_text`)
- **Classes**: PascalCase (e.g., `Config`)
- **Blueprints**: `<name>_bp` suffix (e.g., `index_bp`, `content_bp`)
- **Constants**: UPPER_SNAKE_CASE in `config.py` (e.g., `SECRET_KEY`)

## Import Ordering
Standard library first, then third-party, then local:
```python
import os
from functools import wraps

from flask import Flask, render_template

import services.auth as auth
import utilities.markdown as mdu
```

## Patterns
- Use `current_app.config["KEY"]` for accessing config inside blueprints/services, not direct access to `Config`
- Decorators for auth: `@authd.login_required` on routes
- Context processors for template utility functions: `@app.context_processor`
- Error handlers for custom pages: `@app.errorhandler(404)`
- All route handlers decorated with `@authd.login_required` when auth is enabled

## Code Style
- No semicolons
- 4-space indentation
- Type hints on function signatures (`def func(path: str) -> str:`)
- Docstrings/comments for non-obvious logic
- Avoid frameworks within frameworks — keep it simple

## Dependencies (pinned)
From `requirements.txt`:
- Flask 3.1.x, Flask-Bcrypt, Markdown 3.10+, Pygments, Jinja2
- No ORM, no database, no JS frameworks beyond vanilla
