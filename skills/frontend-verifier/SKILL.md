---
name: frontend-verifier
description: Run focused verification for frontend projects such as React, Next.js, Vite, or TypeScript UI apps. Use when changing components, routes, styling, frontend state, or client-side behavior and you need the right order of lint, typecheck, test, and build validation.
---

# Frontend Verifier

Use this skill after frontend edits or before closing a frontend task.

## Verification Order

1. Read project scripts first from `package.json`.
2. Prefer the narrowest useful command:
   - component or unit test file
   - affected app/package test target
   - scoped lint if available
3. Run typecheck before full build when TypeScript exists.
4. Run full build only when the change touches routing, config, bundling, or shared types.

## Default Command Priority

- `npm test -- --runInBand <target>` or project equivalent
- `pnpm test <target>` or `vitest <target>` when available
- `npm run lint`
- `npm run typecheck`
- `npm run build`

## Guardrails

- Do not run the heaviest command first if a focused check exists.
- If UI behavior changed and there are no tests, mention that gap explicitly.
- If the app uses Playwright or Cypress, run the smallest affected scenario when feasible.
