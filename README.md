# My_Codex_Skill

Codex용 실전 스킬 저장소.

이 저장소는 "긴 전역 프롬프트 하나"로 모든 것을 해결하려는 방식 대신, 짧은 전역 규칙과 도메인별 스킬을 조합하는 운영 방식을 목표로 한다. 핵심은 에이전트의 추론 능력만 믿지 않고, 하네스와 워크플로우를 같이 설계하는 것이다.

## Why This Repository Exists

최근 에이전트 운영에서 중요한 변화는 모델 자체보다 하네스 설계가 결과 품질을 크게 좌우한다는 점이다. 특히 아래 문제가 반복된다.

- 전역 지침 파일이 너무 길어져 실제 작업 컨텍스트를 밀어냄
- 계획, 구현, 검증, 리뷰가 한 프롬프트 안에서 뒤섞임
- 스택별 검증 루틴이 없어 매번 같은 판단을 다시 하게 됨
- 보안, 타입, 테스트, 패키지 영향 범위 같은 고위험 검토가 누락됨

이 저장소는 위 문제를 다음 구조로 해결한다.

- 짧은 전역 `AGENTS.md` 또는 라우터형 규칙
- 목적별 스킬 분리
- 스택별 검증 프리셋
- 도메인별 고위험 작업 가드레일
- 점진적 로딩을 위한 reference 기반 구조

## Core Design Theory

### 1. Harness Engineering

좋은 코딩 에이전트는 단순히 좋은 모델이 아니다. 더 중요한 것은 모델이 어떤 규칙, 도구, 검증 루프 안에서 일하느냐다.

이 저장소는 다음 하네스 원칙을 따른다.

- 짧은 글로벌 규칙
- 작업 유형별로 분리된 스킬
- 구현보다 먼저 영향 범위 파악
- 가장 좁은 검증부터 실행
- 반복 실패 시 접근 변경
- 세부 지식은 references로 분리

### 2. Router-Style Global Prompt

전역 지침은 길고 상세할수록 항상 좋은 것이 아니다. 전역 규칙은 에이전트의 기본 행동만 통제하고, 세부 전략은 필요한 순간에만 스킬로 불러오는 편이 더 안정적이다.

이 저장소는 전역 규칙을 다음 수준으로 제한하는 철학을 따른다.

- 기본 행동 원칙
- 위험 작업에서 먼저 설명해야 하는 조건
- 검증과 보안의 최소 기준
- 어떤 상황에서 어떤 스킬을 우선 적용할지

### 3. Progressive Disclosure

모든 지식을 항상 프롬프트에 싣지 않는다.

- 메타데이터: 언제 스킬이 트리거되는지 설명
- `SKILL.md`: 핵심 워크플로우만 유지
- `references/`: 필요할 때만 읽는 상세 규칙

이렇게 해야 컨텍스트 낭비를 줄이고, 실제 작업 코드와 로그가 더 많이 들어갈 수 있다.

### 4. Verification-First Operations

좋은 에이전트 출력은 "그럴듯한 코드"가 아니라 "검증된 변경"이다.

그래서 이 저장소의 스킬은 공통적으로 다음을 강제한다.

- 가장 가까운 테스트 또는 재현 경로부터 확인
- 전체 빌드보다 좁은 범위 검증 우선
- 테스트 약화 금지
- 검증을 못 했으면 그 사실을 명시

## Key 2026 Trends Reflected Here

### Trend 1. Long `AGENTS.md` Files Are a Liability

최근 공개된 에이전트 운영 사례들은 하나의 거대한 전역 지침 파일보다, 짧은 라우터형 전역 규칙과 필요 시 로딩되는 세부 문서 구조가 더 낫다는 방향으로 수렴한다.

이 저장소는 그 방향을 그대로 반영했다.

### Trend 2. Skills Beat Monolithic Prompting

한 장짜리 "만능 프롬프트"보다, 작업 종류별 스킬이 더 재사용 가능하고 유지보수도 쉽다. 리뷰, 디버깅, 검증, 도메인 작업은 서로 다른 사고 흐름이 필요하다.

### Trend 3. Verification Is Part of the Prompt

현대 코딩 에이전트는 구현만 잘하면 끝나는 것이 아니라, 검증 루프까지 프롬프트 설계에 포함되어야 한다. 그래서 verifier 계열 스킬을 별도로 분리했다.

### Trend 4. Domain Guardrails Matter More Than Generic Advice

Supabase RLS, Next.js server/client boundary, FastAPI response contract, monorepo blast radius 같은 문제는 일반 코딩 규칙만으로 잘 안 잡힌다. 이런 도메인 특화 위험은 전용 스킬이 필요하다.

## Repository Structure

```text
My_Codex_Skill/
├── README.md
└── skills/
    ├── claude-workflow-bridge/
    ├── task-planner/
    ├── review-guard/
    ├── root-cause-debugger/
    ├── frontend-verifier/
    ├── python-verifier/
    ├── node-verifier/
    ├── go-verifier/
    ├── go-builder/
    ├── java-kotlin-builder/
    ├── nextjs-builder/
    ├── fastapi-builder/
    ├── monorepo-coordinator/
    └── supabase-guard/
```

## Included Skills

### Workflow Skills

- `claude-workflow-bridge`
  - Claude Code 스타일 운영 규칙을 Codex에서 가능한 형태로 번역
  - 긴 글로벌 프롬프트 대신 짧은 전역 규칙과 참조 문서 구조 제안
- `task-planner`
  - 작업을 3-7단계의 실행 가능한 구현 계획으로 분해
- `review-guard`
  - 요약보다 결함 식별을 우선하는 버그 중심 코드 리뷰
- `root-cause-debugger`
  - 증상과 원인을 분리하고, 최소 재현으로 근본 원인을 찾는 디버깅

### Verification Skills

- `frontend-verifier`
  - React, Next.js, Vite, TypeScript UI 변경 검증 순서 정리
- `python-verifier`
  - `pytest`, `ruff`, `mypy` 또는 `pyright` 중심 검증 루틴
- `node-verifier`
  - Node.js 또는 TypeScript 서버 프로젝트 검증 루틴
- `go-verifier`
  - Go 패키지 단위 `go test`, `go vet`, `go build` 검증 루틴

### Builder Skills

- `go-builder`
  - Go 패키지 설계, 에러 처리, context 전파, 동시성 리스크를 고려한 구현 가이드
- `java-kotlin-builder`
  - Java/Kotlin 백엔드의 계층 구조, null-safety, transaction 경계, Spring/Ktor 리스크 관리
- `nextjs-builder`
  - App Router, RSC, route handler, cache/revalidation, build 민감도까지 고려한 Next.js 작업
- `fastapi-builder`
  - router, dependency injection, Pydantic schema, auth contract를 고려한 FastAPI 작업

### Domain Coordination Skills

- `monorepo-coordinator`
  - 패키지 영향 범위와 검증 범위를 좁혀서 모노레포 작업 최적화
- `supabase-guard`
  - SQL migration, RLS, auth boundary, generated types 드리프트를 검토하는 Supabase 가드

## Recommended Global Setup

홈 디렉터리 또는 주요 작업 루트에 짧은 `AGENTS.md`를 두고, 아래 원칙만 유지하는 것을 권장한다.

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

이 저장소의 스킬은 이런 라우터형 전역 규칙 위에서 가장 잘 작동한다.

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

Codex system `skill-creator` 스킬의 `quick_validate.py`로 각 스킬 구조를 검증할 수 있다.

예시:

```bash
python3 ~/.codex/skills/.system/skill-creator/scripts/quick_validate.py ./skills/go-builder
python3 ~/.codex/skills/.system/skill-creator/scripts/quick_validate.py ./skills/java-kotlin-builder
```

`PyYAML`이 필요할 수 있다.

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

이 저장소의 스킬은 아래 원칙을 일관되게 따른다.

- 먼저 코드베이스와 실행 경로를 본다.
- 추상적 조언보다 파일 단위 행동을 우선한다.
- 검증 명령까지 포함해서 작업을 닫는다.
- 보안과 계약 변경은 별도 위험으로 본다.
- 같은 실패를 반복하면 접근을 바꾼다.
- 스킬은 짧게 유지하고, 상세 지식은 분리한다.

## Future Expansion

이 저장소는 다음 방향으로 계속 확장할 수 있다.

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

이 저장소는 위 흐름을 Codex에서 실용적으로 재구성한 컬렉션이다.
