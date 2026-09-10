---
name: python-style-guide
category: software-development
description: Python code style guide for Flask projects.
---

# Python Code Style Guide (Flask Projects)

## Overview
Conventions for Python Flask web applications. Prioritizes readability, minimalism, and modularity over cleverness.

## File Structure
```
project/
├── app.py            # Entry point: app creation, config loading, blueprint registration
├── config.py         # All configuration as a Config class + module-level HOST/PORT
├── blueprints/       # Flask blueprint route handlers
├── services/         # Business logic (data access, auth, content loading)
├── utilities/        # Generic helpers (parsing, file ops, template utils)
├── templates/        # Jinja2 templates (use .j2 extension)
├── static/           # CSS and JS assets
└── docs/             # Markdown content or documentation files
```

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

## Dependencies
From `requirements.txt`:
- Flask, Flask-Bcrypt, Markdown, Pygments, Jinja2
- No ORM, no database, no JS frameworks beyond vanilla
