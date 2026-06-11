/*
 * view: 테이블을 바라보는 객체.
 * 검색에서 자주 사용되는 정보들을 저장해서 select 문장을 간단히 만들기 위해서 사용.
 * (문법) create [or replace] view 뷰_이름 as select 문장;
 *        drop view 뷰_이름;
 */

-- 사번, 이름, 부서번호, 부서이름을 갖는 뷰(view)를 생성.
create view v_emp_dept
as
select e.empno, e.ename, e.deptno, d.dname
from emp e
    join dept d on e.deptno = d.deptno
order by e.empno;

-- 생성된 뷰는 테이블을 사용하는 것처럼 select가 가능.
select empno, dname
from v_emp_dept;

select *
from v_emp_dept
where dname = 'SALES';


-- 사번, 이름, 업무, 급여, 부서번호, 부서이름을 갖는 뷰를 생성.
-- 같은 이름의 뷰가 데이터베이스에 없으면 생성(create)하고, 있으면 기존 뷰를 대체(replace).
create or replace view v_emp_dept
as
select e.empno, e.ename, e.job, e.sal, e.deptno, d.dname
from emp e, dept d
where e.deptno = d.deptno
order by e.empno;
