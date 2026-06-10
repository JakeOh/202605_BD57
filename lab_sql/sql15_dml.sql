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

-- 사번이 7369인 직원의 급여를 1000, 수당을 100으로 업데이트.
-- 업무가 'CLERK'인 직원들의 급여를 10% 인상.
-- ACCOUNTING 부서에서 일하는 직원들의 급여를 10% 인상.
-- 급여 등급이 1인 직원들의 급여를 20% 인상.
-- emp 테이블에서 부서번호가 dept 테이블에 없는 직원의 부서번호를 null로 업데이트.

select * from emp;

