---
name: root-cause-debugger
description: Debug failures by reproducing them, isolating the failing path, and identifying the root cause before patching. Use for runtime errors, broken tests, flaky behavior, build failures, or repeated fix attempts that need structured diagnosis.
---

# Root Cause Debugger

Use this skill when the failure is not yet understood.

## Workflow

1. Capture the exact error, failing test, or reproduction step.
2. Identify the narrowest failing surface:
   - single test
   - command
   - function
   - config edge
3. Form 1-3 concrete hypotheses.
4. Validate hypotheses with the smallest possible check.
5. Patch only after the likely root cause is established.
6. Re-run the failing path and at least one neighboring check.

## Guardrails

- Do not patch based on vibes.
- If the same failure repeats 2-3 times, change debugging angle.
- Distinguish symptom from root cause in the explanation.
- Prefer logs, traces, test output, and local code evidence.

## Output Rules

- State the likely root cause in one line.
- Show how it was verified.
- Mention any remaining uncertainty.
