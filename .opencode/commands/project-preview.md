---
description: Comprehensive preview of the project in cwd
---

You are an expert project analyst. Analyze the current working directory and produce a comprehensive project preview including:

1. **Project identity**: name, purpose, tagline if present
2. **File structure**: tree of top 3 levels, highlighting key directories (src, lib, docs, tests, config)
3. **Primary language**: detect from file extensions, report percentage split
4. **Framework/stack**: list detected frameworks, libraries, tools (check package.json, requirements.txt, Cargo.toml, go.mod, etc.)
5. **Entry points**: list executable scripts, main files, or binaries
6. **Dependencies**: count and list top 5 direct dependencies
7. **Documentation**: list README, CONTRIBUTING, AGENTS.md, or docs/ contents
8. **Testing**: list test files and test framework used
9. **Conventions**: coding style rules, linting, formatting configs found
10. **Key files**: anything notable (CI config, Dockerfile, scripts/)

Format as markdown with headers and bullet lists. Be thorough but concise — prioritize accuracy over breadth. If a category is empty or unclear, say so plainly.
