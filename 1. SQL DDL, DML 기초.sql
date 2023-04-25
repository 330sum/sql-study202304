-- 테이블(엔터티) 생성
-- 성적정보 저장 테이블

CREATE TABLE TBL_SCORE (
	NAME VARCHAR2(4) NOT NULL,
	KOR NUMBER(3) NOT NULL CHECK(KOR>0 AND KOR<=100),
	ENG NUMBER(3) NOT NULL CHECK(ENG>0 AND ENG<=100),
	MATH NUMBER(3) NOT NULL CHECK(MATH>0 AND MATH<=100),
	TOTAL NUMBER(3) NULL, 
	AVARAGE NUMBER(5,2),
	GRADE CHAR(1),
	STU_NUM NUMBER(6),
	-- PK 거는법 (테이블 생성시)
	CONSTRAINT PK_STU_NUM PRIMARY KEY (STU_NUM)
	);

-- 테이블 생성 후 PK 적용하기
ALTER TABLE TBL_SCORE 
ADD CONSTRAINT PK_STU_NUM PRIMARY KEY (STU_NUM);

-- 컬럼 추가하기
ALTER TABLE TBL_SCORE ADD (SCO NUMBER(3) NOT NULL);
-- 컬럼 제거하기
ALTER TABLE TBL_SCORE DROP COLUMN SCO;

-- 테이블 복사(TB_EMP)
-- CTAS (CREATE TABLE AS의 줄임말)
CREATE TABLE TB_EMP_COPY AS SELECT * FROM TB_EMP;

-- 복사 테이블 조회
SELECT * FROM TB_EMP_COPY;
SELECT * FROM TB_EMP;

-- 테이블 제거 DROP TABLE (ROLLBACK으로 복구안됨)
DROP TABLE TB_EMP_COPY;

-- TRUNCATE TABLE 
-- 구조는 냅두고, 내부 데이터만 전체 삭제 (ROLLBACK으로 복구안됨)
TRUNCATE TABLE TB_EMP_COPY;



-- 예시 테이블
CREATE TABLE GOODS (
	ID NUMBER(6) PRIMARY KEY,
	G_NAME VARCHAR2(10) NOT NULL,
	PRICE NUMBER(10) DEFAULT 1000,
	REG_DATE DATE
);

SELECT * FROM GOODS;

-- INSERT
-- 필드에 적힌대로 안적고 순서 바뀌어도 되는데 VALUES는 똑같은 순서!
INSERT INTO GOODS (ID, G_NAME, PRICE, REG_DATE) 
VALUES (1, '선풍기', 120000, SYSDATE);

INSERT INTO GOODS (ID, G_NAME, REG_DATE) 
VALUES (2, '달고나', SYSDATE);

INSERT INTO GOODS (ID, G_NAME, PRICE) 
VALUES (3, '후리', 500);

-- 컬럼명 생략 시 VALUES의 컬럼순서도 똑같아야 함.
-- 근데 컬럼명 쓸 필요없다고 하더라도 다 넣는거 추천! 왜? 나중에 추가되거나 삭제되는 경우를 대비해서 적어놓기!
INSERT INTO GOODS
VALUES (4, '세탁기', 10000, SYSDATE)

INSERT INTO GOODS (G_NAME, ID, PRICE) 
VALUES 
	('후리1', 5, 500),
	('후리2', 6, 1500),
	('후리3', 7, 5300);
	
SELECT * FROM GOODS;


-- 수정 UPDATE
-- 한칸삭제(NULL로 UPDATE)
UPDATE GOODS SET G_NAME = '냉장고' WHERE ID = 3;

UPDATE GOODS SET G_NAME = '콜라', PRICE = 3000 WHERE ID = 2;

UPDATE GOODS SET PRICE = 9999;
-- WHERE을 안 쓰면 모든 PRICEC가 9999로 변경됨 (벌크연산)
-- 벌크연산은 언제 사용하면 좋냐?! 한 해가 지나가면 회원모두 나이 1살 올리기, 전제품 10% 할인
-- DML은 복구가 쉬움
UPDATE TBL_USER SET AGE = AGE + 1;


-- 행 삭제 DELETE 
DELETE FROM GOODS WHERE ID = 3;

-- 금액 9999된 행들 다 삭제됨
DELETE FROM PRICE = 9999;

-- 모든 행 삭제
DELETE FROM GOODS; 

SELECT * FROM GOODS;


-- SELECT 조회
SELECT CERTI_CD, CERTI_NM, ISSUE_INSTI_NM FROM TB_CERTI;

SELECT ALL CERTI_NM, ISSUE_INSTI_NM, CERTI_CD FROM TB_CERTI;

SELECT CERTI_NM, ISSUE_INSTI_NM FROM TB_CERTI;

-- 중복 제거 DISTINCT (SELECT 뒤에 아무것도 안쓰면 ALL이 기본값임 - 생략가능)
SELECT DISTINCT ISSUE_INSTI_NM FROM TB_CERTI;

-- 모든 컬럼 조회
-- 실무에서는 사용하지 마세요 (구조가 바뀔 가능성이 있기 때문에, 또는 조회순서 배치를 다르게 해달라고 하는 경우가 있기 때문)
SELECT * FROM TB_CERTI;

-- 열 별칭 부여 (ALIAS)
-- AS 생략가능 / 띄어쓰기 없으면 "" 생략가능
SELECT te.EMP_NM AS "사원명", te.ADDR "사원의 거주지 주소" FROM TB_EMP te;

-- 문자열 연결하기 (+ 기호 아니고, ||와 '' 임! 오라클만 이렇게 씀)
SELECT 
	CERTI_NM || '(' || ISSUE_INSTI_NM || ')' AS "자격증 정보"
FROM TB_CERTI;


-- [ ON DELETE 옵션 ]
-- 1. Cascading : 참조된 레코드가 삭제될 때 해당 레코드를 참조하는 다른 레코드도 함께 삭제
-- 2. Restrict : 참조된 레코드가 삭제될 때 해당 레코드를 참조하는 다른 레코드를 삭제하지 않음!
-- 3. Set Null : 참조된 레코드가 삭제될 때 해당 레코드를 참조하는 다른 레코드의 컬럼 값을 null로 설정
-- 4. Set Default : 참조된 레코드가 삭제될 때 해당 레코드를 참조하는 다른 레코드의 컬럼 값을 기본값으로 설정



-- [ DROP TABLE, TRUNCATE TABLE, DELETE FROM ]
-- DROP TABLE
--    - 데이터베이스에서 테이블을 완전히 삭제
--    - 테이블과 그 테이블에 관련된 모든 데이터, 인덱스, 제약 조건, 트리거, 권한 등을 제거
--    - 복구 불가
-- TRUNCATE TABLE
--    - 테이블의 모든 데이터를 빠르게 삭제 (TRUNCATE는 NEW해서 빈 객체를 끼우는 것과 같은 효과)
--    - 테이블의 구조, 인덱스, 제약 조건 등은 그대로 유지하면서 오직 데이터만 삭제
--    - TRUNCATE는 롤백이 불가능하며, DELETE 문보다 더 빠르게 데이터를 삭제
--    - 사용용도: 테스트로 쓰던 임시테이블 날리기 (로그 안남기고 싶을 때)
-- DELETE FROM
--    - DELETE는 한줄씩 반복해서 삭제
--    - 회원 탈퇴시 현재 테이블에서는 지워졌지만, 다른 테이블로 insert 해놓기.(트리거 같은 역할을 하게됨) 회원탈퇴취소 30일 안에 요청하면 복구 가능
--    - 사용용도: 조건 걸어서 지울 때 (로그 남기고 싶을때)