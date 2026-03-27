---
name: task-planner
description: Build an execution-first implementation plan for coding tasks. Use when the user asks for a plan, when a task needs decomposition before coding, or when a risky or multi-step change needs clear sequencing, validation steps, and acceptance criteria.
---

# Task Planner

Use this skill for work that benefits from explicit sequencing before editing.

## Use This Skill When

- The user asks for a plan
- The task spans multiple files or systems
- The task has rollout, migration, or dependency risk
- You need acceptance criteria before coding

## Workflow

1. Inspect the codebase and current execution path first.
2. Break the task into 3-7 concrete steps.
3. For each step, define:
   - target files or components
   - expected behavior change
   - verification command or check
4. Call out risky assumptions and blockers.
5. Keep the plan implementation-oriented, not abstract.

## Output Rules

- Prefer short numbered steps.
- Include validation, not just editing.
- If the task is simple, collapse to a 1-3 step micro-plan.
- If the user wants execution, move from plan to code without repeating the whole plan.
