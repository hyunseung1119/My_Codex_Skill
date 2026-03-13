---
name: review-guard
description: Perform a defect-focused code review for local changes, pull requests, or proposed implementations. Use when the user asks for review, risk assessment, regression analysis, missing tests, or code quality findings with severity and file references.
---

# Review Guard

Use this skill when review quality matters more than summary.

## Review Priorities

1. Correctness and regression risk
2. Security and data exposure
3. Missing or weakened tests
4. Maintainability problems that can cause future bugs

## Review Workflow

1. Inspect the changed files and nearby tests.
2. Look for behavior changes, not style noise.
3. Prefer concrete findings with:
   - severity
   - impact
   - file reference
   - why it is a problem
4. If no findings exist, say so explicitly.

## Output Rules

- Findings first.
- Order by severity.
- Keep summary brief and secondary.
- Mention residual risk if testing or runtime validation is missing.
