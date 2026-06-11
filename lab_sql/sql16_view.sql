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


-- view: 테이블을 바라보는 객체.
-- 실제 테이블의 내용이 변경되면, 뷰의 내용도 바뀜.
-- emp 테이블에서 사번이 7369인 직원의 업무를 '경리'로 업데이트.
update emp
set job = '경리'
where empno = 7369;

commit;

select * from v_emp_dept;
--> emp 테이블에서 업데이트한 내용이 뷰에서도 보임.

-- 뷰에서 변경된 내용은 실제 테이블에도 반영이 됨.
-- v_emp_dept 뷰에서 사번이 7369인 직원의 급여를 9999로 업데이트.
update v_emp_dept
set sal = 9999
where empno = 7369;
--> 업데이트 성공

select * from emp;
--> 뷰에서 업데이트가 성공하면 뷰가 바라보는 실제 테이블의 데이터가 업데이트됨.

-- v_emp_dept 뷰에서 사번이 7369인 직원의 부서이름을 '리서치'로 업데이트.
update v_emp_dept
set dname = '리서치'
where empno = 7369;
--> 1개 행 업데이트됨.

select * from v_emp_dept;
--> 뷰를 검색하면 모든 부서 이름 'RESEARCH'가  전부 '리서치'로 변경됨.
-- empno=7369인 레코드의 부서번호(deptno)와 일치하는 부서의 부서이름을 dept 테이블에서 업데이트.

select * from dept;


-- 부서번호, 부서별 평균 급여를 갖는 뷰를 생성
create or replace view v_avg_sal
as
select deptno, round(avg(sal), 2) as "AVG_SAL"
from emp
group by deptno
order by deptno;

select * from v_avg_sal;

-- emp 테이블에서 사번이 7839인 직원의 급여를 9999로 업데이트.
update emp
set sal = 9999
where empno = 7839;
--> v_avg_sal 뷰에서도 업데이트된 평균 급여를 보게 됨.

-- v_avg_sal 뷰에서 avg_sal 컬럼 값을 5000으로 업데이트?
update v_avg_sal
set AVG_SAL = 5000
where deptno = 10;
--> v_avg_sal은 업데이트할 수 없는 뷰.
