/*
 * 기본 질의(query): 테이블에서 데이터를 검색.
 * (문법) select 컬럼이름, 컬럼이름, ... from 테이블이름;
 * 테이블의 모든 컬럼을 검색: select * from 테이블이름;
 */
 
-- 직원 테이블(emp)에서 사번(empno)과 직원이름(ename)을 검색.
select empno, ename from emp;

-- 직원 테이블에서 모든 컬럼을 검색.
select empno, ename, job, mgr, hiredate, sal, comm, deptno
from emp;

select * from emp;
--> 출력되는 컬럼의 순서는 테이블을 생성할 때의 컬럼 순서 그대로.

-- 출력되는 컬럼의 순서를 원하는 대로 바꾸고 싶을 때
select empno, ename, job, sal, comm, hiredate, mgr, deptno
from emp;

-- 컬럼 이름에 별명(alias) 설정
-- (문법) select 컬럼이름 as "별명" from 테이블이름;
-- (문법) select 컬럼이름 별명 from 테이블이름;
-- as 키워드는 생략 가능.
-- 별명에는 작은따옴표('')는 사용할 수 없음!
-- 별명을 감싸는 큰따옴표("")는 생략할 수 있음.
-- 별명에 공백이 있는 경우에는 큰따옴표를 생략할 수 없음.
-- 별명 이름의 대소문자를 구분하고 싶을 때는 큰따옴표를 써야 함.

-- 직원 테이블에서 사번과 직원 이름을 검색. 출력할 때 컬럼 이름은 사번, 직원 이름.
select
    empno "사번",
    ename "직원 이름"
from emp;

-- 부서 테이블(dept)에서 부서 번호, 부서 이름, 위치를 검색.
-- 출력할 때는 실제 컬럼 이름 대신에 한글 별명을 사용.
select
    deptno as "부서 번호",
    dname as "부서 이름",
    loc as "위치"
from dept;


-- 연결 연산자(||): 2개 이상의 컬럼(또는 문자열) 값들을 합쳐서 하나의 문자열로 만들어 줌.
-- 직원 테이블에서 직원 이름과 급여를 검색.
-- 'SMITH의 급여는 800입니다.' 형식으로 출력.
select
    ename || '의 급여는 ' || sal || '입니다.' as "직원 급여"
from emp;

-- 부서 테이블에서 부서 번호와 이름을 '10 - ACCOUNTING' 형식으로 출력.
select
    deptno || ' - ' || dname as "부서 번호/이름"
from dept;


-- 검색 결과를 정렬해서 출력하기
-- (문법) select 컬럼이름, ... from 테이블이름 order by 정렬기준컬럼 [asc/desc], ...;
-- asc: 오름차순(ascending order). 정렬의 기본값은 오름차순. 생략 가능.
-- desc: 내림차순(descending order). 생략 불가!

-- 직원 이름을 알파벳 순서로 출력.
select ename from emp
order by ename;  --> asc(오름차순)은 생략 가능.

select ename from emp
order by ename desc;
