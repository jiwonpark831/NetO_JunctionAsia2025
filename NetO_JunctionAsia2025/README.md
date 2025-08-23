# NetO Junction Asia 2025 - 건설 견적 시스템

## 📱 프로젝트 개요

이 프로젝트는 **ML 기반 건설 견적 시스템**을 SwiftUI로 구현한 iOS 앱입니다. 표준단가 데이터를 활용하여 정확한 공사 기간과 비용을 예측합니다.

## 🏗️ 주요 기능

### 1. 견적 계산 (EstimationView)
- **프로젝트 기본 정보**: 평수, 층수, 방/화장실 개수, 착공일
- **구조 및 자재**: RC/목구조/철골, 기본/중급/고급/프리미엄
- **특수 조건**: 도심, 펌프카제한, 소음규제, 지반연약, 장비양호
- **실시간 견적**: ML 모델 또는 로컬 계산을 통한 예측





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
    let room_count: Int            // 방 개수
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

### 홈 기능 사용하기
1. **홈** 탭 선택
2. 사용자 정보 확인
3. BID, Home, Schedule 탭 전환
4. 건축 계획 시작 버튼으로 MakeHouseView 이동





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
│   ├── HomeView.swift                # 홈 뷰
│   ├── AuctionView.swift             # 경매 뷰


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
