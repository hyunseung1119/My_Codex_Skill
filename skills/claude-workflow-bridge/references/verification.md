# Verification Reference

Mirror the quality intent of Claude hooks without pretending there is automation.

## Required Behavior

- After code changes, run at least one relevant verification step if possible.
- Prefer targeted checks first:
  - single test file
  - focused typecheck
  - relevant linter scope
  - minimal build command
- Report exactly what was run and whether it passed.

## Test Integrity

Do not make tests weaker just to get green:

- no `skip` without a real reason
- no assertion removal to hide failures
- no replacing specific assertions with vague truthiness checks
- no unjustified timeout inflation

## Loop Handling

If the same failure repeats 2-3 times:

1. stop editing blindly
2. inspect adjacent implementation and tests
3. reduce the reproduction
4. change approach
