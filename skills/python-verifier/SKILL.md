---
name: python-verifier
description: Run focused verification for Python projects by selecting the right order of pytest, ruff, mypy/pyright, and package-specific checks. Use when editing Python services, scripts, FastAPI apps, data pipelines, or tests.
---

# Python Verifier

Use this skill after Python changes.

## Verification Order

1. Read `pyproject.toml`, `requirements*`, `tox.ini`, or `pytest.ini` if present.
2. Re-run the failing or nearest test first.
3. Run formatting or lint checks only if the project already uses them.
4. Run type checking when the project already has `mypy` or `pyright`.
5. Use broader test scopes only after targeted checks pass.

## Default Command Priority

- `pytest path/to/test_file.py -q`
- `pytest -k <pattern>`
- `ruff check <target>`
- `ruff format --check <target>` or project equivalent
- `mypy <target>` or `pyright`
- `pytest`

## Guardrails

- Do not introduce new Python tooling unless asked.
- Do not weaken failing tests to get green.
- If the project has no type checker or linter, state that instead of inventing one.
