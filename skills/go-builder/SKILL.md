---
name: go-builder
description: Build and modify Go services, CLIs, and libraries with attention to package boundaries, interfaces, error handling, concurrency, and testable design. Use when implementing or refactoring Go handlers, services, packages, goroutine flows, or infrastructure-facing code.
---

# Go Builder

Use this skill for implementation work in Go, not just verification.

## Focus Areas

- package boundaries and dependency direction
- explicit error handling and wrapping
- interface use only where it helps testing or decoupling
- context propagation, cancellation, and timeouts
- concurrency safety around goroutines, channels, and shared state

## Workflow

1. Inspect the affected package and nearby tests first.
2. Prefer small package-local changes before cross-package abstractions.
3. Keep exported APIs narrow and names concrete.
4. For handler/service changes, trace:
   - input validation
   - context flow
   - returned errors
   - logging side effects
5. Verify with `go-verifier` after changes.

## Guardrails

- Do not introduce interfaces prematurely.
- Prefer plain structs and functions until abstraction is justified.
- Mention race-risk when changing concurrent code, even if `-race` is not run.
- Avoid hidden global state unless the project already relies on it.
