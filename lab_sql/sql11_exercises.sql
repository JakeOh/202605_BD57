/*
 * 연습문제 - hr 계정을 사용
 * - hr.sql 스크립트를 실행
 * - hr 계정의 테이블 내용을 파악
 * - 연습문제들에서 직원의 이름은 이름(first_name)과 성(last_name)을 붙여서 하나의 컬럼으로 출력.
 *   (예) Steven King
 */

-- 1. 직원의 이름과 부서 이름을 출력. (inner join)
select
    e.first_name || ' ' || e.last_name as "직원 이름",
    d.department_name
from employees e
    join departments d on e.department_id = d.department_id
;
--> 106개 행(직원 테이블에서 department_id가 null인 직원이 제외)

select
    e.first_name || ' ' || e.last_name as "직원 이름",
    d.department_name
from employees e, departments d
where e.department_id = d.department_id;

-- 2. 직원의 이름과 부서 이름을 출력. 부서 번호가 없는 직원도 출력.
select
    e.first_name || ' ' || e.last_name as "직원 이름",
    d.department_name
from employees e
    left join departments d on e.department_id = d.department_id
;
--> 107개 행(직원 테이블에서 department_id가 null인 직원도 출력).

select
    e.first_name || ' ' || e.last_name as "직원 이름",
    d.department_name
from employees e, departments d
where e.department_id = d.department_id(+);

-- (참고) right outer join
select
    e.first_name || ' ' || e.last_name as "직원 이름",
    d.department_name
from employees e, departments d
where e.department_id(+) = d.department_id;

-- 3. 직원의 이름과 직무 이름(job title)을 출력.
select
    e.first_name || ' ' || e.last_name as "직원 이름",
    j.job_title
from employees e
    join jobs j on e.job_id = j.job_id;

select
    e.first_name || ' ' || e.last_name as "직원 이름",
    j.job_title
from employees e, jobs j
where e.job_id = j.job_id;

-- 4. 직원의 이름과 직원이 근무하는 도시 이름(city)를 출력.
select 
    e.first_name || ' ' || e.last_name as "직원 이름",
    l.city
from employees e
    join departments d on e.department_id = d.department_id
    join locations l on d.location_id = l.location_id;
--> 106개 행.

select 
    e.first_name || ' ' || e.last_name as "직원 이름",
    l.city
from employees e, departments d, locations l
where e.department_id = d.department_id
    and d.location_id = l.location_id;

-- 5. 직원의 이름과 직원이 근무하는 도시 이름(city)를 출력. 근무 도시를 알 수 없는 직원도 출력.
select
    e.first_name || ' ' || e.last_name as "직원 이름",
    l.city
from employees e
    left join departments d on e.department_id = d.department_id
    left join locations l on d.location_id = l.location_id
;
--> 107개 행.

select
    e.first_name || ' ' || e.last_name as "직원 이름",
    l.city
from employees e, departments d, locations l
where e.department_id = d.department_id(+)
    and d.location_id = l.location_id(+);

-- 6. 2008년에 입사한 직원들의 이름을 출력.
select 
    first_name || ' ' || last_name as "직원 이름",
    hire_date
from employees
where to_char(hire_date, 'YYYY') = '2008';
--> hire_date 컬럼(날짜 타입)의 값을 문자열로 변환해서 '2008' 문자열과 같은 지를 비교.

-- 입사일을 DATE 타입의 크기 비교를 사용(2008/01/01 ~ 2008/12/31)
select 
    first_name || ' ' || last_name as "직원 이름",
    hire_date
from employees
where hire_date between to_date('2008-01-01', 'YYYY-MM-DD')
    and to_date('2008-12-31', 'YYYY-MM-DD');

-- 7. 2008년에 입사한 직원들의 부서 이름과 부서별 직원수 출력.
select
    d.department_name, count(*) as "직원수"
from employees e
    join departments d on e.department_id = d.department_id
where hire_date between to_date('2008-01-01', 'YYYY-MM-DD')
    and to_date('2008-12-31', 'YYYY-MM-DD')
group by d.department_name
;

-- 8. 2008년에 입사한 직원들의 부서 이름과 부서별 인원수 출력. 
--    단, 부서별 인원수가 5명 이상인 경우만 출력.
select
    d.department_name, count(*) as "직원수"
from employees e
    join departments d on e.department_id = d.department_id
where hire_date between to_date('2008-01-01', 'YYYY-MM-DD')
    and to_date('2008-12-31', 'YYYY-MM-DD')
group by d.department_name
having count(*) >= 5
;

-- (참고) 부서별 직원 수
-- (1) inner join인 경우 -> 부서번호가 null인 직원이 포함되지 않음.
select
    d.department_name, count(*) as "직원수"
from employees e
    join departments d on e.department_id = d.department_id
group by d.department_name;

-- (2) left outer join인 경우 -> 부서번호가 null인 직원이 포함됨.
select
    d.department_name, count(*) as "직원수"
from employees e
    left join departments d on e.department_id = d.department_id
group by d.department_name;

-- (3) full outer join인 경우 -> 부서번호가 null인 직원, 모든 부서 이름이 포함.
select
    d.department_name, count(e.employee_id) as "직원수"
from employees e
    full join departments d on e.department_id = d.department_id
group by d.department_name;

-- 9. 부서번호, 부서별 급여 평균을 검색. 소숫점 한자리까지 반올림 출력.
select
    department_id, round(avg(salary), 1) as "AVG_SAL"
from employees
group by department_id
order by "AVG_SAL";

-- 10. 부서별 급여 평균이 최대인 부서의 부서번호, 급여 평균을 출력.
-- (1) having 절과 서브쿼리 사용
select
    department_id, round(avg(salary), 1) as "급여 평균"
from employees
group by department_id
having avg(salary) = (
    select max(avg(salary)) from employees
    group by department_id
);

-- (2) from 절에서의 서브쿼리 사용
select
    round(max(t."급여 평균"), 1)
from (
    select department_id, avg(salary) as "급여 평균"
    from employees
    group by department_id
) t
;

-- (3) with 식별자 as (서브쿼리) 사용
with t as (
    select department_id, avg(salary) as "급여 평균"
    from employees
    group by department_id
)
select t.department_id, round(t."급여 평균", 1) as "급여 평균"
from t
where t."급여 평균" = (
    select max(t."급여 평균") from t
)
;

-- (4) offset-fetch 사용(내림차순 정렬 & Top-N 쿼리)
select
    department_id, round(avg(salary), 1) as "급여 평균"
from employees
group by department_id
order by "급여 평균" desc
offset 0 rows
fetch next 1 rows only
;

-- 11. 사번, 직원 이름, 국가 이름, 급여 출력.
select
    e.employee_id,
    e.first_name || ' ' || e.last_name as "직원 이름",
    c.country_name,
    e.salary
from employees e
    join departments d on e.department_id = d.department_id
    join locations l on d.location_id = l.location_id
    join countries c on l.country_id = c.country_id
;

-- left join
select
    e.employee_id,
    e.first_name || ' ' || e.last_name as "직원 이름",
    c.country_name,
    e.salary
from employees e, departments d, locations l, countries c
where e.department_id = d.department_id(+)
    and d.location_id = l.location_id(+)
    and l.country_id = c.country_id(+);

-- 12. 국가이름, 국가별 급여 합계 출력.
select
    c.country_name, sum(e.salary) as "급여 평균"
from employees e
    join departments d on e.department_id = d.department_id
    join locations l on d.location_id = l.location_id
    join countries c on l.country_id = c.country_id
group by c.country_name
;

-- 13. 사번, 직원이름, 직무 이름, 급여를 출력.
select
    e.employee_id,
    e.first_name || ' ' || e.last_name as "직원 이름",
    j.job_title,
    e.salary
from employees e
    join jobs j on e.job_id = j.job_id
order by e.employee_id;

-- 14. 직무 이름, 직무별 급여 평균, 최솟값, 최댓값을 출력.
select
    j.job_title,
    avg(e.salary) as "급여 평균",
    min(e.salary) as "급여 최솟값",
    max(e.salary) as "급여 최댓값"
from employees e
    join jobs j on e.job_id = j.job_id
group by j.job_title
;

-- 15. 국가 이름, 직무 이름, 국가별 직무별 급여 평균을 출력.
select
    c.country_name, j.job_title,
    round(avg(e.salary), 1) as "급여 평균",
    count(*) as "직원수"
from employees e
    join jobs j on e.job_id = j.job_id
    join departments d on e.department_id = d.department_id
    join locations l on d.location_id = l.location_id
    join countries c on l.country_id = c.country_id
group by c.country_name, j.job_title
;

-- 16. 국가 이름, 직무 이름, 국가별 직무별 급여 합계을 출력.
--     미국에서, 국가별 직무별 급여 합계가 50,000 이상인 레코드만 출력.
select
    c.country_name, j.job_title,
    sum(e.salary) as "급여 합계"
from employees e
    join jobs j on e.job_id = j.job_id
    join departments d on e.department_id = d.department_id
    join locations l on d.location_id = l.location_id
    join countries c on l.country_id = c.country_id
where c.country_id = 'US'
group by c.country_name, j.job_title
having sum(e.salary) >= 50000
;

-- (비교)
select
    c.country_name, j.job_title,
    sum(e.salary) as "급여 합계"
from employees e
    join jobs j on e.job_id = j.job_id
    join departments d on e.department_id = d.department_id
    join locations l on d.location_id = l.location_id
    join countries c on l.country_id = c.country_id
group by c.country_name, j.job_title
having c.country_name = 'United States of America'
    and sum(e.salary) >= 50000
;

-- 17. 부서번호, 부서이름, 부서 매니저 사번, 부서 매니저 이름, 부서 매니저 직무, 부서 매니저 급여 출력
select
    d.department_id, d.department_name,
    d.manager_id,
    -- e.employee_id,
    e.first_name || ' ' || e.last_name as "매니저 이름",
    e.salary
from departments d
    join employees e on d.manager_id = e.employee_id
    join jobs j on e.job_id = j.job_id
order by d.department_id;
