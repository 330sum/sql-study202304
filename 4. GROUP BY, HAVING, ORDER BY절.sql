-- 집계 함수 (다중행 함수) = 통계함수
-- : 여러 행을 묶어서 함수를 적용

-- 모든사원의 지급이력 (984건)
SELECT * FROM tb_sal_his;

-- 2019년도의 지급이력 
SELECT * FROM tb_sal_his
WHERE pay_de BETWEEN '20190101' AND '20191231'
ORDER BY emp_no, pay_de
;

-- 5번사원의 총 월급지급이력
SELECT * FROM tb_sal_his
WHERE emp_no = '1000000005'
;

SELECT
    SUBSTR(emp_nm, 1, 1) 성씨   
FROM tb_emp
;


-- GROUP BY로 소그룹화 하지 않으면 집계함수는 전체행수를 기준으로 집계한다.
-- 그룹바이 안쓰면 각 컬럼에 있는 행을 다 합쳐서 결과냄
SELECT 
    SUM(pay_amt) "지급 총액"
    , AVG(pay_amt) "평균 지급액"
    , COUNT(pay_amt) "지급 횟수"
FROM tb_sal_his
;

SELECT * FROM tb_emp;


-- COUNT로 특정컬럼을 지정해서 세면 null은 세지 않음
-- 근데 COUNT * 하면 null도 다 셈
-- 총합을 구할때도 null 빼고 함, 
-- 평균구할때도 null 빼고 함 (41개중 2개 null이면 39개 더하고 39로 나눔)
-- 즉, COUNT* 빼고 다 NULL값 제외
SELECT 
    COUNT(emp_no) AS "총 사원수"
    , COUNT(direct_manager_emp_no) "dmen"
    , COUNT(*) 
    , MIN(birth_de) "최연장자의 생일" -- 일찍 태어날 수록 연장자 1983<1993
    , MAX(birth_de) "최연소자의 생일"
FROM tb_emp;


SELECT 
    direct_manager_emp_no
FROM tb_emp;


-- GROUP BY : 지정된 컬럼으로 소그룹화 한 후 집계함수 적용
-- 부서별로 가장 어린사람의 생년월일, 연장자의 생년월일 부서별 총 사원 수를 조회

SELECT EMP_NO, EMP_NM, BIRTH_DE, DEPT_CD 
FROM tb_emp
ORDER BY dept_cd
;

SELECT 
    dept_cd
    , MAX(birth_de) 최연소자
    , MIN(birth_de) 최연장자
    , COUNT(emp_no) 직원수
FROM tb_emp
GROUP BY dept_cd
ORDER BY dept_cd
;

-- 
SELECT *
FROM TB_SAL_HIS
ORDER BY EMP_NO, PAY_DE 
;

-- where가 없으면 벌크연산됨 전체의 총급여내역 합계가 1건 나옴
SELECT SUM(pay_amt)
FROM TB_SAL_HIS
;

-- 사원별 누적 급여수령액 조회
-- GROUP BY는 emp_no끼리 묶어서 총급여내역 알려주겠다
SELECT 
    emp_no "사번"
    , SUM(pay_amt) "누적 수령액"
FROM tb_sal_his
GROUP BY emp_no
ORDER BY emp_no
;

-- 사원별로 급여를 제일 많이받았을 때, 제일 적게받았을 때, 평균적으로 얼마받았는지 조회
-- GROUP BY로 사번으로 묶고, 단일행함수로 각각 준거임
-- 그룹화를 하면 그룹함수를 써야지 
SELECT 
    emp_no "사번"
    , TO_CHAR(MAX(pay_amt), 'L999,999,999') "최고 수령액"
    , TO_CHAR(MIN(pay_amt), 'L999,999,999') "최저 수령액"
    , TO_CHAR(ROUND(AVG(pay_amt), 2), 'L999,999,999.99') "평균 수령액"
    -- , ROUND(pay_amt, 2) -- 984개
FROM tb_sal_his
GROUP BY emp_no
ORDER BY emp_no
;


SELECT 
	EMP_NO, 
	EMP_NM, 
	DEPT_CD  
FROM TB_EMP -- 41명 사원
;

SELECT EMP_NO, EMP_NM, DEPT_CD  
FROM TB_EMP 
GROUP BY DEPT_CD -- 41명 사람, 부서 14개 --> 에러 추릴수 없음
;

-- 그룹바이한 컬럼은 다이렉트로 조회가능
-- 그 외에는 집계함수를 써야 조회 가능 위에꺼 처럼 하면 에러남
SELECT 
	DEPT_CD  
FROM TB_EMP -- 41명 사원
GROUP BY DEPT_CD
;

SELECT 
	(MAX)EMP_NO, -- 가장 큰 사원번호
	DEPT_CD  
FROM TB_EMP -- 41명 사원
GROUP BY DEPT_CD 
;

-- 아래 것 됨
SELECT 
	EMP_NO, 
FROM TB_EMP
GROUP BY EMP_NO 
;

-- 아래 것 안됨!!!(이거 시험 출제율 높음)
-- 그룹바이 안되면 다이렉트로 못씀
SELECT 
	EMP_NO, 
	EMP_NM, 
FROM TB_EMP
GROUP BY EMP_NO 
;

-- 아래 것 됨!
SELECT 
	EMP_NO, 
	EMP_NM, 
FROM TB_EMP
GROUP BY EMP_NO, EMP_NM
;

-- 만약 윗윗 꺼 쓰고 싶으면 그룹함수 써야함
SELECT 
	EMP_NO, 
	--EMP_NM, 
FROM TB_EMP
GROUP BY EMP_NO 
;





-- 사원별로 2019년에 급여를 제일 많이받았을 때, 제일 적게받았을 때, 평균적으로 얼마받았는지 조회
-- GROUP BY절에 있는 WHERE절은 그룹화 하기 전에 필터링
-- 즉, WHERE 다음에 GROUP BY

SELECT 
    emp_no "사번"
    , TO_CHAR(MAX(pay_amt), 'L999,999,999') "최고 수령액"
    , TO_CHAR(MIN(pay_amt), 'L999,999,999') "최저 수령액"
    , TO_CHAR(ROUND(AVG(pay_amt), 2), 'L999,999,999.99') "평균 수령액"
    , TO_CHAR(SUM(pay_amt), 'L999,999,999') "연봉"
FROM tb_sal_his
--WHERE pay_de BETWEEN '20190101' AND '20191231'
GROUP BY emp_no
ORDER BY emp_no
;


-- HAVING : 그룹화된 결과에서 조건을 걸어 행 수를 제한
-- 그룹화해서 통계 낸 이후에 필터링

-- WHERE -> 통계 전 GROUP BY 통계 후 -> HAVING (조건)

-- 부서별로 가장 어린사람의 생년월일, 연장자의 생년월일, 부서별 총 사원 수를 조회
-- 그런데 부서별 사원이 1명인 부서의 정보는 조회하고 싶지 않음.
SELECT 
    dept_cd
    , MAX(birth_de) 최연소자
    , MIN(birth_de) 최연장자
    , COUNT(emp_no) 직원수
FROM tb_emp
GROUP BY dept_cd
--HAVING COUNT(emp_no) > 1
ORDER BY dept_cd
;


-- 사원별로 급여를 제일 많이받았을 때, 제일 적게받았을 때, 평균적으로 얼마받았는지 조회
-- 평균 급여가 450만원 이상인 사람만 조회
SELECT 
    emp_no "사번"
    , TO_CHAR(MAX(pay_amt), 'L999,999,999') "최고 수령액"
    , TO_CHAR(MIN(pay_amt), 'L999,999,999') "최저 수령액"
    , TO_CHAR(ROUND(AVG(pay_amt), 2), 'L999,999,999.99') "평균 수령액"
FROM tb_sal_his
GROUP BY emp_no
HAVING AVG(pay_amt) >= 4500000 -- HAVING 없으면 41건, 고액수령자 보고싶어서 만듦
ORDER BY emp_no
;

-- 사원별로 2019년 월평균 수령액이 450만원 이상인 사원의 사원번호와 2019년 연봉 조회
-- WHERE : 통계 전에 WHERE절로 19년 자료만 필터링하고
-- GROUP BY : 19년 자료로 사원번호 그룹화 하고
-- HAVING : 450만원 받은 애들 찾음
SELECT 
    emp_no
    , SUM(pay_amt) 연봉
FROM tb_sal_his
WHERE pay_de BETWEEN '20190101' AND '20191231'
GROUP BY emp_no
HAVING AVG(pay_amt) >= 4500000
;

-- 그룹화 대상 컬럼이 2개 이상인 경우
SELECT 
    emp_no
    , sex_cd
    , dept_cd
FROM tb_emp
ORDER BY dept_cd, sex_cd
;

-- 각 부서별로 남,녀가 몇명 있는지
SELECT 
    dept_cd
    , SEX_CD 
    , COUNT(*)
FROM tb_emp
GROUP BY dept_cd, sex_cd
ORDER BY dept_cd
;
-- 정렬도 GROUP BY가 아닌 애들로 하면 애러남 (ORDER BY ADDR 이런거) -> 56번 문제 답 3번
-- 그니까 걍, GROUP BY에 있는 컬럼은 그냥 SELECT와 ORDER BY에 변경없이 들어갈 수 있음
-- 그외에는 집계함수 같이 사용 (흠.. 문제54번 보니까 ORDER BY할 수 있네..?)



-- ORDER BY : 정렬
-- ASC : 오름차 정렬 (기본값), DESC : 내림차 정렬
-- 오름차: 영대문자 -> 영소문자 -> 한글가나다
-- 항상 SELECT절의 맨 마지막에 위치 (왜? 성능때문임! 자료 다 구해지고 마지막 정렬해야죻쥬?)

SELECT 
    emp_no
    , emp_nm
    , addr
FROM tb_emp
ORDER BY emp_no DESC
;

SELECT 
    emp_no
    , emp_nm
    , addr
FROM tb_emp
ORDER BY emp_nm DESC
;

SELECT 
    emp_no
    , emp_nm
    , dept_cd
FROM tb_emp
ORDER BY dept_cd ASC, emp_nm DESC
;

-- 별칭으로도 order by 가능
SELECT 
    emp_no AS 사번
    , emp_nm AS 이름
    , addr AS 주소
FROM tb_emp
ORDER BY 이름 DESC
;

-- 순서로도 order by 가능 (0,1,2 아니고 1,2,3임!)
SELECT 
    emp_no
    , emp_nm
    , dept_cd
FROM tb_emp
ORDER BY 3 ASC, 1 DESC
;

-- 섞어도 됨
SELECT 
    emp_no
    , emp_nm
    , dept_cd
FROM tb_emp
ORDER BY 3 ASC, emp_no DESC
;

SELECT emp_no AS 사번, emp_nm AS 이름, addr AS 주소
FROM tb_emp
ORDER BY 이름, 1 DESC
;

SELECT 
    emp_no
    , SUM(pay_amt) 연봉
FROM tb_sal_his
WHERE pay_de BETWEEN '20190101' AND '20191231'
GROUP BY emp_no
HAVING AVG(pay_amt) >= 4500000
ORDER BY emp_no
;

SELECT 
	EMP_NM ,
	DIRECT_MANAGER_EMP_NO 
FROM TB_EMP
ORDER BY DIRECT_MANAGER_EMP_NO DESC
;


-- 사원별로 2019년 월평균 수령액이 450만원 이상인 사원의 사원번호와 2019년 연봉 조회
SELECT 
    emp_no
    , SUM(pay_amt) 연봉
FROM tb_sal_his
WHERE pay_de BETWEEN '20190101' AND '20191231'
GROUP BY emp_no
HAVING AVG(pay_amt) >= 4500000
ORDER BY SUM(pay_amt) DESC
;

