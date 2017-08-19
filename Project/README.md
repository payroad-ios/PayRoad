# PayRoad TODO

## 공통
#### CocoaPods을 통한 Realm 연동
#### Realm 모델 정의

- Travel
- Transaction
- Currency
- DateInRegion

## 여행
- 여행 목록 tableView 구현 (기본)
- 여행 생성
- 여행 수정 및 삭제
- 여행 목록 view에서 여행별 누적 사용 금액, 남은 예산 등에 대한 간략한 데이터 추가
- 여행 목록 collectionView로 변경, 새 UI 적용

## 가계부
#### 지출
- 지출 목록 tableView
- 새 지출 등록
- 지출 수정 및 삭제
- 지출 목록 tableView 날짜별 섹션 처리
- 통화별 사용금액 계산 / 남은 금액 조회
- 등록 시점의 국가 TimeZone 반영

#### 통화
- 통화 목록 tableView
- 새 통화 등록
- 통화 수정 및 삭제
- 각 나라별 고유 통화 코드 및 이름 정보 사용
- 자동으로 환율 정보를 받아올 수 있도록 Yahoo Exchange API 연동
- 새 통화 등록 시 원화는 화폐를 쉽게 찾을 수 있도록 검색 기능 (searchBar 적용)
- [환전] 사용자가 입력한 여행 환전 정보와 연동

#### 환전
- 환전 목록 tableView
- 새 환전 등록
- 환전 수정 및 삭제

## 일기
- 여행 중 한 줄 일기작성 기능
- 일기 목록 tableView
- 지출 내역을 바탕으로 일기에 일별 지출 금액 추가
- [HealthKit] 일기에 HealthKit으로 부터 걸음 수 데이터 추가

## 심화
- UICollectionView를 활용한 Date Picker 구현 
- 지출 목록 TableView에서 스크롤 다운 하여 새로운 지출 생성하기
- 지출내역에 사진, 위치 등 추가적인 데이터 첨부
- Map API 등을 이용한 지출 히스토리
- 3D Touch : 앱 아이콘에 3D Touch를 적용하여 지출 등록을 쉽게 할 수 있도록 하기
- Widget : 텍스트 및 간단한 progress bar 등으로 여행 상태 조회
- Local Push Notification : 하루를 마무리하는 한마디
- Advanced UI
- HealthKit : 여행 중 오늘 걸음 수 확인
- 사용 내역 통계 대시보드
- SiriKit : SiriKit 이용하여 현재 지출 내역 및 남은 예산 조회 기능
- 소셜 공유 (페이스북, 인스타그램)

# Weekly Milestones
## 공통
- 튜터링 전 리팩토링

## 1주차
### 전반기 튜터링 (8/7)
- [ ]  DataBase 관련 리서치 및 선택

### 후반기 튜터링 (8/10)

- #### PayRoad 프로젝트 생성
- #### DataBase 선택 및 연동
    - [x] Database 선택
    - [x] Realm 연동
- #### 앱을 사용할 수 있도록 기본적인 비지니스 로직 추가
    - [x] 여행 등록
    - [x] 통화 등록
    - [x] 지출 등록
    - [x] Transaction TableView 으로 보여주기
    - [x] Transaction TableView 일별 Section 적용

## 2주차
### 전반기 튜터링 (8/14)
- #### CRUD 마무리
    - [x] 여행/지출/통화 수정 및 삭제
- #### Date 및 Timezone 이슈 해결
    - [x] DateInRegion 모델 정의
    - [x] DateInRegion 모델의 절대 시간 값 구하기
    - [x] Transaction TableView에 DateInRegion을 통해 적용하기
- #### Transaction TableView 기능 추가
    - [x] CollectionView로 Date Picker 기능 구현, 선택된 날짜로 전환
    - [ ] 새 지출 추가 ViewController호출 Gesture 구현 (당겨서 새 항목 추가)
- #### 중복되는 레이아웃 재사용
    - [x] 모델에 대한 Create/Edit을 같은 뷰컨트롤러 사용하여 구현
- #### 기타
    - [ ] 통화 목록에 대한 검색 기능 (searchBar)

### 후반기 튜터링 (8/17)
- #### Calendar 구현
    - [ ] Collection View 이용한 캘린더 구현
- #### Transaction 이미지 추가 기능
    - [x] ImagePicker를 통해 Transaction에 사진 데이터 추가
- #### Transaction TableView 기능 추가
    - [x] 날짜별 지출내역 CollectionView를 통한 구현
    - [ ] Transaction Cell 구현. cell에 썸네일 사진 등 추가적인 데이터 붙이기.
    - [ ] Category 추가.
- #### 여행 목록 view에서 여행별 누적 사용 금액, 남은 예산 등에 대한 간략한 데이터 추가
- #### 여행 목록 collectionView로 변경, 새 UI 적용
- #### 기타
    - [ ] 환전 관련 기본 기능 구현

## 3주차
### 전반기 튜터링 (8/21)
- #### Calendar 적용
    - [ ] Travel 생성/변경 시 일정 DatePicker를 2주차때 구현한 Calendar로 변경
- #### 일기
    - [ ] 여행 중 한 줄 일기작성 기능
    - [ ] 일기 목록 tableView
    - [ ] 지출 내역을 바탕으로 일기에 일별 지출 금액 추가
- #### Advanced UI
    - [ ] UI 및 디자인 보완
    - [ ] Color값 지정 및 저장

### 후반기 튜터링 (8/24)
- #### 추가 스펙 구현
    - [ ] 3D Touch : 앱 아이콘에 3D Touch를 적용하여 지출 등록을 쉽게 할 수 있도록 하기
    - [ ] Map API 등을 이용한 지출 히스토리
    - [ ] Widget : 텍스트 및 간단한 progress bar 등으로 여행 상태 조회
- #### 코드 리팩토링 및 프로젝트 마무리

## 프로젝트 마무리 후 하고싶은 것들
- HealthKit : 여행 중 오늘 걸음 수 확인
- 사용 내역 통계 대시보드
- SiriKit : SiriKit 이용하여 현재 지출 내역 및 남은 예산 조회 기능
- 소셜 공유 (페이스북, 인스타그램)

