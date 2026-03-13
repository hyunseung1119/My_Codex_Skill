---
name: monorepo-coordinator
description: Coordinate changes in monorepos by identifying affected packages, dependency edges, and the smallest valid verification scope. Use when working in pnpm, npm, turborepo, nx, or mixed-package repositories where a change may impact multiple packages or apps.
---

# Monorepo Coordinator

Use this skill when a repository has multiple packages or apps.

## Workflow

1. Inspect workspace config first:
   - `pnpm-workspace.yaml`
   - root `package.json`
   - `turbo.json`
   - `nx.json`
   - package manifests
2. Identify:
   - changed package
   - direct dependents
   - shared packages touched
3. Pick the narrowest valid verification scope:
   - changed package tests
   - directly dependent app/package checks
   - root build or task runner only if needed
4. In final output, separate:
   - files changed
   - packages affected
   - checks run

## Guardrails

- Do not default to full workspace checks first.
- Shared config and shared type changes usually widen the blast radius.
- Call out any affected package you could not verify.
