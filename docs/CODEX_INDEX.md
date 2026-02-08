# CODEX INDEX

## 1) Rule Priority

- 우선순위: `system > developer > AGENTS.md > user request`
- 협업 모드: `Default` (현재 세션 기준)
- 항상 적용: `SOLID`, `DRY`, `KISS`, `YAGNI`
- Git: `Conventional Commits`
- 보안: 시크릿 하드코딩 금지, 입력 검증, 민감정보 로깅 금지
- 에러 처리: 경계에서 처리, silent swallow 금지, API는 `RFC 9457` 권장

## 2) Skill Routing

1. 사용자 질문에서 트리거 키워드 감지
2. 매칭된 스킬의 `SKILL.md` 로드
3. 다중 매칭 시 최소 조합만 선택
4. 해당 턴에서만 적용하고 다음 턴에 재판단
5. 파일 접근 실패 시 fallback 전략으로 진행

## 3) Skills Catalog (31)

### Development Fundamentals

- `skills/clean-code/SKILL.md`
- `skills/code-review/SKILL.md`
- `skills/debugging/SKILL.md`
- `skills/refactoring/SKILL.md`
- `skills/tdd-workflow/SKILL.md`
- `skills/performance-optimization/SKILL.md`
- `skills/security-audit/SKILL.md`
- `skills/git-workflow/SKILL.md`

### API and Backend

- `skills/api-design/SKILL.md`
- `skills/api-spec-generator/SKILL.md`
- `skills/backend-api/SKILL.md`
- `skills/architecture-design/SKILL.md`

### Frontend

- `skills/react-component/SKILL.md`
- `skills/frontend-codemap/SKILL.md`

### AI and LLM

- `skills/ai-developer-practice/SKILL.md`
- `skills/chatbot-designer/SKILL.md`
- `skills/agentic-workflows/SKILL.md`
- `skills/rag-2.0/SKILL.md`
- `skills/prompt-optimizer/SKILL.md`
- `skills/context-compressor/SKILL.md`
- `skills/mcp-integration/SKILL.md`
- `skills/agent-evaluator/SKILL.md`
- `skills/ml-training/SKILL.md`
- `skills/llm-app-planner/SKILL.md`
- `skills/ai-research-integration/SKILL.md`
- `skills/research-agent-tech/SKILL.md`

### Documentation and Planning

- `skills/documentation-gen/SKILL.md`
- `skills/dev-journal/SKILL.md`
- `skills/product-planner/SKILL.md`

### System Skills

- `skills/skill-creator/SKILL.md`
- `skills/skill-installer/SKILL.md`

## 4) Rules File

- `rules/modern-frontend.md`

## 5) Desktop Snapshot

- `.claude/`는 `C:\Users\user\Desktop\.claude`를 기준으로 복사한 전체 스냅샷
- 포함 범위: `agents/`, `commands/`, `rules/`, `skills/`, 루트 가이드 문서

## 6) Update Policy

- 로컬 스킬/룰 변경 시 이 레포를 동기화
- 변경 커밋 메시지 예시:
  - `docs(skills): sync local codex skills snapshot`
  - `docs(rules): sync modern-frontend rule`
  - `docs(claude): sync desktop .claude snapshot`
