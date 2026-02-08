# Token Efficiency

Strategies for optimizing token usage, context management, and cost efficiency.

## Model Selection Matrix

| Task Type | Recommended Model | Rationale |
|-----------|------------------|-----------|
| Simple edits, formatting | Haiku | Fast, cost-effective |
| Code generation, debugging | Sonnet | Best coding balance |
| Architecture, deep analysis | Opus | Maximum reasoning |
| Worker agents (frequent calls) | Haiku | 3x cost savings |
| Orchestrator agents | Sonnet | Needs good judgment |
| Critical decisions | Opus | Worth the cost |

### Cost-Benefit Rules

**Pricing (as of 2026-01-29):**
```
Haiku:  $0.25/1M input, $1.25/1M output  → Use for 90% of subtasks
Sonnet: $3/1M input, $15/1M output       → Main development
Opus:   $15/1M input, $75/1M output      → Complex reasoning only
```

## Context Window Management

### Zone Awareness
```
Context Window (200K tokens)
├── 0-60%:   Normal operation zone
├── 60-80%:  Caution zone (start summarizing)
├── 80-90%:  Critical zone (aggressive compression)
└── 90-100%: Danger zone (avoid complex tasks)
```

### Task Assignment by Context
| Context Usage | Safe Tasks | Avoid |
|---------------|------------|-------|
| < 60% | Any task | - |
| 60-80% | Single-file edits, simple queries | Large refactors |
| 80-90% | Quick fixes, lookups | Multi-file changes |
| > 90% | Clarifications only | Any new work |

## Prompt Compression Techniques

### 1. Reference Substitution
```markdown
# BEFORE (verbose)
The UserAuthenticationService class in src/services/auth/UserAuthenticationService.ts
handles all authentication logic including login, logout, token refresh...

# AFTER (compressed)
`UserAuthenticationService` (auth service) handles login/logout/tokens.
```

### 2. Code Skeleton Extraction
```typescript
// BEFORE: Full file (500 tokens)
export class UserService {
  private db: Database;
  private cache: Cache;

  constructor(db: Database, cache: Cache) {
    this.db = db;
    this.cache = cache;
  }

  async getUser(id: string): Promise<User | null> {
    const cached = await this.cache.get(`user:${id}`);
    if (cached) return cached;
    const user = await this.db.users.findById(id);
    if (user) await this.cache.set(`user:${id}`, user);
    return user;
  }

  async updateUser(id: string, data: UpdateUserDto): Promise<User> {
    // ... 50 more lines
  }
}

// AFTER: Skeleton (100 tokens)
class UserService {
  constructor(db, cache)
  getUser(id): User | null     // cache-first lookup
  updateUser(id, data): User   // validates, updates, invalidates cache
  deleteUser(id): void         // soft delete with cascade
}
```

### 3. Delta Compression
```markdown
# BEFORE: Full diff
- const result = await fetch(url);
- const data = await result.json();
+ const response = await fetch(url);
+ if (!response.ok) throw new Error('Fetch failed');
+ const data = await response.json();

# AFTER: Intent
Added error handling to fetch: checks `response.ok` before parsing JSON.
```

### 4. Extractive Summarization
```markdown
# BEFORE: Full error log (200 lines)
[Full stack trace...]

# AFTER: Key information
Error: `TypeError: Cannot read property 'id' of undefined`
Location: `UserService.ts:45` in `getUser()`
Cause: `user` object is null when accessing `.id`
```

## Token Budget Allocation

### Per-Task Budgets
| Task Type | Input Budget | Output Budget |
|-----------|-------------|---------------|
| Quick question | 2K | 500 |
| Code review | 10K | 3K |
| Feature implementation | 30K | 10K |
| Architecture design | 50K | 15K |

### Agent Budget Distribution
```
Total budget: 100K tokens

Coordinator: 10K (orchestration)
├── Worker 1: 25K (main implementation)
├── Worker 2: 25K (testing)
├── Worker 3: 20K (review)
└── Buffer: 20K (iterations, fixes)
```

## Caching Strategies

### Response Caching
```markdown
# Cache-worthy patterns
- File contents (read once, reference many)
- Search results (glob/grep outputs)
- API documentation (stable reference)

# Do not cache
- Dynamic state (git status, running processes)
- Time-sensitive data
```

### Context Reuse
```markdown
# Efficient: Build on previous context
"In the UserService we discussed, add a method for..."

# Inefficient: Repeat full context
"In src/services/UserService.ts which contains the User class
with methods getUser, updateUser, deleteUser... add a method..."
```

## Parallel vs Sequential Trade-offs

### Parallel (more tokens, faster)
```markdown
Launch 3 agents simultaneously:
- Agent A: security review
- Agent B: performance review
- Agent C: code quality

Total: 3 × 10K = 30K tokens
Time: ~parallel (fastest)
```

### Sequential (fewer tokens, slower)
```markdown
1. Run security review (10K)
2. Based on findings, run performance review (8K - informed)
3. Based on both, run code quality (6K - focused)

Total: 24K tokens (20% savings)
Time: ~3x sequential
```

### Recommendation
- Use parallel for independent analyses
- Use sequential when each step informs the next

## Anti-Patterns

### Token Waste
| Pattern | Waste | Fix |
|---------|-------|-----|
| Re-reading same file | 2x tokens | Reference previous read |
| Verbose prompts | +50% | Use shorthand, references |
| Full file in output | +100% | Output only changes |
| Unnecessary explanations | +30% | Be concise |
| Repeating instructions | +20% | Refer to rules |

### Context Pollution
- Including irrelevant files
- Long chat history without summary
- Verbose tool outputs

## Monitoring

### Warning Thresholds
```json
{
  "TOKEN_BUDGET_WARNING": 0.8,
  "CONTEXT_WARNING": 0.6,
  "COST_WARNING_DAILY": 10.00
}
```

### Track These Metrics
- Tokens per task completion
- Context utilization rate
- Model selection distribution
- Cache hit rate

## Quick Reference

```
🎯 Model Selection
   Simple → Haiku | Coding → Sonnet | Complex → Opus

📊 Context Zones
   <60% Safe | 60-80% Caution | >80% Compress

💰 Cost Savings
   Haiku workers, skeleton refs, delta compression

⚡ Speed vs Cost
   Parallel = faster + more tokens
   Sequential = slower + fewer tokens
```
