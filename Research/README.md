# 데이터베이스 리서치

## SQLLite

* Tried and tested; version 1.0 was released in August 2000
* Open source
* Familiar query language for database developers and admins
  : 기존 쿼리문에 익숙한 개발자들에게 쉽고 친근함.
* Cross-platform : 말그대로
* No hassle of configuration
  : Shipped with iOS so it adds no overhead to your app’s bundle
    즉, iOS에 내장되어있어 추가를 위해 초기 설정이 거의 필요 없음.
* Easy storage of data in tables with multiple columns
  : 많은 column을 가진 테이블 데이터를 쉽게 저장.
* Easy and secured access to data from multiple threads 
  : 멀티스레드 환경에서도 쉽고 안전하게 데이터에 접근 가능.

## Core Data
SQLLite가 **table storage contents**에 주로 초점을 둔다면,
코어데이터는 **객체의 contents를 디테일한 방법을 통해서 저장**하는 데 초점을 둔다.

그래서, 저장할 내용을 어떻게 선택할 것인지를 바탕으로 데이터베이스를 선택하는 것이 좋다.

* Core Data has faster responsiveness and thus performs better than SQLite
  : 코어데이터는 SQLLite보다 빠른 응답성을 가진다.
* Space utilization is greater in Core Data when compared to SQLite
  : SQLLite에 비해서 저장을 위해 필요한 공간이 많이 필요함.
* Core Data uses more memory for storage of contents than SQLite
  : SQLLite에 비해서 저장을 위해 많은 메모리를 필요로 함.

## Realm
* 모바일 cross platform.
  : iOS, Android 모두 사용가능함.
* iOS 8 이상부터 지원. 즉, 사용하는데 문제 버전 관련 문제는 없을 것 같음.
* 렘 사용을 위해 초기 코드 작성에 최소한의 비용(시간) 필요함.
* Obj-C, Swift 모두 사용가능.
* SQLite와 Core Data에 비해서 더 나은 퍼포먼스를 보여줌.
* iOS, Android간 db file 공유 쉽게 가능.
* **공짜.**
* 데이터 저장에 제한이 없음. - 이거 무슨말인지 정확히 모르겠습니다.
* 데이터 크기가 크더라도 속도 저하 없음.

## 야곰님 발표 정리 - 좌충우돌 Realm 모바일 플랫폼 사용기
야곰님께서 3일간 Realm 사용하여 간단한 앱 개발하시면서 느낀 점들 정리.
오브젝트 서버는 서버에서 사용할 데이터베이스를 말하는거같음.
**우리는 주로 모바일 데이터베이스의 기능에 초점을 두면 될 것 같습니다.**

### 모바일 데이터베이스 좋았던 점
* 로컬 DB를 구성하는데 전체 제작 시간의 10% 소요. - DB 개발 시간 단축
* 기술지원 굳.

### 오브젝트 서버 좋았던 점
* 설치 간편. 동기화 구현 빠르게 가능함. 구글, 페이스북, iCloud인증 등도 쉽게 구현 가능.
* Realm 브라우저 사용하면 쿼리 없이 DB 조회 가능.

### 모바일 데이터베이스 아쉬운점
* CocoaPods에서 받는 시간 오래 걸리고 용량 큼. 빌드 시간도 길었음.
* 마이그레이션을 쉽게 지원한다고 했으나 실제로는 귀찮은 부분이 있었음.
* 트랜잭션에 대한 클로저 작성을 하는 것이 아니라 `NotivficationBlock` 을 사용하여 코드가 분산됨.
* 예제 코드가 너무 간단함. 실제로 쓰기 위해서는 예외 처리가 더 많이 들어가야함.
* 예외 발생에 대한 구조화된 문서의 필요성 느낌.
* Realm 브라우저가 mac에서만 동작 가능함.

### 오브젝트 서버 아쉬운점
* 오류, 사용방법, 동기화 충돌에 대한 문서가 좀 더 구조화 되었으면.
* Admin에서 DB 확인 후 수정하려면 Realm브라우저를 별도로 사용해야하는데, 이것은 좀 통합되었으면 함
* Progress handler를 제공하지만 동기화 타이밍을 잡는것이 난해하다는 느낌.
* 가장 큰 문제는 로컬 Realm을 구성하고, 이를 동기화 Realm으로 옮기는 과정.
* API 유료기능이라 아쉽.

### Q&A

* Q: Realm 브라우저 다른 플랫폼 지원
A: 현재 브라우저를 다시 만들고 있어서 곧 여러 플랫폼에서 만날 수 있지만,
  당장 사용해보고 싶은 윈도우 사용자는 Stetho-Realm으로 크롬에서 확인할 수 있습니다.

* Realm Addon에서 Realm 관련된 소스를 많이 볼 수 있습니다.

### Reference

* SQLLite tutorial blog - [SQLite Tutorial: Getting Started](https://www.raywenderlich.com/123579/sqlite-tutorial-swift)
* [sqllite vs coredata vs realm](https://medium.com/@hiddenbrains/sqlite-core-data-and-realm-which-one-to-choose-for-ios-database-b12c0cd424df)
* [Realm World Tour - Seoul 세션 참고를 위한 글](http://sonim1.tistory.com/192)
* [야곰님의 Realm 사용기](https://news.realm.io/kr/news/develop-app-in-3-days-with-rmp/)

