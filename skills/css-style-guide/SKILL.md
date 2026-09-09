---
name: css-style-guide
category: software-development
description: CSS style guide for ant. Layout, spacing, typography.
---

# CSS Style Guide for `ant` Project

## Overview
CSS in `ant` uses a utility-first-ish approach layered on top of PicoCSS (replacing Bootstrap). Custom styles live in `static/css/style.css`. Code highlighting lives in `static/css/codehilite.css`.

## File Structure
- `static/css/style.css` — all custom application CSS
- `static/css/codehilite.css` — Pygments syntax highlighting theme

## CSS Conventions
- Flat selectors, no nesting (plain CSS, no preprocessor)
- Use descriptive class names, not overly abbreviated
- Section comments with `/* Section name */` headers
- Keep specificity low — avoid `!important` unless overriding framework styles

## Layout Classes
- `.sidebar` — fixed left sidebar (300px wide, full height, scrollable)
- `.sidebar.hide` — pushes sidebar off-screen left
- `.sidebar-toggle-btn` — floating toggle button (top-left area)
- `.content` — main content area (margin-left compensates for sidebar)
- `.content.wide` — expanded content (no sidebar margin)
- `article` — main content card (auto-centered, max-width constrained)
- `article.wide` — expanded article width

## Button/Control Classes
- `.signout-btn` — floating sign-out button (top-right)
- `.to-top-btn` — floating back-to-top button (right side)
- `.headerbar` — top bar containing sidebar toggle and sign-out

## Spacing Utility Classes
- `.blank-1` — 1rem spacer (display: block)
- `.blank-2` — 2rem spacer
- `.blank-5` — 5rem spacer

## Typography
- Font family: `Ubuntu` (body), `Ubuntu Mono` (code)
- Code blocks: dark background (#1c1d21), light text (#d0d0d0)
- Inline code: light red background (#ffeff0), dark text
- Headings: 1rem vertical margin
- `.large-h` — large heading (42px)
- `.title-h` — title heading (72px)

## Responsive Breakpoints
- `@media (max-width: 1200px)` — sidebar pushed off-canvas, content full-width, toggle button visible

## Framework Override Strategy
- PicoCSS handles base styles and components
- Custom CSS overrides or extends as needed
- Avoid fighting the framework — adapt to Pico patterns (e.g., `.container`, `.grid`)

## JS-DOM Interaction Classes
- `.click` — toggled on sidebar toggle button when active
- `.show` — toggled on back-to-top button when visible
- `.mark` — marker element appended to sidebar links via JS

## PicoCSS Integration
- Link `pico.css` in `<head>` via CDN
- Use Pico classes directly (`.container`, `.card`, `.btn`, `.grid`) where possible
- Custom CSS complements, doesn't replace, Pico foundation styles
- Pico uses `data-theme="light"` or `data-theme="dark"` on `<html>` or `<body>`
