/*
 * 조건 검색 - where 구문
 * 조건을 만족하는 행(row)들을 검색하는 방법.
 * (문법) select 컬럼이름, ... from 테이블이름 where 조건식 [order by ...];
 *
 * 조건식에서 사용되는 연산자들:
 * (1) 비교 연산자: =, !=, >, >=, <, <=, is null, is not null, ...
 * (2) 논리 연산자: and, or, not
 */

-- 10번 부서에서 근무하는 직원들의 사번, 이름, 부서번호, 급여를 출력.
select empno, ename, deptno, sal
from emp
where deptno = 10;

-- 10번 부서가 아닌 직원들의 사번, 이름, 부서번호, 급여를 출력.
select empno, ename, deptno, sal
from emp
where deptno != 10;

-- 수당(comm)이 null이 아닌 직원들의 모든 정보를 출력.
select * from emp
where comm is not null;

-- 수당이 null인 직원들의 모든 정보를 출력.
select * from emp
where comm is null;

-- (주의) null인 지 아닌 지를 비교할 때는 =, != 연산자를 사용하면 안 됨!!!
-- 반드시 is null 또는 is not null 키워드를 사용해야 함!
select * from emp where comm = null;  --> 0개 행(row)가 선택.
select * from emp where comm != null;  --> 결과는 0개 행(row).

-- 수당이 null이 아닌 직원들의 부서번호, 사번, 이름, 급여, 수당을 검색
-- 정렬 순서: (1) 부서번호 오름차순, (2) 사번 오름차순
select deptno, empno, ename, sal, comm
from emp
where comm is not null
order by deptno, empno;

-- 급여가 2000 이상인 직원들의 이름, 업무, 급여를 출력.
-- 정렬 순서: (1) 급여 내림차순, (2) 이름 오름차순
select ename, job, sal
from emp
where sal >= 2000
order by sal desc, ename;

-- 급여가 2000 이상이고 3000 이하인 직원들의 이름, 업무, 급여를 출력
-- 정렬 순서: 급여 내림차순.
select ename, job, sal
from emp
where sal >= 2000 and sal <= 3000
order by sal desc;
