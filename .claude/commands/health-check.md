---
description: Run repository skill/agent/command/rule integrity checks and output a quality score report.
argument-hint: [optional_scope]
allowed-tools: ["Read", "Grep", "Glob", "Bash"]
---

# /health-check

Run configuration health checks for the Codex skill repository.

## Checks

1. Skill registry consistency (`skills/` vs `.claude/skills/`)
2. `SKILL.md` existence for each skill
3. Agent frontmatter completeness (`name`, `description`, `tools`, `model`, `permission_mode`, `when_to_use`)
4. Command frontmatter completeness (`description`, `argument-hint`, `allowed-tools`)
5. Rule presence and policy documentation coverage

## Output

- Score by dimension (0-100)
- Overall score
- Blocking issues
- Recommended fixes in priority order
