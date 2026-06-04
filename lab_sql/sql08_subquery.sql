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
select * from emp
where empno in (
    select distinct mgr from emp 
);
-- empno = null or empno = 7902 or empno = 7698 or ...

-- 매지저가 아닌 직원들?
select * from emp
where empno not in (
    select distinct mgr from emp
);
--> 결과 행의 개수는 0개.
--> empno != null and empno != 7902 and empno != 7698 and empno != 7839 and ...

-- empno in (a, b) 조건식은 empno = a or empno = b 조건식과 동일.
-- empno not in (a, b) 조건식은 empno != a and empno != b 조건식와 동일.
-- in과 not in은 값을 비교할 때 동등 비교 연산자(=, !=)를 사용. is로 비교하지 않음.
-- empno = null 조건식은 항상 False. empno != null 조건식도 항상 False.
select * from emp where mgr != null;  --> 0개 행.
select * from emp where mgr is not null;  --> 13개 행.

select * from emp
where empno not in (
    select distinct mgr from emp 
    where mgr is not null
);
--> empno != 7902 and empno != 7698 and empno != 7839 and ...


-- 다중 행 서브 쿼리와 where exists, where not exists 구문
-- 매니저인 직원들?
select e1.* from emp e1
where exists (
    select e2.* from emp e2 where e2.mgr = e1.empno
);
--> 메인 쿼리의 사원(e1)의 사번(empno)가 다른 사원(e2)의 관리자 사번(mgr)에 존재하면.
--> 누군가의 상사(manager) 역할을 하는 직원 6명이 검색됨.

select e1.* from emp e1
where exists (
    select e2.* from emp e2 where e1.mgr = e2.empno
);
--> 메인 쿼리의 사원(e1)의 관리자 사번이 다른 사원(e2)의 사번(empno)에 존재하면.
--> 나에게 업무를 지시하는 상사(manager)가 있는 지를 검색.
--> 매니저가 있는 직원 13명이 검색됨.

-- 매지저가 아닌 직원들?
select e1.* from emp e1
where not exists (
    select e2.* from emp e2 where e2.mgr = e1.empno
);

-- 부서 테이블의 부서 정보(번호, 이름, 위치)를 출력. 단, 직원 테이블에 존재하는 부서들만.
select d.* from dept d
where exists (
    select e.* from emp e where e.deptno = d.deptno
)
order by d.deptno;

-- 부서 테이블의 부서 정보(번호, 이름, 위치)를 출력. 단, 직원 테이블에 존재하지 않는 부서들만.
select d.* from dept d
where not exists (
    select e.* from emp e where e.deptno = d.deptno
)
order by d.deptno;


-- 참고
select d.* from dept d
where exists (
    select e.* from emp
);
--> 비상관 서브 쿼리(uncorrelated sub query):
--> 메인 쿼리(dept)와 서브 쿼리(emp)가 아무런 연결 고리가 없음.
--> 모든 부서에 대해서 where 절이 항상 참(true)가 되기 때문에 4개 부서가 모두 검색됨.


-- 다중 행 서브 쿼리에서의 any vs all
select * from emp
where sal > any (
    select sal from emp where job = 'SALESMAN'
);
--> sal > 1600 or sal > 1250 or sal > 1500와 같은 문장
--> sal > 1250
--> 영업사원 급여 최솟값(1250)보다 더 많은 급여를 받는 직원들.

select * from emp
where sal > all (
    select sal from emp where job = 'SALESMAN'
);
--> sal > 1600 and sal > 1250 and sal > 1500
--> sal > 1600
--> 영업사원 급여 최댓값(1600)보다 더 많은 급여를 받는 직원들.


-- having 절에서 사용되는 서브 쿼리
-- 업무별 급여의 합계를 출력. 단, 영업사원들의 급여 합계보다 큰 업무들만 출력.
select
    job, sum(sal)
from emp
group by job
having sum(sal) > (
    select sum(sal) from emp where job = 'SALESMAN'
);


-- select 절에서 사용되는 서브 쿼리
select empno, ename, 'ACCONUNTING' as DEPT_NAME
from emp
where deptno = 10;

select
    empno, ename,
    (select dname from dept where deptno = 10) as DEPT_NAME
from emp
where deptno = 10;

-- CLERK들의 사번, 이름, 급여, CLERK 급여의 최솟값, CLERK 급여의 최댓값을 출력.
select
    empno, ename, sal,
    (select min(sal) from emp where job = 'CLERK') as MIN_SAL,
    (select max(sal) from emp where job = 'CLERK') as MAX_SAL
from emp
where job = 'CLERK';
