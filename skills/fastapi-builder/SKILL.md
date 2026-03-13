---
name: fastapi-builder
description: Build and validate FastAPI changes with attention to routers, dependency injection, Pydantic schemas, auth, and response contracts. Use when editing endpoints, request or response models, middleware, dependencies, background tasks, or service wiring in FastAPI projects.
---

# FastAPI Builder

Use this skill for FastAPI-specific backend work.

## Focus Areas

- router registration and path structure
- request and response schema integrity
- dependency injection and auth guards
- async boundaries and blocking calls
- error handling and status code correctness

## Workflow

1. Inspect app entrypoints, router wiring, and schema modules first.
2. Identify the changed surface:
   - endpoint
   - dependency
   - schema
   - service layer
   - middleware
3. Check contract risks:
   - request validation changes
   - response shape drift
   - auth/permission regressions
   - blocking I/O inside async handlers
4. Verify in this order when possible:
   - nearest `pytest` target
   - schema or service tests
   - broader API test slice

## Guardrails

- Prefer explicit response models when the project uses them.
- Mention OpenAPI or contract drift when endpoint behavior changes.
- For auth-related endpoints, include permission and error-path coverage in review.
