# Hooks System

## Hook Types

- **SessionStart**: On session start (environment context, progress loading, regression gate)
- **UserPromptSubmit**: On user message (environment context injection)
- **PreToolUse**: Before tool execution (validation, parameter modification, blocking)
- **PostToolUse**: After tool execution (auto-format, type checks, warnings, loop detection, tracing)
- **PostToolUseFailure**: After tool failure (root cause analysis, failure tracking)
- **PostCompact**: After context compression (checkpoint saving)
- **Stop**: When session ends (DoD check, progress tracking, verification, learning)

## Execution Model

Hooks within the same event run **sequentially** in the order listed. Each hook receives the same input and can output JSON to influence Claude's behavior.

| Output Format | When Used | Effect |
|---------------|-----------|--------|
| `{"decision":"block","reason":"..."}` | PreToolUse, Stop | Blocks the action |
| `{"decision":"approve","reason":"..."}` | Any event | Approves with context injected |
| `{"hookSpecificOutput":{...}}` | UserPromptSubmit only | Injects context into conversation |
| Plain text stdout | SessionStart only | Directly injected into context |
| No output (exit 0) | Any event | Silent pass-through |

**Important:** If any hook in a chain outputs `"decision":"block"`, the action is blocked regardless of other hooks.

## Provided Hook Scripts (`hooks/` directory) — 21 total

### SessionStart (3)
| Script | Purpose |
|--------|---------|
| `env-context-injector.sh` | Git/프로젝트/런타임 환경 정보 자동 주입 (1회, session-specific lock) |
| `progress-loader.sh` | 이전 세션의 claude-progress.txt 상태 로드 (경과 시간 표시) |
| `regression-gate.sh` | 이전 세션 실패 테스트 회귀 검사 (smoke test, 24h TTL) |

### UserPromptSubmit (1)
| Script | Matcher | Purpose |
|--------|---------|---------|
| `env-context-injector.sh` | (all) | 세션 시작 시 Git/프로젝트/런타임 환경 정보 자동 주입 (1회, session-specific lock) |

### PreToolUse (4)
| Script | Matcher | Purpose |
|--------|---------|---------|
| `dangerous-command-blocker.sh` | Bash | `rm -rf`, `git push --force`, `git reset --hard`, `git clean -f`, `DROP TABLE` 차단 |
| `pre-commit-security.sh` | Bash(git commit*) | 커밋 전 staged diff에서 시크릿/credential 검사 |
| `code-quality-gate.sh` | Bash(git commit*) | 커밋 전 merge conflict marker, TODO/FIXME, 디버그 로그, 대용량 변경 검사 |
| `test-coverage-gate.sh` | Bash(git commit*) | 커밋 전 테스트 커버리지 80% 미만 시 차단 (Python/Node/Go, 10분 캐시) |
| `secret-detector.sh` | Edit, Write | 14개 provider 패턴 감지 (AWS, OpenAI, Anthropic, Slack, GitHub, GitLab, Google, Stripe, Shopify, SendGrid 등) |

### PostToolUse (8)
| Script | Matcher | Purpose | Order |
|--------|---------|---------|-------|
| `dependency-audit.sh` | Bash | npm/pip/cargo/go 패키지 설치 시 URL 설치, 위험 플래그, typosquatting 검사 | 1st (Bash) |
| `console-log-warning.sh` | Edit, Write | JS/TS console.log/debug/info/warn/error/trace 경고 | 1st |
| `prettier-format.sh` | Edit, Write | JS/TS/CSS/JSON Prettier 자동 포맷 | 2nd |
| `tsc-check.sh` | Edit, Write | TypeScript 증분 타입 체크 (head -10) | 3rd |
| `ruff-format.sh` | Edit, Write | Python ruff check --fix + format (pyproject.toml 감지) | 4th |
| `loop-detector.sh` | Edit, Write | 같은 파일 4회+ 편집 시 doom loop 경고 (session-specific) | 5th |
| `trace-logger.sh` | (all) | 모든 도구 호출을 `~/.codex/traces/` JSONL로 기록 (7일 보관) | 6th |
| `learning-indexer.sh` | Bash | `/learn` 실행 후 학습 패턴 자동 인덱싱 → 크로스세션 검색 지원 | 7th |
| `verification-loop.sh` | Edit, Write | 코드 변경 후 관련 테스트 자동 실행 → 실패 시 피드백 주입 (Spotify Honk 패턴) | 8th |
| `observability-metrics.sh` | Edit, Write | 도구 호출 메트릭 수집 → `~/.codex/traces/metrics.jsonl` (5MB 로테이션, 7일 보관) | 9th |

### PostToolUseFailure (1)
| Script | Matcher | Purpose |
|--------|---------|---------|
| `failure-explainer.sh` | Bash | 에러 분류 + WHY 3단계 추적 + 반복 실패 에스컬레이션 (3회+) |

### PostCompact (1)
| Script | Purpose |
|--------|---------|
| `compact-checkpoint.sh` | 컨텍스트 압축 시 progress 파일에 체크포인트 추가 |

### Stop (4)
| Script | Purpose |
|--------|---------|
| `dod-checker.sh` | 미커밋 변경, .env 추적 여부 등 완료 조건 검증 |
| `progress-tracker.sh` | git 상태 + 언어별 요약 + DoD + 테스트 결과를 claude-progress.txt에 기록 |
| `pre-completion-check.sh` | 코드 변경 감지 시 테스트 실행 여부 검증 (Python/JS/TS/Go) + regression-gate 연동 |
| `session-learning.sh` | 세션 학습 요약 리마인더 |

## Harness Engineering Middleware Pipeline

```
Session Start
  → EnvironmentBootstrap       (env-context-injector.sh — SessionStart)
  → ProgressRehydration        (progress-loader.sh — SessionStart)
  → RegressionGate             (regression-gate.sh — SessionStart)

Agent Request
  → LocalContextMiddleware     (env-context-injector.sh — UserPromptSubmit)
  → Safety Guard              (dangerous-command-blocker.sh + secret-detector.sh — PreToolUse)
  → CommitGuard               (pre-commit-security.sh + code-quality-gate.sh — PreToolUse)
  → [Tool Execution]
  → SupplyChainGuard          (dependency-audit.sh — PostToolUse/Bash)
  → Quality Gate              (console-log, prettier, tsc, ruff — PostToolUse)
  → LoopDetectionMiddleware    (loop-detector.sh — PostToolUse)
  → ExecutionTracing           (trace-logger.sh — PostToolUse)
  → FailureAnalysis           (failure-explainer.sh — PostToolUseFailure)

Context Compression
  → CompactionCheckpoint       (compact-checkpoint.sh — PostCompact)

Session End
  → DoD Verification          (dod-checker.sh — Stop)
  → ProgressPersistence        (progress-tracker.sh — Stop)
  → PreCompletionChecklist     (pre-completion-check.sh — Stop)
  → SessionLearning            (session-learning.sh — Stop)
```

## Session Isolation

모든 lock 파일은 session-specific (`CLAUDE_SESSION_ID` 또는 `$$` 기반):
- 멀티 세션 동시 실행 시 각 세션이 독립적으로 동작
- `env-context-injector`: 세션당 1회만 주입
- `loop-detector`: 세션별 편집 카운트 독립 추적
- `pre-completion-check`, `session-learning`, `regression-gate`: 세션별 lock

## Auto-Accept Permissions

Use with caution:
- Enable for trusted, well-defined plans
- Disable for exploratory work
- Never use dangerously-skip-permissions flag
- Configure `allowedTools` in settings instead

