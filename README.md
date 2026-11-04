## 📢 경매사이트 프로젝트 (MyAuct)

[![build](https://github.com/sanguk57/project-auction/actions/workflows/build.yml/badge.svg)](https://github.com/sanguk57/project-auction/actions/workflows/build.yml)

중고 물품을 경매로 사고파는 웹 사이트입니다.
판매자는 사진과 시작가·입찰 단위·경매 기간을 정해 상품을 등록하고, 구매자는 기간 안에 입찰·찜·문의 댓글을 남길 수 있습니다.

 ### 🛠 개요
  1.  개발기간 : 2023.01.19 ~ 2023.02.15 (1개월), 2026.11 리팩터링 · 최신 버전 마이그레이션
  2.  개발인원 : 개인 프로젝트
  3.  개발환경
      * 언어 / 화면 : Java 17 이상, JSP / JSTL 3.0, JavaScript (jQuery, Ajax), HTML / CSS (Bootstrap 템플릿)
      * 프레임워크 : Spring Framework 7 (Spring MVC, XML 설정, Jakarta EE 11), MyBatis 3.5
      * 주요 라이브러리 : HikariCP (커넥션 풀), Jackson 3 (JSON), Spring Security Crypto (BCrypt), Thumbnailator (썸네일), Logback, Lombok
      * 서버 : Apache Tomcat 11.0
      * DB : MySQL 8.4 / 9.7
      * 테스트 : JUnit Jupiter 6, Spring Test (MockMvc), H2 (테스트 전용 메모리 DB)
      * CI / 배포 : GitHub Actions, Docker Compose
      * 편집툴 : STS, VS Code, Sequel Pro / MySQL Workbench

 ### 🙋‍♂️ 세부설명

   [클릭](https://sang-wook.tistory.com/13)

 ### ✨ 주요 기능
  | 구분 | 기능 |
  |---|---|
  | 회원 | 회원가입(약관 동의, 아이디 중복 확인, 주소 검색), 로그인 / 로그아웃, 아이디 찾기, 비밀번호 찾기 · 변경 |
  | 상품 | 목록 · 검색(상품명 / 카테고리) + **검색어 자동완성**, **상태(진행 중 · 시작 전 · 마감) · 카테고리 필터, 정렬(마감 임박 · 최신 · 가격 · 입찰 많은 순)**, 페이징, 상세, 등록(이미지 여러 장 + 썸네일 자동 생성), 수정(**사진 한 장씩 삭제 · 추가 · 대표 사진 지정**), 삭제 |
  | 경매 | 입찰(최소 입찰가 = 현재가 + 입찰 단위), **즉시구매**, **실시간 가격 갱신(SSE)**, 경매 시작 / 마감 카운트다운, **마감 시 자동 낙찰 · 유찰 처리** |
  | 거래 | 낙찰되면 판매자 ↔ 낙찰자에게만 서로의 연락처 공개 |
  | 소통 | 상품 문의 댓글, 댓글의 답글 |
  | 마이 | **마이페이지** (입찰 내역 · 낙찰 상품 · 판매 현황 · 내 정보 수정 · 비밀번호 변경 · 회원 탈퇴), 내 등록 상품, 관심(찜) 상품 |

  **경매 규칙 (서버에서 검사)**
  - 경매 기간(시작 ~ 종료) 안에서만 입찰 가능
  - 본인이 등록한 상품에는 입찰 불가
  - 두 명이 동시에 입찰해도 한 명만 반영 (현재가가 그대로일 때만 갱신하는 조건부 UPDATE)
  - 입찰이 한 건이라도 있으면 판매자도 수정 · 삭제 불가
  - 즉시구매가 이상으로 입찰하면 즉시구매가로 바로 낙찰
  - 마감 시각이 지나면 30초마다 도는 스케줄러가 최고 입찰자에게 낙찰(입찰이 없으면 유찰) — 상세 화면을 여는 순간에도 바로 처리
  - 마감 · 낙찰 처리와 입찰이 동시에 들어와도 한쪽만 반영 (`SELECT … FOR UPDATE` + `end_chk = 'N'` 조건)
  - 진행 중인 입찰 · 판매가 있으면 회원 탈퇴 불가, 탈퇴하면 개인정보는 지우고 거래 기록만 남김

 ### 📁 프로젝트 구조
  ```
  src/main/java/com/myauct/web
   ├─ domain
   │   ├─ user          회원 (UserController, UserApi, 서비스, DAO)
   │   ├─ auctmaster    상품 · 입찰 · 이미지 (AuctMasterController, RestAPIController, FileStorageService)
   │   ├─ auctcategory  카테고리
   │   ├─ auctconcern   관심(찜) 상품
   │   ├─ auctboard     문의 댓글 · 답글
   │   └─ mypage        마이페이지 (입찰 내역 · 낙찰 · 판매 현황 · 내 정보)
   └─ global            로그인 검사 인터셉터, CSRF 필터, 공통 예외 처리, 세션 상수
  src/main/resources
   ├─ com/myauct/mappers  MyBatis 매퍼 XML
   ├─ config              app-default.properties (비밀이 아닌 기본 설정)
   └─ logback.xml
  src/main/webapp/WEB-INF
   ├─ spring              root-context.xml (DB · 서비스), servlet-context.xml (MVC · 컨트롤러)
   └─ views               JSP (aucts: 경매 화면, users: 회원 화면, include: 공통 머리글 · 바닥글)
  sql
   ├─ schema.sql          테이블 생성 (다시 실행하면 데이터가 지워짐!)
   ├─ sample-data.sql     샘플 데이터
   └─ migrations/         기존 DB 에 새 컬럼만 추가하는 스크립트 (데이터 유지)
  src/test                테스트 (H2 메모리 DB)
  .github/workflows       GitHub Actions (push 할 때마다 빌드 + 테스트)
  Dockerfile, docker-compose.yml, docker/   도커로 MySQL + 톰캣 한 번에 실행
  ```

 ### ⚙️ 실행 방법
  1. **준비** : JDK 17 이상, MySQL 8.4 이상, Apache Tomcat **11.0.x** (Tomcat 9 / 10 에서는 동작하지 않음)
  2. **DB 생성** : MySQL 에 root 로 접속해 DB 와 계정을 만든 뒤 SQL 실행
     ```sql
     CREATE DATABASE kuk2028 DEFAULT CHARACTER SET utf8mb4;
     CREATE USER 'kuk2028'@'localhost' IDENTIFIED BY '비밀번호';
     GRANT ALL PRIVILEGES ON kuk2028.* TO 'kuk2028'@'localhost';
     source sql/schema.sql
     source sql/sample-data.sql
     ```
     - Windows 명령줄에서 실행할 때는 한글이 깨지지 않도록 `mysql --default-character-set=utf8mb4 -u root -p` 로 접속
     - 샘플 계정 : `seller01`(판매자) / `buyer001` / `buyer002`, 비밀번호는 모두 `test1234!`
  3. **설정 파일** : `config/app.properties.example` 을 **`C:\myauct\app.properties`** 로 복사하고 DB 비밀번호 · 주소 검색 API 키 등을 입력
     - WAR 밖 파일이라 값을 바꾼 뒤 **서버 재시작만** 하면 반영됨 (다시 빌드할 필요 없음), 비밀번호가 WAR 에 들어가지 않음
     - 다른 위치를 쓰려면 톰캣 VM 옵션 `-Dmyauct.config=경로` 또는 환경변수 `MYAUCT_CONFIG`
     - 서버 시작 로그에 읽은 설정 파일 위치와 빠진 값이 표시됨
  4. **빌드** : `mvn clean package -DskipTests` → `target/web.war` 생성
  5. **배포** : `web.war` 를 톰캣 `webapps` 에 넣거나, VS Code 의 Community Server Connectors 에서 Add Deployment
  6. **접속** : http://localhost:8080/web/

  **예전에 만든 DB 를 쓰고 있다면** (2026.11 이전 schema.sql 로 만든 경우) 새 기능에 필요한 컬럼을 한 번 추가합니다. 데이터는 그대로 남습니다.
  ```
  mysql --default-character-set=utf8mb4 -u kuk2028 -p < sql/migrations/001-auction-end-mypage.sql
  ```

  **도커로 실행** (MySQL · 톰캣 설치 없이)
  ```
  docker compose up -d --build      # http://localhost:8080/web  (처음 뜰 때 schema + 샘플 데이터 자동 생성)
  docker compose down               # 정지 (DB 까지 지우려면 down -v)
  ```
  - 비밀번호 · 주소 검색 키는 `.env.example` 을 `.env` 로 복사해서 입력
  - 도커 MySQL 은 PC 에 설치된 MySQL 과 겹치지 않게 3307 포트로 열림

 ### 🧪 테스트
  - `mvn test` : 전체 43개 테스트. **MySQL 없이** H2 메모리 DB(MySQL 호환 모드)에 `schema.sql` + `sample-data.sql` 을 매번 새로 넣고 실행
    → 실제 DB(`kuk2028`) 데이터는 건드리지 않음 (설정 : `src/test/resources/test-app.properties`)
  | 테스트 | 내용 |
  |---|---|
  | `AuctionFlowTest` | 입찰 규칙, 동시 입찰, 즉시구매, 마감 → 낙찰 / 유찰, 마감 후 입찰 차단, 실시간 이벤트 |
  | `ProductListTest` | 상태 · 카테고리 · 검색 필터, 정렬, 개수와 목록 일치, 잘못된 정렬값 차단 |
  | `PhotoManagementTest` | 사진 삭제 · 추가 · 대표 지정, 다른 상품 사진 삭제 차단 |
  | `MyPageTest` | 입찰 내역 상태(최고가 / 밀림 / 낙찰 / 패찰), 판매 현황, 탈퇴 조건 |
  | `UserAccountTest` | 로그인, 평문 → BCrypt 변환, 비밀번호 변경, 내 정보 수정 |
  | `WebLayerTest` | CSRF 차단, 로그인 · 권한, 연락처 공개 범위, 실시간 연결 |
  | `PagingDTOTest`, `FileStorageServiceTest` | 페이징 계산, 업로드 파일 검사 |
  - GitHub 에 push 하면 GitHub Actions 가 같은 테스트를 돌리고 결과를 위 배지로 표시

 ---

 ### 🔄 변경 이력 (2026.11 리팩터링)

 #### 1. 보안
  | 문제 | 수정 |
  |---|---|
  | `/aucts/loginUser?user_id=아이디` 만으로 **비밀번호 없이 로그인** 가능 | 서버에서 비밀번호 확인 후 세션 저장, 로그인 시 세션 새로 발급 (세션 고정 공격 방지) |
  | 비밀번호 찾기에서 `unum` 만 바꿔 보내면 **남의 비밀번호 변경** 가능 | 본인 확인이 끝난 회원번호를 세션에만 보관해서 사용 |
  | `/rest/userList` 가 **전체 회원 정보(비밀번호 포함) 노출** | API 삭제 |
  | 비밀번호 **평문 저장** · 콘솔 출력 | BCrypt 암호화 (기존 평문 회원은 다음 로그인 때 자동 변환), 비밀번호 로그 출력 삭제 |
  | 입찰 · 댓글 · 찜 요청의 회원번호를 브라우저에서 받음 → **남의 이름으로 활동** 가능 | 회원번호는 로그인 세션에서만 꺼내 사용 |
  | 상품 수정 · 삭제 시 **본인 확인 없음**, 삭제가 링크(GET) | 본인 상품만 가능, 삭제는 POST, 로그인 검사 인터셉터 추가 |
  | 업로드 파일 종류 검사 없음 → **`.jsp` 웹셸 업로드** 가능 | jpg / png / gif 만 허용, 실제 이미지인지 검사, 업로드 폴더를 웹앱 밖으로 분리 |
  | 댓글 · 상품명 · 검색어 등을 그대로 출력 → **XSS** | JSP `c:out` / `fn:escapeXml`, 자바스크립트 `.text()` 로 출력 |
  | DB 비밀번호가 설정 XML 에 그대로 있음 | `app.properties` 로 분리하고 `.gitignore` 등록 |
  | log4j 1.x (지원 종료, 보안 취약점) | Logback 으로 교체 |

 #### 2. 버그 수정
  - 상품 수정 SQL 에 `=` 가 빠져 있어 수정이 항상 실패, 수정 화면이 등록 주소로 전송돼 새 상품이 생기던 문제
  - 상품 상세에 **모든 상품의 댓글**이 함께 나오던 문제 (댓글 N 개마다 쿼리 2N 번 → 쿼리 1 번)
  - 입찰자 수에 전체 상품의 입찰 건수가 들어가던 문제
  - 입찰 검증 없음 → 최소 금액 · 경매 기간 · 본인 상품 · 수량 · 동시 입찰을 서버에서 검사
  - `MAX(id)` 로 새 번호를 가져와 동시 등록 시 번호가 꼬일 수 있던 문제 → `useGeneratedKeys`
  - 목록 썸네일이 다른 상품 이미지와 섞여 나오던 문제
  - 삭제 링크 변수명 오타로 삭제가 동작하지 않던 문제
  - JSP 의 `${x == N}`, `test="${x} == Y"` 조건이 항상 거짓이라 상품 상태 · 수정 화면 선택값이 잘못 나오던 문제
  - 가격을 바꾸지 않고 수정 저장하면 빈 값이 전송돼 오류가 나던 문제
  - 업로드 경로가 특정 PC(맥) 경로로 고정, 삭제 시 다른 경로를 써서 파일이 안 지워지던 문제
  - 세션 만료 시간이 0(만료 없음) → 30분
  - 서비스 빈이 두 번 생성되던 스캔 설정, 트랜잭션 미적용 → `@Transactional` 적용

 #### 3. 최신 버전 마이그레이션
  | 항목 | 이전 | 이후 |
  |---|---|---|
  | Spring | 5.3.18 | 7.0 |
  | Servlet / JSP / JSTL | javax 4.0 / 2.1 / 1.2 | jakarta 6.1 / 4.0 / 3.0 |
  | 서버 | Tomcat 9 | Tomcat 11 |
  | MyBatis / MyBatis-Spring | 3.5.11 / 2.0.6 | 3.5.19 / 4.1 |
  | Jackson | 2.14 | 3.2 |
  | MySQL 드라이버 | mysql-connector-java 8.0 | mysql-connector-j |
  | 로깅 | log4j 1.2 | Logback 1.6 / SLF4J 2.0 |
  | 커넥션 | DriverManagerDataSource | HikariCP |
  | 테스트 | JUnit 4 | JUnit Jupiter 6 |

 #### 4. 화면 정리
  - 물류 회사 템플릿(Logis)에 남아 있던 페이지(Services, Pricing, Contact 등)와 영문 예시 문구 · 가짜 후기 · 물류 사진 삭제 (이미지 37개 → 6개)
  - 메인 화면에 이용 안내, 사이트 소개, 경매 관련 자주 묻는 질문 작성
  - 회원가입 약관을 실제 이용약관 · 개인정보 수집 동의 내용으로 작성
  - 상단 메뉴 · 바닥글 · 탭 제목 · 파비콘을 사이트에 맞게 변경
  - 이미지 업로드 화면 : gif 선택 가능, 조건에 맞지 않는 파일은 선택 해제, 미리보기 순서 수정

 #### 5. 화면 디자인 개편
  - 공통 디자인 파일 `css/myauct.css` (색 · 글꼴 · 모서리 · 그림자를 CSS 변수로 관리), 한글 글꼴 Pretendard 적용
  - **상품 카드** : 사진 · 현재가 · 입찰 수 · 남은 시간 · 상태 배지(진행 중 / 시작 전 / 마감) · 찜 하트
    - 목록 화면(메인, 전체 경매)의 중복 코드를 `include/productGrid.jsp`, `js/productList.js` 로 통합
    - 썸네일 · 카테고리를 목록 쿼리에서 함께 조회 (화면을 그린 뒤 Ajax 로 다시 요청하지 않음)
    - 진행 중인 경매 → 시작 전 → 마감 순으로 정렬
  - **상품 상세** : 사진 슬라이드 + 가격 · 입찰 박스, 실시간 남은 시간, 판매자 / 비로그인 / 시작 전 / 마감 상태별 안내
  - **상품 등록 · 수정** : 같은 폼(`include/productForm.jsp`, `js/productForm.js`)을 함께 사용
    - 기본 정보 → 사진 → 경매 조건 → 경매 기간 → 거래 방법 → 상세 설명 순서의 단계별 구성
    - 오른쪽에 목록 카드 미리보기 + 등록 버튼 고정, 금액 자동 콤마, 입찰 단위 · 경매 기간(1 / 3 / 7 / 14일) 빠른 선택
    - 전송 전 필수 항목 · 기간 · 즉시구매가 검사 후 해당 칸으로 이동, 두 번 눌러 중복 등록되는 것 방지
    - 카테고리를 화면을 그릴 때 함께 전달 (Ajax 요청 제거), 수정 화면에 현재 사진 표시
  - **로그인 · 회원가입 · 아이디 / 비밀번호 찾기** : 같은 카드 디자인으로 통일, "아이디 기억하기" 가 실제로 저장되도록 수정
  - **회원가입 정보 입력** : 계정 · 기본 정보 · 연락처로 나눈 화면, 단계 표시(약관 동의 → 정보 입력 → 가입 완료)
    - 칸마다 바로 결과 표시, 비밀번호 규칙 체크리스트, 휴대폰 번호 하이픈 자동 입력
    - 입력 순서에 따라 가입 버튼이 켜지지 않던 문제, 이름 검사 정규식 오류, 성별 미선택 시 "성별" 이 저장되던 문제 수정
    - 서버에서도 이름 · 휴대폰 번호 검사, 오류로 돌아오면 입력했던 값(비밀번호 제외)을 다시 채움
    - 중복 확인 결과가 늦게 도착하면 바꾼 아이디에 이전 결과가 표시되던 문제 수정
  - **찜(하트)** : 누르면 상단 "관심 상품 N" 이 바로 바뀜 (예전: 새로고침해야 반영), 관심 상품 목록에서 끄면 카드가 빠지고 건수도 줄어듦,
    빠르게 여러 번 눌러도 요청은 한 번씩만
  - 실제 인증 없이 화면에서 임의 숫자를 채워 넣던 "본인인증" 버튼 제거
  - 썸네일을 원본의 1/3 → 최대 640px 로 만들어 카드 사진이 흐리게 보이던 문제 수정
  - 찜 하트를 외부(카카오) 이미지 대신 Bootstrap Icons 로 교체
  - 모바일 화면(폭 390px) 대응

 #### 6. 추가
  - **검색어 자동완성** : 검색창에 입력하면 등록된 상품명 · 카테고리 중 맞는 것을 추천
    (`GET /product-api/suggest?q=`, `js/autocomplete.js`)
    - 검색어로 시작하는 것을 먼저, 그다음 상품 수가 많은 순으로 최대 8개
    - 입력이 멈춘 뒤 0.2초 후 요청 · 이전 요청 취소로 결과가 뒤섞이지 않음
    - ↑ ↓ / Enter / Esc 키보드 조작, 일치하는 글자 강조
    - 결과가 없으면 "일치하는 상품이 없어요" 안내, 한글 입력기(IME) 조합 중에도 동작하도록 input · keyup · compositionend 에서 확인
  - `sql/schema.sql`, `sql/sample-data.sql` : 테이블 생성 스크립트와 샘플 데이터
  - 공통 예외 처리(`GlobalExceptionHandler`), 사용자에게 보여줄 오류 메시지(`BusinessException`)
  - DB 없이 실행되는 단위 테스트 (파일 업로드 검사, 페이징)

 #### 7. 설정 · 운영
  - **설정 파일을 WAR 밖으로 분리**
    | 파일 | 내용 | 깃 |
    |---|---|---|
    | WAR 안 `config/app-default.properties` | 비밀이 아닌 기본값 (DB 주소, 업로드 폴더 등) | 올림 |
    | WAR 밖 `C:/myauct/app.properties` | 실제 값 (DB 비밀번호, 주소 검색 API 키) · 같은 항목이면 이 파일이 우선 | 올리지 않음 |
    - 설정을 바꾼 뒤 서버 재시작만 하면 반영 (예전: 설정이 WAR 안에 복사돼서 매번 다시 빌드해야 했음)
    - 위치 변경 : 톰캣 VM 옵션 `-Dmyauct.config=경로` 또는 환경변수 `MYAUCT_CONFIG`
    - 서버 시작 시 `ConfigReporter` 가 읽은 설정 파일 위치 · 빠진 값(DB 비밀번호 등)을 로그로 알려줌
  - **주소 검색 API** : JSP 두 곳에 서로 다른 키가 직접 적혀 있던 것을 `juso.confmKey` 설정 하나로 통일,
    키가 없으면 팝업에서 "직접 입력" 안내
  - 주소 검색 팝업이 요청값을 자바스크립트에 그대로 출력하던 XSS 수정
  - 업로드 폴더 기본값을 웹앱 밖 `C:/myauct/upload` 로 변경

 #### 8. 경매 기능 완성 · 운영 기반
  | # | 항목 | 내용 |
  |---|---|---|
  | 1 | 경매 종료 · 낙찰 | `AuctionCloseScheduler` 가 30초마다 마감된 경매를 낙찰(S) / 유찰(U) 처리, 낙찰자 · 낙찰가 · 처리 시각 저장. 상세 화면 · 목록 카드에 결과 표시, 판매자와 낙찰자에게만 상대 연락처 공개 |
  | 2 | 마이페이지 | `/my` : 입찰 내역(최고가 / 밀림 / 낙찰 / 패찰), 낙찰 상품, 판매 현황, 내 정보 수정, 비밀번호 변경, 회원 탈퇴 |
  | 3 | 즉시구매 | 상세 화면의 "즉시구매" 버튼 (`POST /product-api/buy_now`), 즉시구매가 이상 입찰 시에도 바로 낙찰(B) |
  | 4 | 실시간 가격 | `GET /product-api/stream` (Server-Sent Events). 다른 사람이 입찰하면 새로고침 없이 현재가 · 입찰 수 · 최소 입찰가가 바뀌고 알림 표시, 마감 · 낙찰도 바로 반영. 이벤트는 DB 커밋 후에만 전송 |
  | 5 | 정렬 · 필터 | 상태 탭, 카테고리 · 정렬 선택. 정렬값은 서버에서 허용 목록으로만 받아 SQL 삽입 차단, 페이지를 넘겨도 조건 유지 |
  | 6 | 사진 관리 | 수정 화면에서 사진마다 삭제 · 대표 지정, 새 사진은 뒤에 추가 (`sort_no`), 목록 썸네일도 대표 사진 |
  | 7 | CSRF 방어 | `CsrfFilter` : 세션별 토큰을 POST · PUT · DELETE 마다 검사. `js/csrf.js` 가 Ajax 헤더와 폼에 토큰을 자동으로 넣음 (주소 검색 팝업 콜백은 제외) |
  | 8 | 테스트 DB 분리 | 테스트는 H2 메모리 DB 사용 → 실제 DB 를 지우지 않음, 예전 데이터에 의존하던 테스트를 새로 작성 (43개) |
  | 9 | GitHub Actions | `.github/workflows/build.yml` : push · PR 마다 JDK 17 로 빌드 + 테스트, 실패 시 테스트 리포트 · 성공 시 WAR 업로드 |
  | 10 | Docker Compose | `docker compose up` 으로 MySQL 8.4 + Tomcat 11 실행, 처음 뜰 때 테이블 · 샘플 데이터 자동 생성 |

  - DB 변경 : `Auct_Master` 에 `win_unum`, `win_amt`, `end_date` (+ 인덱스), `Auct_FileUpload` 에 `sort_no`, `User_List` 에 `del_yn` 추가
    (`sql/migrations/001-auction-end-mypage.sql`)

 ---

 ### 📝 라이선스
  - 화면 디자인 : [Logis 템플릿](https://bootstrapmade.com/) (BootstrapMade 무료 라이선스, 바닥글의 출처 표기 유지)
