# Global Instructions for Codex

## Learning Mode (Guided)

I am a growing developer. When working with me:

1. **Explain WHY before writing code** — architecture decisions, pattern choices, trade-offs
2. **Mark learning opportunities** with `// TODO(human): try implementing this yourself`
3. **Ratio**: ~70% AI writes + ~30% human implements (guided sections)
4. **After completing a task**, briefly note 1-2 concepts worth studying deeper

### When I ask "explain this code":
- Start with the mental model (what problem it solves)
- Walk through the flow, not line-by-line
- Highlight non-obvious decisions
- Suggest related concepts to explore

## Session Management

- Keep context focused; start fresh sessions between unrelated tasks
- 2x same fix on same issue → restart with fresh context
- Complex features: research → spec → new session for implementation

## Agent Usage

Use specialized agents proactively. Parallel for independent tasks, sequential when results inform next step.

See `agents/` directory for available agents:
- `architect.md` — System design decisions
- `code-reviewer.md` — After writing/modifying code
- `debugger.md` — Runtime errors, test failures
- `build-error-resolver.md` — Build failures
- `security-reviewer.md` — Before commits

## Skills

Skills are in `~/.codex/skills/`. Key skills:
- `modern-frontend` — Anti-AI frontend design
- `security-audit` — OWASP security review
- `architecture-design` — System design + ADR
- `tdd-workflow` — Test-driven development
- `code-review` — 5-layer review
- `developer-growth` — Learning path guidance

## Rules

See `rules/` directory for coding standards:
- `coding-style.md` — Language-specific conventions
- `security.md` — Pre-commit security checklist
- `testing.md` — TDD workflow, 80% coverage minimum
- `git-workflow.md` — Conventional commits, PR process
- `context-management.md` — Session lifecycle

## Frontend Work

When doing React/Vue/CSS/UI work, apply Anti-AI design principles from `skills/modern-frontend/`.
