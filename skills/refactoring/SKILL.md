---
name: refactoring
description: "안전하고 체계적인 리팩토링을 수행합니다. \\\"리팩토링\\\", \\\"코드 개선\\\", \\\"정리해줘\\\", \\\"클린업\\\", \\\"기술 부채 해결\\\", \\\"코드 스멜\\\", \\\"구조 개선\\\" 등의 요청 시 사용합니다. 동작을 변경하지 않으면서 코드 구조를 개선하며, 각 단계마다 테스트로 검증합니다. (코드 작성 원칙은 clean-code, 리뷰 관점은 code-review 스킬 참조)"
---

# Safe Refactoring Skill — Zero Regression

## 목적
외부 동작(behavior)은 유지하면서 내부 구조를 개선한다.
"리팩토링하다가 버그 만들었다"를 원천 차단한다.

## 핵심 규칙
- MUST: 리팩토링 전 기존 테스트가 모두 통과하는 상태에서 시작
- MUST: 한 번에 하나의 리팩토링 기법만 적용
- MUST: 각 리팩토링 후 테스트 실행 → 통과 → 커밋
- MUST: 리팩토링 커밋과 기능 변경 커밋을 분리
- MUST NOT: 리팩토링과 기능 추가를 동시에 하지 않기
- MUST NOT: 테스트 없는 코드를 리팩토링하지 않기 (테스트 먼저 추가)

## 코드 스멜 탐지 체크리스트

### 함수 수준
```
□ 긴 함수 (Long Function) — 20줄 초과
□ 긴 매개변수 목록 (Long Parameter List) — 3개 초과
□ 플래그 인자 (Flag Argument) — boolean으로 동작 분기
□ 중복 코드 (Duplicated Code) — 3회 이상 반복
□ 복잡한 조건문 (Complex Conditional) — 중첩 3단계 초과
□ 매직 넘버/문자열 — 의미 없는 리터럴 값
```

### 클래스/모듈 수준
```
□ 거대 클래스 (God Class) — 책임이 3개 이상
□ 기능 편애 (Feature Envy) — 다른 클래스의 데이터를 과도하게 사용
□ 데이터 뭉치 (Data Clump) — 항상 함께 다니는 데이터 그룹
□ 산탄총 수술 (Shotgun Surgery) — 하나의 변경이 여러 파일을 수정
□ 발산적 변경 (Divergent Change) — 하나의 파일이 여러 이유로 수정
□ 중재자 (Middle Man) — 위임만 하는 클래스
```

### 아키텍처 수준
```
□ 순환 의존성 (Circular Dependency)
□ 레이어 위반 (Layer Violation) — 안쪽 레이어가 바깥을 import
□ 과도한 결합 (Tight Coupling) — 구현 세부사항에 의존
□ 부족한 응집 (Low Cohesion) — 관련 없는 기능이 한 모듈에
```

## 리팩토링 기법 카탈로그

### 1. Extract Function
```typescript
// Before
function processOrder(order: Order) {
  // 30줄의 가격 계산 로직
  // 20줄의 재고 확인 로직
  // 15줄의 알림 발송 로직
}

// After
function processOrder(order: Order) {
  const price = calculatePrice(order);
  validateInventory(order.items);
  sendNotification(order, price);
}
```

### 2. Replace Conditional with Polymorphism
```typescript
// Before
function calculateDiscount(type: string, amount: number) {
  if (type === 'vip') return amount * 0.2;
  if (type === 'member') return amount * 0.1;
  if (type === 'student') return amount * 0.15;
  return 0;
}

// After
interface DiscountStrategy {
  calculate(amount: number): number;
}
const strategies: Record<string, DiscountStrategy> = {
  vip: { calculate: (a) => a * 0.2 },
  member: { calculate: (a) => a * 0.1 },
  student: { calculate: (a) => a * 0.15 },
};
```

### 3. Introduce Parameter Object
```typescript
// Before
function search(query: string, page: number, limit: number,
  sortBy: string, sortOrder: string, filters: Filter[]) { ... }

// After
interface SearchParams {
  query: string;
  pagination: { page: number; limit: number };
  sort: { field: string; order: 'asc' | 'desc' };
  filters: Filter[];
}
function search(params: SearchParams) { ... }
```

### 4. Replace Nested Conditionals with Guard Clauses
```typescript
// Before
function getPayment(order: Order) {
  if (order) {
    if (order.isPaid) {
      if (order.payment) {
        return order.payment;
      }
    }
  }
  return null;
}

// After
function getPayment(order: Order) {
  if (!order) return null;
  if (!order.isPaid) return null;
  if (!order.payment) return null;
  return order.payment;
}
```

## 안전한 리팩토링 절차

```
1. ✅ 현재 테스트 통과 확인
2. 📸 현재 상태 커밋 (안전장치)
3. 🔍 코드 스멜 식별 및 목록 작성
4. 🎯 하나의 스멜 선택
5. 🛠 리팩토링 기법 적용
6. ✅ 테스트 실행 → 통과 확인
7. 💾 커밋: refactor(scope): description
8. 🔄 다음 스멜로 반복
```

## 리팩토링 우선순위

```
높음 (즉시):
  - 버그를 유발하는 코드 스멜
  - 새 기능 추가를 가로막는 구조
  - 보안 취약점을 유발하는 패턴

중간 (계획적):
  - 중복 코드
  - 복잡한 조건문
  - 긴 함수

낮음 (기회 발생 시):
  - 네이밍 개선
  - 불필요한 주석 제거
  - import 정리
```

## 대규모 리팩토링 전략

큰 리팩토링은 Strangler Fig 패턴으로:
```
1. 새 구조(New)를 기존 구조(Old) 옆에 생성
2. 새 코드는 New로, 기존 코드는 점진적 이전
3. Old와 New가 공존하는 기간 동안 모든 테스트 통과 유지
4. 이전 완료 후 Old 제거
5. 각 단계마다 배포 가능한 상태 유지
```


