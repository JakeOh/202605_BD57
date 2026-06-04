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

-- 페이징(paging) 처리: 한 페이지에 보여주는 검색 결과의 개수를 제한.
-- (예) 직원 테이블에서 급여 오름차순으로 정렬했을 때 5개 행씩 출력(1 ~ 5, 6 ~ 10, ...)
-- (1) rownum 사용 --> Oracle에서만 가능.
-- (2) row_number() 윈도우 함수를 사용.
-- (3) Top-N 쿼리 사용.

-- rownum: Oracle에서 제공되는 가상(pseudo) 컬럼.
select
    e.*, rownum as "RN"
from emp e
order by sal;
--> rownum: 급여로 정렬한 다음의 행번호가 아니라(!), 정렬 전의 emp 테이블에서의 행 번호.

select
    t.*, rownum as "RN"
from (
    select * from emp order by sal
) t;
--> rownum: 급여 오름차순 정렬된 상태에서의 행 번호.

with t2 as (
    select t.*, rownum as "RN"
    from (select * from emp order by sal) t
)
select 
    t2.*
from t2
where t2.RN between 11 and 15;


-- row_number() 윈도우 함수
select
    e.*,
    row_number() over (order by sal) as "RN"
from emp e;

with t as (
    select
        e.*,
        row_number() over (order by sal) as "RN"
    from emp e
)
select *
from t
where t.RN between 6 and 10;


-- Top-N 쿼리
select *
from emp
order by sal
offset 10 rows
fetch next 5 rows only;
--> offset n rows: select한 전체 결과에서 첫 n개의 행을 건너뛰고
--> fetch next m rows only: 그 다음 m개의 행들만 출력.

-- 입사일 최신 순으로 10명씩 출력. 입사일이 null인 경우는 가장 마지막에 출력되도록.
select *
from emp
order by hiredate desc nulls last
offset 0 rows
fetch next 10 rows only;

select *
from emp
order by hiredate desc nulls last
offset 10 rows
fetch next 10 rows only;
