---
name: css-framework-migration
category: references
---

# CSS Framework Migration Checklist

## Before Migration

- Inventory all external CSS/JS dependencies in `<head>`
- List all framework-specific classes used in templates
- List all JS framework calls (jQuery, framework bundle, Popper.js)
- Catalog all icon fonts in use (Bootstrap Icons, FontAwesome, etc.)

## Removal Step

1. Remove all CDN `<link>` tags for the old framework CSS
2. Remove all `<script>` tags for the old framework JS bundle
3. Remove all `<link>` tags for icon font CSS
4. Remove any framework JS that depends on the old framework (jQuery plugins, Popper)

## Replacement Step

1. Add new framework CSS via CDN or local static file
2. Add theme attribute on `<html>` or `<body>`
3. Replace inline JS that used the old framework with vanilla JS
4. Remove all jQuery usage

## Class Mapping (Bootstrap → PicoCSS)

| Bootstrap | PicoCSS |
|---|---|
| `.container` | `.container` (same name, different default behavior) |
| `.row` + `.col-*` | `.grid` |
| `.btn` | `.btn` |
| `.btn-primary` | `.primary` |
| `.btn-lg` | no direct equivalent — use `.btn` |
| `.form-control` | auto-styled by Pico |
| `.visually-hidden` | n/a — Pico handles this |
| `.w-100` | `.w-100` (not needed in Pico) |
| `.list-group` | `.card` or `.list` |
| `.float-sm-start/end` | `.float-start/end` |

## Icon Fonts → Inline SVG

For every `<i class="bi bi-icon"></i>`, replace with inline SVG.
Common icons:
- arrow up: `<polyline points="18 15 12 9 6 15">`
- menu/hamburger: three `<line>` elements
- signout: path + polyline for arrow
- paragraph: use literal `¶` character

## JavaScript Migration

| jQuery | Vanilla JS |
|---|---|
| `$(sel).click(fn)` | `el.addEventListener('click', fn)` |
| `$(sel).toggleClass('cls')` | `el.classList.toggle('cls')` |
| `$(sel).addClass('cls')` | `el.classList.add('cls')` |
| `$(sel).removeClass('cls')` | `el.classList.remove('cls')` |
| `$(window).scroll(fn)` | `window.addEventListener('scroll', fn)` |
| `$(sel).append(html)` | `el.insertAdjacentHTML('beforeend', html)` |
| `$(sel).css('prop', val)` | `el.style.prop = val` |
| `$(document).ready(fn)` | `DOMContentLoaded` event |
| `$(sel).children('.cls')` | `el.querySelector('.cls')` |

## Post-Migration Verification

- grep for old framework name in all templates and JS (should find none in tags)
- grep for jQuery / `$` in JS files
- grep for icon font classes in templates
- test all interactive features (sidebar toggle, back-to-top, pagination)
- verify responsive breakpoints still work
- check all pages for consistent styling
