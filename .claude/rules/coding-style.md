# Coding Style

## 2026 Standards

### Functional Core, Imperative Shell

Separate pure business logic from side effects:

```typescript
// PURE CORE: No side effects, easily testable
function calculateDiscount(order: Order, rules: DiscountRules): Money {
  return rules
    .filter(rule => rule.applies(order))
    .reduce((total, rule) => total.add(rule.calculate(order)), Money.zero());
}

// IMPERATIVE SHELL: Handles I/O, calls pure functions
async function applyDiscount(orderId: string): Promise<void> {
  const order = await orderRepo.findById(orderId);     // I/O
  const rules = await rulesRepo.getActive();           // I/O
  const discount = calculateDiscount(order, rules);    // Pure
  await orderRepo.updateDiscount(orderId, discount);   // I/O
}
```

### Type-Driven Development

Define types first, then implement:

```typescript
// 1. Define the contract
interface UserService {
  create(input: CreateUserInput): Promise<Result<User, CreateUserError>>;
  findById(id: UserId): Promise<Option<User>>;
}

type CreateUserError =
  | { type: 'email_taken'; email: string }
  | { type: 'invalid_input'; errors: ValidationError[] };

// 2. Implement to satisfy the contract
class UserServiceImpl implements UserService {
  // Implementation follows type contract exactly
}
```

### Result Types Over Exceptions

Use explicit Result types for expected errors:

```typescript
// Define Result type
type Result<T, E> = { ok: true; value: T } | { ok: false; error: E };

// Use for operations that can fail
function parseConfig(raw: string): Result<Config, ParseError> {
  try {
    const parsed = JSON.parse(raw);
    return { ok: true, value: validated(parsed) };
  } catch (e) {
    return { ok: false, error: { message: 'Invalid JSON', raw } };
  }
}

// Handle explicitly
const result = parseConfig(input);
if (!result.ok) {
  logger.error('Config parse failed', result.error);
  return defaultConfig;
}
return result.value;
```

### Maintainability Metrics

| Metric | Target | Tool |
|--------|--------|------|
| Cyclomatic Complexity | < 10 per function | ESLint |
| Cognitive Complexity | < 15 per function | SonarQube |
| Test Coverage | > 80% | Jest/Vitest |
| Max File Length | < 400 lines | ESLint |
| Max Function Length | < 50 lines | ESLint |

---

## Immutability (CRITICAL)

ALWAYS create new objects, NEVER mutate:

```javascript
// WRONG: Mutation
function updateUser(user, name) {
  user.name = name  // MUTATION!
  return user
}

// CORRECT: Immutability
function updateUser(user, name) {
  return {
    ...user,
    name
  }
}
```

## File Organization

MANY SMALL FILES > FEW LARGE FILES:
- High cohesion, low coupling
- 200-400 lines typical, 800 max
- Extract utilities from large components
- Organize by feature/domain, not by type

## Error Handling

ALWAYS handle errors comprehensively:

```typescript
try {
  const result = await riskyOperation()
  return result
} catch (error) {
  console.error('Operation failed:', error)
  throw new Error('Detailed user-friendly message')
}
```

## Input Validation

ALWAYS validate user input:

```typescript
import { z } from 'zod'

const schema = z.object({
  email: z.string().email(),
  age: z.number().int().min(0).max(150)
})

const validated = schema.parse(input)
```

## Code Quality Checklist

Before marking work complete:
- [ ] Code is readable and well-named
- [ ] Functions are small (<50 lines)
- [ ] Files are focused (<800 lines)
- [ ] No deep nesting (>4 levels)
- [ ] Proper error handling
- [ ] No console.log statements
- [ ] No hardcoded values
- [ ] No mutation (immutable patterns used)
