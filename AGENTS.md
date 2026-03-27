# Global Instructions for Codex

## Codex First
This repository is designed for `~/.codex` first.
Always use the OpenAI developer documentation MCP server if you need to work with the OpenAI API, ChatGPT Apps SDK, Codex, MCP configuration, or OpenAI platform behavior without me having to explicitly ask.

## Learning Mode (Guided)

I am a growing developer. When working with me:

1. Explain WHY before writing code: architecture decisions, pattern choices, trade-offs
2. Mark learning opportunities with `// TODO(human): try implementing this yourself`
3. Keep roughly a 70/30 split between AI implementation and human practice
4. After each task, mention 1-2 concepts worth studying deeper

## Core Workflow

1. Explain: clarify the problem, why the approach fits, and the trade-offs before non-trivial changes
2. Align: confirm direction for risky, ambiguous, or broad changes
3. Execute: implement end-to-end
4. Reflect: summarize what changed and what to study next

Prefer evidence over guesses. Use repository context, concrete measurements, official docs, or benchmarks where possible.

## Harness Rules

Use these files as the primary operating system for the agent:

- `rules/workflow.md`
- `rules/harness-engineering.md`
- `rules/agents.md`
- `rules/coding-style.md`
- `rules/testing.md`
- `rules/security.md`
- `rules/git-workflow.md`
- `rules/context-management.md`
- `rules/advanced-workflows.md`
- `rules/hooks.md`
- `rules/defaults.md`
- `rules/cs-boost.md`

## Agent Usage

Use specialized agents when the platform supports them.
Default triggers:

- `planner` for complex features, architecture, or large refactors
- `code-reviewer` after code modifications
- `tdd-guide` for new features and bug fixes
- `security-reviewer` for auth, API, input handling, or sensitive data
- `build-error-resolver` for build and type failures
- `debugger` for runtime errors and failing tests
- `architect` for system design and scalability questions
- `a11y-reviewer`, `database-reviewer`, `python-reviewer`, `go-reviewer`, `rust-expert`, `graphql-expert`, `react-agent`, `performance-optimizer`, `refactor-cleaner`, `doc-updater`, `e2e-runner`, `infrastructure-agent`, and `vector-db-agent` when their specialty matches

## Commands

Prefer the command pack in `commands/` when it fits the request.
Especially useful:

- `/plan`
- `/code-review`
- `/verify`
- `/tdd`
- `/multi-agent`
- `/modern-frontend`
- `/frontend-codemap`
- `/update-docs`
- `/tool-registry`
- `/test-coverage`
- `/build-fix`

## Skills

Skills live in `~/.codex/skills/`.
Use the synced skill set for architecture, backend, frontend, review, TDD, security, documentation, MCP, and research workflows.

## Codex Notes

- `AGENTS.md` should stay short and act as a table of contents.
- Put deeper guidance in `rules/`, `skills/`, `commands/`, and docs.
- Codex is the primary target of this repository.
- Claude-specific hooks and `settings.local.json` are kept only as optional compatibility assets.
