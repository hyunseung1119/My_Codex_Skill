# MCP 서버 설정 가이드

## 개요

MCP (Model Context Protocol)는 Claude Code가 외부 시스템(GitHub, 데이터베이스, 파일시스템 등)과 상호작용할 수 있게 해주는 표준 프로토콜입니다.

## 설치된 MCP 서버 확인

```bash
# 현재 설치된 MCP 서버 목록
claude mcp list

# 특정 서버 상세 정보
claude mcp get <server-name>
```

## 권장 MCP 서버

### 1. GitHub MCP (필수 - PR 관리, 이슈 처리)

```bash
# 설치
claude mcp add --transport http github https://api.githubcopilot.com/mcp/

# 프로젝트 범위로 설치 (팀 공유 가능)
claude mcp add --transport http github --scope project https://api.githubcopilot.com/mcp/
```

**사용 예시:**
```bash
# PR 검토
Use the GitHub MCP to review PR #123 for security issues

# 이슈 분석
Analyze GitHub issue #456 and create implementation plan

# 커밋 히스토리 조회
Show me the commit history for the last week
```

### 2. Filesystem MCP (권장 - 프로젝트 네비게이션)

```bash
# 로컬 파일시스템 접근
claude mcp add --transport stdio filesystem -- npx -y @modelcontextprotocol/server-filesystem
```

**사용 예시:**
```bash
# 프로젝트 구조 탐색
Navigate the project structure and show me all Python files

# 파일 검색
Find all files related to authentication
```

### 3. PostgreSQL MCP (선택 - 데이터베이스 쿼리)

데이터베이스를 사용하는 경우:

```bash
# PostgreSQL 서버 추가
claude mcp add --transport stdio postgres \
  --env DATABASE_URL='postgresql://user:pass@localhost:5432/dbname' \
  -- npx -y @modelcontextprotocol/server-postgres
```

**사용 예시:**
```bash
# 데이터 분석
Query the user table and show statistics

# 스키마 확인
Show me the database schema
```

### 4. Puppeteer/Playwright MCP (선택 - 웹 자동화)

웹 스크래핑이나 자동화가 필요한 경우:

```bash
# Puppeteer 서버 추가
claude mcp add --transport stdio puppeteer -- npx -y @modelcontextprotocol/server-puppeteer
```

## 프로젝트별 MCP 설정

프로젝트 루트에 `.mcp.json` 파일 생성:

```json
{
  "mcpServers": {
    "github": {
      "type": "http",
      "url": "https://api.githubcopilot.com/mcp/"
    },
    "filesystem": {
      "type": "stdio",
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-filesystem"],
      "env": {
        "ALLOWED_DIRECTORIES": "."
      }
    }
  }
}
```

## MCP 서버 관리

```bash
# 서버 제거
claude mcp remove <server-name>

# 서버 재설정
claude mcp reset-project-choices

# 서버 연결 테스트
claude mcp test <server-name>
```

## 문제 해결

### MCP 서버 연결 실패

```bash
# 1. 서버 상태 확인
claude mcp list

# 2. 인증 필요시
claude mcp auth <server-name>

# 3. 타임아웃 조정
export MCP_TIMEOUT=10000  # 10초
```

### 서버가 응답하지 않음

1. MCP 서버 재시작:
   ```bash
   claude mcp restart <server-name>
   ```

2. 로그 확인:
   ```bash
   cat ~/.claude/mcp.log
   ```

3. 환경 변수 확인:
   ```bash
   claude mcp get <server-name>
   ```

## 성능 최적화

### 1. 필요한 서버만 활성화

사용하지 않는 MCP 서버는 비활성화:

```bash
claude mcp disable <server-name>
```

### 2. 캐싱 활성화

MCP 응답 캐싱으로 성능 향상:

```json
{
  "env": {
    "MCP_CACHE_ENABLED": "true",
    "MCP_CACHE_TTL": "3600"
  }
}
```

### 3. 출력 토큰 제한

대량 데이터 반환 시 토큰 제한:

```json
{
  "env": {
    "MAX_MCP_OUTPUT_TOKENS": "25000"
  }
}
```

## 보안 고려사항

1. **인증 정보 보호**: `.mcp.json`을 `.gitignore`에 추가
2. **권한 최소화**: 필요한 권한만 부여
3. **HTTPS 사용**: HTTP MCP 서버는 HTTPS로 설정

## 참고 자료

- [MCP 공식 문서](https://modelcontextprotocol.io)
- [Claude Code MCP 가이드](https://code.claude.com/docs/en/mcp)
- [MCP 서버 카탈로그](https://mcpcat.io)
