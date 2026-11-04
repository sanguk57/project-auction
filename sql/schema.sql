-- =====================================================================
--  경매 사이트 테이블 생성 스크립트 (MySQL 8.0 이상)
--
--  DTO / 매퍼 XML / JSP 를 보고 만든 스키마입니다.
--  테이블·컬럼 이름은 매퍼 XML 과 대소문자까지 똑같이 맞췄습니다.
--  (리눅스 MySQL 은 테이블 이름 대소문자를 구분합니다)
--
--  실행 순서
--   1) 아래 "DB / 계정 생성" 부분을 root 계정으로 실행
--   2) 나머지 전체를 실행 (다시 실행하면 기존 테이블과 데이터가 지워짐!)
-- =====================================================================

-- ---------------------------------------------------------------------
-- DB / 계정 생성 (처음 한 번만, root 로 실행)
-- 비밀번호는 app.properties 의 db.password 와 같게 맞추세요.
-- ---------------------------------------------------------------------
-- CREATE DATABASE IF NOT EXISTS kuk2028 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci;
-- CREATE USER IF NOT EXISTS 'kuk2028'@'localhost' IDENTIFIED BY '새비밀번호';
-- GRANT ALL PRIVILEGES ON kuk2028.* TO 'kuk2028'@'localhost';

USE kuk2028;

SET FOREIGN_KEY_CHECKS = 0;
DROP TABLE IF EXISTS Auct_Board_Memo;
DROP TABLE IF EXISTS Auct_Board;
DROP TABLE IF EXISTS Auct_Master_join;
DROP TABLE IF EXISTS Auct_Concern;
DROP TABLE IF EXISTS Auct_FileUpload;
DROP TABLE IF EXISTS Auct_Master;
DROP TABLE IF EXISTS Auct_Category;
DROP TABLE IF EXISTS User_List;
SET FOREIGN_KEY_CHECKS = 1;


-- ---------------------------------------------------------------------
-- 회원  (UserDTO / userMapper.xml)
-- ---------------------------------------------------------------------
CREATE TABLE User_List (
    unum        INT          NOT NULL AUTO_INCREMENT COMMENT '회원번호',
    user_id     VARCHAR(20)  NOT NULL                COMMENT '아이디 (영문+숫자 8~12자)',
    password    VARCHAR(100) NOT NULL                COMMENT 'BCrypt 해시 (60자)',
    name        VARCHAR(30)  NOT NULL                COMMENT '이름',
    phone       VARCHAR(20)  NOT NULL                COMMENT '전화번호 010-0000-0000',
    addr        VARCHAR(200)     NULL                COMMENT '주소',
    gender      VARCHAR(10)      NULL                COMMENT '남자 / 여자',
    email       VARCHAR(100)     NULL                COMMENT '이메일',
    age         INT              NULL                COMMENT '나이 (현재연도 - 출생연도 + 1)',
    del_yn      CHAR(1)      NOT NULL DEFAULT 'N'    COMMENT 'Y:탈퇴 (개인정보는 지우고 기록만 남김)',
    PRIMARY KEY (unum),
    UNIQUE KEY uk_user_id (user_id),
    KEY idx_user_name_phone (name, phone)             -- 아이디 찾기
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COMMENT = '회원';


-- ---------------------------------------------------------------------
-- 카테고리  (AuctCategoryDTO / auctCategoryMapper.xml)
-- ---------------------------------------------------------------------
CREATE TABLE Auct_Category (
    cnum        INT          NOT NULL AUTO_INCREMENT COMMENT '카테고리 번호',
    category    VARCHAR(50)  NOT NULL                COMMENT '카테고리 이름',
    PRIMARY KEY (cnum),
    UNIQUE KEY uk_category (category)                 -- 같은 이름 중복 방지
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COMMENT = '상품 카테고리';


-- ---------------------------------------------------------------------
-- 경매 상품  (AuctMasterDTO / auctMasterMapper.xml)
--  Y/N 값은 productEnrollment.jsp 의 select 옵션 기준
-- ---------------------------------------------------------------------
CREATE TABLE Auct_Master (
    anum        INT          NOT NULL AUTO_INCREMENT COMMENT '상품번호',
    unum        INT          NOT NULL                COMMENT '판매자 회원번호',
    cnum        INT          NOT NULL                COMMENT '카테고리 번호',
    prod_title  VARCHAR(100) NOT NULL                COMMENT '판매글 제목',
    prod_name   VARCHAR(100) NOT NULL                COMMENT '상품명',
    sales_addr  VARCHAR(200)     NULL                COMMENT '판매 지역',
    prod_type   CHAR(1)      NOT NULL DEFAULT 'N'    COMMENT 'N:새상품 Y:중고',
    as_type     CHAR(1)      NOT NULL DEFAULT 'N'    COMMENT 'Y:AS가능 N:불가',
    limit_type  CHAR(1)      NOT NULL DEFAULT 'N'    COMMENT 'Y:즉시구매 가능 N:불가',
    trans_type  CHAR(1)      NOT NULL DEFAULT 'Y'    COMMENT 'Y:택배 N:직거래',
    start_amt   INT          NOT NULL DEFAULT 0      COMMENT '현재 경매가 (입찰될 때마다 갱신)',
    limit_amt   INT          NOT NULL DEFAULT 0      COMMENT '즉시구매 가격',
    join_amt    INT          NOT NULL DEFAULT 0      COMMENT '입찰 단위(호가)',
    curr_amt    INT          NOT NULL DEFAULT 0      COMMENT '시중 판매가',
    join_cnt    INT          NOT NULL DEFAULT 0      COMMENT '입찰 횟수',
    total_cnt   INT          NOT NULL DEFAULT 1      COMMENT '판매 수량',
    auct_start  DATETIME     NOT NULL                COMMENT '경매 시작',
    auct_end    DATETIME     NOT NULL                COMMENT '경매 종료',
    contents    TEXT             NULL                COMMENT '상품 설명',
    prod_img    VARCHAR(200)     NULL                COMMENT '(미사용) 대표 이미지',
    con_html    CHAR(1)      NOT NULL DEFAULT 'N'    COMMENT '(미사용) 설명 HTML 여부',
    end_chk     CHAR(1)      NOT NULL DEFAULT 'N'    COMMENT 'N:진행(미처리) S:낙찰 U:유찰 B:즉시구매',
    win_unum    INT              NULL                COMMENT '낙찰자 회원번호',
    win_amt     INT              NULL                COMMENT '낙찰 가격',
    end_date    DATETIME         NULL                COMMENT '낙찰/유찰 처리 시각',
    delete_chk  CHAR(1)      NOT NULL DEFAULT 'N'    COMMENT '(미사용) 삭제 여부',
    reg_date    DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '등록일',
    PRIMARY KEY (anum),
    KEY idx_master_unum (unum),
    KEY idx_master_limit_amt (limit_amt),              -- 목록 정렬
    CONSTRAINT fk_master_user     FOREIGN KEY (unum) REFERENCES User_List (unum),
    KEY idx_master_end (end_chk, auct_end),            -- 마감 처리 대상 찾기
    CONSTRAINT fk_master_winner   FOREIGN KEY (win_unum) REFERENCES User_List (unum),
    CONSTRAINT fk_master_category FOREIGN KEY (cnum) REFERENCES Auct_Category (cnum)
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COMMENT = '경매 상품';


-- ---------------------------------------------------------------------
-- 상품 이미지  (AuctFileUploadDTO / auctFileUploadMapper.xml)
--  실제 파일 이름 = file_name + '_' + file_dname + file_ext
--  썸네일          = 's_' + 위 이름
-- ---------------------------------------------------------------------
CREATE TABLE Auct_FileUpload (
    fnum        INT          NOT NULL AUTO_INCREMENT COMMENT '파일번호',
    anum        INT          NOT NULL                COMMENT '상품번호',
    upload_path VARCHAR(20)  NOT NULL                COMMENT '저장 폴더 (예: 2026/11/03)',
    file_name   VARCHAR(100) NOT NULL                COMMENT '원본 파일명 (확장자 제외)',
    file_dname  VARCHAR(50)  NOT NULL                COMMENT '저장시각_랜덤값',
    file_ext    VARCHAR(10)  NOT NULL                COMMENT '.jpg .png .gif',
    sort_no     INT          NOT NULL DEFAULT 0      COMMENT '사진 순서 (작을수록 앞, 첫 번째가 대표 사진)',
    PRIMARY KEY (fnum),
    KEY idx_file_anum (anum),
    CONSTRAINT fk_file_master FOREIGN KEY (anum) REFERENCES Auct_Master (anum) ON DELETE CASCADE
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COMMENT = '상품 이미지';


-- ---------------------------------------------------------------------
-- 관심(찜) 상품  (AuctConcernDTO / auctConcernMapper.xml)
-- ---------------------------------------------------------------------
CREATE TABLE Auct_Concern (
    inum        INT          NOT NULL AUTO_INCREMENT COMMENT '번호',
    unum        INT          NOT NULL                COMMENT '회원번호',
    anum        INT          NOT NULL                COMMENT '상품번호',
    wdate       DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '찜한 날짜',
    PRIMARY KEY (inum),
    UNIQUE KEY uk_concern (unum, anum),               -- 같은 상품 중복 찜 방지
    KEY idx_concern_anum (anum),
    CONSTRAINT fk_concern_user   FOREIGN KEY (unum) REFERENCES User_List (unum),
    CONSTRAINT fk_concern_master FOREIGN KEY (anum) REFERENCES Auct_Master (anum) ON DELETE CASCADE
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COMMENT = '관심 상품';


-- ---------------------------------------------------------------------
-- 입찰 내역  (AuctMasterJoinDTO / auctMasterJoinMapper.xml)
--  입찰이 있는 상품은 서비스에서 삭제를 막으므로 ON DELETE CASCADE 를 걸지 않음
-- ---------------------------------------------------------------------
CREATE TABLE Auct_Master_join (
    jnum         INT         NOT NULL AUTO_INCREMENT COMMENT '입찰번호',
    unum         INT         NOT NULL                COMMENT '입찰자 회원번호',
    anum         INT         NOT NULL                COMMENT '상품번호',
    amount       INT         NOT NULL DEFAULT 1      COMMENT '입찰 수량',
    volume       INT         NOT NULL                COMMENT '입찰 가격',
    join_gb      CHAR(1)     NOT NULL DEFAULT 'B'    COMMENT '(미사용) B:입찰 L:즉시구매',
    cancel_chk   CHAR(1)     NOT NULL DEFAULT 'N'    COMMENT '(미사용) 취소 여부',
    join_created DATETIME    NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '입찰 시각',
    PRIMARY KEY (jnum),
    KEY idx_join_anum (anum),
    CONSTRAINT fk_join_user   FOREIGN KEY (unum) REFERENCES User_List (unum),
    CONSTRAINT fk_join_master FOREIGN KEY (anum) REFERENCES Auct_Master (anum)
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COMMENT = '입찰 내역';


-- ---------------------------------------------------------------------
-- 상품 문의 댓글  (AuctBoardDTO / auctBoardMapper.xml)
-- ---------------------------------------------------------------------
CREATE TABLE Auct_Board (
    qnum        INT           NOT NULL AUTO_INCREMENT COMMENT '댓글번호',
    unum        INT           NOT NULL                COMMENT '작성자',
    anum        INT           NOT NULL                COMMENT '상품번호',
    subject     VARCHAR(100)  NOT NULL                COMMENT '제목',
    contents    VARCHAR(1000) NOT NULL                COMMENT '내용',
    re_cnt      INT           NOT NULL DEFAULT 0      COMMENT '(미사용) 답글 수',
    views       INT           NOT NULL DEFAULT 0      COMMENT '(미사용) 조회수',
    wdate       DATETIME      NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '작성일',
    PRIMARY KEY (qnum),
    KEY idx_board_anum (anum),
    KEY idx_board_unum (unum),
    CONSTRAINT fk_board_user   FOREIGN KEY (unum) REFERENCES User_List (unum),
    CONSTRAINT fk_board_master FOREIGN KEY (anum) REFERENCES Auct_Master (anum) ON DELETE CASCADE
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COMMENT = '상품 문의 댓글';


-- ---------------------------------------------------------------------
-- 댓글의 답글  (AuctBoardMemoDTO / auctBoardMemoMapper.xml)
-- ---------------------------------------------------------------------
CREATE TABLE Auct_Board_Memo (
    mnum        INT           NOT NULL AUTO_INCREMENT COMMENT '답글번호',
    qnum        INT           NOT NULL                COMMENT '댓글번호',
    unum        INT           NOT NULL                COMMENT '작성자',
    memo        VARCHAR(1000) NOT NULL                COMMENT '내용',
    wdate       DATETIME      NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '작성일',
    PRIMARY KEY (mnum),
    KEY idx_memo_qnum (qnum),
    CONSTRAINT fk_memo_user  FOREIGN KEY (unum) REFERENCES User_List (unum),
    CONSTRAINT fk_memo_board FOREIGN KEY (qnum) REFERENCES Auct_Board (qnum) ON DELETE CASCADE
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COMMENT = '댓글의 답글';
