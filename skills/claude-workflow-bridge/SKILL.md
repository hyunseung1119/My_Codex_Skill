---
name: claude-workflow-bridge
description: Apply the user's Claude Code operating model to Codex by creating or following reusable global workflow, validation, security, and context-management rules. Use for Codex setup customization, global agent behavior tuning, or translating Claude hooks/rules into Codex-compatible instructions.
---

# Claude Workflow Bridge

Codex cannot import Claude Code hooks directly. Use this skill to translate the intent of that setup into Codex-native behavior.

## Use This Skill When

- The user wants Codex configured like their Claude Code environment
- You are creating or updating global rules in `~/AGENTS.md`
- You are building reusable Codex skills that mirror Claude workflows
- You need to map Claude hooks, commands, or rule files into Codex practices

## Workflow

1. Inspect the current Claude source of truth first:
   - `~/.claude/My_ClaudeCode_Skill/CLAUDE.md`
   - `~/.claude/settings.json`
   - Relevant rule files under `~/.claude/My_ClaudeCode_Skill/rules/`
2. Extract only portable behavior:
   - workflow order
   - validation requirements
   - security checks
   - context management
   - loop prevention
3. Convert hooks into Codex operating rules instead of fake automation.
4. Keep global instructions concise. Put detailed guidance in `references/`.
5. Prefer reusable skills when the behavior should be invoked selectively.

## Translation Table

- Claude global prompt/router -> `~/AGENTS.md`
- Claude rules -> this skill's `references/`
- Claude hook middleware -> manual Codex checklist or validation step
- Claude slash commands -> concise workflows embedded in skills, not fake command names
- Claude agents -> explicit review/planning/debugging behaviors triggered by task type

## Codex Guardrails

- Do not promise automatic hooks that Codex does not have.
- Do not bloat `~/AGENTS.md` with long reference material.
- Do not copy large rule documents verbatim when a shorter Codex-specific version works.
- Always verify the new setup by reading the files back after editing.

## References

- For global behavior and sequencing, read `references/workflow.md`.
- For validation and self-checking, read `references/verification.md`.
- For security expectations, read `references/security.md`.
- For long-session hygiene, read `references/context.md`.
