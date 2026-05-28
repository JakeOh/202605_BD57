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

-- between A and B 연산자: 컬럼이름 between 값1 and 값2
select ename, job, sal
from emp
where sal between 2000 and 3000
order by sal desc;

-- 수당은 null이 아니고, 급여는 1500 미만인 직원들의 모든 정보를 출력.
select * from emp
where comm is not null and sal < 1500;

-- 10번 또는 20번 부서에서 근무하는 직원들의 부서번호, 이름, 급여를 출력.
-- 정렬: (1) 부서번호 오름차순, (2) 급여 내림차순.
select deptno, ename, sal
from emp
where deptno = 10 or deptno = 20
order by deptno, sal desc;

select deptno, ename, sal
from emp
where deptno in (10, 20)
order by deptno, sal desc;

-- 업무가 'CLERK'인 직원들의 이름, 업무, 급여를 출력. 이름순으로 출력.
select ename, job, sal
from emp
where job = 'CLERK';
--> SQL 식별자(예약어, 테이블 이름, 컬럼 이름 등)를 제외한 문자열은 작은따옴표('')를 사용함!
--> 컬럼에 저장된 문자열의 비교에서는 대/소문자를 구분!!

-- 업무가 'CLERK' 또는 'MANAGER'인 직원들의 이름, 업무, 급여를 출력.
-- 정렬: (1) 업무, (2) 급여
select ename, job, sal
from emp
where job = 'CLERK' or job = 'MANAGER'
order by job, sal;

select ename, job, sal
from emp
where job in ('CLERK', 'MANAGER')
order by job, sal;

-- 업무가 영업사원(SALESMAN), 관리자(MANAGER), 분석가(ANALYST)인 직원들의 모든 정보(컬럼).
select * from emp
where job = 'SALESMAN' or job = 'MANAGER' or job = 'ANALYST';

select * from emp
where job in ('SALESMAN', 'MANAGER', 'ANALYST');

-- 20번 부서에서 근무하는 'CLERK'의 모든 레코드(모든 컬럼)를 출력.
select * from emp
where deptno = 20 and job = 'CLERK';

-- CLERK, ANALYST, MANAGER가 아닌 직원들의 사번, 이름, 업무, 급여를 사번순 출력.
select empno, ename, job, sal
from emp
where job != 'CLERK' and job != 'ANALYST' and job != 'MANAGER'
order by empno;

select empno, ename, job, sal
from emp
where job not in ('CLERK', 'ANALYST', 'MANAGER')
order by empno;

-- like 검색: 특정 문자열이 포함된 값들을 찾는 검색 방법.
-- like 검색에서 사용하는 wildcard(특수문자)
-- (1) %: 글자수 상관없이 어떤 문자열이어도 상관 없음.
-- (2) _: 밑줄(underscore)이 있는 위치에 "한 글자"가 어떤 문자이더라도 상관 없음.

select * from emp where job like 'C%';
--> job(업무)가 'C'로 시작하는

select * from emp where job like 'C_';
--> job이 CA, CB, CC, CD, ... 등의 패턴인 경우

select * from emp where job like '%R';
--> job이 'R'로 끝나는

-- job이 'A'를 포함하는
select * from emp where job like '%A%';


-- 날짜 타입의 크기 비교: 과거 < 현재 < 미래
