# Migration Guide: .claude 2026 Update

This guide covers the migration to the 2026 version of the .claude configuration.

## Overview

The 2026 update adds:
- 7 new agents (4 meta-agents + 3 domain specialists)
- 2 new rules (token-efficiency, architecture)
- 4 new skills (context-compressor, rag-2.0, mcp-integration, agentic-workflows)
- 3 new commands (multi-agent, token-analysis, rust)
- Updated settings with model overrides and agent defaults
- Enhanced coding-style.md with 2026 standards

## Pre-Migration Checklist

- [ ] Backup existing `.claude` directory
- [ ] Note any custom modifications to existing files
- [ ] Verify Claude Code version is 2026-compatible

## Backup Procedure

```bash
# Create timestamped backup
cp -r ~/.claude ~/.claude-backup-$(date +%Y%m%d)

# Or for project-specific .claude
cp -r ./.claude ./.claude-backup-$(date +%Y%m%d)
```

## New Files Added

### Agents (7 files)
```
agents/
├── critic-agent.md         # Self-critique and refinement
├── tree-of-thoughts.md     # Multi-path problem solving
├── react-agent.md          # Reasoning + Acting pattern
├── coordinator.md          # Multi-agent orchestration
├── rust-expert.md          # Rust systems programming
├── infrastructure-agent.md # K8s, Terraform, CI/CD
└── vector-db-agent.md      # Vector DB and RAG
```

### Rules (2 files)
```
rules/
├── token-efficiency.md     # Token optimization strategies
└── architecture.md         # Architecture patterns & DDD
```

### Skills (4 directories)
```
skills/
├── context-compressor/SKILL.md   # Context compression
├── rag-2.0/SKILL.md              # Advanced RAG patterns
├── mcp-integration/SKILL.md      # MCP server setup
└── agentic-workflows/SKILL.md    # Multi-agent patterns
```

### Commands (3 files)
```
commands/
├── multi-agent.md      # /multi-agent pattern execution
├── token-analysis.md   # /token-analysis usage tracking
└── rust.md             # /rust expert commands
```

## Modified Files

### settings.local.json

New settings added:
```json
{
  "env": {
    "MAX_THINKING_TOKENS": "32000",      // Increased from 16000
    "CLAUDE_CODE_MAX_OUTPUT_TOKENS": "16000",  // Increased from 8000
    "PARALLEL_AGENT_LIMIT": "3",         // New
    "TOKEN_BUDGET_WARNING": "0.8"        // New
  },
  "modelOverrides": {                    // New section
    "planning": "opus",
    "architecture": "opus",
    "simple-edit": "haiku",
    "formatting": "haiku"
  },
  "agentDefaults": {                     // New section
    "maxIterations": 10,
    "parallelLimit": 3,
    "timeoutMs": 300000
  }
}
```

New permissions:
- `Bash(cargo:*)` - Rust cargo commands
- `Bash(rustc:*)` - Rust compiler
- `Bash(kubectl:*)` - Kubernetes
- `Bash(terraform:*)` - Infrastructure as Code
- `Bash(docker:*)` - Container operations

### rules/coding-style.md

New "2026 Standards" section added at the top:
- Functional Core, Imperative Shell pattern
- Type-Driven Development
- Result Types Over Exceptions
- Maintainability Metrics

## Step-by-Step Migration

### Step 1: Backup
```bash
cp -r ./.claude ./.claude-backup-$(date +%Y%m%d)
```

### Step 2: Apply Updates
The migration has already been applied. Verify files exist:
```bash
ls -la .claude/agents/
ls -la .claude/rules/
ls -la .claude/skills/
ls -la .claude/commands/
```

### Step 3: Verify Settings
```bash
cat .claude/settings.local.json | jq .
```

### Step 4: Test New Features

Test agents:
```
# In Claude Code
Use the critic-agent to review this function...
Use the tree-of-thoughts agent to explore options for...
```

Test commands:
```
/multi-agent debate "REST vs GraphQL"
/token-analysis conversation
/rust review src/lib.rs
```

## Rollback Procedure

If issues occur:

```bash
# Remove new version
rm -rf ./.claude

# Restore backup
cp -r ./.claude-backup-YYYYMMDD ./.claude
```

## Verification Checklist

After migration, verify:

- [ ] `settings.local.json` parses without errors
- [ ] New agents appear in agent list
- [ ] `/multi-agent` command works
- [ ] `/token-analysis` command works
- [ ] `/rust` command works (if Rust project)
- [ ] Existing commands still work (`/plan`, `/code-review`)
- [ ] Hooks still function (Prettier, etc.)

## Troubleshooting

### Settings Parse Error
```bash
# Validate JSON
cat .claude/settings.local.json | jq .

# Common issue: trailing commas
# Fix: Remove trailing commas from JSON
```

### Agent Not Found
- Verify file is in correct location: `agents/<name>.md`
- Check file has correct markdown structure
- Restart Claude Code session

### Command Not Working
- Verify file is in `commands/<name>.md`
- Check SKILL.md format for skills
- Ensure permissions are granted in settings

### Performance Issues
- Check `PARALLEL_AGENT_LIMIT` is not too high
- Verify `MAX_THINKING_TOKENS` is appropriate
- Monitor token usage with `/token-analysis`

## Summary of Changes

| Category | Before | After |
|----------|--------|-------|
| Agents | 12 | 19 (+7) |
| Rules | 8 | 10 (+2) |
| Skills | 7 | 11 (+4) |
| Commands | 22 | 25 (+3) |
| MAX_THINKING_TOKENS | 16000 | 32000 |
| MAX_OUTPUT_TOKENS | 8000 | 16000 |

## Support

For issues with the 2026 migration:
1. Check this guide's troubleshooting section
2. Review individual file documentation
3. Report issues at https://github.com/anthropics/claude-code/issues
