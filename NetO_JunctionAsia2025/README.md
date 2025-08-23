# NetO Junction Asia 2025 - 건설 견적 시스템

## 📱 프로젝트 개요

이 프로젝트는 **ML 기반 건설 견적 시스템**을 SwiftUI로 구현한 iOS 앱입니다. 표준단가 데이터를 활용하여 정확한 공사 기간과 비용을 예측합니다.

## 🏗️ 주요 기능

### 1. 견적 계산 (EstimationView)
- **프로젝트 기본 정보**: 평수, 층수, 방/화장실 개수, 착공일
- **구조 및 자재**: RC/목구조/철골, 기본/중급/고급/프리미엄
- **특수 조건**: 도심, 펌프카제한, 소음규제, 지반연약, 장비양호
- **실시간 견적**: ML 모델 또는 로컬 계산을 통한 예측

### 2. 표준단가 브라우저 (StandardPriceView)
- **카테고리별 분류**: 가설공사, 토공사, 말뚝·지지공, 철거공사, 흙운반, 옹벽·배면채움
- **검색 기능**: 공종명 또는 코드로 빠른 검색
- **보정계수**: 조건별 단가 및 노무비율 보정계수 표시
- **상세 정보**: 공종별 상세 스펙 및 적용 조건

### 3. 견적 히스토리 (EstimationHistoryView)
- **견적 기록**: 과거 견적 내역 및 결과
- **필터링**: 기간별, 조건별 검색 및 필터
- **품질 지표**: ML 모델 신뢰도, 정확도, 모델 버전
- **상태 추적**: API 응답 상태 및 오류 정보

## 🚀 기술 스택

### Frontend
- **SwiftUI**: 모던 iOS UI 프레임워크
- **Combine**: 반응형 프로그래밍
- **Core Data**: 로컬 데이터 저장 (향후 구현)

### Backend (향후 구현)
- **Firebase Cloud Functions**: ML 모델 서빙
- **Python**: LightGBM/XGBoost 모델
- **Firestore**: 견적 데이터 저장

### ML 모델
- **LightGBM**: 기간 및 비용 예측
- **표준단가 데이터**: 보정계수 적용
- **하이브리드 접근**: ML + 규칙 기반

## 📊 데이터 구조

### 견적 입력 (EstimationRequest)
```swift
struct EstimationRequest: Codable {
    let startDate: String      // 착공일
    let size: Int             // 평수
    let floor: Int            // 층수
    let roomN: Int            // 방 개수
    let restroomN: Int        // 화장실 개수
    let construct: String     // 구조 (RC/목구조/철골)
    let material: String      // 자재 등급
    let conditionTags: [String] // 특수 조건
}
```

### 견적 응답 (EstimationResponse)
```swift
struct EstimationResponse: Codable {
    let durationDays: Double  // 예상 공사 기간
    let costKRW: Int         // 예상 공사 비용
    let confidence: String?   // 계산 방식
    let explanation: String?  // 참고사항
}
```

## 🔧 설치 및 실행

### 1. 프로젝트 클론
```bash
git clone [repository-url]
cd NetO_JunctionAsia2025
```

### 2. Xcode에서 열기
```bash
open NetO_JunctionAsia2025.xcodeproj
```

### 3. 빌드 및 실행
- Xcode에서 `Cmd + R`로 시뮬레이터 실행
- 또는 실제 iOS 기기에서 테스트

## 📱 사용법

### 견적 계산하기
1. **견적 계산** 탭 선택
2. 프로젝트 기본 정보 입력 (평수, 층수, 방 개수 등)
3. 구조 및 자재 등급 선택
4. 특수 조건 체크 (도심, 펌프카제한 등)
5. **견적 계산** 버튼 클릭
6. 결과 확인 (공사 기간, 비용, 평당 단가)

### 표준단가 확인하기
1. **표준단가** 탭 선택
2. 카테고리 선택 (가설공사, 토공사 등)
3. 검색어 입력으로 특정 공종 찾기
4. 공종 선택하여 상세 정보 및 보정계수 확인

### 견적 히스토리 보기
1. **견적 히스토리** 탭 선택
2. 기간별 필터 적용
3. 검색어로 특정 프로젝트 찾기
4. 상세 정보 펼쳐보기

## 🔮 향후 개발 계획

### Phase 1: ML 모델 연결
- [ ] Firebase Cloud Functions 배포
- [ ] Python ML 모델 학습 및 배포
- [ ] 실시간 예측 API 연동

### Phase 2: 데이터 관리
- [ ] Firestore 연동
- [ ] 견적 히스토리 저장
- [ ] 사용자 계정 관리

### Phase 3: 고급 기능
- [ ] 3D 시각화
- [ ] 일정 관리 연동
- [ ] 예산 분석 도구

## 📁 프로젝트 구조

```
NetO_JunctionAsia2025/
├── Models/
│   └── ConstructionModels.swift      # 데이터 모델
├── Services/
│   └── StandardPriceLoader.swift     # 표준단가 로더
├── Feature/
│   ├── EstimationView.swift          # 견적 계산 뷰
│   ├── EstimationResultView.swift    # 견적 결과 뷰
│   ├── StandardPriceView.swift       # 표준단가 브라우저
│   └── EstimationHistoryView.swift   # 견적 히스토리
├── Config/
│   └── MLConfig.swift                # ML 설정
├── Construction unit price.json      # 표준단가 데이터
└── ContentView.swift                 # 메인 뷰
```

## 🤝 기여하기

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## 📄 라이선스

이 프로젝트는 MIT 라이선스 하에 배포됩니다. 자세한 내용은 `LICENSE` 파일을 참조하세요.

## 📞 문의

프로젝트에 대한 문의사항이나 제안사항이 있으시면 이슈를 생성해 주세요.

---

**NetO Junction Asia 2025** - 건설업계의 디지털 혁신을 위한 첫 걸음 🚀
