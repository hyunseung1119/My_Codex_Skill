# My_Codex_Skill

## Codex 인식 규칙 (현재 세션 기준)

### 1) 우선 적용 규칙
- 우선순위: `system > developer > AGENTS.md > user request`
- 협업 모드: `Default`
- 공통 품질 규칙: `SOLID`, `DRY`, `KISS`, `YAGNI`
- Git 규칙: `Conventional Commits`
- 보안 규칙: 시크릿 하드코딩 금지, 입력 검증/정규화, 민감정보 로깅 금지
- 에러 처리: 경계에서 처리, 묵살 금지, API는 `RFC 9457 Problem Details` 권장
- 프론트엔드: Anti-AI 디자인 규칙 + `C:\Users\user\.claude\rules\modern-frontend.md` 참고

### 2) 스킬 사용 방식
- 사용자 질문에서 트리거를 매칭해 해당 스킬을 선택
- 선택된 스킬의 `SKILL.md`를 읽고 지침을 적용
- 여러 스킬이 겹치면 최소 조합만 사용
- 스킬 파일 접근이 막히면 fallback 방식으로 진행
- 스킬은 턴마다 재판단 (자동 고정 아님)

### 3) 현재 인식 중인 스킬 목록

#### Development Fundamentals
- `clean-code`
- `code-review`
- `debugging`
- `refactoring`
- `tdd-workflow`
- `performance-optimization`
- `security-audit`
- `git-workflow`

#### API & Backend
- `api-design`
- `api-spec-generator`
- `backend-api`
- `architecture-design`

#### Frontend
- `react-component`
- `frontend-codemap`

#### AI / LLM
- `ai-developer-practice`
- `chatbot-designer`
- `agentic-workflows`
- `rag-2.0`
- `prompt-optimizer`
- `context-compressor`
- `mcp-integration`
- `agent-evaluator`
- `ml-training`
- `llm-app-planner`
- `ai-research-integration`
- `research-agent-tech`

#### Documentation & Planning
- `documentation-gen`
- `dev-journal`
- `product-planner`

#### System Skills
- `skill-creator`
- `skill-installer`
