/*
 * 서브 쿼리(sub query): SQL 문장의 일부로 다른 SQL 문장이 포함되는 것.
 * (1) select 절에서의 서브 쿼리
 * (2) from 절에서의 서브 쿼리
 * (3) where 절에서의 서브 쿼리
 * (4) having 절에서의 서브 쿼리
 *
 * (주의) 서브 쿼리는 () 안에 작성. 서브 쿼리에서는 세미콜론(;)을 사용하지 않음.
 */

-- ALLEN의 급여보다 더 많은 급여를 받는 직원들?
-- (step 1) allen의 급여
select sal from emp where ename = 'ALLEN';
-- (step 2) 급여가 1600보다 많은 직원들
select * from emp where sal > 1600;

-- sub query
select * from emp
where sal > (
    select sal from emp where ename = 'ALLEN'
);

-- 전체 사원의 급여 평균보다 더 많은 급여를 받는 직원들?
-- (step 1) 급여 평균
select avg(sal) from emp;
-- (step 2) 평균보다 급여가 많은 직원들
select * from emp where sal > 2201.6;
-- sub query
select * from emp where sal > (
    select avg(sal) from emp
);

-- 1. ALLEN보다 적은 급여를 받는 직원들의 사번, 이름, 급여를 출력.
select empno, ename, sal
from emp
where sal < (
    select sal from emp where ename = 'ALLEN'
);

-- 2. ALLEN과 같은 업무를 담당하는 직원들의 사번, 이름, 부서번호, 업무, 급여를 출력.
select empno, ename, deptno, job, sal
from emp
where job = (
    select job from emp where ename = 'ALLEN'
);

-- 3. SALESMAN의 급여 최댓값보다 더 많은 급여를 받는 직원들의 사번, 이름, 급여, 업무를 출력.
select empno, ename, sal, job
from emp
where sal > (
    select max(sal) from emp where job = 'SALESMAN'
);

-- 4. WARD의 연봉보다 더 많은 연봉을 받는 직원들의 이름, 급여, 수당, 연봉을 출력.
--    연봉 = sal * 12 + comm. comm(수당)이 null인 경우에는 0으로 계산.
--    연봉 내림차순 정렬.
select
    ename, sal, comm, 
    sal * 12 + nvl(comm, 0) as "연봉"
from emp
where sal * 12 + nvl(comm, 0) > (
    select sal * 12 + nvl(comm, 0) from emp where ename = 'WARD'
)
order by 연봉 desc;

-- 5. SCOTT과 같은 급여를  받는 직원들의 이름과 급여를 출력. 단, SCOTT은 제외.
select ename, sal
from emp
where sal = (select sal from emp where ename = 'SCOTT')
    and ename != 'SCOTT';

-- 6. ALLEN보다 늦게 입사한 직원들의 이름, 입사날짜를 최근입사일부터 출력.
select ename, hiredate
from emp
where hiredate > (select hiredate from emp where ename = 'ALLEN')
order by hiredate desc;

-- 7. 매니저가 KING인 직원들의 사번, 이름, 매니저 사번을 검색.
select empno, ename, mgr
from emp
where mgr = (select empno from emp where ename = 'KING');

-- 8. ACCOUNTING 부서에서 일하는 직원들의 이름, 급여, 부서 번호를 검색.
select ename, sal, deptno
from emp
where deptno = (
    select deptno from dept where dname = 'ACCOUNTING'
);

-- 9. CHICAGO에서 근무하는 직원들의 이름, 급여, 부서 번호를 검색.
select ename, sal, deptno
from emp
where deptno = (
    select deptno from dept where loc = 'CHICAGO'
);

select
    e.ename, e.sal, e.deptno
from emp e
    join dept d on e.deptno = d.deptno
where d.loc = 'CHICAGO';


-- 단일 행 서브 쿼리: 서브 쿼리의 결과 행의 개수가 1개인 서브 쿼리.
-- 단일 행 서브 쿼리는 동등 비교(=)를 할 수 있음.

-- 다중 행 서브 쿼리: 서브 쿼리의 결과 행의 개수가 2개 이상인 서브 쿼리.
-- 다중 행 서브 쿼리는 동등 비교(=)를 할 수 없음! in 연산자는 사용 가능!

-- SALESMAN들의 급여와 같은 급여를 받는 직원들?
-- (step 1) SALESMAN들의 급여
select sal from emp where job = 'SALESMAN';
-- (step 2) 급여가 1600 또는 1250 또는 1500인 직원들
select * from emp where sal = 1600 or sal = 1250 or sal = 1500;
select * from emp where sal in (1600, 1250, 1500);
-- sub query
select * from emp 
where sal in (select sal from emp where job = 'SALESMAN');

-- 매니저인 직원들?

-- 매지저가 아닌 직원들?

