# GUIDE.md

이 문서는 **개발 경험이 많지 않은 사람도** 따라할 수 있게 작성한 Codex 설치 가이드입니다.

## 1. 이 저장소를 한 문장으로 설명하면

"Codex가 더 똑똑하게 일하도록, 우리 방식의 규칙과 도구 설명을 한 번에 넣어주는 전역 셋업"입니다.

## 2. 설치 전에 알아둘 것

설치가 끝나면 Codex는 아래를 더 잘 이해하게 됩니다.

- 우리 팀이 선호하는 작업 순서
- 언제 plan을 먼저 해야 하는지
- 어떻게 리뷰하고 테스트해야 하는지
- 어떤 스킬을 어떤 상황에서 써야 하는지
- 어떤 문서를 먼저 읽어야 하는지

즉, 같은 Codex라도 **그냥 쓰는 것**과 **우리 셋업을 얹어서 쓰는 것**의 차이가 생깁니다.

## 3. 가장 쉬운 설치 방법

### Windows

1. PowerShell을 엽니다.
2. 이 저장소 폴더로 이동합니다.
3. 아래 명령을 실행합니다.

```powershell
cd "C:\path\to\My_Codex_Skill"
.\setup.ps1 -Target Codex
```

### macOS / Linux

```bash
cd /path/to/My_Codex_Skill
bash ./setup.sh --target codex
```

## 4. 설치가 실제로 하는 일

Codex 전역 홈(`~/.codex`)에 아래를 연결합니다.

- `AGENTS.md`
- `skills/`
- `agents/`
- `rules/`
- `commands/`

기존에 같은 이름의 자산이 있으면 바로 덮지 않고 백업 폴더로 옮긴 뒤 연결합니다.

## 5. 설치 후 확인 방법

Codex를 다시 시작한 다음, 아무 저장소에서 아래처럼 물어보세요.

```text
내 전역 코덱스 셋업에 어떤 규칙이 들어가 있지?
```

또는

```text
이 작업은 먼저 어떻게 계획할까?
```

정상이라면 `AGENTS.md`, `rules/`, `skills/`, `commands/`를 자연스럽게 참조합니다.

## 6. 추천 추가 설정

설치만으로도 쓸 수 있지만, 아래까지 하면 훨씬 안정적입니다.

1. OpenAI Docs MCP 연결
2. GitHub MCP 연결
3. Playwright 또는 브라우저 자동화 도구 연결
4. `config.codex.example.toml`을 참고해 개인 `~/.codex/config.toml` 보정

자세한 내용은 [MCP_QUICK_SETUP.md](MCP_QUICK_SETUP.md)를 보세요.

## 7. 문제가 생기면 먼저 볼 것

### 스킬이 안 읽히는 경우

- `skills/*/SKILL.md` frontmatter가 깨졌는지 확인
- `~/.codex/skills`가 실제로 연결되었는지 확인

### 기존 설정이 사라진 것처럼 보이는 경우

- `~/.codex/backups/` 아래 백업 폴더를 먼저 확인
- 설치 스크립트는 기존 자산을 삭제하지 않고 백업 후 링크합니다

### Codex가 Claude 문구를 말하는 경우

- 일부 레거시 문서는 Claude 계열에서 가져온 자산을 바탕으로 유지되고 있습니다
- 이 저장소는 Codex-first로 운영되며, README/AGENTS/setup 스크립트 기준으로 보면 됩니다

### PowerShell에서 링크 생성이 실패하는 경우

- 관리자 PowerShell로 다시 시도
- 또는 Windows 개발자 모드 활성화
- 그래도 안 되면 스크립트가 파일은 `HardLink`, 디렉터리는 `Junction`으로 폴백합니다

## 8. 나중에 업데이트하는 방법

```bash
git pull
```

그 다음 설치 스크립트를 한 번 더 실행하세요.

```powershell
.\setup.ps1 -Target Codex
```

또는

```bash
bash ./setup.sh --target codex
```

## 9. 팀에 공유할 때 추천 방식

- 개인 전역 설정은 이 저장소 하나로 통일
- 프로젝트별 세부 규칙은 각 프로젝트의 `AGENTS.md`에 추가
- OpenAI Docs MCP는 팀 공통으로 연결
- 문서/규칙/스킬은 이 저장소에서 버전 관리

## 10. 제일 중요한 요약

- Codex를 그냥 쓰지 말고, 셋업을 얹어서 쓰기
- `AGENTS.md`는 짧고 선명하게 유지하기
- 깊은 설명은 `rules/`, `skills/`, `commands/`로 분리하기
- OpenAI Docs MCP와 함께 쓰기
- 문제가 생기면 백업 폴더부터 보기
