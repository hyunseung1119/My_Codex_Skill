# Global Claude Code Instructions

이 파일은 모든 프로젝트에서 적용되는 전역 지침입니다.

## 프론트엔드 개발 시 필수 적용

프론트엔드 작업(React, Vue, HTML/CSS 등)을 수행할 때는 반드시:

1. **`~/.claude/rules/modern-frontend.md` 규칙을 참조하여 적용합니다**
2. **AI 클리셰 패턴을 피합니다** (보라색 그라데이션, 단순 카드 그리드 등)
3. **WebSearch로 2026 트렌드를 조사합니다**
4. **UX 연구 기반으로 설계합니다**

## 자동 적용 규칙

### 프론트엔드 작업 감지 시 자동 실행:
- React 컴포넌트 생성/수정
- CSS/스타일 작업
- UI/UX 관련 질문
- 웹 디자인 작업

### 적용 내용:
- 최신 트렌드 조사 (Bento Grid, Glass Morphism 2.0, Variable Fonts 등)
- 마이크로인터랙션 적용
- Skeleton Loading 구현
- Container Queries 사용
- 접근성(a11y) 고려
- 성능 최적화

## 참조 문서

- `~/.claude/rules/modern-frontend.md` - Anti-AI 디자인 원칙 (자동 적용)
- `~/.claude/skills/react-component/SKILL.md` - 종합 프론트엔드 디자인 시스템
- `/modern-frontend` 커맨드 - 위 두 문서를 명시적으로 활성화
