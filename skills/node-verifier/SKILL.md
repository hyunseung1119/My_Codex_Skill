---
name: node-verifier
description: Run focused verification for Node.js backends, libraries, and TypeScript server projects. Use when changing APIs, services, packages, CLI tools, or shared JS/TS modules and you need the right order of test, lint, typecheck, and build checks.
---

# Node Verifier

Use this skill after server-side or package-level JS/TS changes.

## Verification Order

1. Inspect `package.json` scripts and workspace layout first.
2. Re-run the nearest unit or integration test before global test suites.
3. Run typecheck when TypeScript or `tsc` scripts exist.
4. Run build when packaging, emitted artifacts, or runtime entrypoints changed.

## Default Command Priority

- nearest `npm test` or workspace-targeted test command
- `npm run lint`
- `npm run typecheck`
- `npm run build`
- package or workspace integration test command

## Guardrails

- In monorepos, target the affected package first.
- If the repo has no explicit typecheck script, do not assume one.
- For API changes, mention missing contract or integration coverage when absent.
