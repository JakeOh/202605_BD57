/*
 * JOIN 연습 문제
 */

-- Ex1. 직원 이름, 근무 도시를 검색. 도시 이름으로 정렬.
-- inner join과 outer join의 결과를 비교하세요.
-- inner join
select 
    e.ename, d.loc
from emp e 
    join dept d on e.deptno = d.deptno
order by d.loc;
--> 14개 행

select e.ename, d.loc
from emp e, dept d
where e.deptno = d.deptno
order by d.loc;

-- left outer join
select 
    e.ename, d.loc
from emp e 
    left join dept d on e.deptno = d.deptno
order by d.loc;
--> 15개 행(오쌤/null)

select e.ename, d.loc
from emp e, dept d
where e.deptno = d.deptno(+)
order by d.loc;

-- right outer join
select
    e.ename, d.loc
from emp e
    right join dept d on e.deptno = d.deptno
order by d.loc;
--> 15개 행(null/boston)

select e.ename, d.loc
from emp e, dept d
where e.deptno(+) = d.deptno
order by d.loc;

select
    e.ename, d.loc
from emp e
    full join dept d on e.deptno = d.deptno
order by d.loc;

select e.ename, d.loc
from emp e, dept d
where e.deptno = d.deptno(+)
union
select e.ename, d.loc
from emp e, dept d
where e.deptno(+) = d.deptno
order by loc;

-- Ex2. 직원 이름, 매니저의 이름, 직원 급여, 직원 급여 등급 검색. inner join.
-- 정렬 순서: (1) 매니저, (2) 급여 등급
select
    e1.ename as "직원 이름",
    e2.ename as "매니저 이름",
    e1.sal as "직원 급여",
    s.grade as "급여 등급"
from emp e1
    join emp e2 on e1.mgr = e2.empno
    join salgrade s on e1.sal between s.losal and s.hisal
order by "매니저 이름", "급여 등급";

select
    e1.*, e2.*, s.*
from emp e1
    join emp e2 on e1.mgr = e2.empno
    join salgrade s on e1.sal between s.losal and s.hisal;

select
    e1.ename as "직원 이름",
    e2.ename as "매니저 이름",
    e1.sal as "직원 급여",
    s.grade as "급여 등급"
from emp e1, emp e2, salgrade s
where e1.mgr = e2.empno and e1.sal between s.losal and s.hisal
order by "매니저 이름", "급여 등급";

select
    e1.ename as "직원 이름",
    e2.ename as "매니저 이름",
    e1.sal as "직원 급여",
    s.grade as "급여 등급"
from emp e1, emp e2, salgrade s
where e1.mgr = e2.empno(+) 
    and e1.sal between s.losal(+) and s.hisal(+)
order by "매니저 이름", "급여 등급";

-- Ex3. 직원 이름, 부서 이름, 급여, 급여 등급 검색. inner join.
-- 정렬 순서: (1) 부서 이름, (2) 급여 등급

-- Ex4. 부서 이름, 부서 위치, 부서의 직원수 검색. 부서 번호 오름차순.

-- Ex5. 부서 번호, 부서 이름, 부서 직원수, 부서의 급여 최솟값/최댓값 검색.
-- 부서 번호 오름차순.

-- Ex6. 부서 번호, 부서 이름, 사번, 직원이름, 매니저 사번, 매니저 이름, 
-- 직원 급여, 직원 급여 등급 검색.
-- 급여가 2,000 이상인 직원들만 검색.
-- 정렬 순서: (1) 부서 번호, (2) 사번
