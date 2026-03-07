# Agent Orchestration

## Core Agents (use proactively)
| Agent | When to Use | Model |
|-------|-------------|-------|
| planner | Complex features, refactoring | opus |
| code-reviewer | After writing/modifying code | sonnet |
| tdd-guide | New features, bug fixes | sonnet |
| security-reviewer | Before commits | sonnet |
| build-error-resolver | Build failures | sonnet |
| debugger | Runtime errors, test failures | sonnet |
| architect | System design decisions | opus |

## Auto-Trigger Rules
- Complex feature request -> **planner**
- Code just written -> **code-reviewer**
- Bug fix or new feature -> **tdd-guide**
- Build fails -> **build-error-resolver**

## Execution
- **Parallel**: Independent operations (security + performance + type check)
- **Sequential**: When results inform next step
- Use split-role sub-agents for complex analysis (security, performance, consistency)

## Communication Rules
- Each agent MUST declare its scope before starting (what files it will touch)
- Agents MUST NOT modify files outside their declared scope
- When multiple agents run in parallel, they MUST work on non-overlapping files
- Agent output format: `[AGENT_NAME] STATUS: summary` for coordination
- On conflict: stop and report to user, do not overwrite other agent's work
- Research/exploration agents: return summary only, never modify files
