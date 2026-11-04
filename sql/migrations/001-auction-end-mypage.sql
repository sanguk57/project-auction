-- =====================================================================
--  기존 DB 를 새 기능(낙찰 처리 · 즉시구매 · 사진 순서 · 회원 탈퇴)에 맞게 바꾸는 스크립트
--  - 컬럼만 추가한다. 기존 데이터는 지우거나 바꾸지 않는다.
--  - 한 번만 실행 (이미 실행했으면 "Duplicate column" 오류가 나고 아무것도 바뀌지 않음)
--  - schema.sql 로 새로 만든 DB 에는 실행할 필요 없음 (이미 포함)
-- =====================================================================
USE kuk2028;

ALTER TABLE Auct_Master
    MODIFY COLUMN end_chk CHAR(1) NOT NULL DEFAULT 'N' COMMENT 'N:진행(미처리) S:낙찰 U:유찰 B:즉시구매',
    ADD COLUMN win_unum INT NULL COMMENT '낙찰자 회원번호' AFTER end_chk,
    ADD COLUMN win_amt INT NULL COMMENT '낙찰 가격' AFTER win_unum,
    ADD COLUMN end_date DATETIME NULL COMMENT '낙찰/유찰 처리 시각' AFTER win_amt,
    ADD KEY idx_master_end (end_chk, auct_end),
    ADD CONSTRAINT fk_master_winner FOREIGN KEY (win_unum) REFERENCES User_List (unum);

ALTER TABLE Auct_FileUpload
    ADD COLUMN sort_no INT NOT NULL DEFAULT 0 COMMENT '사진 순서 (작을수록 앞, 첫 번째가 대표 사진)' AFTER file_ext;

ALTER TABLE User_List
    ADD COLUMN del_yn CHAR(1) NOT NULL DEFAULT 'N' COMMENT 'Y:탈퇴 (개인정보는 지우고 기록만 남김)' AFTER age;
