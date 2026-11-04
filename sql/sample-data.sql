-- =====================================================================
--  테스트용 샘플 데이터 (schema.sql 실행 직후, 빈 테이블에 실행)
--
--  테스트 계정 (비밀번호는 모두 test1234!)
--    seller01  : 판매자 - 상품 4개 등록
--    buyer001  : 구매자 - 입찰/찜/댓글
--    buyer002  : 구매자
--
--  경매 기간은 NOW() 기준이라 언제 실행해도
--  진행중 / 시작 전 / 마감 상품이 하나씩 생깁니다.
-- =====================================================================

USE kuk2028;

-- 회원 (password = BCrypt('test1234!'))
INSERT INTO User_List (unum, user_id, password, name, phone, addr, gender, email, age) VALUES
 (1, 'seller01', '$2a$10$h3Pf4D82TmLooBK0/BiJ8uGRaOGs6k0EzrAi55eClejV7MROWtyLW', '김판매', '010-1111-1111', '서울특별시 강남구 테헤란로 1', '남자', 'seller01@example.com', 30),
 (2, 'buyer001', '$2a$10$h3Pf4D82TmLooBK0/BiJ8uGRaOGs6k0EzrAi55eClejV7MROWtyLW', '이구매', '010-2222-2222', '부산광역시 해운대구 센텀로 2', '여자', 'buyer001@example.com', 27),
 (3, 'buyer002', '$2a$10$h3Pf4D82TmLooBK0/BiJ8uGRaOGs6k0EzrAi55eClejV7MROWtyLW', '박입찰', '010-3333-3333', '대구광역시 중구 동성로 3', '남자', 'buyer002@example.com', 35);

-- 카테고리
INSERT INTO Auct_Category (cnum, category) VALUES
 (1, '가전기기'),
 (2, '디지털'),
 (3, '의류'),
 (4, '도서');

-- 상품
INSERT INTO Auct_Master
 (anum, unum, cnum, prod_title, prod_name, sales_addr, prod_type, as_type, limit_type, trans_type,
  start_amt, limit_amt, join_amt, curr_amt, join_cnt, total_cnt, auct_start, auct_end, contents)
VALUES
 -- 진행중 + 입찰 2건 있음 (수정/삭제 불가 상태 확인용)
 (1, 1, 2, '아이패드 에어 5세대 팝니다', '아이패드 에어 5', '서울특별시 강남구', 'Y', 'Y', 'Y', 'Y',
  420000, 600000, 10000, 750000, 2, 1, NOW() - INTERVAL 1 DAY, NOW() + INTERVAL 6 DAY,
  '1년 사용, 기스 없음. 케이스 같이 드립니다.'),
 -- 진행중 + 입찰 없음 (입찰 / 수정 / 삭제 테스트용)
 (2, 1, 1, '미개봉 무선청소기', '무선청소기 V12', '서울특별시 강남구', 'N', 'Y', 'N', 'Y',
  200000, 0, 5000, 450000, 0, 2, NOW() - INTERVAL 2 HOUR, NOW() + INTERVAL 3 DAY,
  '선물 받은 미개봉 제품입니다. 2개 있습니다.'),
 -- 시작 전 ("아직 경매가 시작되지 않았습니다" 확인용)
 (3, 1, 3, '겨울 패딩 (L)', '롱패딩', '서울특별시 송파구', 'Y', 'N', 'N', 'N',
  50000, 0, 1000, 180000, 0, 1, NOW() + INTERVAL 1 DAY, NOW() + INTERVAL 8 DAY,
  '두 번 입었습니다. 직거래만 가능합니다.'),
 -- 마감 ("경매가 마감되었습니다" 확인용)
 (4, 1, 4, '자바 프로그래밍 책 세트', '자바의 정석 1~2권', '서울특별시 마포구', 'Y', 'N', 'N', 'Y',
  15000, 0, 500, 40000, 0, 1, NOW() - INTERVAL 10 DAY, NOW() - INTERVAL 1 DAY,
  '필기 조금 있습니다.');

-- 입찰 내역 (상품 1 : 400,000 → 410,000 → 420,000)
INSERT INTO Auct_Master_join (unum, anum, amount, volume, join_created) VALUES
 (2, 1, 1, 410000, NOW() - INTERVAL 20 HOUR),
 (3, 1, 1, 420000, NOW() - INTERVAL 5 HOUR);

-- 찜
INSERT INTO Auct_Concern (unum, anum) VALUES
 (2, 1),
 (2, 2);

-- 문의 댓글 / 답글
INSERT INTO Auct_Board (qnum, unum, anum, subject, contents) VALUES
 (1, 2, 1, '배터리 상태', '배터리 효율이 몇 % 인가요?'),
 (2, 3, 1, '직거래', '강남역에서 직거래 가능할까요?');

INSERT INTO Auct_Board_Memo (qnum, unum, memo) VALUES
 (1, 1, '92% 입니다.'),
 (2, 1, '네, 평일 저녁에 가능합니다.');
