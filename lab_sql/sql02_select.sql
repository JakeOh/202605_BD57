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
 