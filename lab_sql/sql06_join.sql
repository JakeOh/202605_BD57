/*
 * join: 관계형 데이터베이스(RDBMS, Relational Database Management System)에서 
 * 1개 이상의 테이블에서 필요한 정보들을 조합해서 검색하는 방법.
 * join의 종류:
 * 1. inner join
 * 2. outer join
 *    (1) left outer join
 *    (2) right outer join
 *    (3) full outer join
 * join 문장 문법
 * 1. ANSI 표준 문법
 *    select ...
 *    from 테이블1 join_방법 테이블2 on join_조건식;
 * 2. Oracle 문법
 *    select ...
 *    from 테이블1, 테이블2, ...
 *    where join_조건식;
 */

-- inner join과 outer join의 차이점을 비교하기 위한 데이터 삽입(insert)
insert into emp (empno, ename, sal, deptno)
values (1004, '오쌤', 4000, 50);

commit;  -- 테이블의 변경 내용을 영구히 저장.

select * from emp;
select * from dept;


-- 직원 이름, 부서 번호, 부서 이름 검색

-- INNER JOIN
-- (1) ANSI 표준 문법
select
    e.ename, e.deptno, d.dname
from emp e inner join dept d on e.deptno = d.deptno;

-- (2) Oracle 문법
select
    e.ename, e.deptno, d.dname
from emp e, dept d
where e.deptno = d.deptno;
