# Security Guidelines

## Mandatory Security Checks

Before ANY commit:
- [ ] No hardcoded secrets (API keys, passwords, tokens)
- [ ] All user inputs validated
- [ ] SQL injection prevention (parameterized queries)
- [ ] XSS prevention (sanitized HTML)
- [ ] CSRF protection enabled
- [ ] Authentication/authorization verified
- [ ] Rate limiting on all endpoints
- [ ] Error messages don't leak sensitive data

## Secret Management (2026 Best Practices)

### Basic: Environment Variables

```typescript
// ❌ NEVER: Hardcoded secrets
const apiKey = "sk-proj-xxxxx"
const dbPassword = "mypassword123"

// ✅ ALWAYS: Environment variables
const apiKey = process.env.OPENAI_API_KEY
const dbPassword = process.env.DB_PASSWORD

if (!apiKey) {
  throw new Error('OPENAI_API_KEY not configured')
}
```

```python
# Python
import os

api_key = os.environ.get("OPENAI_API_KEY")
if not api_key:
    raise ValueError("OPENAI_API_KEY not configured")
```

**.env file (DO NOT commit to git):**
```bash
# .env (add to .gitignore!)
OPENAI_API_KEY=sk-proj-xxxxx
DB_PASSWORD=xxxxx
JWT_SECRET=xxxxx
```

**.gitignore:**
```
.env
.env.local
.env.*.local
secrets/
credentials.json
*.pem
*.key
```

---

### Advanced: Secret Management Services

#### 1. AWS Secrets Manager (Recommended for AWS)

```typescript
import { SecretsManagerClient, GetSecretValueCommand } from '@aws-sdk/client-secrets-manager';

const client = new SecretsManagerClient({ region: 'us-west-2' });

async function getSecret(secretName: string): Promise<string> {
  const command = new GetSecretValueCommand({
    SecretId: secretName
  });

  const response = await client.send(command);
  return response.SecretString!;
}

// Usage
const apiKey = await getSecret('prod/openai/api-key');
const dbCredentials = JSON.parse(await getSecret('prod/db/credentials'));
```

```python
# Python
import boto3
import json

def get_secret(secret_name: str, region: str = 'us-west-2') -> dict:
    client = boto3.client('secretsmanager', region_name=region)
    response = client.get_secret_value(SecretId=secret_name)
    return json.loads(response['SecretString'])

# Usage
db_creds = get_secret('prod/db/credentials')
connection_string = f"postgresql://{db_creds['username']}:{db_creds['password']}@{db_creds['host']}"
```

**Benefits:**
- Automatic rotation
- Audit logs (who accessed what secret when)
- Fine-grained IAM permissions
- Encryption at rest

**Cost:** ~$0.40/secret/month + $0.05 per 10,000 API calls

#### 2. HashiCorp Vault (Recommended for Multi-Cloud)

```typescript
import vault from 'node-vault';

const vaultClient = vault({
  apiVersion: 'v1',
  endpoint: process.env.VAULT_ADDR,
  token: process.env.VAULT_TOKEN
});

async function getSecret(path: string): Promise<any> {
  const response = await vaultClient.read(path);
  return response.data.data;  // KV v2
}

// Usage
const dbCreds = await getSecret('secret/data/production/database');
const apiKeys = await getSecret('secret/data/production/api-keys');
```

**Dynamic Secrets (Advanced):**
```typescript
// Vault generates temporary credentials
const dbCreds = await vaultClient.read('database/creds/readonly');
// dbCreds.data.username: "v-root-readonly-abc123"
// dbCreds.data.password: "A1a-random-generated-password"
// Lease duration: 1 hour → Auto-revoked after expiry
```

**Benefits:**
- Dynamic secrets (auto-generated, auto-revoked)
- Multi-cloud support
- Encryption as a service
- Secret versioning

**Deployment:** Self-hosted or HashiCorp Cloud

#### 3. Azure Key Vault

```typescript
import { SecretClient } from '@azure/keyvault-secrets';
import { DefaultAzureCredential } from '@azure/identity';

const credential = new DefaultAzureCredential();
const vaultUrl = `https://${process.env.VAULT_NAME}.vault.azure.net`;
const client = new SecretClient(vaultUrl, credential);

async function getSecret(secretName: string): Promise<string> {
  const secret = await client.getSecret(secretName);
  return secret.value!;
}

// Usage
const apiKey = await getSecret('OpenAI-API-Key');
```

#### 4. Google Secret Manager

```python
from google.cloud import secretmanager

def get_secret(project_id: str, secret_id: str, version: str = 'latest') -> str:
    client = secretmanager.SecretManagerServiceClient()
    name = f"projects/{project_id}/secrets/{secret_id}/versions/{version}"
    response = client.access_secret_version(request={"name": name})
    return response.payload.data.decode('UTF-8')

# Usage
api_key = get_secret('my-project', 'openai-api-key')
```

---

### Secret Rotation

#### Automated Rotation (AWS Secrets Manager)

```typescript
// Lambda function for rotation
export async function rotateSecret(event: any) {
  const secretId = event.SecretId;
  const token = event.Token;
  const step = event.Step;

  switch (step) {
    case 'createSecret':
      // Generate new password
      const newPassword = generateStrongPassword();
      await secretsManager.putSecretValue({
        SecretId: secretId,
        ClientRequestToken: token,
        SecretString: JSON.stringify({ password: newPassword }),
        VersionStages: ['AWSPENDING']
      });
      break;

    case 'setSecret':
      // Update database with new password
      const pendingSecret = await getSecret(secretId, 'AWSPENDING');
      await updateDatabasePassword(pendingSecret.password);
      break;

    case 'testSecret':
      // Test new credentials
      const testSecret = await getSecret(secretId, 'AWSPENDING');
      await testDatabaseConnection(testSecret.password);
      break;

    case 'finishSecret':
      // Mark as current
      await secretsManager.updateSecretVersionStage({
        SecretId: secretId,
        VersionStage: 'AWSCURRENT',
        MoveToVersionId: token
      });
      break;
  }
}
```

**Rotation Schedule:**
```typescript
// CloudFormation / Terraform
const secret = new secretsmanager.Secret(this, 'DBSecret', {
  generateSecretString: {
    secretStringTemplate: JSON.stringify({ username: 'admin' }),
    generateStringKey: 'password'
  }
});

// Auto-rotate every 30 days
const rotation = new secretsmanager.RotationSchedule(this, 'Rotation', {
  secret: secret,
  automaticallyAfter: Duration.days(30),
  rotationLambda: rotationFunction
});
```

#### Manual Rotation Checklist

1. **Generate new secret**
   ```bash
   # New API key
   openssl rand -hex 32
   ```

2. **Update secret in vault**
   ```bash
   aws secretsmanager update-secret \
     --secret-id prod/api-key \
     --secret-string "new-key-here"
   ```

3. **Update application**
   - Rolling restart (Kubernetes)
   - Blue-green deployment
   - Canary release

4. **Verify**
   - Test with new secret
   - Monitor error rates

5. **Revoke old secret**
   - Wait 24-48 hours
   - Disable old key

---

### Local Development

#### .env Files (Simple Projects)

```bash
# .env.local (add to .gitignore)
OPENAI_API_KEY=sk-proj-local-xxxxx
DB_PASSWORD=local_password
```

```typescript
// Load with dotenv
import dotenv from 'dotenv';
dotenv.config({ path: '.env.local' });

const apiKey = process.env.OPENAI_API_KEY;
```

#### .env.example (Commit to Git)

```bash
# .env.example (safe to commit)
OPENAI_API_KEY=sk-proj-your-key-here
DB_PASSWORD=your-password-here
DB_HOST=localhost
DB_PORT=5432
```

**Onboarding:**
```bash
# New developer
cp .env.example .env.local
# Edit .env.local with real credentials
```

#### direnv (Automatic Environment Loading)

```bash
# Install direnv
brew install direnv  # macOS
sudo apt install direnv  # Linux

# Add to ~/.bashrc or ~/.zshrc
eval "$(direnv hook bash)"

# Create .envrc in project root
cat > .envrc <<EOF
export OPENAI_API_KEY=sk-proj-xxxxx
export DB_PASSWORD=xxxxx
EOF

# Allow
direnv allow .

# Now cd into project → variables auto-loaded
# cd out of project → variables auto-unloaded
```

---

### Kubernetes Secrets

```yaml
# secret.yaml
apiVersion: v1
kind: Secret
metadata:
  name: app-secrets
type: Opaque
stringData:
  OPENAI_API_KEY: sk-proj-xxxxx
  DB_PASSWORD: xxxxx
```

```yaml
# deployment.yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: my-app
spec:
  template:
    spec:
      containers:
        - name: app
          image: my-app:latest
          env:
            - name: OPENAI_API_KEY
              valueFrom:
                secretKeyRef:
                  name: app-secrets
                  key: OPENAI_API_KEY
            - name: DB_PASSWORD
              valueFrom:
                secretKeyRef:
                  name: app-secrets
                  key: DB_PASSWORD
```

**Best Practice: Use External Secrets Operator**

```yaml
# externalsecret.yaml
apiVersion: external-secrets.io/v1beta1
kind: ExternalSecret
metadata:
  name: app-secrets
spec:
  refreshInterval: 1h
  secretStoreRef:
    name: aws-secretsmanager
    kind: SecretStore
  target:
    name: app-secrets
    creationPolicy: Owner
  data:
    - secretKey: OPENAI_API_KEY
      remoteRef:
        key: prod/openai/api-key
    - secretKey: DB_PASSWORD
      remoteRef:
        key: prod/db/password
```

**Benefits:**
- Secrets stay in AWS/Vault, not in Kubernetes etcd
- Automatic sync
- Audit trail

---

### Secret Scanning

#### Pre-Commit Hook (git-secrets)

```bash
# Install git-secrets
brew install git-secrets

# Initialize
git secrets --install
git secrets --register-aws

# Add custom patterns
git secrets --add 'sk-proj-[a-zA-Z0-9]{48}'  # OpenAI keys
git secrets --add 'ghp_[a-zA-Z0-9]{36}'      # GitHub tokens
git secrets --add 'xoxb-[0-9]{10,12}-[0-9]{10,12}-[a-zA-Z0-9]{24}'  # Slack tokens

# Test
echo "sk-proj-abc123..." > test.txt
git add test.txt
git commit -m "test"
# → Blocked! Secret detected
```

#### GitHub Secret Scanning

Automatically enabled for public repositories. For private:

```yaml
# .github/workflows/secret-scan.yml
name: Secret Scan

on: [push, pull_request]

jobs:
  scan:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4

      - name: TruffleHog Scan
        uses: trufflesecurity/trufflehog@main
        with:
          path: ./
          base: ${{ github.event.repository.default_branch }}
          head: HEAD
```

#### GitGuardian (SaaS)

- Scans all commits in real-time
- Alerts on Slack/Email
- Remediation guidance

---

### Security Checklist

- [ ] No secrets in code (use env vars)
- [ ] `.env` files in `.gitignore`
- [ ] Secret manager configured (AWS/Vault/Azure/GCP)
- [ ] Secrets rotated regularly (30-90 days)
- [ ] Principle of least privilege (IAM/RBAC)
- [ ] Secrets encrypted at rest
- [ ] Audit logs enabled
- [ ] Pre-commit hooks installed (git-secrets)
- [ ] CI/CD secret scanning enabled
- [ ] Emergency rotation procedure documented

---

### Emergency: Secret Leaked

1. **Immediate Action (< 5 minutes)**
   ```bash
   # Rotate secret IMMEDIATELY
   aws secretsmanager update-secret \
     --secret-id prod/api-key \
     --secret-string "$(openssl rand -hex 32)"

   # Revoke old secret
   # OpenAI: https://platform.openai.com/api-keys
   # GitHub: https://github.com/settings/tokens
   ```

2. **Assess Impact (< 30 minutes)**
   - Check audit logs: Was the secret used?
   - Review recent API calls/database queries
   - Identify potential unauthorized access

3. **Remediate (< 2 hours)**
   - Deploy new secret to all services
   - Verify services are healthy
   - Monitor for anomalies

4. **Post-Mortem (< 24 hours)**
   - How did it leak? (commit, logs, screenshot)
   - Update processes to prevent recurrence
   - Document incident

5. **Prevention**
   - Enable secret scanning (GitHub, GitGuardian)
   - Pre-commit hooks (git-secrets)
   - Regular audits

## API Security (OWASP API Security Top 10)

### 1. BOLA (Broken Object Level Authorization)

**Problem:** Users can access objects they shouldn't own.

```typescript
// ❌ VULNERABLE: No ownership check
app.get('/api/orders/:orderId', async (req, res) => {
  const order = await db.orders.findById(req.params.orderId);
  return res.json(order);  // Any user can see any order!
});

// ✅ SECURE: Verify ownership
app.get('/api/orders/:orderId', authenticateUser, async (req, res) => {
  const order = await db.orders.findById(req.params.orderId);

  if (!order) {
    return res.status(404).json({ error: 'Order not found' });
  }

  // Check if user owns this order
  if (order.userId !== req.user.id) {
    return res.status(403).json({ error: 'Access denied' });
  }

  return res.json(order);
});
```

**Prevention:**
```typescript
// Middleware for ownership check
function requireOwnership(resourceType: string) {
  return async (req, res, next) => {
    const resourceId = req.params.id;
    const resource = await db[resourceType].findById(resourceId);

    if (!resource) {
      return res.status(404).json({ error: 'Resource not found' });
    }

    if (resource.userId !== req.user.id && !req.user.isAdmin) {
      return res.status(403).json({ error: 'Access denied' });
    }

    req.resource = resource;
    next();
  };
}

// Usage
app.get('/api/orders/:id', authenticateUser, requireOwnership('orders'), (req, res) => {
  return res.json(req.resource);
});
```

### 2. BFLA (Broken Function Level Authorization)

**Problem:** Users can access admin/privileged functions.

```typescript
// ❌ VULNERABLE: No role check
app.delete('/api/users/:userId', authenticateUser, async (req, res) => {
  await db.users.delete(req.params.userId);  // Any logged-in user can delete!
  return res.json({ success: true });
});

// ✅ SECURE: Check user role
app.delete('/api/users/:userId', authenticateUser, requireRole('admin'), async (req, res) => {
  await db.users.delete(req.params.userId);
  return res.json({ success: true });
});
```

**RBAC Implementation:**
```typescript
enum Role {
  User = 'user',
  Admin = 'admin',
  SuperAdmin = 'superadmin'
}

const permissions = {
  'user': ['read:own', 'update:own'],
  'admin': ['read:own', 'update:own', 'read:all', 'delete:own'],
  'superadmin': ['read:own', 'update:own', 'read:all', 'delete:own', 'delete:all', 'manage:users']
};

function requirePermission(permission: string) {
  return (req, res, next) => {
    const userRole = req.user.role;
    const userPermissions = permissions[userRole] || [];

    if (!userPermissions.includes(permission)) {
      return res.status(403).json({
        error: 'Insufficient permissions',
        required: permission,
        current: userPermissions
      });
    }

    next();
  };
}

// Usage
app.delete('/api/users/:id', authenticateUser, requirePermission('delete:all'), async (req, res) => {
  await db.users.delete(req.params.id);
  return res.json({ success: true });
});
```

### 3. Mass Assignment

**Problem:** Users can modify fields they shouldn't.

```typescript
// ❌ VULNERABLE: Accepts all fields
app.patch('/api/users/:id', async (req, res) => {
  await db.users.update(req.params.id, req.body);  // User can set isAdmin: true!
  return res.json({ success: true });
});

// ✅ SECURE: Whitelist allowed fields
const allowedFields = ['name', 'email', 'bio'];

app.patch('/api/users/:id', async (req, res) => {
  const updates = {};
  for (const field of allowedFields) {
    if (req.body[field] !== undefined) {
      updates[field] = req.body[field];
    }
  }

  await db.users.update(req.params.id, updates);
  return res.json({ success: true });
});
```

### 4. Excessive Data Exposure

**Problem:** API returns more data than needed.

```typescript
// ❌ VULNERABLE: Returns entire user object
app.get('/api/users/:id', async (req, res) => {
  const user = await db.users.findById(req.params.id);
  return res.json(user);  // Includes password hash, internal IDs, etc.
});

// ✅ SECURE: Return only necessary fields
app.get('/api/users/:id', async (req, res) => {
  const user = await db.users.findById(req.params.id);

  return res.json({
    id: user.id,
    name: user.name,
    email: user.email,
    avatar: user.avatar,
    createdAt: user.createdAt
  });
});

// Better: Use DTOs
class UserPublicDto {
  id: string;
  name: string;
  email: string;
  avatar: string;
  createdAt: Date;

  static fromEntity(user: User): UserPublicDto {
    return {
      id: user.id,
      name: user.name,
      email: user.email,
      avatar: user.avatar,
      createdAt: user.createdAt
    };
  }
}

app.get('/api/users/:id', async (req, res) => {
  const user = await db.users.findById(req.params.id);
  return res.json(UserPublicDto.fromEntity(user));
});
```

### 5. Rate Limiting

**Problem:** No protection against brute force or abuse.

```typescript
import rateLimit from 'express-rate-limit';

// Global rate limit
const globalLimiter = rateLimit({
  windowMs: 15 * 60 * 1000, // 15 minutes
  max: 100, // 100 requests per window
  message: 'Too many requests, please try again later.'
});

// Strict limit for auth endpoints
const authLimiter = rateLimit({
  windowMs: 15 * 60 * 1000,
  max: 5, // 5 attempts per 15 minutes
  skipSuccessfulRequests: true, // Don't count successful logins
  message: 'Too many login attempts, please try again later.'
});

app.use('/api/', globalLimiter);
app.post('/api/auth/login', authLimiter, loginHandler);
```

### 6. Security Headers

```typescript
import helmet from 'helmet';

app.use(helmet({
  contentSecurityPolicy: {
    directives: {
      defaultSrc: ["'self'"],
      scriptSrc: ["'self'", "'unsafe-inline'"],
      styleSrc: ["'self'", "'unsafe-inline'"],
      imgSrc: ["'self'", 'data:', 'https:'],
      connectSrc: ["'self'"],
      fontSrc: ["'self'"],
      objectSrc: ["'none'"],
      mediaSrc: ["'self'"],
      frameSrc: ["'none'"]
    }
  },
  hsts: {
    maxAge: 31536000,
    includeSubDomains: true,
    preload: true
  },
  referrerPolicy: { policy: 'no-referrer' },
  noSniff: true,
  xssFilter: true,
  hidePoweredBy: true
}));
```

### API Security Checklist

- [ ] BOLA: All object access checks ownership
- [ ] BFLA: Admin endpoints require admin role
- [ ] Mass assignment: Only whitelisted fields accepted
- [ ] Excessive data: DTOs filter sensitive fields
- [ ] Rate limiting: Enabled on all endpoints
- [ ] Authentication: Required on non-public endpoints
- [ ] Authorization: Role-based access control (RBAC)
- [ ] Input validation: All inputs validated (zod, joi)
- [ ] SQL injection: Parameterized queries only
- [ ] Security headers: helmet configured
- [ ] CORS: Restricted to known origins
- [ ] HTTPS: Enforced in production
- [ ] Logging: Security events logged (failed auth, access denials)

---

## Security Response Protocol

If security issue found:
1. STOP immediately
2. Use **security-reviewer** agent
3. Fix CRITICAL issues before continuing
4. Rotate any exposed secrets
5. Review entire codebase for similar issues
