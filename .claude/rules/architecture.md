# Architecture Guidelines

Patterns, principles, and anti-patterns for software architecture design.

## Core Principles

### 1. Separation of Concerns
Each module/layer has a single, well-defined responsibility.

### 2. Dependency Inversion
High-level modules depend on abstractions, not concrete implementations.

### 3. Explicit Dependencies
All dependencies are declared, not hidden. No service locators.

### 4. Fail Fast
Validate early, fail with clear errors, don't propagate invalid state.

## Architectural Patterns

### Layered Architecture
```
┌─────────────────────────────┐
│      Presentation Layer     │  UI, API Controllers
├─────────────────────────────┤
│      Application Layer      │  Use Cases, Orchestration
├─────────────────────────────┤
│        Domain Layer         │  Business Logic, Entities
├─────────────────────────────┤
│     Infrastructure Layer    │  DB, External Services
└─────────────────────────────┘

Rules:
- Dependencies flow downward only
- Domain layer has NO external dependencies
- Infrastructure implements domain interfaces
```

### Hexagonal Architecture (Ports & Adapters)
```
                    ┌─────────────┐
    HTTP ──────────►│             │
                    │   Domain    │◄────────── Database
    CLI  ──────────►│   (Core)    │
                    │             │◄────────── External API
    Events ────────►│             │
                    └─────────────┘

Ports: Interfaces defined by domain
Adapters: Implementations for specific tech
```

### CQRS (Command Query Responsibility Segregation)
```
        ┌──────────────┐
        │   Command    │────► Write Model ────► Event Store
        │   (Write)    │
        └──────────────┘
                                    │
                                    ▼ (Projection)
        ┌──────────────┐
        │    Query     │◄─── Read Model ◄──── Query DB
        │   (Read)     │
        └──────────────┘

Use when:
- Read/write patterns differ significantly
- Need optimized read models
- Event sourcing requirements
```

### Event Sourcing
```
State = f(Initial State, [Events])

Events:
  UserCreated { id, email, timestamp }
  UserEmailChanged { id, newEmail, timestamp }
  UserDeleted { id, timestamp }

Benefits:
- Complete audit trail
- Temporal queries
- Easy debugging

Costs:
- Complexity
- Eventually consistent reads
- Event schema evolution
```

## Domain-Driven Design (DDD)

### Strategic Patterns
| Pattern | Description | Use When |
|---------|-------------|----------|
| Bounded Context | Clear boundary for domain model | Large domains |
| Context Map | Relationships between contexts | Multiple teams |
| Ubiquitous Language | Shared vocabulary | Always |

### Tactical Patterns
```typescript
// Entity: Identity-based equality
class User {
  constructor(
    readonly id: UserId,
    private _email: Email,
    private _name: Name
  ) {}

  changeEmail(newEmail: Email): void {
    // Business rules here
    this._email = newEmail;
  }
}

// Value Object: Value-based equality
class Email {
  constructor(readonly value: string) {
    if (!this.isValid(value)) {
      throw new InvalidEmailError(value);
    }
  }

  equals(other: Email): boolean {
    return this.value === other.value;
  }
}

// Aggregate Root: Consistency boundary
class Order {
  private items: OrderItem[] = [];

  addItem(product: Product, quantity: number): void {
    // Invariant: max 10 items per order
    if (this.items.length >= 10) {
      throw new OrderLimitExceededError();
    }
    this.items.push(new OrderItem(product, quantity));
  }
}

// Domain Service: Stateless operations
class TransferService {
  transfer(from: Account, to: Account, amount: Money): void {
    from.debit(amount);
    to.credit(amount);
  }
}

// Repository: Aggregate persistence
interface UserRepository {
  findById(id: UserId): Promise<User | null>;
  save(user: User): Promise<void>;
}
```

## Module Boundaries

### High Cohesion
```
✅ GOOD: Feature-based structure
src/
├── users/
│   ├── UserService.ts
│   ├── UserRepository.ts
│   ├── UserController.ts
│   └── user.types.ts
├── orders/
│   ├── OrderService.ts
│   └── ...
```

### Low Coupling
```
❌ BAD: Direct dependency
class OrderService {
  constructor(private userRepo: UserRepository) {} // Tight coupling
}

✅ GOOD: Interface dependency
class OrderService {
  constructor(private userProvider: IUserProvider) {} // Loose coupling
}
```

### Dependency Rules
```
┌─────────────────────────────────────────┐
│  Infrastructure depends on Domain       │
│  Application depends on Domain          │
│  Domain depends on NOTHING external     │
└─────────────────────────────────────────┘
```

## API Design

### RESTful Resources
```
GET    /users          List users
GET    /users/:id      Get user
POST   /users          Create user
PUT    /users/:id      Replace user
PATCH  /users/:id      Update user
DELETE /users/:id      Delete user
```

### Response Envelope
```typescript
interface ApiResponse<T> {
  success: boolean;
  data?: T;
  error?: {
    code: string;
    message: string;
    details?: unknown;
  };
  meta?: {
    page: number;
    limit: number;
    total: number;
  };
}
```

### Versioning
```
/api/v1/users    # URL versioning (recommended)
Accept: application/vnd.api+json;version=1  # Header versioning
```

## Anti-Patterns to Avoid

### Architecture Smells
| Anti-Pattern | Problem | Solution |
|-------------|---------|----------|
| God Class | Too many responsibilities | Split by concern |
| Spaghetti Code | No clear structure | Define layers |
| Big Ball of Mud | No boundaries | Establish modules |
| Golden Hammer | One solution for all | Choose appropriate pattern |
| Leaky Abstraction | Implementation details leak | Better interfaces |

### Common Mistakes
```
❌ Circular dependencies
   A → B → C → A

❌ Service locator (hidden dependencies)
   const db = Container.get('database');

❌ Anemic domain model (no behavior)
   class User { id; name; email; } // Just data

❌ Transaction script in controllers
   controller.createOrder() { /* 200 lines of logic */ }

❌ Shared mutable state
   global.currentUser = user;
```

## Decision Framework

### When to Use What
| Situation | Pattern |
|-----------|---------|
| Simple CRUD | Layered + Repository |
| Complex domain | DDD + Hexagonal |
| High read/write ratio difference | CQRS |
| Audit requirements | Event Sourcing |
| Multiple data sources | Hexagonal |
| Microservices | Bounded Contexts |

### Complexity Budget
```
Start simple → Add complexity only when needed

1. Start with layered architecture
2. Extract domain layer when business logic grows
3. Add CQRS when read/write patterns diverge
4. Add Event Sourcing only if audit trail required
```

## Review Checklist

- [ ] Clear layer/module boundaries
- [ ] Dependencies flow in correct direction
- [ ] Domain logic isolated from infrastructure
- [ ] Interfaces define contracts
- [ ] No circular dependencies
- [ ] Appropriate pattern for problem complexity
- [ ] API follows conventions
- [ ] Error handling is consistent
