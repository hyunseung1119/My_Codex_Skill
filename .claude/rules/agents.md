# Agent Orchestration

## Available Agents

Located in `~/.claude/agents/`:

### Core Agents
| Agent | Purpose | When to Use |
|-------|---------|-------------|
| planner | Implementation planning | Complex features, refactoring |
| architect | System design | Architectural decisions |
| tdd-guide | Test-driven development | New features, bug fixes |
| code-reviewer | Code review | After writing code |
| security-reviewer | Security analysis | Before commits |
| build-error-resolver | Fix build errors | When build fails |
| e2e-runner | E2E testing | Critical user flows |
| refactor-cleaner | Dead code cleanup | Code maintenance |
| doc-updater | Documentation | Updating docs |
| debugger | Bug diagnosis | Runtime errors, test failures |
| performance-optimizer | Performance tuning | Slow queries, API latency |

### Meta Agents (2026)
| Agent | Purpose | When to Use |
|-------|---------|-------------|
| coordinator | Multi-agent orchestration | Complex multi-step workflows |
| critic-agent | Self-critique & refinement | Quality assurance, iteration |
| tree-of-thoughts | Multi-path exploration | Architecture decisions, trade-offs |
| react-agent | Reasoning + Acting | Investigation, debugging |

### Domain Specialists (2026)
| Agent | Purpose | When to Use |
|-------|---------|-------------|
| rust-expert | Rust systems programming | Rust code review, lifetimes, async |
| infrastructure-agent | K8s, Terraform, CI/CD | DevOps, deployment, IaC |
| vector-db-agent | Vector DB, RAG systems | Embeddings, semantic search |

## Immediate Agent Usage

No user prompt needed:
1. Complex feature requests - Use **planner** agent
2. Code just written/modified - Use **code-reviewer** agent
3. Bug fix or new feature - Use **tdd-guide** agent
4. Architectural decision - Use **architect** + **tree-of-thoughts** agents
5. Multi-step complex tasks - Use **coordinator** agent
6. Quality refinement needed - Use **critic-agent**
7. Investigation/debugging - Use **react-agent**
8. Rust code - Use **rust-expert** agent
9. Infrastructure/DevOps - Use **infrastructure-agent**
10. Vector DB/RAG - Use **vector-db-agent**

## Parallel Task Execution

ALWAYS use parallel Task execution for independent operations:

```markdown
# GOOD: Parallel execution
Launch 3 agents in parallel:
1. Agent 1: Security analysis of auth.ts
2. Agent 2: Performance review of cache system
3. Agent 3: Type checking of utils.ts

# BAD: Sequential when unnecessary
First agent 1, then agent 2, then agent 3
```

## Multi-Perspective Analysis

For complex problems, use split role sub-agents:
- Factual reviewer
- Senior engineer
- Security expert
- Consistency reviewer
- Redundancy checker
