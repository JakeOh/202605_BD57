/*
 * sub query 연습
 */

-- from 절에서 사용되는 서브 쿼리

-- 이름, 급여, 급여 순위(내림차순) 출력.
select
    ename, sal,
    rank() over (order by sal desc) as "RANKING"
from emp;

-- 이름, 급여, 급여 순위 1 ~ 5위 출력.
select
    t.*
from (
    select 
        ename, sal, 
        rank() over (order by sal desc) as "RANKING"
    from emp
) t
where t.RANKING between 1 and 5;


-- 이름, 급여, 급여 순위 6 ~ 10위 출력.
select
    t.*
from (
    select 
        ename, sal, 
        rank() over (order by sal desc) as "RANKING"
    from emp
) t
where t.RANKING between 6 and 10;

-- 이름, 급여, 급여 순위 11 ~ 15위 출력.
select
    t.*
from (
    select 
        ename, sal, 
        rank() over (order by sal desc) as "RANKING"
    from emp
) t
where t.RANKING between 11 and 15;

-- with 식별자 as (서브 쿼리) 구문: 주된 SQL 문장을 간단히 작성해서 가독성을 높이기 위해서.
with t as (
    select 
        ename, sal,
        rank() over (order by sal desc) as "RANKING"
    from emp
)
select t.* 
from t
where t.RANKING between 1 and 5;


-- 직원 이름, 입사날짜, 입사날짜 순위(오름차순)를 검색.
select
    ename, hiredate,
    rank() over (order by hiredate)
from emp;
--> order by hiredate [asc]인 경우는 null이 가장 마지막.
--> order by hiredate desc인 경우는 null이 가장 먼저!


-- 직원 이름, 입사날짜, 입사 순위가 1 ~ 5위까 출력.
select
    t.*
from (
    select 
        ename, hiredate,
        rank() over (order by hiredate) as "RANKING"
    from emp
) t
where t.RANKING between 1 and 5;

with t as (
    select 
        ename, hiredate,
        rank() over (order by hiredate) as "RANKING"
    from emp
)
select t.*
from t
where t.RANKING between 1 and 5;

select hiredate from emp order by hiredate desc;
--> 내림차순 정렬에서는 null이 가장 먼저.
select hiredate from emp order by hiredate desc nulls last;
--> 내림차순 정렬에서도 null이 가장 마지막에 출력되도록.
