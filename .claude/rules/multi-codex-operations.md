# Multi-Codex Operations Rule

## Goal

Enable safe parallel execution across multiple Codex instances without merge conflicts or quality regressions.

## Branch and Ownership

- One Codex instance per branch.
- Do not share writable ownership of the same file in parallel.
- If overlap is unavoidable, assign a temporary file owner and defer other edits.

## Parallel Work Contract

Each workstream must define before execution:
- scope: exact files/directories
- inputs: assumptions and dependencies
- outputs: expected artifacts
- done criteria: verifiable checks

## Merge Gate

Before merge, require all of:
- build/test pass for touched scope
- code review checklist complete
- security checklist complete for auth/data/IO changes
- docs updated for behavior changes

## Conflict Resolution

- Prefer replay/rebase with minimal diffs.
- Never use destructive reset in shared branches.
- If conflict affects business logic, route to reviewer + critic-agent.

## Observability and Eval

- Record per-workstream: task id, files touched, checks run, result.
- Keep a short post-merge note: what changed, risk, rollback plan.
