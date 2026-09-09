---
name: html-style-guide
category: software-development
description: HTML/Jinja2 template style guide for ant project.
---

# HTML/Jinja2 Template Style Guide for `ant` Project

## Overview
Templates use Jinja2 with `.j2` extension. All templates extend `base.j2`. PicoCSS replaces Bootstrap for styling.

## Template Structure
```
templates/
├── base.j2       # Base layout, head, scripts
├── index.j2      # Main content + sidebar layout
├── signin.j2     # Login form
└── 404.j2        # Not-found page
```

## Base Template (`base.j2`)
- DOCTYPE with `<html lang="en" dir="ltr">`
- Meta charset utf-8, viewport responsive
- Title block with default fallback
- Favicon link
- Stylesheet links: PicoCSS, Google Fonts, custom `style.css`, `codehilite.css`
- Content block
- Back-to-top button (inline SVG icon, no icon font)
- Script links: vanilla `script.js` only (no jQuery, no Bootstrap bundle)

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
- Bootstrap Icons (`bi-*` classes) are REMOVED
- Replace with inline SVG for any needed icons
- The back-to-top button uses an inline SVG arrow
- No external icon font dependencies

## PicoCSS Classes
- Use Pico's built-in component classes: `.container`, `.card`, `.btn`, `.grid`, `.stack`
- Form elements: Pico auto-styles `<form>`, `<input>`, `<button>`, `<label>`
- No need for `form-control`, `btn-primary`, `btn-lg` etc. (Bootstrap remnants)
- Use `role="alert"` with `.alert` classes for admonitions (already in CSS)

## Data Passing from Flask
Templates receive: `title`, `article`, `contents`, `current_path`, `links`, `wrong_pw`
- `article` and `contents` are pre-rendered HTML strings (`| safe`)
- `links` is a list of URL paths for pagination
- `current_path` is the active URL for highlighting sidebar links

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

## Pagination (in index.j2)
- Previous/Next links use Pico card or button styling
- Conditional rendering based on `link == current_path`

## Sign-in Template
- Form posts to `/signin/`
- Uses Pico form styles (no custom `form-control` classes)
- Password input with `required` attribute
- Button uses Pico `.btn` (no Bootstrap button classes)
- Error message shown when `wrong_pw` is truthy

## 404 Template
- Simple centered message
- Back button uses `.btn` class

## No External JS Dependencies
- No jQuery
- No Bootstrap bundle JS
- No Popper.js
- Only `static/js/script.js` with vanilla JavaScript

## JS Integration Pattern
```html
<script>
// If page-specific JS needed, use IIFEs
(() => { /* code */ })()
</script>
<script src="{{ url_for('static', filename='js/script.js') }}"></script>
```
