# Claude Code Glossary

Unified terminology for .claude configuration (2026).

---

## Core Concepts

### Agent
A specialized autonomous unit that performs specific tasks using Claude Code's tools.

**Types:**
- **Meta Agents**: Orchestrate other agents (coordinator, critic-agent, tree-of-thoughts, react-agent)
- **Domain Specialists**: Experts in specific domains (rust-expert, infrastructure-agent, vector-db-agent)
- **Core Agents**: General development tasks (planner, code-reviewer, security-reviewer, tdd-guide, debugger)

**Usage:**
```bash
# Invoke an agent
Use the code-reviewer agent to review src/api/routes.py

# Or via command
/code-review
```

**Location:** `.claude/agents/*.md`

**Note:** In earlier versions, these were sometimes called "subagents" but the standard term is now "**agent**".

---

### Skill
A reusable workflow or template for specific development tasks.

**Examples:**
- `backend-api`: FastAPI endpoint development
- `react-component`: React component creation
- `ml-training`: ML/AI model training and RAG
- `ai-research-integration`: Research latest AI techniques

**Usage:**
```bash
# Invoke a skill
/backend-api Create a POST /users endpoint

# Or natural language
Use the backend-api skill to implement user CRUD
```

**Location:** `.claude/skills/<skill-name>/SKILL.md`

**Structure:**
```
skills/backend-api/
├── SKILL.md          # Main skill definition
└── examples/         # Example code (optional)
```

---

### Command
A slash command that invokes a skill or agent.

**Examples:**
- `/commit`: Create git commit
- `/code-review`: Invoke code-reviewer agent
- `/multi-agent`: Coordinator orchestration
- `/dev-journal`: Generate development log

**Usage:**
```bash
/commit
/code-review
/multi-agent "implement authentication"
```

**Location:** `.claude/commands/*.md`

**Note:** Commands are shortcuts to skills or agents. They appear in the autocomplete menu.

---

### Rule
Project-specific guidelines that Claude Code follows automatically.

**Examples:**
- `coding-style.md`: Immutability, functional programming, 2026 standards
- `security.md`: OWASP Top 10, secret management
- `testing.md`: TDD workflow, 80% coverage requirement
- `architecture.md`: DDD, Hexagonal, CQRS patterns
- `token-efficiency.md`: Model selection, context management

**Usage:**
Rules are automatically loaded from `.claude/rules/*.md` when Claude Code starts.

**Location:** `.claude/rules/*.md`

**Customization:**
```bash
# Remove unwanted rules
rm .claude/rules/security.md

# Add custom rule
echo "# My Rule" > .claude/rules/my-rule.md
```

---

### Hook
Automated scripts that run before/after tool executions.

**Types:**
- **PreToolUse**: Before tool execution (validation, parameter modification)
- **PostToolUse**: After tool execution (auto-format, checks)
- **Stop**: When session ends (final verification)

**Examples:**
- Auto-format with Prettier after editing JS/TS files
- Run `tsc` after editing TypeScript
- Warn about `console.log` statements
- Open editor for review before `git push`

**Configuration:** `~/.claude/settings.json`

**Example Hook:**
```json
{
  "hooks": {
    "postToolUse": [
      {
        "trigger": {
          "tool": "Edit",
          "filePattern": "**/*.{js,jsx,ts,tsx}"
        },
        "action": {
          "command": "prettier --write {filePath}"
        }
      }
    ]
  }
}
```

---

## Agent Types (2026)

### Meta Agents
Agents that orchestrate or enhance other agents.

| Agent | Purpose | When to Use |
|-------|---------|-------------|
| **coordinator** | Multi-agent orchestration | Complex multi-step workflows |
| **critic-agent** | Self-critique and refinement | Quality assurance, iterative improvement |
| **tree-of-thoughts** | Multi-path exploration | Architecture decisions, trade-off analysis |
| **react-agent** | Reasoning + Acting loop | Investigation, debugging, problem-solving |

**See:** `.claude/rules/agents.md`

---

### Domain Specialists
Agents with deep expertise in specific domains.

| Agent | Domain | Key Features |
|-------|--------|--------------|
| **rust-expert** | Rust programming | Ownership, lifetimes, async, unsafe code review |
| **infrastructure-agent** | DevOps/K8s/Terraform | IaC, deployment, CI/CD, security |
| **vector-db-agent** | Vector databases & RAG | 6 DB comparison, RAG patterns, RAGAS metrics |
| **database-reviewer** | PostgreSQL | Query optimization, schema design, Supabase best practices |
| **go-reviewer** | Go programming | Idiomatic Go, concurrency, error handling |

---

### Core Agents
General-purpose development agents.

| Agent | Purpose | Proactive? |
|-------|---------|-----------|
| **planner** | Implementation planning | ✅ Complex features |
| **architect** | System design | ✅ Architectural decisions |
| **tdd-guide** | Test-driven development | ✅ New features, bug fixes |
| **code-reviewer** | Code review | ✅ After writing code |
| **security-reviewer** | Security analysis | ✅ Before commits |
| **build-error-resolver** | Build error fixing | ✅ When build fails |
| **e2e-runner** | E2E testing | ✅ Critical user flows |
| **refactor-cleaner** | Dead code cleanup | On demand |
| **doc-updater** | Documentation | On demand |
| **debugger** | Bug diagnosis | On demand |
| **performance-optimizer** | Performance tuning | On demand |

**Note:** "Proactive" means the agent is automatically invoked by the system when appropriate conditions are met.

---

## AI/ML Terminology

### RAG (Retrieval-Augmented Generation)
Pattern where LLM generates answers based on retrieved documents.

**2026 Techniques:**
- **Instructed Retriever**: Metadata-aware retrieval (70% accuracy improvement)
- **Hybrid Search**: Semantic + keyword matching
- **Multi-Modal RAG**: Text + images
- **Self-RAG**: Adaptive retrieval decisions
- **Late Interaction**: Precise ranking after retrieval (ColBERT)

**See:** `.claude/skills/rag-2.0/SKILL.md`

---

### CRAG (Corrective RAG)
Self-correcting RAG that validates retrieved documents before generation.

---

### Vector Database (Vector DB)
Database optimized for similarity search using embeddings.

**Popular Options (2026):**
- Weaviate (hybrid search)
- Pinecone (managed, easy)
- Qdrant (fast, open-source)
- Chroma (simple, embedded)
- Milvus (scalable)
- pgvector (PostgreSQL extension)

**See:** `.claude/agents/vector-db-agent.md`

---

### Embedding
Numerical vector representation of text/image/audio for semantic similarity.

**Common Models (2026):**
- `text-embedding-3-large` (OpenAI)
- `voyage-2` (Voyage AI)
- `e5-mistral-7b` (Mistral)

---

### ReAct (Reasoning + Acting)
Pattern where agent alternates between reasoning and taking actions.

**Example:**
```
Thought: "I need to check the logs"
Action: Read logs/api.log
Observation: "Error: NoneType object"
Thought: "User object is None"
Action: Read src/api/routes.py
Observation: "Auth middleware missing"
Thought: "Fix: Add auth check"
Action: Edit src/api/routes.py
```

**See:** `.claude/agents/react-agent.md`

---

### Chain-of-Thought (CoT)
Prompting technique where model explains reasoning step-by-step.

**Variants:**
- **Tree of Thoughts**: Explores multiple reasoning paths
- **Self-Consistency**: Generates multiple answers, votes on best
- **Auto-CoT**: Auto-generates reasoning chains

**See:** AI research papers on prompt engineering

---

## Architecture Patterns

### DDD (Domain-Driven Design)
Design approach focused on modeling the business domain.

**Key Concepts:**
- Entity: Identity-based equality
- Value Object: Value-based equality
- Aggregate Root: Consistency boundary
- Domain Service: Stateless operations
- Repository: Persistence abstraction

**See:** `.claude/rules/architecture.md`

---

### Hexagonal Architecture (Ports & Adapters)
Architecture where domain logic is isolated from infrastructure.

**Structure:**
```
Core (Domain Logic)
  ↕ Ports (Interfaces)
Adapters (Infrastructure: DB, HTTP, etc.)
```

---

### CQRS (Command Query Responsibility Segregation)
Separate read models from write models.

**Use When:**
- Read/write patterns differ significantly
- Need optimized read models
- Event sourcing requirements

---

### Event Sourcing
Store all changes as events, not just current state.

**Benefits:**
- Complete audit trail
- Temporal queries
- Easy debugging

**Costs:**
- Complexity
- Eventually consistent reads

---

## Token & Context Management

### Token
Unit of text for LLMs (roughly 0.75 words in English).

**Cost (2026 Anthropic):**
| Model | Input | Output |
|-------|-------|--------|
| Haiku | $0.25/1M | $1.25/1M |
| Sonnet | $3/1M | $15/1M |
| Opus | $15/1M | $75/1M |

**See:** `.claude/rules/token-efficiency.md`

---

### Context Window
Maximum tokens the model can process in a single request.

**Claude 4.5 (2026):** 200,000 tokens

---

### Context Zone
Health indicator for context usage.

| Zone | Usage | Action |
|------|-------|--------|
| **Safe** | < 60% | Any task |
| **Caution** | 60-80% | Single-file operations, summarize |
| **Critical** | 80-90% | Compress context |
| **Danger** | > 90% | Avoid complex tasks |

---

### Model Selection

| Task | Model | Rationale |
|------|-------|-----------|
| Simple edits | Haiku | 3x cost savings |
| Main development | Sonnet | Best coding balance |
| Architecture | Opus | Maximum reasoning |

**See:** `.claude/rules/token-efficiency.md`

---

## MCP (Model Context Protocol)

Standard protocol for connecting AI assistants to external data sources.

**MCP Server:** Provides tools/resources (e.g., database, Slack, GitHub)
**MCP Client:** Claude Code (connects to servers)

**Examples:**
- `@modelcontextprotocol/server-postgres`: PostgreSQL access
- `@modelcontextprotocol/server-github`: GitHub integration
- `@modelcontextprotocol/server-slack`: Slack integration

**See:** `.claude/skills/mcp-integration/SKILL.md`

---

## Observability (2026)

### OpenTelemetry (OTel)
Standard for observability (logs, metrics, traces).

**GenAI Semantic Conventions (v1.37+):**
- `gen_ai.request.model`: Model name
- `gen_ai.usage.input_tokens`: Input token count
- `gen_ai.usage.output_tokens`: Output token count
- `gen_ai.operation.name`: Operation type (chat, completion)

**See:** `.claude/rules/observability.md`

---

### Three Pillars of Observability

1. **Logs**: Structured events (JSON)
2. **Metrics**: Aggregated measurements (Prometheus)
3. **Traces**: Request flow across services (distributed tracing)

---

### AgentOps
Lifecycle management for AI agents (development, testing, deployment, monitoring, retraining, retirement).

---

## Testing

### TDD (Test-Driven Development)
Write tests first, then implement code.

**Workflow:**
1. **RED**: Write failing test
2. **GREEN**: Write minimal code to pass
3. **REFACTOR**: Improve code quality

**Requirement:** 80%+ test coverage

**See:** `.claude/rules/testing.md`, `.claude/agents/tdd-guide.md`

---

### E2E Testing (End-to-End)
Test complete user flows (browser automation).

**Tools:**
- Playwright (recommended 2026)
- Cypress

**See:** `.claude/agents/e2e-runner.md`

---

## Git & Commits

### Conventional Commits
Standardized commit message format.

**Format:**
```
<type>: <description>

<optional body>
```

**Types:**
- `feat`: New feature
- `fix`: Bug fix
- `refactor`: Code refactoring
- `docs`: Documentation
- `test`: Tests
- `chore`: Maintenance
- `perf`: Performance
- `ci`: CI/CD

**Example:**
```
feat: add JWT authentication

Implement JWT-based authentication with access/refresh tokens.
- Access token: 15min expiry
- Refresh token: 7 days
- HttpOnly cookies for security

Co-Authored-By: Claude Sonnet 4.5 <noreply@anthropic.com>
```

**See:** `.claude/rules/git-workflow.md`

---

### ADR (Architecture Decision Record)
Document capturing an important architectural decision.

**Format:**
```markdown
# ADR-042: JWT Authentication

**Status:** Accepted
**Date:** 2026-01-27
**Deciders:** Engineering team

## Context
[Problem statement]

## Decision
[What was decided]

## Consequences
[Positive, negative, neutral impacts]

## Alternatives Considered
[Other options and why rejected]
```

**See:** `/dev-journal --adr` command

---

## Security

### OWASP Top 10
Top 10 most critical web application security risks.

**2024/2025 List:**
1. Broken Access Control
2. Cryptographic Failures
3. Injection
4. Insecure Design
5. Security Misconfiguration
6. Vulnerable and Outdated Components
7. Authentication Failures
8. Data Integrity Failures
9. Logging & Monitoring Failures
10. Server-Side Request Forgery (SSRF)

**See:** `.claude/rules/security.md`, `.claude/agents/security-reviewer.md`

---

### Secret Management
Secure storage and rotation of API keys, passwords, tokens.

**Tools (2026):**
- AWS Secrets Manager
- HashiCorp Vault
- Azure Key Vault
- Google Secret Manager

**Basic:** Environment variables (`.env` file, `.gitignore`)

**See:** `.claude/rules/security.md` (Secret Management section)

---

## Cross-References

- **Agent List:** `.claude/rules/agents.md`
- **Architecture Patterns:** `.claude/rules/architecture.md`
- **Coding Style:** `.claude/rules/coding-style.md`
- **Token Efficiency:** `.claude/rules/token-efficiency.md`
- **Security:** `.claude/rules/security.md`
- **Testing:** `.claude/rules/testing.md`
- **Observability:** `.claude/rules/observability.md`
- **Git Workflow:** `.claude/rules/git-workflow.md`

---

**Version:** 1.0
**Last Updated:** 2026-01-29
