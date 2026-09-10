---
name: css-style-guide
category: software-development
description: CSS style guide. Layout, spacing, typography, framework.
---

# CSS Style Guide (Web App Projects)

## Overview
CSS conventions for web applications using a lightweight CSS framework (like PicoCSS) layered over custom styles. Framework handles base styles; custom CSS extends where needed.

## File Structure
- `static/css/style.css` — all custom application CSS
- `static/css/codehilite.css` — syntax highlighting theme (if using Pygments)

## CSS Conventions
- Flat selectors, no nesting (plain CSS, no preprocessor)
- Use descriptive class names, not overly abbreviated
- Section comments with `/* Section name */` headers
- Keep specificity low — avoid `!important` unless overriding framework styles

## Layout Classes
- `.sidebar` — fixed left sidebar (width defined in project, full height, scrollable)
- `.sidebar.hide` — pushes sidebar off-screen left
- `.sidebar-toggle-btn` — floating toggle button
- `.content` — main content area (margin compensates for sidebar)
- `.content.wide` — expanded content (no sidebar margin)
- `article` — main content card (auto-centered, max-width constrained)
- `article.wide` — expanded article width

## Button/Control Classes
- `.signout-btn` — floating action button (position per project)
- `.to-top-btn` — floating back-to-top button
- `.headerbar` — top bar containing toggle and action buttons

## Spacing Utility Classes
- `.blank-1` — 1rem spacer (display: block)
- `.blank-2` — 2rem spacer
- `.blank-5` — 5rem spacer

## Typography
- Font family: define in project (e.g., `Ubuntu` body, `Ubuntu Mono` code)
- Code blocks: dark background, light text
- Inline code: light background, dark text
- Headings: consistent vertical margin
- `.large-h` — large heading
- `.title-h` — title heading

## Responsive Breakpoints
- Define project-specific breakpoint (e.g., `@media (max-width: 1200px)`) — sidebar pushed off-canvas, content full-width

## Framework Override Strategy
- CSS framework handles base styles and components
- Custom CSS overrides or extends as needed
- Avoid fighting the framework — adapt to its patterns

## JS-DOM Interaction Classes
- `.click` — toggled on buttons when active
- `.show` — toggled on elements when visible
- `.mark` — marker element appended via JS

## Framework Integration
- Link framework CSS in `<head>` via CDN or local static file
- Use framework classes directly where possible
- Custom CSS complements, doesn't replace, framework foundation styles
- Framework supports theme attributes (e.g., `data-theme="light"|"dark"` on `<html>` or `<body>`)
