# My Codex Skill

Claude Code 셋업을 **Codex에서도 100% 동일하게 사용**할 수 있도록 구성한 전역 설정 저장소입니다.

- 기준일: **2026-03-08**
- 목표: 스킬/에이전트/커맨드/룰을 Codex 전역(`~/.codex/`)에서 그대로 사용
- 운영: 이 저장소를 `~/.codex/`에 클론하면 즉시 동작

## 포함 자산

| 종류 | 수량 |
|------|------|
| Skills | 39 |
| Agents | 15+ |
| Commands | 30+ |
| Rules | 6 |

## 디렉터리 구조

```
~/.codex/                   ← 이 저장소를 여기에 클론
├── AGENTS.md               ← Codex 전역 인스트럭션 (= Claude의 CLAUDE.md)
├── skills/                 ← 스킬 라이브러리
│   └── <skill-name>/
│       └── SKILL.md
├── agents/                 ← 에이전트 정의
│   └── *.md
├── commands/               ← 커스텀 커맨드
│   └── *.md
└── rules/                  ← 코딩 규칙
    └── *.md
```

## 설치 방법

### Linux / macOS / WSL (권장)

```bash
# 기존 ~/.codex 백업 (있다면)
[ -d ~/.codex ] && mv ~/.codex ~/.codex.bak

# 클론
git clone https://github.com/hyunseung1119/My_Codex_Skill.git ~/.codex
```

### Windows PowerShell

```powershell
# 기존 백업
if (Test-Path "$env:USERPROFILE\.codex") {
    Move-Item "$env:USERPROFILE\.codex" "$env:USERPROFILE\.codex.bak"
}

# 클론
git clone https://github.com/hyunseung1119/My_Codex_Skill.git "$env:USERPROFILE\.codex"
```

## 업데이트

```bash
cd ~/.codex && git pull
```

## 원본과의 관계

- 원본(Claude 설정): `C:\Users\user\Desktop\.claude`
- 이 저장소는 원본에서 Codex 호환 형태로 정리한 독립 레포
- 두 설정이 같은 스킬/에이전트/룰을 공유하도록 구성됨
