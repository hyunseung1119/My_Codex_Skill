# My_Codex_Skill

Codex용 실전 스킬 저장소입니다.

이 저장소는 "긴 전역 프롬프트 하나"로 모든 것을 해결하려는 방식 대신, 짧은 전역 규칙과 도메인별 스킬을 조합하는 운영 방식을 목표로 하는 저장소입니다. 핵심은 에이전트의 추론 능력만 믿지 않고, 하네스와 워크플로우를 같이 설계하는 것입니다.

## Why This Repository Exists

최근 에이전트 운영에서 중요한 변화는 모델 자체보다 하네스 설계가 결과 품질을 크게 좌우한다는 점입니다. 특히 아래 문제가 반복됩니다.

- 전역 지침 파일이 너무 길어져 실제 작업 컨텍스트를 밀어냄
- 계획, 구현, 검증, 리뷰가 한 프롬프트 안에서 뒤섞임
- 스택별 검증 루틴이 없어 매번 같은 판단을 다시 하게 됨
- 보안, 타입, 테스트, 패키지 영향 범위 같은 고위험 검토가 누락됨

이 저장소는 위 문제를 다음 구조로 해결합니다.

- 짧은 전역 `AGENTS.md` 또는 라우터형 규칙
- 목적별 스킬 분리
- 스택별 검증 프리셋
- 도메인별 고위험 작업 가드레일
- 점진적 로딩을 위한 reference 기반 구조

## Core Design Theory

### 1. Harness Engineering

좋은 코딩 에이전트는 단순히 좋은 모델이 아닙니다. 더 중요한 것은 모델이 어떤 규칙, 도구, 검증 루프 안에서 일하느냐입니다.

이 저장소는 다음 하네스 원칙을 따릅니다.

- 짧은 글로벌 규칙
- 작업 유형별로 분리된 스킬
- 구현보다 먼저 영향 범위 파악
- 가장 좁은 검증부터 실행
- 반복 실패 시 접근 변경
- 세부 지식은 references로 분리

### 2. Router-Style Global Prompt

전역 지침은 길고 상세할수록 항상 좋은 것이 아닙니다. 전역 규칙은 에이전트의 기본 행동만 통제하고, 세부 전략은 필요한 순간에만 스킬로 불러오는 편이 더 안정적입니다.

이 저장소는 전역 규칙을 다음 수준으로 제한하는 철학을 따릅니다.

- 기본 행동 원칙
- 위험 작업에서 먼저 설명해야 하는 조건
- 검증과 보안의 최소 기준
- 어떤 상황에서 어떤 스킬을 우선 적용할지

### 3. Progressive Disclosure

모든 지식을 항상 프롬프트에 싣지 않습니다.

- 메타데이터: 언제 스킬이 트리거되는지 설명
- `SKILL.md`: 핵심 워크플로우만 유지
- `references/`: 필요할 때만 읽는 상세 규칙

이렇게 해야 컨텍스트 낭비를 줄이고, 실제 작업 코드와 로그가 더 많이 들어갈 수 있습니다.

### 4. Verification-First Operations

좋은 에이전트 출력은 "그럴듯한 코드"가 아니라 "검증된 변경"입니다.

그래서 이 저장소의 스킬은 공통적으로 다음을 강제합니다.

- 가장 가까운 테스트 또는 재현 경로부터 확인
- 전체 빌드보다 좁은 범위 검증 우선
- 테스트 약화 금지
- 검증을 못 했으면 그 사실을 명시

## Key 2026 Trends Reflected Here

### Trend 1. Long `AGENTS.md` Files Are a Liability

최근 공개된 에이전트 운영 사례들은 하나의 거대한 전역 지침 파일보다, 짧은 라우터형 전역 규칙과 필요 시 로딩되는 세부 문서 구조가 더 낫다는 방향으로 수렴하고 있습니다.

이 저장소는 그 방향을 그대로 반영했습니다.

### Trend 2. Skills Beat Monolithic Prompting

한 장짜리 "만능 프롬프트"보다, 작업 종류별 스킬이 더 재사용 가능하고 유지보수도 쉽습니다. 리뷰, 디버깅, 검증, 도메인 작업은 서로 다른 사고 흐름이 필요합니다.

### Trend 3. Verification Is Part of the Prompt

현대 코딩 에이전트는 구현만 잘하면 끝나는 것이 아니라, 검증 루프까지 프롬프트 설계에 포함되어야 합니다. 그래서 verifier 계열 스킬을 별도로 분리했습니다.

### Trend 4. Domain Guardrails Matter More Than Generic Advice

Supabase RLS, Next.js server/client boundary, FastAPI response contract, monorepo blast radius 같은 문제는 일반 코딩 규칙만으로 잘 잡히지 않습니다. 이런 도메인 특화 위험은 전용 스킬이 필요합니다.

## Repository Structure

```text
My_Codex_Skill/
├── README.md                           # 저장소 개요, 설치 방법, 운영 철학, 사용 예시를 담은 문서입니다.
├── .gitignore                          # macOS 및 Python 캐시 같은 불필요한 파일을 제외하는 설정입니다.
└── skills/                             # 실제로 Codex에 설치하거나 심볼릭 링크할 사용자 스킬 모음입니다.
    ├── claude-workflow-bridge/         # Claude Code 스타일 운영 방식을 Codex 식으로 번역하는 브리지 스킬입니다.
    │   ├── SKILL.md                    # 스킬의 트리거 조건과 핵심 워크플로우를 설명하는 본문입니다.
    │   ├── agents/
    │   │   └── openai.yaml             # UI 표시 이름, 짧은 설명, 기본 프롬프트를 담은 메타데이터입니다.
    │   └── references/
    │       ├── workflow.md             # 작업 순서와 운영 루프 기준을 설명하는 참조 문서입니다.
    │       ├── verification.md         # 검증 루프와 테스트 무결성 기준을 설명하는 문서입니다.
    │       ├── security.md             # 보안 점검 포인트와 우선순위를 설명하는 문서입니다.
    │       └── context.md              # 긴 세션에서 컨텍스트를 관리하는 원칙을 담은 문서입니다.
    ├── task-planner/                   # 복잡한 작업을 실행 가능한 단계로 분해하는 계획 스킬입니다.
    │   ├── SKILL.md                    # 구현 순서, 검증 단계, 리스크 분리 방법을 정의합니다.
    │   └── agents/openai.yaml          # 플래너 스킬의 UI 메타데이터입니다.
    ├── review-guard/                   # 결함 중심 리뷰를 수행하는 코드 리뷰 스킬입니다.
    │   ├── SKILL.md                    # 심각도, 영향 범위, 파일 근거 중심 리뷰 방식을 정의합니다.
    │   └── agents/openai.yaml          # 리뷰 스킬의 UI 메타데이터입니다.
    ├── root-cause-debugger/            # 증상과 원인을 분리해 디버깅하는 스킬입니다.
    │   ├── SKILL.md                    # 재현, 가설 검증, 최소 수정 원칙을 정의합니다.
    │   └── agents/openai.yaml          # 디버깅 스킬의 UI 메타데이터입니다.
    ├── frontend-verifier/              # React, Next.js, Vite 계열 프론트엔드 검증 스킬입니다.
    │   ├── SKILL.md                    # 프론트엔드 변경 후 어떤 순서로 검증할지 정의합니다.
    │   └── agents/openai.yaml          # 프론트엔드 검증 스킬 메타데이터입니다.
    ├── python-verifier/                # Python 프로젝트 검증 스킬입니다.
    │   ├── SKILL.md                    # pytest, ruff, mypy/pyright 우선순위를 정의합니다.
    │   └── agents/openai.yaml          # Python 검증 스킬 메타데이터입니다.
    ├── node-verifier/                  # Node.js 또는 TypeScript 서버 검증 스킬입니다.
    │   ├── SKILL.md                    # 테스트, 린트, 타입체크, 빌드 순서를 정의합니다.
    │   └── agents/openai.yaml          # Node 검증 스킬 메타데이터입니다.
    ├── go-verifier/                    # Go 패키지 단위 검증 스킬입니다.
    │   ├── SKILL.md                    # go test, go vet, go build의 실행 기준을 설명합니다.
    │   └── agents/openai.yaml          # Go 검증 스킬 메타데이터입니다.
    ├── go-builder/                     # Go 구현 작업용 스킬입니다.
    │   ├── SKILL.md                    # package 경계, error handling, concurrency 원칙을 정의합니다.
    │   └── agents/openai.yaml          # Go 빌더 스킬 메타데이터입니다.
    ├── java-kotlin-builder/            # Java/Kotlin 백엔드 구현용 스킬입니다.
    │   ├── SKILL.md                    # 계층 구조, null-safety, transaction 경계를 설명합니다.
    │   └── agents/openai.yaml          # JVM 빌더 스킬 메타데이터입니다.
    ├── nextjs-builder/                 # Next.js App Router와 RSC 작업용 스킬입니다.
    │   ├── SKILL.md                    # server/client boundary, cache, route 민감도를 설명합니다.
    │   └── agents/openai.yaml          # Next.js 빌더 스킬 메타데이터입니다.
    ├── fastapi-builder/                # FastAPI 엔드포인트와 스키마 작업용 스킬입니다.
    │   ├── SKILL.md                    # router, DI, auth contract, schema drift를 다룹니다.
    │   └── agents/openai.yaml          # FastAPI 빌더 스킬 메타데이터입니다.
    ├── monorepo-coordinator/           # 모노레포 영향 범위를 조정하는 스킬입니다.
    │   ├── SKILL.md                    # 변경 패키지와 종속 패키지 검증 범위를 결정합니다.
    │   └── agents/openai.yaml          # 모노레포 조정 스킬 메타데이터입니다.
    └── supabase-guard/                 # Supabase 마이그레이션, RLS, auth 경계를 검토하는 스킬입니다.
        ├── SKILL.md                    # schema, policy, generated types 리스크를 다룹니다.
        └── agents/openai.yaml          # Supabase 가드 스킬 메타데이터입니다.
```

## Full Codex Setup Structure

아래 트리는 이 저장소를 실제 Codex 전역 셋업에 반영했을 때의 전체 구조를 설명하는 예시입니다.

```text
~/
├── AGENTS.md                                      # 전역 Codex 라우터 규칙입니다. 길게 쓰지 않고 핵심 행동 원칙만 유지합니다.
└── .codex/
    ├── config.toml                                # Codex 모델, 프로젝트 신뢰 설정 등 기본 동작 설정입니다.
    ├── auth.json                                  # Codex 인증 정보가 저장되는 파일입니다.
    ├── history.jsonl                              # 세션 히스토리 로그입니다.
    ├── version.json                               # Codex 버전 정보입니다.
    ├── log/                                       # Codex 실행 로그 디렉터리입니다.
    ├── shell_snapshots/                           # 셸 상태 스냅샷 디렉터리입니다.
    └── skills/                                    # Codex가 인식하는 스킬 루트 디렉터리입니다.
        ├── .system/                               # Codex 기본 제공 시스템 스킬 디렉터리입니다.
        │   ├── skill-creator/                     # 새 스킬 작성과 검증을 돕는 시스템 스킬입니다.
        │   └── skill-installer/                   # 외부 스킬 설치를 돕는 시스템 스킬입니다.
        ├── claude-workflow-bridge/                # Claude 스타일 운영을 Codex로 옮기는 브리지 스킬입니다.
        ├── task-planner/                          # 계획 수립 전용 스킬입니다.
        ├── review-guard/                          # 리뷰 전용 스킬입니다.
        ├── root-cause-debugger/                   # 디버깅 전용 스킬입니다.
        ├── frontend-verifier/                     # 프론트엔드 검증 스킬입니다.
        ├── python-verifier/                       # Python 검증 스킬입니다.
        ├── node-verifier/                         # Node.js 검증 스킬입니다.
        ├── go-verifier/                           # Go 검증 스킬입니다.
        ├── go-builder/                            # Go 구현 스킬입니다.
        ├── java-kotlin-builder/                   # Java/Kotlin 구현 스킬입니다.
        ├── nextjs-builder/                        # Next.js 도메인 스킬입니다.
        ├── fastapi-builder/                       # FastAPI 도메인 스킬입니다.
        ├── monorepo-coordinator/                  # 모노레포 영향 범위 제어 스킬입니다.
        └── supabase-guard/                        # Supabase 보안/스키마 가드 스킬입니다.
```

## Included Skills

### Workflow Skills

- `claude-workflow-bridge`
  - Claude Code 스타일 운영 규칙을 Codex에서 가능한 형태로 번역하는 스킬입니다.
  - 긴 글로벌 프롬프트 대신 짧은 전역 규칙과 참조 문서 구조를 제안하는 역할입니다.
- `task-planner`
  - 작업을 3-7단계의 실행 가능한 구현 계획으로 분해하는 스킬입니다.
- `review-guard`
  - 요약보다 결함 식별을 우선하는 버그 중심 코드 리뷰 스킬입니다.
- `root-cause-debugger`
  - 증상과 원인을 분리하고, 최소 재현으로 근본 원인을 찾는 디버깅 스킬입니다.

### Verification Skills

- `frontend-verifier`
  - React, Next.js, Vite, TypeScript UI 변경 검증 순서를 정리한 스킬입니다.
- `python-verifier`
  - `pytest`, `ruff`, `mypy` 또는 `pyright` 중심 검증 루틴을 제공하는 스킬입니다.
- `node-verifier`
  - Node.js 또는 TypeScript 서버 프로젝트 검증 루틴을 제공하는 스킬입니다.
- `go-verifier`
  - Go 패키지 단위 `go test`, `go vet`, `go build` 검증 루틴을 제공하는 스킬입니다.

### Builder Skills

- `go-builder`
  - Go 패키지 설계, 에러 처리, context 전파, 동시성 리스크를 고려한 구현 가이드를 제공하는 스킬입니다.
- `java-kotlin-builder`
  - Java/Kotlin 백엔드의 계층 구조, null-safety, transaction 경계, Spring/Ktor 리스크를 관리하는 스킬입니다.
- `nextjs-builder`
  - App Router, RSC, route handler, cache/revalidation, build 민감도까지 고려한 Next.js 작업 스킬입니다.
- `fastapi-builder`
  - router, dependency injection, Pydantic schema, auth contract를 고려한 FastAPI 작업 스킬입니다.

### Domain Coordination Skills

- `monorepo-coordinator`
  - 패키지 영향 범위와 검증 범위를 좁혀서 모노레포 작업을 최적화하는 스킬입니다.
- `supabase-guard`
  - SQL migration, RLS, auth boundary, generated types 드리프트를 검토하는 Supabase 가드 스킬입니다.

## Recommended Global Setup

홈 디렉터리 또는 주요 작업 루트에 짧은 `AGENTS.md`를 두고, 아래 원칙만 유지하는 것을 권장합니다.

```md
# Global Codex Instructions

- 기본 태도: 짧게 파악하고 바로 실행한다.
- 작업 루프: Discover -> Plan -> Execute -> Verify -> Reflect
- 위험 작업은 먼저 설명한다.
- 검증은 가장 좁은 범위부터 실행한다.
- 테스트를 약화해서 통과시키지 않는다.
- 반복 실패 시 접근을 바꾼다.
- 세부 규칙은 스킬로 분리한다.
```

이 저장소의 스킬은 이런 라우터형 전역 규칙 위에서 가장 잘 작동합니다.

## Installation

### Option 1. Copy Into Codex Skills Directory

```bash
mkdir -p ~/.codex/skills
cp -R skills/* ~/.codex/skills/
```

### Option 2. Symlink During Local Development

```bash
mkdir -p ~/.codex/skills
for d in skills/*; do
  ln -sfn "$(pwd)/$d" "$HOME/.codex/skills/$(basename "$d")"
done
```

## Validation

Codex system `skill-creator` 스킬의 `quick_validate.py`로 각 스킬 구조를 검증할 수 있습니다.

예시:

```bash
python3 ~/.codex/skills/.system/skill-creator/scripts/quick_validate.py ./skills/go-builder
python3 ~/.codex/skills/.system/skill-creator/scripts/quick_validate.py ./skills/java-kotlin-builder
```

`PyYAML`이 필요할 수 있습니다.

```bash
python3 -m pip install --user PyYAML
```

## Usage Examples

### Planning

```text
Use $task-planner to break this migration into executable steps.
```

### Review

```text
Use $review-guard to review this diff for regressions and missing tests.
```

### Debugging

```text
Use $root-cause-debugger to isolate why this test flakes in CI.
```

### Next.js

```text
Use $nextjs-builder to update this route handler and validate server/client boundaries.
```

### FastAPI

```text
Use $fastapi-builder to add this endpoint and check schema/auth contract drift.
```

### Go

```text
Use $go-builder to refactor this service and then verify it with $go-verifier.
```

### Java/Kotlin

```text
Use $java-kotlin-builder to implement this service method and keep transaction boundaries explicit.
```

### Supabase

```text
Use $supabase-guard to review this migration and RLS policy change.
```

## Operational Principles Behind The Skills

이 저장소의 스킬은 아래 원칙을 일관되게 따릅니다.

- 먼저 코드베이스와 실행 경로를 본다.
- 추상적 조언보다 파일 단위 행동을 우선한다.
- 검증 명령까지 포함해서 작업을 닫는다.
- 보안과 계약 변경은 별도 위험으로 본다.
- 같은 실패를 반복하면 접근을 바꾼다.
- 스킬은 짧게 유지하고, 상세 지식은 분리한다.

## Future Expansion

이 저장소는 다음 방향으로 계속 확장할 수 있습니다.

- `spring-builder`
- `ktor-builder`
- `postgres-performance-review`
- `graphql-guard`
- `playwright-e2e-runner`
- `ai-agent-evaluator`

## References

- OpenAI, Harness engineering: leveraging Codex in an agent-first world
- Anthropic, Effective harnesses for long-running agents
- Anthropic Claude Code, Common workflows

이 저장소는 위 흐름을 Codex에서 실용적으로 재구성한 컬렉션입니다.
