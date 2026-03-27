---
name: go-verifier
description: Run focused verification for Go projects by choosing the right order of package tests, go test filters, vet, and build checks. Use when changing Go services, CLIs, libraries, handlers, or concurrency-sensitive code.
---

# Go Verifier

Use this skill after Go changes.

## Verification Order

1. Identify the affected package first.
2. Re-run the closest package test or filtered test before `./...`.
3. Run `go test` before `go build` when behavior changed.
4. Run broader package or module checks after the targeted path is clean.

## Default Command Priority

- `go test ./path/to/pkg`
- `go test ./path/to/pkg -run <TestName>`
- `go test ./...`
- `go vet ./...`
- `go build ./...`

## Guardrails

- Prefer package-level scope over module-wide scope first.
- If the code touches goroutines, channels, or shared state, call out race-risk even if `-race` is too expensive to run.
- If generation is required, confirm the project-specific command before running it.
