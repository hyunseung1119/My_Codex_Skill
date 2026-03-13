---
name: nextjs-builder
description: Build and validate Next.js application changes with attention to App Router, server and client component boundaries, route handlers, caching, and deployment-sensitive behavior. Use when editing Next.js pages, layouts, server actions, route handlers, metadata, or data fetching logic.
---

# Next.js Builder

Use this skill for real Next.js app work, not generic React edits.

## Focus Areas

- App Router structure: `app/`, layouts, nested routes, loading and error boundaries
- Server vs client component boundaries
- Route handlers and server actions
- Cache and revalidation behavior
- Metadata, redirects, and middleware-sensitive changes

## Workflow

1. Inspect `package.json`, `next.config.*`, and the affected route tree first.
2. Confirm whether the changed file is:
   - server component
   - client component
   - route handler
   - shared util
3. Check for boundary mistakes:
   - client-only APIs in server code
   - server secrets crossing into client bundles
   - invalid async/data fetching patterns
4. Verify in this order when possible:
   - nearest test
   - `lint`
   - `typecheck`
   - `build` for routing/config/shared boundary changes

## Guardrails

- Be explicit when a change can affect static vs dynamic rendering.
- Call out cache invalidation assumptions.
- If there is no route-level test coverage, mention the gap.
