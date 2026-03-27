# MCP Quick Setup for Codex

작성일: 2026-03-27

이 문서는 **Codex에서 바로 도움이 되는 MCP만** 빠르게 연결하기 위한 가이드입니다.

## 추천 우선순위

1. OpenAI Developer Docs MCP
2. GitHub MCP
3. Playwright / 브라우저 자동화 MCP
4. Context7 같은 라이브러리 문서형 MCP

## 1. OpenAI Developer Docs MCP

이건 가장 먼저 연결하는 것을 권장합니다.

OpenAI 공식 문서에 따르면 Codex는 아래 MCP 서버를 `~/.codex/config.toml` 또는 CLI로 연결할 수 있습니다.

서버 URL:

```text
https://developers.openai.com/mcp
```

### CLI로 추가

```bash
codex mcp add openaiDeveloperDocs --url https://developers.openai.com/mcp
codex mcp list
```

### config.toml로 추가

```toml
[mcp_servers.openaiDeveloperDocs]
url = "https://developers.openai.com/mcp"
```

### AGENTS.md에 함께 넣을 문구

```text
Always use the OpenAI developer documentation MCP server if you need to work with the OpenAI API, ChatGPT Apps SDK, Codex, or MCP configuration without me having to explicitly ask.
```

## 2. GitHub MCP

추천 이유:

- PR, issue, diff, 코드 검색을 에이전트가 더 자연스럽게 다룸
- Codex 비동기 작업과 잘 맞음
- 리뷰/변경 이력 확인 흐름이 쉬워짐

팀에서 GitHub 중심으로 일한다면 거의 필수입니다.

## 3. Playwright 또는 브라우저 자동화 MCP

추천 이유:

- UI 변경 검증 자동화
- 스크린샷/DOM 확인
- 회귀 테스트와 재현 작업 자동화

프론트엔드나 E2E 품질이 중요하면 붙이는 것이 좋습니다.

## 4. Context7 또는 라이브러리 문서형 MCP

추천 이유:

- 패키지 최신 문서를 직접 찾아와 컨텍스트에 주입
- 프레임워크/SDK 버전 차이로 생기는 오류 감소

단, OpenAI 관련 질문은 OpenAI Docs MCP를 우선으로 두는 것이 더 낫습니다.

## 권장 조합

### 개인 개발자

- OpenAI Docs MCP
- GitHub MCP

### 제품 팀

- OpenAI Docs MCP
- GitHub MCP
- Playwright MCP

### 프레임워크가 자주 바뀌는 팀

- OpenAI Docs MCP
- GitHub MCP
- Context7
- Playwright MCP

## 참고

- OpenAI Developers, *Docs MCP*  
  https://developers.openai.com/learn/docs-mcp
- OpenAI docs 기준으로 Codex CLI와 IDE extension은 같은 설정을 공유합니다.
- 자세한 예시 값은 [config.codex.example.toml](config.codex.example.toml)을 참고하세요.
