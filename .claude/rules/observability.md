# Observability Guidelines (2026)

Comprehensive observability strategy for AI systems using OpenTelemetry and modern monitoring tools.

## Core Principles

1. **Instrument Everything**: Every LLM call, agent action, tool use
2. **Standardize on OpenTelemetry**: Use GenAI Semantic Conventions
3. **Three Pillars**: Logs, Metrics, Traces
4. **Actionable Alerts**: Alert on problems, not noise

---

## OpenTelemetry GenAI Semantic Conventions

### 2026 Standard

As of 2026, OpenTelemetry v1.37+ includes **GenAI Semantic Conventions** for LLM observability.

**Key Attributes:**
```typescript
{
  // Model information
  "gen_ai.request.model": "claude-sonnet-4-5",
  "gen_ai.provider.name": "anthropic",
  "gen_ai.operation.name": "chat",

  // Token usage
  "gen_ai.usage.input_tokens": 1500,
  "gen_ai.usage.output_tokens": 800,

  // Prompt and response (optional, be careful with PII)
  "gen_ai.prompt": "...",
  "gen_ai.completion": "...",

  // Tool use
  "gen_ai.tools": ["read_file", "write_code"],
  "gen_ai.tool_calls": 3
}
```

### Industry Adoption

- ✅ **Datadog LLM Observability**: Native support (v1.37+)
- ✅ **Langfuse**: OpenTelemetry integration
- ✅ **Grafana**: OTel Collector → Prometheus/Loki
- ✅ **VictoriaMetrics**: AI agent monitoring

---

## Implementation

### 1. Instrument LLM Calls

```typescript
// Auto-instrumentation (recommended)
import { OpenAIInstrumentor } from '@opentelemetry/instrumentation-openai';
import { AnthropicInstrumentor } from 'opentelemetry-instrumentation-anthropic';

// Initialize
OpenAIInstrumentor().instrument();
AnthropicInstrumentor().instrument();

// All API calls are now automatically traced
const response = await anthropic.messages.create({
  model: "claude-sonnet-4-5",
  messages: [{ role: "user", content: "Hello" }]
});
// → Automatically creates span with gen_ai.* attributes
```

```python
# Python: Auto-instrumentation
from opentelemetry.instrumentation.openai import OpenAIInstrumentor
from opentelemetry.instrumentation.anthropic import AnthropicInstrumentor

OpenAIInstrumentor().instrument()
AnthropicInstrumentor().instrument()

# All API calls are traced
response = client.messages.create(
    model="claude-sonnet-4-5",
    messages=[{"role": "user", "content": "Hello"}]
)
```

### 2. Manual Instrumentation

```typescript
import { trace } from '@opentelemetry/api';

const tracer = trace.getTracer('my-ai-app');

async function generateResponse(query: string): Promise<string> {
  return tracer.startActiveSpan('generate_response', async (span) => {
    try {
      // Set attributes
      span.setAttribute('gen_ai.operation.name', 'chat');
      span.setAttribute('gen_ai.request.model', 'claude-sonnet-4-5');
      span.setAttribute('app.query', query);

      const response = await anthropic.messages.create({
        model: "claude-sonnet-4-5",
        messages: [{ role: "user", content: query }]
      });

      // Record token usage
      span.setAttribute('gen_ai.usage.input_tokens', response.usage.input_tokens);
      span.setAttribute('gen_ai.usage.output_tokens', response.usage.output_tokens);
      span.setAttribute('gen_ai.usage.total_tokens', response.usage.input_tokens + response.usage.output_tokens);

      // Record cost (optional)
      const cost = calculateCost(response.usage, 'claude-sonnet-4-5');
      span.setAttribute('app.cost_usd', cost);

      span.setStatus({ code: SpanStatusCode.OK });
      return response.content[0].text;

    } catch (error) {
      span.recordException(error);
      span.setStatus({ code: SpanStatusCode.ERROR, message: error.message });
      throw error;

    } finally {
      span.end();
    }
  });
}
```

### 3. Agent Workflow Tracing

```python
from opentelemetry import trace

tracer = trace.get_tracer(__name__)

def run_agent_workflow(task: str):
    with tracer.start_as_current_span("agent_workflow") as workflow_span:
        workflow_span.set_attribute("task", task)

        # Step 1: Plan
        with tracer.start_as_current_span("agent.plan") as plan_span:
            plan = planner_agent.run(task)
            plan_span.set_attribute("plan_steps", len(plan.steps))

        # Step 2: Execute (parallel)
        with tracer.start_as_current_span("agent.execute") as exec_span:
            results = []
            for step in plan.steps:
                with tracer.start_as_current_span(f"agent.step.{step.id}") as step_span:
                    step_span.set_attribute("step.type", step.type)
                    step_span.set_attribute("step.tools", step.tools)

                    result = executor_agent.run(step)
                    results.append(result)

                    step_span.set_attribute("step.success", result.success)
                    step_span.set_attribute("gen_ai.usage.total_tokens", result.tokens)

        # Step 3: Synthesize
        with tracer.start_as_current_span("agent.synthesize") as synth_span:
            final = synthesizer_agent.run(results)
            synth_span.set_attribute("output_length", len(final))

        # Record total metrics
        total_tokens = sum(r.tokens for r in results)
        workflow_span.set_attribute("total_tokens", total_tokens)
        workflow_span.set_attribute("total_cost_usd", calculate_cost(total_tokens))

        return final
```

---

## Metrics

### Key Metrics to Track

| Metric | Description | Alert Threshold |
|--------|-------------|-----------------|
| **Latency** | Time per LLM call | p95 > 5s |
| **Token Usage** | Input/output tokens per request | Sudden 2x spike |
| **Cost** | USD per request | Daily budget exceeded |
| **Error Rate** | % of failed requests | > 5% |
| **Cache Hit Rate** | % of cached responses | < 80% (if caching) |
| **Agent Success Rate** | % of successful agent workflows | < 90% |

### Prometheus Metrics

```typescript
import { Counter, Histogram, Gauge } from 'prom-client';

// Request counter
const llmRequests = new Counter({
  name: 'llm_requests_total',
  help: 'Total LLM API requests',
  labelNames: ['model', 'operation', 'status']
});

// Token usage histogram
const tokenUsage = new Histogram({
  name: 'llm_tokens_used',
  help: 'Tokens used per request',
  labelNames: ['model', 'type'],  // type: input|output
  buckets: [100, 500, 1000, 5000, 10000, 50000]
});

// Cost gauge
const costGauge = new Gauge({
  name: 'llm_cost_usd_total',
  help: 'Total LLM cost in USD',
  labelNames: ['model']
});

// Latency histogram
const latency = new Histogram({
  name: 'llm_latency_seconds',
  help: 'LLM API latency',
  labelNames: ['model', 'operation'],
  buckets: [0.1, 0.5, 1, 2, 5, 10]
});

// Usage
async function callLLM(model: string, messages: any[]) {
  const start = Date.now();

  try {
    const response = await anthropic.messages.create({ model, messages });

    // Record metrics
    llmRequests.inc({ model, operation: 'chat', status: 'success' });
    tokenUsage.observe({ model, type: 'input' }, response.usage.input_tokens);
    tokenUsage.observe({ model, type: 'output' }, response.usage.output_tokens);

    const cost = calculateCost(response.usage, model);
    costGauge.inc({ model }, cost);

    const duration = (Date.now() - start) / 1000;
    latency.observe({ model, operation: 'chat' }, duration);

    return response;

  } catch (error) {
    llmRequests.inc({ model, operation: 'chat', status: 'error' });
    throw error;
  }
}
```

---

## Logging

### Structured Logging

```typescript
import winston from 'winston';

const logger = winston.createLogger({
  level: 'info',
  format: winston.format.combine(
    winston.format.timestamp(),
    winston.format.json()
  ),
  transports: [
    new winston.transports.File({ filename: 'app.log' })
  ]
});

// Log LLM calls
logger.info('LLM request', {
  model: 'claude-sonnet-4-5',
  operation: 'chat',
  input_tokens: 1500,
  output_tokens: 800,
  latency_ms: 2300,
  cost_usd: 0.0135,
  trace_id: span.spanContext().traceId  // Link to trace
});

// Log agent decisions
logger.info('Agent decision', {
  agent: 'planner',
  task: 'implement authentication',
  decision: 'use JWT',
  confidence: 0.95,
  reasoning: '...',
  trace_id: span.spanContext().traceId
});

// Log errors with context
logger.error('LLM call failed', {
  model: 'claude-sonnet-4-5',
  error: error.message,
  stack: error.stack,
  retry_attempt: 3,
  trace_id: span.spanContext().traceId
});
```

### Log Levels

| Level | Use Case | Examples |
|-------|----------|----------|
| **DEBUG** | Development, detailed tracing | Prompt/response content, tool calls |
| **INFO** | Normal operations | LLM requests, agent decisions |
| **WARN** | Degraded performance | High latency, retry attempts |
| **ERROR** | Failures | API errors, agent failures |

---

## Monitoring Platforms

### 1. Datadog LLM Observability

```typescript
import { datadogLLMIntegration } from '@datadog/llm-observability';

datadogLLMIntegration.init({
  apiKey: process.env.DD_API_KEY,
  service: 'my-ai-app',
  env: 'production',

  // Auto-capture prompts/responses (be careful with PII)
  capturePrompts: false,
  captureResponses: false,

  // Custom tags
  tags: {
    team: 'ai-team',
    version: '2.0'
  }
});

// Datadog automatically maps:
// - gen_ai.request.model → llm.model
// - gen_ai.usage.input_tokens → llm.input_tokens
// - gen_ai.provider.name → llm.provider
```

**Features:**
- Out-of-the-box LLM dashboards
- Token usage analytics
- Cost tracking
- Prompt/response visualization (opt-in)

### 2. Langfuse (Open Source)

```python
from langfuse import Langfuse

langfuse = Langfuse(
    public_key=os.environ["LANGFUSE_PUBLIC_KEY"],
    secret_key=os.environ["LANGFUSE_SECRET_KEY"],
    host=os.environ["LANGFUSE_HOST"]
)

# Manual tracking
trace = langfuse.trace(
    name="agent_workflow",
    user_id="user_123",
    metadata={"task": "implement auth"}
)

generation = trace.generation(
    name="planner_step",
    model="claude-sonnet-4-5",
    input="Plan authentication system",
    output="Step 1: Choose JWT...",
    usage={
        "input_tokens": 150,
        "output_tokens": 400
    }
)

# OpenTelemetry integration (2026)
from langfuse.opentelemetry import LangfuseSpanProcessor

span_processor = LangfuseSpanProcessor()
# Add to OTel TracerProvider
```

**Features:**
- Trace visualization (tree view)
- Prompt management
- Evaluation runs
- User feedback tracking

### 3. Grafana + Prometheus

```yaml
# docker-compose.yml
version: '3.8'

services:
  # OpenTelemetry Collector
  otel-collector:
    image: otel/opentelemetry-collector-contrib:latest
    volumes:
      - ./otel-config.yaml:/etc/otel-config.yaml
    command: ["--config=/etc/otel-config.yaml"]
    ports:
      - "4317:4317"   # OTLP gRPC
      - "4318:4318"   # OTLP HTTP

  # Prometheus
  prometheus:
    image: prom/prometheus:latest
    volumes:
      - ./prometheus.yml:/etc/prometheus/prometheus.yml
    ports:
      - "9090:9090"

  # Grafana
  grafana:
    image: grafana/grafana:latest
    ports:
      - "3000:3000"
    environment:
      - GF_SECURITY_ADMIN_PASSWORD=admin
```

```yaml
# otel-config.yaml
receivers:
  otlp:
    protocols:
      grpc:
      http:

processors:
  batch:

exporters:
  prometheus:
    endpoint: "prometheus:9090"
  logging:
    loglevel: debug

service:
  pipelines:
    traces:
      receivers: [otlp]
      processors: [batch]
      exporters: [logging]
    metrics:
      receivers: [otlp]
      processors: [batch]
      exporters: [prometheus]
```

---

## Alerting

### Alert Rules (Prometheus)

```yaml
# alerts.yml
groups:
  - name: llm_alerts
    interval: 30s
    rules:
      # High latency
      - alert: LLMHighLatency
        expr: histogram_quantile(0.95, llm_latency_seconds_bucket) > 5
        for: 5m
        labels:
          severity: warning
        annotations:
          summary: "LLM latency high (p95 > 5s)"
          description: "Model {{ $labels.model }} p95 latency: {{ $value }}s"

      # Error rate
      - alert: LLMHighErrorRate
        expr: rate(llm_requests_total{status="error"}[5m]) / rate(llm_requests_total[5m]) > 0.05
        for: 2m
        labels:
          severity: critical
        annotations:
          summary: "LLM error rate > 5%"
          description: "Model {{ $labels.model }}: {{ $value | humanizePercentage }}"

      # Cost spike
      - alert: LLMCostSpike
        expr: rate(llm_cost_usd_total[1h]) > 10
        for: 15m
        labels:
          severity: warning
        annotations:
          summary: "LLM cost spike (>$10/hour)"
          description: "Current rate: ${{ $value }}/hour"

      # Token usage spike
      - alert: LLMTokenSpike
        expr: rate(llm_tokens_used_sum[5m]) > on() group_left() (avg_over_time(llm_tokens_used_sum[1h]) * 2)
        for: 10m
        labels:
          severity: warning
        annotations:
          summary: "Token usage 2x higher than average"
```

### Slack Notifications

```typescript
import { WebClient } from '@slack/web-api';

const slack = new WebClient(process.env.SLACK_TOKEN);

async function sendAlert(alert: Alert) {
  await slack.chat.postMessage({
    channel: '#ai-alerts',
    text: `🚨 ${alert.title}`,
    blocks: [
      {
        type: 'header',
        text: { type: 'plain_text', text: `🚨 ${alert.title}` }
      },
      {
        type: 'section',
        fields: [
          { type: 'mrkdwn', text: `*Model:*\n${alert.model}` },
          { type: 'mrkdwn', text: `*Severity:*\n${alert.severity}` },
          { type: 'mrkdwn', text: `*Metric:*\n${alert.metric}` },
          { type: 'mrkdwn', text: `*Value:*\n${alert.value}` }
        ]
      },
      {
        type: 'section',
        text: { type: 'mrkdwn', text: alert.description }
      },
      {
        type: 'actions',
        elements: [
          {
            type: 'button',
            text: { type: 'plain_text', text: 'View Dashboard' },
            url: alert.dashboardUrl
          },
          {
            type: 'button',
            text: { type: 'plain_text', text: 'View Trace' },
            url: alert.traceUrl
          }
        ]
      }
    ]
  });
}
```

---

## Dashboards

### Key Visualizations

1. **LLM Request Rate** (line chart)
   - Requests per second, by model

2. **Token Usage** (stacked area chart)
   - Input tokens vs output tokens over time

3. **Cost** (line chart + total)
   - Cost per hour, cumulative daily cost

4. **Latency Distribution** (heatmap)
   - p50, p95, p99 latencies

5. **Error Rate** (line chart)
   - % of failed requests

6. **Agent Success Rate** (gauge)
   - % of successful agent workflows

7. **Cache Hit Rate** (gauge)
   - % of cached responses (if applicable)

8. **Top Expensive Queries** (table)
   - Queries sorted by token usage/cost

### Grafana Dashboard JSON

```json
{
  "dashboard": {
    "title": "LLM Observability",
    "panels": [
      {
        "title": "Request Rate",
        "targets": [
          {
            "expr": "rate(llm_requests_total[5m])",
            "legendFormat": "{{model}}"
          }
        ],
        "type": "graph"
      },
      {
        "title": "Token Usage",
        "targets": [
          {
            "expr": "rate(llm_tokens_used_sum{type=\"input\"}[5m])",
            "legendFormat": "Input"
          },
          {
            "expr": "rate(llm_tokens_used_sum{type=\"output\"}[5m])",
            "legendFormat": "Output"
          }
        ],
        "type": "graph",
        "stack": true
      },
      {
        "title": "Cost (Hourly)",
        "targets": [
          {
            "expr": "rate(llm_cost_usd_total[1h])",
            "legendFormat": "{{model}}"
          }
        ],
        "type": "graph"
      },
      {
        "title": "p95 Latency",
        "targets": [
          {
            "expr": "histogram_quantile(0.95, rate(llm_latency_seconds_bucket[5m]))",
            "legendFormat": "{{model}}"
          }
        ],
        "type": "graph"
      }
    ]
  }
}
```

---

## Best Practices

### 1. PII and Security

```typescript
// ❌ DON'T: Log sensitive prompts
span.setAttribute('gen_ai.prompt', prompt);  // May contain user data

// ✅ DO: Hash or omit
span.setAttribute('gen_ai.prompt_hash', hashPrompt(prompt));
span.setAttribute('gen_ai.prompt_length', prompt.length);
```

### 2. Sampling

```typescript
// High-traffic: Sample traces
import { TraceIdRatioBasedSampler } from '@opentelemetry/sdk-trace-base';

const sampler = new TraceIdRatioBasedSampler(0.1);  // Sample 10%

// Low-traffic or critical flows: Sample 100%
```

### 3. Cost Attribution

```typescript
// Tag with user/team for cost allocation
span.setAttribute('app.user_id', userId);
span.setAttribute('app.team', team);
span.setAttribute('app.feature', 'chatbot');

// Query cost by team:
// sum by (team) (llm_cost_usd_total)
```

### 4. Context Propagation

```typescript
// Propagate trace context across services
import { propagation } from '@opentelemetry/api';

// Service A
const headers = {};
propagation.inject(context.active(), headers);

// HTTP request to Service B
await fetch('http://service-b/api', {
  headers: {
    ...headers,  // Includes traceparent header
    'Content-Type': 'application/json'
  }
});

// Service B: Extract context
const context = propagation.extract(context.active(), request.headers);
// Continue trace
```

---

## Checklist

Before deploying AI systems to production:

- [ ] OpenTelemetry instrumentation added (auto or manual)
- [ ] GenAI Semantic Conventions used
- [ ] Logs are structured (JSON)
- [ ] Metrics exported (Prometheus/Datadog)
- [ ] Traces sent to backend (Jaeger/Datadog/Langfuse)
- [ ] Dashboards created (latency, cost, errors)
- [ ] Alerts configured (error rate, cost spike)
- [ ] PII scrubbed from logs/traces
- [ ] Cost attribution by user/team
- [ ] Sampling configured for high traffic

---

## Resources

### 2026 Tools

| Tool | Purpose | Best For |
|------|---------|----------|
| **Datadog LLM Observability** | All-in-one platform | Enterprises, easy setup |
| **Langfuse** | Open-source LLM platform | Startups, self-hosted |
| **Grafana + Prometheus** | Custom dashboards | DevOps teams, Kubernetes |
| **OpenLIT** | Open-source SDK | Python/JS apps |
| **VictoriaMetrics** | Time-series DB | High cardinality metrics |

### References

- [OpenTelemetry GenAI Semantic Conventions](https://opentelemetry.io/blog/2024/llm-observability/)
- [Datadog LLM Observability](https://www.datadoghq.com/blog/llm-otel-semantic-convention/)
- [Langfuse OpenTelemetry Integration](https://langfuse.com/integrations/native/opentelemetry)
- [OpenLIT SDK](https://github.com/openlit/openlit)
