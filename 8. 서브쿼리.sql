-- # 단일행 서브쿼리
-- 단일 행 서브쿼리 (Single-row Subquery): 서브쿼리가 하나의 행만 반환하는 경우입니다. 
-- 이때, 주로 비교 연산자(=, >, <, >=, <=, <>)와 함께 사용됩니다.
--  서브쿼리의 조회 결과가 1건 이하인 경우 (1건 또는 0건)

-- 부서코드가 100004번인 부서의 사원정보 조회

SELECT 
    emp_no, emp_nm, dept_cd
FROM tb_emp
WHERE dept_cd = '100004'
;

-- 사원이름이 이나라인 사람이 속해 있는 부서의 사원정보 조회
SELECT 
    A.emp_no, A.emp_nm, A.dept_cd
FROM tb_emp A
WHERE dept_cd = (SELECT dept_cd FROM tb_emp WHERE emp_nm = '이나라')
;

-- 사원이름이 이관심인 사람이 속해 있는 부서의 사원정보 조회
-- 단일행 비교연산자(=, <>, >, >=, <, <=)는 단일행 서브쿼리로만 비교해야 함.
SELECT 
    emp_no, emp_nm, dept_cd
FROM tb_emp
WHERE dept_cd = (SELECT dept_cd FROM tb_emp WHERE emp_nm = '이관심')
;

-- 20200525에 받은 급여가 회사전체의 20200525일 
-- 전체 평균 급여보다 높은 사원들의 정보(사번, 이름, 급여지급일, 받은급여액수) 조회
-- 신입사원인데 월급 못 받은경우 inner join으로 하면 못봄, 보고 싶을 경우 outer join으로 구해야함
SELECT 
    A.emp_no, A.emp_nm, B.pay_de, B.pay_amt
FROM tb_emp A
JOIN tb_sal_his B
ON A.emp_no = B.emp_no
WHERE B.pay_de = '20200525'
    AND B.pay_amt >= (
                        SELECT AVG(pay_amt)
                        FROM tb_sal_his
                        WHERE pay_de = '20200525'
                     )
ORDER BY A.emp_no, B.pay_de
;

-- 회사 전체 20200525 급여평균
SELECT AVG(pay_amt)
FROM tb_sal_his
WHERE pay_de = '20200525'
;


-- # 다중행 서브쿼리
-- 다중 행 서브쿼리 (Multi-row Subquery): 서브쿼리가 둘 이상의 행을 반환하는 경우입니다. 
-- 이때, 다중 행 비교 연산자(IN, ANY, ALL, EXISTS, NOT EXISTS)와 함께 사용됩니다.
-- 서브쿼리의 조회 건수가 0건 이상인 것 (0건, 1건, 2건도 다 다중행. 즉, 단일행도 포함됨)
-- ## 다중행 연산자
-- 1. IN : 메인쿼리의 비교조건이 서브쿼리 결과중에 하나라도 일치하면 참 (or개념)
--    ex )  salary IN (200, 300, 400)
--            250 ->  200, 300, 400 중에 없으므로 false
-- 2. ANY, SOME : 메인쿼리의 비교조건이 서브쿼리의 검색결과 중 하나 이상 일치하면 참
--    ex )  salary > ANY (200, 300, 400)
--            250 ->  200보다 크므로 true
-- 3. ALL : 메인쿼리의 비교조건이 서브쿼리의 검색결과와 모두 일치하면 참
--    ex )  salary > ALL (200, 300, 400)
--            250 ->  200보다는 크지만 300, 400보다는 크지 않으므로 false
-- 4. EXISTS : 메인쿼리의 비교조건이 서브쿼리의 결과 중 만족하는 값이 하나라도 존재하면 참


-- 한국데이터베이스진흥원에서 발급한 자격증을 가지고 있는
-- 사원의 사원번호와 사원이름과 해당 사원의 한국데이터베이스진흥원에서 
-- 발급한 자격증 개수를 조회

SELECT certi_cd 
FROM tb_certi 
WHERE issue_insti_nm = '한국데이터베이스진흥원'
;

SELECT 
    A.emp_no, A.emp_nm, COUNT(B.certi_cd) "자격증 개수"
FROM tb_emp A
JOIN tb_emp_certi B
ON A.emp_no = B.emp_no
WHERE B.certi_cd IN (
                        SELECT certi_cd 
                        FROM tb_certi 
                        WHERE issue_insti_nm = '한국데이터베이스진흥원'
                    )
GROUP BY A.emp_no, A.emp_nm
ORDER BY A.emp_no
;

-- ANY는 대소에 많이 씀(<, >) ('= ANY'는 'IN'이랑 같음)
-- ALL은 한국데이터베이스진흥원꺼 다 딴 사람만 조회됨
SELECT 
    A.emp_no, A.emp_nm, COUNT(B.certi_cd) "자격증 개수"
FROM tb_emp A
JOIN tb_emp_certi B
ON A.emp_no = B.emp_no
WHERE B.certi_cd = ANY (
                        SELECT certi_cd 
                        FROM tb_certi 
                        WHERE issue_insti_nm = '한국데이터베이스진흥원'
                    )
GROUP BY A.emp_no, A.emp_nm
ORDER BY A.emp_no
;


-- EXISTS문 : 메인쿼리의 비교조건이 서브쿼리의 결과 중 만족하는 값이 하나라도 존재하면 참
-- 주소가 강남인 직원들이 근무하고 있는 부서정보를 조회 (부서코드, 부서명)

-- exists 조건에 매칭 된것
-- not exists 조건에 매칭 되지 않은 것들

SELECT emp_no, emp_nm, addr, dept_cd
FROM tb_emp 
WHERE addr LIKE '%강남%'
;

SELECT dept_cd, dept_nm
FROM tb_dept
WHERE dept_cd IN ('100009', '100010')
;

SELECT dept_cd, dept_nm
FROM tb_dept 
WHERE dept_cd IN (
                    SELECT dept_cd
                    FROM tb_emp 
                    WHERE addr LIKE '%강남%'
                )
;

SELECT 
    1
-- 'abc'
-- EMP_NM 
FROM tb_emp
WHERE addr LIKE '%강남%'
;


SELECT A.dept_cd, A.dept_nm
FROM tb_dept A
WHERE EXISTS (
--WHERE NOT EXISTS (
                    SELECT 
                        1
                    FROM tb_emp B
                    WHERE addr LIKE '%강남%'
                        AND A.dept_cd = B.dept_cd
                )
ORDER BY 1
;

-- # 다중 컬럼 서브쿼리
--  : 서브쿼리의 조회 컬럼이 2개 이상인 서브쿼리

-- 부서원이 2명 이상인 부서 중에서 각 부서의 
-- 가장 연장자의 사번과 이름 생년월일과 부서코드를 조회

SELECT 
    A.emp_no, A.emp_nm, A.birth_de, A.dept_cd, B.dept_nm
FROM tb_emp A
JOIN tb_dept B
ON A.dept_cd = B.dept_cd
WHERE (A.dept_cd, A.birth_de) IN (
                        SELECT 
                            dept_cd, MIN(birth_de)
                        FROM tb_emp
                        GROUP BY dept_cd
                        HAVING COUNT(*) >= 2
                    )
ORDER BY A.emp_no
;


-- 인라인 뷰 서브쿼리 (FROM절에 쓰는 서브쿼리)

-- 각 사원의 사번과 이름과 평균 급여정보를 조회하고 싶다.
SELECT 
    A.emp_no, A.emp_nm, B.pay_avg
FROM tb_emp A, (
-- FROM tb_emp A JOIN (
                 SELECT 
                    emp_no, AVG(pay_amt) AS pay_avg
                 FROM tb_sal_his
                 GROUP BY emp_no
                    ) B
WHERE A.emp_no = B.emp_no
ORDER BY A.emp_no
;

-- JOIN은 중첩반복문 때문에 성능상 좋지 않음 (190번라인)
-- 그래서 결과는 똑같지만 성능 최적화를 생각해서 서브쿼리를 작성 (190번 라인 = 175번 라인)
SELECT 
    A.emp_no, A.emp_nm, AVG(B.PAY_AMT)
FROM tb_emp A 
JOIN TB_SAL_HIS B
ON A.emp_no = B.emp_no
GROUP BY A.EMP_NO, A.EMP_NM 
ORDER BY A.emp_no
;


-- # 스칼라 서브쿼리 
-- 하나의 행과 하나의 열을 반환하는 서브쿼리
-- 사원의 사번, 사원명, 부서명, 생년월일, 성별코드를 조회
-- 결과적으로 하나의 값을 반환하며, 이 값은 주로 표현식이나 비교 연산자와 함께 사용
-- ELECT, WHERE, HAVING, UPDATE 등과 같은 다양한 절에서 사용
SELECT 
    A.emp_no
    , A.emp_nm
    , (SELECT B.dept_nm FROM tb_dept B WHERE A.dept_cd = B.dept_cd) AS dept_nm
    , A.birth_de
    , A.sex_cd
FROM tb_emp A
;

-- # 인라인 뷰 서브쿼리 (Inline View Subquery) = 다이나믹 뷰 (동적뷰)
-- 인라인 뷰 서브쿼리는 FROM 절에서 사용되며, 가상 테이블을 생성하는 데 사용
-- 인라인 뷰는 서브쿼리의 결과를 임시 테이블처럼 사용하여 다른 테이블과 조인할 수 있습니다. 
-- 인라인 뷰는 주로 복잡한 질의를 단순화하거나, 중간 결과를 생성하여 성능을 향상시키는 데 사용

SELECT 
    emp_nm, null
FROM tb_emp;