/*
 * DML(Data Manipulation Language): insert, update, delete
 */

-- INSERT INTO table_name [(column1, column2, ...)] VALUES (value1, value2, ...);
--> 1개의 행만 삽입.
-- INSERT INTO table_name [(column1, column2, ...)] SELECT 문장;
--> select 문장의 결과에 따라서 여러개의 행들이 한 번에 삽입될 수 있음.

-- bonus 테이블에 이름, 업무, 급여, 수당을 삽입
insert into bonus values ('오쌤', '교육', 3000, 100);

-- bonus 테이블에 이름, 업무, 급여를 삽입
insert into bonus (ename, job, sal) values ('홍길동', '도둑', 10000);

-- emp 테이블에서 comm이 null이 아닌 직원들의 이름, 업무, 급여, 수당을 bonus 테이블에 삽입.
insert into bonus
select ename, job, sal, comm from emp 
where comm is not null;

-- emp 테이블에서 부서번호가 20인 직원들의 이름, 업무, 급여, 수당을 bonus 테이블에 삽입.
insert into bonus
select ename, job, sal, comm from emp
where deptno = 20;

select * from bonus;

commit;


-- update 문장: 테이블에서 특정 컬럼의 값(들)을 수정(업데이트).
-- UPDATE table_name SET column1 = value1, column2 = value2, ... [WHERE 조건식];
-- where 절은 생략 가능. where 절이 없는 경우에는 테이블의 모든 행이 업데이트됨.
-- where 절이 있으면 조건을 만족하는 행들만 업데이트됨.

update emp set job = 'clerk';
--> 조건절이 없는 경우에는 emp 테이블의 모든 행(15개 행)에서 job 컬럼의 값이 업데이트됨.

rollback;  --> 직전(마지막)에 commit된 상태로 되돌림.

-- 업무가 null인 직원의 업무를 'CLERK'으로 업데이트하세요.
update emp
set job = 'CLERK'
where job is null;

-- SQL에서 = 연산자의 의미:
-- (1) 비교 연산자: WHERE/HAVING 조건식에서 사용된 = 연산자.
--     column = value: column의 값이 value와 같으면 true, 그렇지 않으면 false.
-- (2) 할당 연산자: SET 절에서 사용된 = 연산자. 
--     column = value: value를 column에 저장(할당).

-- Ex 1. 사번이 7369인 직원의 급여를 1000, 수당을 100으로 업데이트.
update emp
set sal = 1000, comm = 100
where empno = 7369;
--> 사번이 PK인 경우라면, 오직 1개의 행만 업데이트됨.

-- Ex 2. 업무가 'CLERK'인 직원들의 급여를 10% 인상.
update emp
set sal = sal * 1.1
where job = 'CLERK';

-- Ex 3. ACCOUNTING 부서에서 일하는 직원들의 급여를 10% 인상.
update emp
set sal = sal * 1.1
where deptno = (
    select deptno from dept where dname = 'ACCOUNTING'
);

-- Ex 4. 급여 등급이 1인 직원들의 급여를 20% 인상.
-- 급여 등급이 1인 직원들 검색
select * from emp
where sal between (select losal from salgrade where grade = 1) 
    and (select hisal from salgrade where grade = 1);

-- 급여 20% 인상
update emp
set sal = sal * 1.2
where sal between (select losal from salgrade where grade = 1) 
    and (select hisal from salgrade where grade = 1);

-- 급여 등급이 2인 직원들(JOIN 사용)
select e.*, s.*
from emp e 
    join salgrade s on e.sal between s.losal and s.hisal
where s.grade = 2;

-- 급여 등급이 2인 직원들의 급여를 5% 인상
update emp
set sal = sal * 1.05
where empno in (
    select e.empno
    from emp e 
        join salgrade s on e.sal between s.losal and s.hisal
    where s.grade = 2
);


-- Ex 5. emp 테이블에서 부서번호가 dept 테이블에 없는 직원의 부서번호를 null로 업데이트.
update emp
set deptno = null
where deptno not in (
    select deptno from dept
);

-- 입사날짜가 null인 직원(들)의 입사일을 현재시간으로 업데이트.
update emp
set hiredate = sysdate
where hiredate is null;

-- comm이 null인 직원들의 comm을 0으로 업데이트.
update emp
set comm = 0
where comm is null;

commit;

select * from emp;


-- delete 문장: 테이블에서 (조건을 만족하는) 행(들)을 삭제하는 DML.
-- (문법) delete from 테이블_이름 [where 조건식];
-- where 조건절은 생략 가능. 조건절이 없으면 테이블의 모든 행들이 삭제됨.

delete from emp; --> 테이블의 모든 행(15개)들이 삭제됨.

rollback;  --> 이전(가장 마지막) commit 상태로 되돌림.

-- 사번이 1004인 직원 정보를 테이블에서 삭제.
delete from emp where empno = 1004;

commit;

-- 급여 등급이 5인 직원들의 정보를 테이블에서 삭제.
-- 급여 등급이 5인 직원들
select * from emp
where sal between (select losal from salgrade where grade = 5)
    and (select hisal from salgrade where grade = 5);

select e.*, s.*
from emp e
    join salgrade s on e.sal between s.losal and s.hisal
where grade = 5;

-- 급여 5등급 직원 삭제
delete from emp
where sal between (select losal from salgrade where grade = 5)
    and (select hisal from salgrade where grade = 5);

rollback;

delete from emp
where empno in (
    select e.empno
    from emp e
        join salgrade s on e.sal between s.losal and s.hisal
    where grade = 5
);

rollback;

select * from emp;
