-- 트랜잭션
CREATE TABLE employees (
    id NUMBER PRIMARY KEY,
    name VARCHAR2(50),
    salary NUMBER(8,2)
);

INSERT INTO employees VALUES (1, 'Alice', 5000);
INSERT INTO employees VALUES (2, 'Bob', 6000);
INSERT INTO employees VALUES (3, 'Charlie', 7000);

-- 조회
SELECT * FROM EMPLOYEES;
SELECT SUM(SALARY) FROM EMPLOYEES;

COMMIT; -- 변경사항을 완전히 DB에 반영

-- 트랜잭션 시작 (COMMIT하기전 언제든 ROLLBACK으로 취소 가능)
BEGIN
	-- 모든 사원들의 급여를 1000씩 올려줄거다 (모든사원이니까 WHERE절 필요없음-벌크연산)
	UPDATE EMPLOYEES SET SALARY = SALARY + 1000;
	SELECT SUM(SALARY) FROM EMPLOYEES; 	-- 급여 총합 조회
	ROLLBACK;
	SELECT SUM(SALARY) FROM EMPLOYEES; 	-- 급여 총합 조회
END;

-- DML은 ROLLBACK을 하면 이전 COMMIT으로 돌아감

-- 하나의 트랜잭션이 완벽히 끝나고 나서 커밋 되어야함, 둘 중 하나라도 안되면 롤백되어야 함
-- 예시)
UPDATE ACCOUNT SET BALANCE = BALANCE - 1000 WHERE USER_NAME = '김철수';
UPDATE ACCOUNT SET BALANCE = BALANCE + 1000 WHERE USER_NAME = '박영희';
COMMIT;


-- WHERE 조건절
SELECT EMP_NO, EMP_NM, ADDR, SEX_CD -- 컬럼 필터링은 SELECT
FROM TB_EMP
WHERE SEX_CD = 2 -- 튜플 필터링은 WHERE!
;

-- WHERE절로 PK 동등조건을 걸면 무조건 단일행이 조회된다! -- 개별조회할때 사용됨!
SELECT EMP_NO, EMP_NM, ADDR, SEX_CD -- 컬럼 필터링은 SELECT
FROM TB_EMP
WHERE EMP_NO =1000000003
;

-- 비교연산자 (90년대생만 조회)
SELECT EMP_NO, EMP_NM, BIRTH_DE, TEL_NO 
FROM TB_EMP
WHERE BIRTH_DE >= '1990101' AND BIRTH_DE <= '19991231'
;

-- BETWEEN 연산자
SELECT EMP_NO, EMP_NM, BIRTH_DE, TEL_NO 
FROM TB_EMP
WHERE BIRTH_DE BETWEEN '1990101' AND '19991231'
;

-- OR 연산
SELECT EMP_NO , EMP_NM, DEPT_CD  
FROM TB_EMP te 
WHERE DEPT_CD = '100004' OR DEPT_CD = '100006'
;

-- IN 연산자
SELECT EMP_NO , EMP_NM, DEPT_CD  
FROM TB_EMP te 
WHERE DEPT_CD IN ('100004' ,'100006')
;

-- NOT IN 연산자 (NOT = !, 괄호 안에 있는 애들 빼고 조회)
SELECT EMP_NO , EMP_NM, DEPT_CD  
FROM TB_EMP te 
WHERE DEPT_CD NOT IN ('100004' ,'100006')
;


-- LIKE연산자
-- 검색에서 주로 사용
-- 와일드 카드 맵핑(%: 0글자 이상, _: 딱 1글자)
SELECT EMP_NO, EMP_NM
FROM TB_EMP
WHERE EMP_NM LIKE '%심' --(= 쓰지말고, LIKE로 사용!)
;

SELECT EMP_NO, EMP_NM, ADDR  
FROM TB_EMP
WHERE ADDR LIKE '%용인%'
;

SELECT EMP_NO, EMP_NM
FROM TB_EMP
WHERE EMP_NM LIKE '이%'
;

SELECT EMP_NO, EMP_NM
FROM TB_EMP
WHERE EMP_NM LIKE '이__'
;

-- 성씨가 김씨이면서, 부서가 100003, 100004, 100006번 중에 하나이면서, 
-- 90년대생인 사원의 사번, 이름, 생일, 부서코드를 조회
SELECT 
	EMP_NO, 
	EMP_NM, 
	BIRTH_DE, 
	DEPT_CD 
FROM TB_EMP
WHERE 1=1 -- 완전 실무 꿀팁! (아래조건들 추가/삭제 쉽도록!)
	AND EMP_NM LIKE '김%'
	AND DEPT_CD IN ('100003', '100004', '100006') 
	AND BIRTH_DE BETWEEN '19900101' AND '19991231'
;


-- 부정일치 비교 연산자
SELECT EMP_NO, EMP_NM, ADDR, SEX_CD FROM TB_EMP
WHERE SEX_CD != 2
;

SELECT EMP_NO, EMP_NM, ADDR, SEX_CD FROM TB_EMP
WHERE SEX_CD ^= 2
;

SELECT EMP_NO, EMP_NM, ADDR, SEX_CD FROM TB_EMP
WHERE SEX_CD <> 2
;

SELECT EMP_NO, EMP_NM, ADDR, SEX_CD FROM TB_EMP
WHERE NOT SEX_CD = 2
;

-- 성별코드가 1이 아니면서 성씨가 이씨가 아닌 사람들의
-- 사번, 이름, 성별코드를 조회하세요.
SELECT EMP_NO, EMP_NM, SEX_CD 
FROM TB_EMP
WHERE 1=1
	AND SEX_CD <> 1
	AND EMP_NM NOT LIKE '이%'
;	


-- NULL값 조회
-- 반드시 IS NULL 연산자로 조회해야 한다
SELECT EMP_NO, EMP_NM, DIRECT_MANAGER_EMP_NO 
FROM TB_EMP
WHERE DIRECT_MANAGER_EMP_NO IS NULL -- = NULL 하면 안됨! (시험에 자주 출제!)
;

SELECT EMP_NO, EMP_NM, DIRECT_MANAGER_EMP_NO 
FROM TB_EMP
WHERE DIRECT_MANAGER_EMP_NO IS NOT NULL -- NOT LIKE, NOT BETWEEN 인데 요건 IS NOT NULL! (영문법주의)
;

-- 연산자 우선 순위
-- NOT > AND > OR
SELECT 
	EMP_NO , 
	EMP_NM , 
	ADDR 
FROM TB_EMP te 
WHERE 1=1
	AND EMP_NM LIKE '김%'
	AND (ADDR LIKE '%수원%' OR ADDR LIKE '%일산%')
;




