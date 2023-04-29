SELECT EMP_NO , EMP_NM , DEPT_CD 
FROM TB_EMP te;

SELECT DEPT_CD , DEPT_NM 
FROM TB_DEPT td ;


-- 사원들의 사번, 이름, 주소, 부서명
SELECT 
    E.emp_no, E.emp_nm, E.addr, D.dept_nm
FROM tb_emp E 
JOIN tb_dept D
ON E.dept_cd = D.dept_cd
;

-- 조인 기초 테스트 데이터
CREATE TABLE TEST_A ( -- 게시물
    id NUMBER(10) PRIMARY KEY
    , content VARCHAR2(200)
); 
CREATE TABLE TEST_B ( -- 댓글
    b_id NUMBER(10) PRIMARY KEY
    , reply VARCHAR2(100)
    , a_id NUMBER(10)
);

INSERT INTO TEST_A  VALUES (1, 'aaa');
INSERT INTO TEST_A  VALUES (2, 'bbb');
INSERT INTO TEST_A  VALUES (3, 'ccc');

INSERT INTO TEST_B  VALUES (1, 'ㄱㄱㄱ', 1);
INSERT INTO TEST_B  VALUES (2, 'ㄴㄴㄴ', 1);
INSERT INTO TEST_B  VALUES (3, 'ㄷㄷㄷ', 2);
INSERT INTO TEST_B  VALUES (4, 'ㄹㄹㄹ', 3);
COMMIT;

SELECT * FROM test_a;
SELECT * FROM test_b;

-- JOIN 가로연결 (A컬럼 + B컬럼)
-- 중첩반복문의 형태 (A튜플 * B튜플)
-- FROM에서 , , 콤마로 연결하는 것 오라클 전용 조인문법임
-- CROSS JOIN, 카테시안 곱(cartesian product)
SELECT 
    *
FROM test_a, test_b
-- WHERE TEST_A.ID = TEST_B.A_ID
;

-- WHERE조건이 없으면 cross join이 되어서(카테시안 곱으로)원하는 데이터가 나오지 않음
SELECT 
	TB_EMP.EMP_NO , 
	TB_EMP.EMP_NM , 
	TB_EMP.DEPT_CD ,
	TB_DEPT.DEPT_CD , 
	TB_DEPT.dept_nm
FROM TB_EMP, TB_DEPT
WHERE TB_EMP.DEPT_CD = TB_DEPT.DEPT_CD;

-- INNER JOIN (EQUI JOIN의 한 종류)
SELECT 
    *
FROM test_a, test_b
WHERE test_a.id = test_b.a_id -- 조인 조건
;

SELECT 
    test_a.id, test_a.content, test_b.reply
FROM test_a, test_b
WHERE test_a.id = test_b.a_id 
;

SELECT 
    A.id, A.content, B.reply
FROM test_a A, test_b B
WHERE A.id = B.a_id 
;


-- 자격증 관련 테이블
SELECT * FROM tb_emp;
SELECT * FROM tb_emp_certi;
SELECT * FROM tb_certi;


-- 사원의 사원번호와 취득 자격증명을 조회하고 싶음
SELECT
     A.emp_no, 
     B.certi_nm,
     A.CERTI_CD,
     B.CERTI_CD 
FROM tb_emp_certi A, tb_certi B
WHERE A.certi_cd = B.certi_cd -- 이너 조인
ORDER BY A.emp_no, B.certi_cd
;

-- 사원의 사원번호와 사원이름과 취득 자격증명을 조회하고 싶음
SELECT
    A.emp_no, C.emp_nm, B.certi_nm
FROM tb_emp_certi A, tb_certi B, tb_emp C
WHERE A.certi_cd = B.certi_cd
    AND A.emp_no = C.emp_no
ORDER BY A.emp_no, B.certi_cd
;

-- 조인테이블이 2개면 조건이 1개, 조인테이블이 3개면 조건도 2개 ...

-- 사원의 사원번호와 사원이름과 부서이름과 취득 자격증명을 조회하고 싶음
SELECT
    A.emp_no, C.emp_nm, D.dept_nm, B.certi_nm
FROM tb_emp_certi A, tb_certi B, tb_emp C, tb_dept D
WHERE A.certi_cd = B.certi_cd
    AND A.emp_no = C.emp_no
    AND C.dept_cd = D.dept_cd
ORDER BY A.emp_no, B.certi_cd
;


-- 부서별 총 자격증 취득 수를 조회

SELECT 
    B.dept_cd, C.dept_nm, COUNT(A.certi_cd) "부서별 자격증 수"
FROM tb_emp_certi A, tb_emp B, tb_dept C
WHERE A.emp_no = B.emp_no
    AND B.dept_cd = C.dept_cd
GROUP BY B.dept_cd, C.dept_nm
ORDER BY B.dept_cd
;


-- # INNER JOIN
-- PK와 FK가 같은 것
-- 1. 2개 이상의 테이블이 공통된 컬럼에 의해 논리적으로 결합되는 조인기법입니다.
-- 2. WHERE절에 사용된 컬럼들이 동등연산자(=)에 의해 조인됩니다.

-- 용인시에 사는 사원의 사원번호, 사원명, 주소, 부서코드, 부서명을 조회하고 싶다.

-- 오라클 조인조건은 FROM에 콤마로 나열하고 WHERE에 = 해서 들어가서 구분하기가 어려워져서 ANSI에 
SELECT 
    A.emp_no, A.emp_nm, A.addr, A.dept_cd, B.dept_nm
FROM tb_emp A, tb_dept B
WHERE A.addr LIKE '%용인%'
    AND A.dept_cd = B.dept_cd
--    AND A.emp_nm LIKE '김%'
ORDER BY A.emp_no
;

-- JOIN ON (ANSI 표준 조인)
-- 1. FROM절 뒤, WHERE 절 앞
-- 2. JOIN 키워드 뒤에는 조인할 테이블명을 명시
-- 3. ON 키워드 뒤에는 조인 조건을 명시
-- 4. 조인 조건 서술부(ON절) 일반 조건 서술부 (WHERE절)를 분리해서 작성하는 방법
-- 5. ON절을 이용하면 JOIN 이후의 논리연산이나 서브쿼리와 같은 추가 서술이 가능
-- 그냥 JOIN만 쓰면 INNER JOIN임

SELECT 
    A.emp_no, A.emp_nm, A.addr, A.dept_cd, B.dept_nm
FROM tb_emp A JOIN tb_dept B
ON A.dept_cd = B.dept_cd
WHERE A.addr LIKE '%용인%'
    AND A.emp_nm LIKE '김%'
ORDER BY A.emp_no
;

SELECT 
    A.emp_no, A.emp_nm, A.addr, A.dept_cd, B.dept_nm
FROM tb_emp A
INNER JOIN tb_dept B
ON A.dept_cd = B.dept_cd
WHERE A.addr LIKE '%용인%'
    AND A.emp_nm LIKE '김%'
ORDER BY A.emp_no
;


-- 1980년대생 사원들의 사번, 사원명, 부서명, 자격증명, 취득일자를 조회
SELECT
    E.emp_no, E.emp_nm, E.birth_de, D.dept_nm, C.certi_nm, EC.acqu_de
FROM tb_emp E, tb_dept D, tb_emp_certi EC, tb_certi C
WHERE E.dept_cd = D.dept_cd
    AND EC.certi_cd = C.certi_cd
    AND E.emp_no = EC.emp_no
    AND E.birth_de BETWEEN '19800101' AND '19891231'
;

SELECT
    E.emp_no, E.emp_nm, E.birth_de, D.dept_nm, C.certi_nm, EC.acqu_de
FROM tb_emp E 
JOIN tb_dept D 
ON E.dept_cd = D.dept_cd
JOIN tb_emp_certi EC 
ON E.emp_no = EC.emp_no
JOIN tb_certi C
ON EC.certi_cd = C.certi_cd
WHERE E.birth_de BETWEEN '19800101' AND '19891231'
;


-- SELECT [DISTINCT] { 열이름 .... } 
-- FROM  테이블 또는 뷰 이름
-- JOIN  테이블 또는 뷰 이름
-- ON    조인 조건
-- WHERE 조회 조건
-- GROUP BY  열을 그룹화
-- HAVING    그룹화 조건
-- ORDER BY  정렬할 열 [ASC | DESC];



-- JOIN ON 구문으로 카테시안 곱 만들기
SELECT 
    *
FROM test_a A, test_B b
;

SELECT 
    *
FROM test_a A 
CROSS JOIN test_B b
;


-- # NATURAL JOIN
-- 두테이블의 PK FK가 완전 동일한 경우, ON절을 쓰지않아도 알아서 조인해줌!
-- 주의! 두테이블을 조인하면 컬럼+컬럼인데 PK=FK인 컬럼 하나로 합쳐져서 나와서 하나를 뺌! (시험자주등장)
-- 또, PK=FK인 컬럼 앞에는 특정하게 정의 불가능 246번라인 (시험자주등장 - 여기서 오류나는걸 찾아라 이런식)
-- 근데, 함부로 쓰면 안되는 이유? PK=FK가 1개인 경우에는 inner join과 같은 결과를 주지만,
-- 근데, PK=FK가 2개 이상이면 natural이 다 해버림 그래서 inner join과 결과가 다를 수 있음
 
-- 1. NATURAL JOIN은 동일한 이름을 갖는 컬럼들에 대해 자동으로 조인조건을 생성하는 기법입니다.
-- 2. 즉, 자동으로 2개 이상의 테이블에서 같은 이름을 가진 컬럼을 찾아 INNER조인을 수행합니다.
-- 3. 이 때 조인되는 동일 이름의 컬럼은 데이터 타입이 같아야 하며, 
--    ALIAS나 테이블명을 자동 조인 컬럼 앞에 표기하면 안됩니다. --246번라인
-- 4. SELECT * 문법을 사용하면, 공통 컬럼은 집합에서 한번만 표기됩니다.
-- 5. 공통 컬럼이 n개 이상이면 조인 조건이 n개로 처리됩니다.

-- 사원 테이블과 부서 테이블을 조인 (사번, 사원명, 부서코드, 부서명)
-- 컬럼 15개 (inner join)
SELECT 
    A.emp_no, A.emp_nm, B.dept_cd, B.dept_nm 
FROM tb_emp A
INNER JOIN tb_dept B
ON A.dept_cd = B.dept_cd
;


-- 컬럼 14개 (natural join)
SELECT
    A.emp_no, A.emp_nm, dept_cd, B.dept_nm -- dept_cd앞에 A또는 B라고 특정하게 정의하면 안됨
FROM tb_emp A
NATURAL JOIN tb_dept B
;

-- # USING절 조인
-- 1. NATURAL조인에서는 자동으로 이름과 타입이 일치하는 모든 컬럼에 대해
--    조인이 일어나지만 USING을 사용하면 원하는 컬럼에 대해서면 선택적 조인조건을 부여할 수 있습니다.
-- 2. USING절에서도 조인 컬럼에 대해 ALIAS나 테이블명을 표기하시면 안됩니다.
SELECT 
    A.emp_no, A.emp_nm, dept_cd, B.dept_nm
FROM tb_emp A
INNER JOIN tb_dept B
USING (dept_cd)
;


SELECT 
    *
FROM tb_emp A
INNER JOIN tb_dept B
ON A.dept_cd = B.dept_cd
;


SELECT 
    *
FROM tb_emp A
NATURAL JOIN tb_dept B
;

SELECT 
    *
FROM tb_emp A
INNER JOIN 
