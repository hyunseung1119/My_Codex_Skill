# Performance Optimization

## Model Selection Strategy

> See `rules/token-efficiency.md` for detailed model selection matrix and cost analysis.

**Quick Reference:**
- **Haiku**: Worker agents, simple edits, formatting
- **Sonnet**: Main development, orchestration
- **Opus**: Architecture, deep reasoning

## Context Window Management

> See `rules/token-efficiency.md` for context zone management and compression techniques.

**Key Thresholds:**
- `< 60%`: Safe for any task
- `60-80%`: Caution, prefer single-file operations
- `> 80%`: Compress context, avoid complex tasks

## Ultrathink + Plan Mode

For complex tasks requiring deep reasoning:
1. Use `ultrathink` for enhanced thinking
2. Enable **Plan Mode** for structured approach
3. "Rev the engine" with multiple critique rounds
4. Use split role sub-agents for diverse analysis

## Build Troubleshooting

If build fails:
1. Use **build-error-resolver** agent
2. Analyze error messages
3. Fix incrementally
4. Verify after each fix
