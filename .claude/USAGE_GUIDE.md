# Claude Code 사용 가이드 (2026 업데이트)

## 시작하기

### 🆕 2026 신규 명령어

#### 멀티 에이전트 오케스트레이션 (`/multi-agent`)

복잡한 작업을 여러 에이전트가 협력하여 처리:

```bash
# 전체 기능 구현 (계획 → 코드 → 테스트 → 리뷰 → 문서)
/multi-agent "사용자 인증 시스템 구현"

# → coordinator가 자동으로 여러 에이전트 조율:
#    1. planner: 구현 계획
#    2. tdd-guide: 테스트 작성
#    3. security-reviewer: 보안 검증
#    4. code-reviewer: 코드 리뷰
#    5. doc-updater: 문서 업데이트
```

#### 토큰 사용량 분석 (`/token-analysis`)

토큰 사용을 최적화:

```bash
# 현재 세션 토큰 분석
/token-analysis

# 출력:
# - 도구별 토큰 사용량
# - 비효율적인 패턴 감지
# - 최적화 제안 (Haiku 사용 권장 등)
```

#### Rust 워크플로우 (`/rust`)

Rust 프로젝트 전용:

```bash
# rust-expert 에이전트 활성화
/rust "소유권 문제 해결 및 코드 리뷰"

# 자동으로:
# - 소유권/수명 검사
# - Unsafe 코드 리뷰
# - Clippy 경고 해결
# - 성능 최적화
```

#### AI 연구 통합 (`/ai-research`)

최신 AI 기법 탐색:

```bash
# 논문 검색 및 적용
/ai-research "RAG retrieval 정확도 개선 방법"

# 출력:
# - 관련 논문 3개 (평가 점수 포함)
# - POC 구현 코드
# - 벤치마크 전략
# - ADR (Architecture Decision Record)
```

#### 개발 일지 (`/dev-journal`)

자동 개발 일지 생성:

```bash
# 오늘 일지
/dev-journal --daily

# 주간 요약
/dev-journal --weekly

# ADR 작성
/dev-journal --adr "JWT 인증 채택"

# 문제 해결 로그
/dev-journal --problem "Cache race condition"
```

#### 프론트엔드 코드맵 (`/frontend-codemap`)

UI와 코드를 매핑하여 직관적인 수정 가능:

```bash
# 전체 프론트엔드 분석
/frontend-codemap

# 출력: docs/frontend/COMPONENT_MAP.md
# ┌─────────────────────────────────┐
# │ UserProfilePage                 │
# │  ┌────────────────────────────┐│
# │  │ ProfileHeader              ││
# │  │  - Avatar (line 20)        ││
# │  │  - Name (line 25)          ││
# │  │  - Email (line 30) ← 여기! ││
# │  └────────────────────────────┘│
# └─────────────────────────────────┘

# 이제 스크린샷 없이 바로 요청:
"ProfileHeader의 이메일 표시(line 30) 색상 회색으로"
# → 즉시 이해하고 수정!

# 특정 페이지만
/frontend-codemap src/pages/UserProfile.tsx

# 컴포넌트 트리만
/frontend-codemap --tree
```

**효과:**
- ❌ Before: 스크린샷 → "여기 고쳐줘" → "어느 파일?" → "잠깐..."
- ✅ After: "ProfileForm의 Save 버튼(line 80) 오른쪽 정렬" → 즉시 수정!

---

### Skills 사용법

프로젝트에 맞는 전문 명령어를 사용하세요:

#### 백엔드 개발 (`/backend-api`)

```bash
# 새 엔드포인트 추가
/backend-api Add a POST /api/v1/evaluate endpoint for result evaluation

# 기존 엔드포인트 수정
/backend-api Update the /api/v1/process-excel endpoint to support batch processing

# 테스트 작성
/backend-api Write tests for the multi_excel routes
```

#### 프론트엔드 개발 (`/react-component`)

```bash
# 새 컴포넌트 생성
/react-component Create a ResultsTable component with sorting and filtering

# 컴포넌트 수정
/react-component Update ExcelResultCardList to show loading states

# 스타일링
/react-component Add responsive design to the ChatV1V6Tab component
```

#### AI/ML 개발 (`/ml-training`)

```bash
# RAG 시스템 평가
/ml-training Evaluate the current RAG system and generate performance report

# 모델 최적화
/ml-training Optimize the prompt templates to reduce token usage

# 데이터 인덱싱
/ml-training Index the new legal documents into the RAG system
```

#### 코드 리팩토링 (`/clean-code`)

```bash
# 클린코드 리팩토링
/clean-code Review and refactor src/multi_excel/agents/synthesizer.py

# 계층 구조 개선
/clean-code Restructure backend/routes/ to follow clean architecture

# 함수 분리
/clean-code Split the long process() function into smaller functions

# 프롬프트 분리
/clean-code Extract hardcoded prompts into separate template files
```

### Agents 사용법

특화된 에이전트에게 작업을 위임하세요:

#### 코드 리뷰 (`code-reviewer`)

```bash
# 특정 파일 리뷰
Use the code-reviewer agent to review src/multi_excel/agents/synthesizer.py

# PR 전체 리뷰
Use the code-reviewer agent to review all changes in the current branch

# 보안 검토
Use the code-reviewer agent to check for security vulnerabilities in backend/routes/
```

#### 디버깅 (`debugger`)

```bash
# 테스트 실패 수정
Use the debugger agent to fix the failing test in tests/test_og_rag_api.py

# 런타임 에러 해결
Use the debugger agent to investigate the "token limit exceeded" error

# 버그 재현
Use the debugger agent to reproduce the issue described in GitHub issue #123
```

#### 성능 최적화 (`performance-optimizer`)

```bash
# API 성능 개선
Use the performance-optimizer agent to analyze and improve API response times

# 토큰 효율성
Use the performance-optimizer agent to reduce token usage in RAG system

# 프론트엔드 최적화
Use the performance-optimizer agent to optimize bundle size and rendering performance
```

## 일반적인 워크플로우

### 🆕 1. 새 기능 개발 (2026 - Multi-Agent)

```bash
# 간단한 방법: Coordinator에게 전체 위임
/multi-agent "결제 시스템 구현"

# Coordinator가 자동으로:
# 1. planner → 구현 계획 (5개 단계, 15개 파일 식별)
# 2. tdd-guide → 테스트 작성 (RED 상태 확인)
# 3. 병렬 실행:
#    - backend-api skill: API 엔드포인트 구현
#    - react-component skill: UI 컴포넌트 구현
# 4. build-error-resolver → 빌드 에러 해결 (발생 시)
# 5. 병렬 리뷰:
#    - code-reviewer: 코드 품질
#    - security-reviewer: 보안 검증
# 6. tdd-guide → 테스트 통과 확인 (GREEN)
# 7. doc-updater → API 문서 업데이트
# 8. /dev-journal → 일지 기록
```

**수동 제어 (필요시):**

```bash
# 1단계: 계획 수립
/plan "결제 시스템 구현"

# 2단계: TDD 워크플로우
/tdd  # 테스트 먼저 작성 강제

# 3단계: 구현
/backend-api implement payment endpoint
/react-component create PaymentForm component

# 4단계: 병렬 리뷰 (빠름!)
단일 메시지에서:
- Use code-reviewer for code quality
- Use security-reviewer for payment security
- Use performance-optimizer for API performance

# 5단계: 개발 일지
/dev-journal --daily
```

### 2. 버그 수정 (ReAct Agent 활용)

```bash
# ReAct Agent로 자동 조사 + 해결
"API가 500 에러를 반환해, 원인 찾고 수정해줘"

# react-agent가 자동으로 ReAct 루프 실행:
#
# 🧠 Thought 1: "로그를 확인해야겠다"
# 🛠️ Action 1: grep "ERROR" logs/api.log
# 📊 Observation 1: "NoneType object has no attribute 'id'"
#
# 🧠 Thought 2: "user 객체가 None인 것 같다"
# 🛠️ Action 2: Read src/api/routes/users.py
# 📊 Observation 2: "인증 미들웨어에서 user 검증 누락"
#
# 🧠 Thought 3: "인증 체크 추가 필요"
# 🛠️ Action 3: Edit src/api/routes/users.py (user 검증 추가)
#
# 🧠 Thought 4: "테스트로 검증"
# 🛠️ Action 4: pytest tests/test_users.py
# 📊 Observation 4: "All tests passed"
#
# ✅ Solution: Fixed authentication check in user routes

# 수동 방법 (필요 시):
Use the debugger agent to investigate the 500 error
implement the suggested fix
/tdd  # 테스트 추가로 재발 방지
```

### 3. 성능 최적화

```bash
# 1단계: 성능 측정
Use the performance-optimizer agent to profile current performance

# 2단계: 최적화 적용
implement suggested optimizations

# 3단계: 벤치마크
measure performance improvements
document the results

# 4단계: 커밋
commit with message "perf: optimize..."
```

### 🆕 4. 아키텍처 결정 (Tree of Thoughts)

```bash
# 여러 선택지가 있는 결정
"캐싱 전략 결정: Redis vs Memcached vs CDN"

# tree-of-thoughts가 다중 경로 탐색:
#
# Path 1: Redis
#   ├─ Pros: Persistence, 복잡한 자료구조, Pub/Sub
#   ├─ Cons: 메모리 비용, 관리 복잡도
#   └─ Score: 8.5/10

# Path 2: Memcached
#   ├─ Pros: 빠른 속도, 단순함, 낮은 메모리
#   ├─ Cons: No persistence, 단순 key-value만
#   └─ Score: 6.0/10

# Path 3: CDN (CloudFlare)
#   ├─ Pros: 글로벌 분산, DDoS 보호
#   ├─ Cons: 비용, 동적 콘텐츠 제한
#   └─ Score: 7.5/10
#
# 🏆 Recommendation: Redis (Hybrid with CDN)
# 📄 ADR: docs/adr/0045-redis-cdn-hybrid-caching.md
```

### 5. RAG 시스템 개선 (2026 최신 기법)

```bash
# 최신 RAG 기법 조사
/ai-research "RAG retrieval accuracy 개선"

# 출력:
# 1. Instructed Retriever (Databricks, 2026) - Score: 4.2/5
#    → 70% 정확도 향상
# 2. Multi-Modal RAG - Score: 3.8/5
# 3. Self-RAG - Score: 4.0/5

# POC 구현 선택
"1번 Instructed Retriever를 POC로 구현해줘"

# 벤치마크
Use performance-optimizer to benchmark against baseline

# 결정 기록
/dev-journal --adr "Instructed Retriever 채택"

# RAG 2.0 스킬로 전체 재구성 (필요 시)
/rag-2.0 "기존 RAG를 Hybrid Search + Instructed Retriever로 업그레이드"
```

## 🆕 2026 고급 워크플로우

### Critic-Agent로 품질 개선

```bash
# 코드 작성 후 자동 비평 및 개선
"이 코드를 critic-agent로 검토하고 개선해줘"

# Critic-Agent가:
# 1. 코드 분석 (정확성, 가독성, 성능, 보안)
# 2. 개선안 제시
# 3. 개선 적용
# 4. 재검토 (3회 반복)
# 5. 최종 승인
```

### Agentic Workflows (복잡한 시스템)

```bash
# Plan-and-Execute 패턴 (90% 토큰 절감)
/agentic-workflows "사용자 대시보드 전체 구축"

# 패턴:
# - Small model (Haiku): 계획 수립
# - Large model (Sonnet): 각 단계 실행
# - Parallel execution: 독립적인 작업 병렬 처리
```

### Context Compression (거대 코드베이스)

```bash
# 컨텍스트 80% 이상 시
/context-compressor --target 50%

# 압축 기법:
# - Reference Substitution
# - Code Skeleton Extraction
# - Delta Compression
# - Extractive Summarization
```

---

## 토큰 절약 팁 (2026 업데이트)

### 🆕 1. 모델 선택 전략

```bash
# 작업별 최적 모델 자동 선택 (settings.json 설정)
{
  "modelOverrides": {
    "debugger": "haiku",           // 3x 비용 절감
    "code-reviewer": "sonnet",     // 균형
    "architect": "opus",           // 깊은 분석 필요
    "coordinator": "sonnet"        // 판단력 중요
  }
}

# 토큰 분석으로 비효율 감지
/token-analysis
# → "debugger 에이전트에서 Sonnet 사용 중, Haiku로 전환 권장"
```

### 2. Context 관리

```bash
# 정기적으로 Context 정리
/clear

# 현재 토큰 사용량 확인
/cost

# Context 상태 확인
/context

# 🆕 자동 압축 (Context 60% 이상 시)
/context-compressor --auto

# 🆕 Context 존 확인
/context
# < 60%: Safe
# 60-80%: Caution (단일 파일 작업 권장)
# > 80%: Critical (압축 필수)
```

### 2. 효율적인 질문

❌ **비효율적:**
```
Show me all the code in the project and explain how it works
```

✅ **효율적:**
```
Explain how the MultiExcelAgent handles parallel processing in src/multi_excel/agents/
```

### 3. Agent 활용

❌ **비효율적:** 메인 Context에서 모든 작업 수행

✅ **효율적:** 고볼륨 작업은 Agent에 위임
```bash
Use the debugger agent to investigate this issue in the background
```

### 4. Skills로 지식 재사용

❌ **비효율적:** 매번 "FastAPI best practices"를 설명

✅ **효율적:** `/backend-api` skill에 패턴 정의, 자동 로드

## Hooks 활용

### 자동 포맷팅

JavaScript/React 파일 저장 시 자동으로 Prettier 실행:

```bash
# 자동 실행됨 - 별도 명령 불필요
Edit frontend_react/src/components/NewComponent.jsx
# → Prettier가 자동으로 포맷팅
```

### 테스트 출력 필터링

테스트 실행 시 자동으로 중요한 결과만 표시:

```bash
# 자동으로 필터링됨
pytest tests/
# → PASS/FAIL/ERROR만 표시
```

## MCP 서버 활용

### GitHub 통합

```bash
# PR 생성
Create a pull request for the current branch

# 이슈 조회
Show me open issues related to authentication

# 커밋 히스토리
What changes were made in the last sprint?
```

### 데이터베이스 쿼리

```bash
# 데이터 분석 (PostgreSQL MCP 설치 시)
Query the database and show user engagement metrics

# 스키마 확인
What tables are in the database?
```

## 문제 해결

### Skills가 로드되지 않음

```bash
# Skills 확인
/context
# "Skills:" 섹션에서 로드된 skills 확인

# Skill 설명이 너무 길면 로드 실패 가능
# → SKILL.md 파일 간결화
```

### Hooks가 실행되지 않음

```bash
# Hooks 상태 확인
/hooks

# 권한 확인
/permissions
# Bash 실행 권한이 있는지 확인
```

### Agent 실패

```bash
# 에이전트 정의 확인
cat .claude/agents/<agent-name>.md

# 권한 확인
# 에이전트에 필요한 tools가 allowed인지 확인
```

## 추가 명령어

```bash
# 도움말
/help

# 설정 확인
/config

# 피드백 제공
/feedback

# 프로젝트 초기화
/init
```

## 참고 자료

- [Claude Code 공식 문서](https://code.claude.com/docs)
- [Skills 가이드](https://code.claude.com/docs/en/skills)
- [MCP 설정 가이드](./.claude/MCP_SETUP_GUIDE.md)
- [2026 AI 트렌드](./.claude/MIGRATION_2026.md)
- [Token Efficiency 가이드](./.claude/rules/token-efficiency.md)

---

**버전**: 2.0 (2026 업데이트)
**최종 수정**: 2026-01-29

### 변경 사항 (v2.0)
- `/multi-agent`, `/token-analysis`, `/rust` 명령어 추가
- `/ai-research`, `/dev-journal` 스킬 추가
- Meta Agents 워크플로우 (coordinator, critic-agent, tree-of-thoughts, react-agent)
- 2026 RAG 개선 기법 (Instructed Retriever, Hybrid Search)
- Context Compression 전략
- 모델 선택 최적화 (Haiku/Sonnet/Opus)
