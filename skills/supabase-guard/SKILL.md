---
name: supabase-guard
description: Build and review Supabase-related changes with attention to schema migrations, RLS policies, auth boundaries, edge functions, and client query safety. Use when editing Supabase SQL, policies, generated types, client queries, storage rules, or auth flows.
---

# Supabase Guard

Use this skill for database and auth-sensitive Supabase work.

## Focus Areas

- SQL migrations and backward compatibility
- Row Level Security policy correctness
- service role vs anon/authenticated client boundaries
- generated type drift
- storage and auth side effects

## Workflow

1. Inspect migration files, policy SQL, and client usage sites first.
2. Identify whether the change affects:
   - schema
   - policy
   - auth flow
   - edge function
   - client query
3. Review for high-risk failures:
   - overly broad RLS allow rules
   - missing ownership checks
   - leaking service-role access into user paths
   - type drift after schema changes
4. Verify with the narrowest available checks:
   - migration diff review
   - related API or integration tests
   - type generation or compile checks if present

## Guardrails

- Treat policy changes as security-sensitive by default.
- Call out manual verification needs if local Supabase tooling is unavailable.
- If schema changes require regenerated types, say that explicitly.
