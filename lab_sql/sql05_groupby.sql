/* 
 * 다중 행 함수: 여러 개의 행들이 함수의 아규먼트로 전달되서 하나의 값이 반환되는 함수.
 *   (예) 통계 함수: count(개수), sum(합계), avg(평균), variance(분산), stddev(표준편차), ...
 */

-- count(column): column에서 null이 아닌 행의 개수를 반환.
select count(empno) from emp;  --> 14
select count(mgr) from emp;  --> 13
select count(comm) from emp;  --> 4

-- count(*): 테이블의 전체 행의 개수를 반환.
select count(*) from emp;


-- 통계(집계) 함수의 특징: null을 제외하고 계산을 수행.
-- sum(column): column에서 null 아닌 값들의 합계를 반환.
select sum(sal) from emp;
select sum(comm) from emp;

-- avg(column): 평균(average, mean). 평균(avg) = 합계(sum) / 개수(count).
select avg(sal) from emp;  -- 급여 평균
select round(avg(sal), 2) from emp;

select avg(comm) from emp;  -- 수당 평균(= 2200 / 4)

-- 급여의 개수, 합계, 평균, 분산, 표준편차(standard deviation), 최댓값, 최솟값 출력
select
    count(sal) as 개수,
    sum(sal) as 합계,
    round(avg(sal), 2) as 평균,
    round(variance(sal), 2) as 분산,
    round(stddev(sal), 2) as 표준편차,
    max(sal) as 최댓값,
    min(sal) as 최솟값
from emp;


-- 다중 행 함수는 단일 행 함수 (또는 컬럼)과 함께 사용할 수 없음!
-- select comm, count(comm) from emp;  --> 에러 발생.
-- select nvl(comm, 0), count(comm) from emp;  --> 에러 발생.


/*
 * 그룹 쿼리
 * (예) 부서 별 직원 수, 부서 별 급여 평균, ...
 * (문법)
 * select ...
 * from 테이블
 * where 조건식(1)
 * group by 컬럼(그룹을 묶기 위한 컬럼), ...
 * having 조건식(2)
 * order by 컬럼(정렬 기준이 되는 컬럼), ...;
 *
 * where 조건식(1): 그룹을 묶기 전에 조건을 만족하는 행들만 선택하기 위한 조건식.
 * having 조건식(2): 그룹을 묶은 다음에 조건에 맞는 그룹들만 선택하기 위한 조건식.
 *
 * (주의)
 * group by에서 사용한 그룹을 묶기 위한 컬럼들은 select할 수 있음.
 * group by에서 사용되지 않은 컬럼들은 select할 수 없음!!!
 */

-- 부서 별 직원 수
select deptno, count(*)
from emp
group by deptno
order by deptno;

-- 부서 별 급여 평균(소숫점 이하 2자리까지 반올림)
select deptno, round(avg(sal), 2) as "부서 급여 평균"
from emp
group by deptno
order by deptno;

-- 업무가 PRESIDENT인 경우는 제외하고,
-- 업무 별 직원 수, 급여 평균, 급여 최댓값, 급여 최솟값을 출력.
select 
    job, 
    count(*) as 직원수, 
    round(avg(sal), 2) as 급여평균, 
    max(sal) as 최댓값, 
    min(sal) as 최솟값
from emp
where job != 'PRESIDENT'
group by job
order by job;

select 
    job, 
    count(*) as 직원수, 
    round(avg(sal), 2) as 급여평균, 
    max(sal) as 최댓값, 
    min(sal) as 최솟값
from emp
group by job
having job != 'PRESIDENT'
order by job;

-- 매니저가 있는(mgr이 null이 아닌) 직원들 중에서 부서 별 직원 수, 급여 평균을 출력.
select 
    deptno as 부서번호,
    count(*) as 직원수,
    round(avg(sal), 2) as 급여평균
from emp
where mgr is not null
group by deptno
order by deptno;

/*
select 
    deptno as 부서번호,
    count(*) as 직원수,
    round(avg(sal), 2) as 급여평균
from emp
group by deptno
having mgr is not null
order by deptno;
--> having에서 사용할 수 없는 조건식 - 에러가 발생.
*/

