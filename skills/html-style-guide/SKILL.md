---
name: html-style-guide
category: software-development
description: HTML/Jinja2 template style guide for web apps.
---

# HTML/Jinja2 Template Style Guide (Web App Projects)

## Overview
Conventions for HTML templates rendered via Jinja2 in Flask/web applications. Framework (e.g., PicoCSS) handles styling; templates should avoid framework-specific remnants from prior stacks.

## Template Structure
```
templates/
├── base.j2       # Base layout, head, scripts, global elements
├── index.j2      # Main content + sidebar layout
├── signin.j2     # Login form
└── 404.j2        # Not-found page
```

## Base Template
- DOCTYPE with `<html lang="en" dir="ltr">`
- Meta charset utf-8, viewport responsive
- Title block with default fallback
- Favicon link
- Stylesheet links: CSS framework, custom `style.css`, highlight theme
- Content block
- Floating action buttons (back-to-top, signout) — use inline SVG icons
- Script links: vanilla JS only (no jQuery, no framework bundle JS)

## Extending Templates
```jinja2
{% extends 'base.j2' %}

{% block title %}
    Page Title
{% endblock %}

{% block content %}
    <!-- Page-specific HTML -->
{% endblock %}
```

## No Icon Fonts
- External icon font classes are REMOVED
- Replace with inline SVG for any needed icons
- No external icon font dependencies

## CSS Framework Classes
- Use framework's built-in component classes where possible
- Form elements: framework auto-styles `<form>`, `<input>`, `<button>`, `<label>`
- No need for old framework's utility classes (`form-control`, `btn-primary`, etc.)
- Use `role="alert"` with alert classes for status messages

## Data Passing from Flask
Templates receive page-specific variables from route handlers:
- Content variables are pre-rendered HTML strings (`| safe`)
- Context variables include current path, link lists, error flags
- Use `url_for('static', filename='...')` for asset references

## Sidebar Navigation
```jinja2
<div class="headerbar">
    <div class="sidebar-toggle-btn" id="toggle-sidebar">
        <!-- inline SVG icon -->
    </div>
    {% if session['logged_in'] %}
        <div class="signout-btn">
            <a href="/signout/">...</a>
        </div>
    {% endif %}
</div>
<nav class="sidebar">{{ contents | safe }}</nav>
<main class="content">{% block content %}{% endblock %}</main>
```

## Sign-in Template
- Form posts to auth route
- Uses framework form styles (no custom input classes)
- Password input with `required` attribute
- Button uses framework `.btn` class
- Error message shown when error flag is truthy

## 404 Template
- Simple centered message
- Back button uses `.btn` class

## No External JS Dependencies
- No jQuery
- No framework bundle JS
- No Popper.js
- Only custom `script.js` with vanilla JavaScript

## JS Integration Pattern
```html
<script>
// Page-specific JS uses IIFEs
(() => { /* code */ })()
</script>
<script src="{{ url_for('static', filename='js/script.js') }}"></script>
```
