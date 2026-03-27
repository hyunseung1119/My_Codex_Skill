# My Codex Skill

Codex 전역 세팅을 빠르게 붙일 수 있게 만든 오픈소스 저장소입니다.

이 저장소는 **Codex-first**를 기준으로 설계되었습니다. 핵심 자산은 `AGENTS.md`, `skills/`, `agents/`, `rules/`, `commands/`이며, 설치 스크립트는 기본적으로 `~/.codex`에 연결합니다. 기존 Claude 계열 자산과 훅은 **호환용 레거시 자산**으로만 유지합니다.

## 이 저장소가 해주는 일

- Codex가 매 세션 참고할 전역 `AGENTS.md` 제공
- 재사용 가능한 `36`개 스킬, `24`개 에이전트, `31`개 커맨드, `12`개 규칙 제공
- Windows/macOS/Linux용 설치 스크립트 제공
- 비개발자도 따라할 수 있는 설정 가이드 제공
- 2026년 최신 Codex/에이전트 트렌드 기준 점검 문서 제공

## 누구를 위한 저장소인가

- 혼자 개발하지만 Codex를 좀 더 체계적으로 쓰고 싶은 사람
- 팀 공통 규칙, 리뷰 방식, 문서화 습관을 Codex에 주입하고 싶은 팀
- PM, 디자이너, 운영 담당자처럼 코드보다 "어떻게 시키면 되는지"가 중요한 사용자
- 나중에 오픈소스로 배포 가능한 형태의 AI 개발 셋업이 필요한 사람

## 3분 설치

### Windows

```powershell
cd "C:\path\to\My_Codex_Skill"
.\setup.ps1 -Target Codex
```

### macOS / Linux

```bash
cd /path/to/My_Codex_Skill
bash ./setup.sh --target codex
```

## 설치 후 바로 해볼 것

1. Codex를 다시 시작합니다.
2. 저장소 하나를 연 뒤 아래처럼 짧게 테스트합니다.

```text
이 저장소 구조를 빠르게 설명해줘
```

```text
이 작업 먼저 plan으로 쪼개줘
```

```text
이 변경사항 리뷰해줘
```

## 스킬 검증

스킬을 추가하거나 수정했다면 배포 전에 한 번 검증하는 것이 안전합니다.

```powershell
powershell -ExecutionPolicy Bypass -File .\scripts\validate-skills.ps1
```

이 스크립트는 모든 `SKILL.md`가 YAML frontmatter로 시작하는지, 그리고 UTF-8 BOM 없이 저장됐는지 확인합니다.

## 먼저 읽을 문서

- [GUIDE.md](GUIDE.md): 비개발자도 따라할 수 있는 단계별 설치 가이드
- [MCP_QUICK_SETUP.md](MCP_QUICK_SETUP.md): Codex에서 바로 쓸 MCP 추천 설정
- [TREND_CHECK_2026.md](TREND_CHECK_2026.md): 2026년 최신 사례/논문/공식 자료 기준 적합도 체크
- [config.codex.example.toml](config.codex.example.toml): 바로 복사해 쓸 수 있는 Codex 예시 설정

## 저장소 구조

```text
.
├─ AGENTS.md                    # Codex 전역 기본 지침
├─ README.md                    # 저장소 소개
├─ GUIDE.md                     # 쉬운 설치/운영 가이드
├─ MCP_QUICK_SETUP.md           # MCP 연결 가이드
├─ TREND_CHECK_2026.md          # 최신 트렌드 기준 점검 문서
├─ config.codex.example.toml    # Codex 예시 설정
├─ setup.ps1 / setup.sh         # Codex-first 설치 스크립트
├─ skills/                      # 전문 작업 스킬
├─ agents/                      # 역할별 서브 에이전트 정의
├─ rules/                       # 항상 또는 상황별로 참고할 규칙
├─ commands/                    # slash command 문서
└─ hooks/                       # Claude 계열 호환용 참조 자산
```

## Codex 기준 운영 원칙

- `AGENTS.md`는 짧고 명확한 엔트리포인트여야 합니다.
- 깊은 규칙과 설명은 `rules/`, `skills/`, `commands/`로 분리합니다.
- 설치 스크립트는 기존 사용자 설정을 바로 덮어쓰지 않고 백업 후 연결합니다.
- Codex가 기본이며, Claude 전용 훅/설정은 자동 실행 대상으로 가정하지 않습니다.

## 왜 이렇게 만들었나

2026년 현재 Codex와 같은 코딩 에이전트는 단순 프롬프트보다 **환경 설계**, **지속 규칙**, **검증 루프**, **문서화된 컨텍스트**, **MCP 연결**에서 성능 차이가 크게 납니다. 이 저장소는 그 차이를 개인이나 작은 팀이 바로 가져갈 수 있게 정리한 셋업입니다.

## 현재 상태

- Codex 전역 설치 스크립트 반영 완료
- Codex가 읽는 스킬 frontmatter 정규화 완료
- 공개용 문서 구조 정리 완료
- Claude 유산 문서와 Codex 문서를 단계적으로 분리 중

## 주의사항

- 이 저장소가 `~/.codex`를 자동으로 완전히 대체하지는 않습니다. 기존 사용자 설정은 백업 후 링크합니다.
- 일부 `hooks/`와 `settings.local.json`은 Claude 호환 자산입니다. Codex에서는 그대로 자동 실행되지 않을 수 있습니다.
- OpenAI 관련 질문 품질을 높이려면 `MCP_QUICK_SETUP.md`에 있는 OpenAI Docs MCP 설정을 함께 적용하는 것을 권장합니다.

## 마이그레이션 메모

이 저장소의 설치 경로, README, AGENTS, MCP 가이드, 설정 예시는 Codex 기준으로 정리되었습니다.
다만 일부 깊은 스킬/커맨드 문서에는 과거 자산에서 넘어온 예시 문구가 남아 있을 수 있습니다. 그런 경우에는 **설치 스크립트와 루트 문서 기준이 우선**이며, 긴 문서는 순차적으로 Codex 전용 표현으로 계속 정리하면 됩니다.
