# TREND_CHECK_2026.md

작성일: 2026-03-27

이 문서는 현재 저장소가 **2026년 기준 Codex / 코딩 에이전트 운영 트렌드**를 얼마나 잘 따라가고 있는지 점검한 결과입니다.

## 결론 요약

현재 셋업은 **방향성은 좋고, 핵심 구조도 상당히 맞습니다.**

특히 아래는 잘 따라가고 있습니다.

- 전역 `AGENTS.md` + 세부 규칙/스킬/커맨드 분리
- 검증 루프와 리뷰 중심 운영 철학
- 역할별 에이전트/스킬 분리
- OpenAI Docs MCP 같은 공식 문서형 MCP를 붙이기 쉬운 구조
- 작은 작업을 빠르게 넘기고 배경 작업으로 분산하는 운영 방식

반면, 공개용 Codex 셋업으로 더 좋아지려면 아래 보완이 필요합니다.

- Codex-native MCP와 Codex-native config 예시를 더 전면에 배치
- 레거시 Claude 전용 자산과 Codex 자산을 문서상 명확히 분리
- Observability / eval / trace-grade 같은 Codex-native 운영 흐름 예시 추가
- `AGENTS.md`는 목차, 세부 설명은 문서 디렉터리로 넘기는 구조 강화

## 1. 최신 트렌드 기준

### A. "프롬프트"보다 "하네스"가 중요해졌다

OpenAI는 2026년 2월 11일 공개한 *Harness engineering: leveraging Codex in an agent-first world*에서, 사람이 직접 코드를 치는 비중보다 **환경 설계, 문서 구조, 검증 루프, 제약 조건**을 설계하는 일이 더 중요해졌다고 설명합니다.

우리 셋업 상태:

- 강점: rules / skills / agents / commands로 하네스 구조가 이미 분리돼 있음
- 강점: 검증, 리뷰, 세션 운영, 스타일 규칙을 명시하는 자산이 있음
- 보완점: Codex 기준으로 문서/설정/예시를 더 전면화해야 함

판정: `잘 따라가는 편`

### B. AGENTS.md는 긴 백과사전이 아니라 "짧은 목차"여야 한다

OpenAI는 같은 글에서 "하나의 거대한 AGENTS.md"보다 **짧은 엔트리포인트 + 구조화된 docs 체계**가 더 좋다고 설명합니다.

우리 셋업 상태:

- 강점: 이미 rules, commands, skills가 분리되어 있음
- 보완점: 지금까지는 README/GUIDE가 Claude 중심이었고, Codex 문서 체계가 약했음
- 이번 정리로 개선: README, GUIDE, TREND_CHECK, MCP 가이드를 Codex 기준으로 재배치

판정: `부분 정렬 -> 개선 중`

### C. 에이전트는 반드시 자기 검증 루프를 가져야 한다

LangChain은 2026년 2월 17일 *Improving Deep Agents with harness engineering*에서 **self-verification, tracing, loop detection, local context injection**이 성능 향상에 핵심이라고 설명했습니다. 같은 글에서 하네스만 바꿔 Terminal Bench 2.0 점수를 `52.8 -> 66.5`로 끌어올렸다고 밝힙니다.

우리 셋업 상태:

- 강점: verification, review, context, loop 관련 규칙과 훅 철학이 이미 반영돼 있음
- 보완점: Codex-native trace/eval 예시는 아직 저장소에 부족함
- 보완점: 훅 철학은 좋지만 Codex에서 바로 쓰는 설정 예시가 더 필요함

판정: `구조는 좋음, Codex 운영 예시 보강 필요`

### D. 장시간 작업은 "세션 간 인계 아티팩트"가 중요하다

Anthropic은 2025년 11월 26일 *Effective harnesses for long-running agents*에서, 긴 작업을 여러 세션에 걸쳐 이어가려면 **progress 파일, init 스크립트, feature checklist, git 기록**이 중요하다고 정리했습니다.

우리 셋업 상태:

- 강점: progress 개념, 체크포인트, 세션 학습 철학이 이미 있음
- 보완점: Codex 기준의 progress artifact 이름과 사용법을 더 중립적으로 정리할 필요가 있음

판정: `아이디어는 맞고, Codex 언어로 재정리 필요`

### E. MCP와 공식 문서 연결은 이제 기본값에 가깝다

OpenAI의 Docs MCP 가이드는 2026년 3월 기준 Codex에서 `https://developers.openai.com/mcp`를 바로 연결하고, 관련 질문이 나오면 공식 문서를 우선 읽게 하라고 권장합니다.

우리 셋업 상태:

- 강점: MCP_QUICK_SETUP 문서와 MCP 확장 철학이 이미 있음
- 개선: OpenAI Docs MCP를 기본 추천값으로 승격함
- 개선: `config.codex.example.toml`과 `AGENTS.md`에 공식 Docs MCP 사용 방향 반영

판정: `이번 문서화로 트렌드에 더 가까워짐`

## 2. 현재 셋업 총평

### 잘하고 있는 점

- 구조화된 지식 저장소를 지향한다
- 재사용 가능한 스킬과 에이전트 체계를 이미 갖고 있다
- 계획, 리뷰, 검증을 중요하게 본다
- 비개발자도 slash command 중심으로 접근 가능하다
- Codex 전역 적용에 필요한 자산 묶음이 이미 충분하다

### 아직 아쉬운 점

- 공개 저장소 관점에서는 Codex 브랜딩이 늦었다
- 일부 문서/자산에 Claude 흔적이 남아 있었다
- Codex-native setup과 config 예시가 약했다
- 공식 OpenAI 문서 MCP 연결이 기본값으로 안내되지 않았다
- trace/eval/observability를 Codex에서 어떻게 굴리는지 예시가 부족하다

## 3. 앞으로 추천하는 보완 순서

1. Codex 예시 설정(`config.codex.example.toml`) 유지 및 고도화
2. OpenAI Docs MCP를 기본 권장값으로 유지
3. `AGENTS.md`는 짧게, 세부 규칙은 docs/rules로 더 분리
4. `eval/`, `traces/`, `examples/` 같은 Codex 운영 예시를 저장소에 추가
5. 장기적으로는 Claude 전용 자산과 Codex 자산을 폴더 수준에서 더 분리

## 4. 참고한 1차 자료

- OpenAI, *Introducing Codex*, 2025-05-16  
  https://openai.com/index/introducing-codex/
- OpenAI, *Introducing upgrades to Codex*, 2025-09-15  
  https://openai.com/index/introducing-upgrades-to-codex/
- OpenAI, *Harness engineering: leveraging Codex in an agent-first world*, 2026-02-11  
  https://openai.com/index/harness-engineering/
- OpenAI, *How OpenAI uses Codex*, current guide accessed in March 2026  
  https://openai.com/business/guides-and-resources/how-openai-uses-codex/
- OpenAI Developers, *Docs MCP*, current docs accessed in March 2026  
  https://developers.openai.com/learn/docs-mcp
- Anthropic, *Effective harnesses for long-running agents*, 2025-11-26  
  https://www.anthropic.com/engineering/effective-harnesses-for-long-running-agents
- LangChain, *Improving Deep Agents with harness engineering*, 2026-02-17  
  https://blog.langchain.com/improving-deep-agents-with-harness-engineering/

## 한 줄 평가

이 셋업은 **2026년 기준으로 충분히 현대적이고 방향이 맞습니다.** 다만 공개 저장소로서의 완성도는 이제부터가 중요하고, 이번 Codex-first 정리로 그 핵심 구간에 들어섰습니다.
