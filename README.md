# My_Codex_Skill

Codex가 참고하는 스킬/룰/운영 커맨드를 한 저장소에서 관리하기 위한 레포입니다.

## Included

- `skills/`: 인식 중인 31개 스킬의 원문 `SKILL.md`
- `rules/`: 로컬 룰 파일(`modern-frontend.md`)
- `docs/CODEX_INDEX.md`: 스킬 라우팅 방식, 우선순위 룰, 스킬 카탈로그
- `docs/GIT_COMMANDS.md`: 신규 레포 생성/푸시, upstream 변경 커맨드
- `docs/SKILL_TRIGGERS.md`: 스킬별 트리거 키워드 표

## Quick Check

```powershell
tree /A /F
Get-ChildItem -Path skills -Directory | Select-Object Name
Get-Content -Path skills\clean-code\SKILL.md -Encoding utf8 | Select-Object -First 30
Get-Content -Path rules\modern-frontend.md -Encoding utf8 | Select-Object -First 30
```

## Notes

- 이 레포는 2026-02-08 스냅샷 기준으로 정리되었습니다.
- 원본 로컬 경로는 일반적으로 `C:\Users\user\.codex\skills`, `C:\Users\user\.claude\rules` 입니다.
