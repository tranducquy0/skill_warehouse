---
name: readme-style-guide
category: software-development
description: README writing voice and style guide for ant.
---

# README Writing Style Guide for `ant` Project

## Voice and Tone
- **Conversational but direct** — you're explaining to a friend who's technically competent
- **Casual but not unprofessional** — "bro", "hmm...", "like I said, it is minimal"
- **Self-deprecating humor is okay** — "(hmm...)" after claiming reliability
- **No corporate jargon** — avoid "enterprise-grade", "robust solution", "streamline"
- **Parenthetical asides are encouraged** — "no user accounts, no roles, just 1 password"
- **Exclamation points are used sparingly but effectively** — "no user accounts!"
- **Emojis: none** in docs/commits/code

## Structure
1. **Title** — just the project name as `# name`
2. **What is it?** — short, irreverent description that immediately communicates the value prop
3. **How it works?** — explain the core mechanism in plain language
4. **Key features broken into subsections** — "Authentication", "Rendering Documentations", etc.
5. **Deploy** — step-by-step shell commands in a fenced block
6. **Project progress** — pointer to TODO or issues
7. **FAQ** — pointer to docs/
8. **License** — always at the bottom

## Writing Rules
- Start section descriptions with lowercase unless it's a proper noun
- Use backticks around code identifiers (`ant`, `owl`, `flask-bcrypt`)
- Link to relevant projects: `[name](url)` format
- Use contractions — "doesn't", "it's", "don't"
- Mention what the project does NOT do: "doesn't need a database", "no user accounts"
- Keep sentences short. Some can be fragments.
- When listing alternatives the project avoids: "No, you don't need Docker or Postgresql"
- Mention replacements/migrations directly: "(replacing Bootstrap 5)"

## Code Blocks
- Use ```shell for install/deploy commands
- Use ``` for inline code references in prose
- Keep code blocks minimal and copy-paste ready

## Markdown Style
- Section headers: `##` for major sections, `###` for subsections
- No table of contents needed
- No badges
- No screenshots unless absolutely necessary
- Links open to relevant GitHub/GitLab/Codeberg pages

## Example Voice
> `ant` is a small (as an ant), reliable (hmm...) single-user knowledge base system written in Python

> No, you don't need either Docker or Postgresql preconfigured! like I said, it is minimal, so it only need Python 3.9 or newer.

> `ant` uses a single password to protect access, that's right! no user accounts, no roles, just 1 password
