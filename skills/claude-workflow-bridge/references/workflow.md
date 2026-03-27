# Workflow Reference

Codex-side translation of the user's Claude workflow:

1. Discover before editing.
2. Explain first when the change is architectural, risky, or expensive.
3. Execute directly for routine implementation work.
4. Verify with the narrowest meaningful command first.
5. Close with a brief reflection on outcome and residual risk.

Apply an evidence rule to recommendations:

- Prefer official docs, local codebase patterns, benchmarks, or actual command output.
- If evidence is missing, say so explicitly.

For bug fixing:

1. State the likely root cause.
2. Reproduce or anchor on the failing test/log.
3. Patch the smallest correct surface.
4. Re-run verification.
5. Add a one-line prevention note when useful.
