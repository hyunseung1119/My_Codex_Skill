# Security Reference

When touching authentication, APIs, persistence, or input handling:

- check secret exposure first
- validate and sanitize inputs
- use parameterized queries
- confirm authorization, not just authentication
- avoid leaking internals in error paths
- watch for mass assignment and over-broad DTOs

If a critical security flaw is found:

1. state it clearly
2. explain impact
3. fix or contain it before unrelated work
