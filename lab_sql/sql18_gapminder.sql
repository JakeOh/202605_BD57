/*
 * github의 gapminder.tsv 파일 다운로드, 테이블에 데이터 임포트.
 * TSV(tab-separated values): 값들이 탭으로 구분된 텍스트 파일. csv 파일의 일종.
 * 테이블 이름: gapminder
 * 컬럼 이름: country, continent, year, life_exp(기대수명), pop(인구수), gdp_percap(1인당 GDP)
 *
 * 1. 테이블에는 모두 몇 개의 나라가 있을까요?
 * 2. 테이블에는 모두 몇 개의 대륙이 있을까요?
 * 3. 테이블에는 저장된 데이터는 몇 년도부터 몇 년도까지 조사한 내용일까요?
 * 4. 기대 수명이 최댓값인 레코드(row)를 찾으세요.
 * 5. 인구가 최댓값인 레코드(row)를 찾으세요.
 * 6. 1인당 GDP가 최댓값인 레코드(row)를 찾으세요.
 * 7. 우리나라의 통계 자료만 출력하세요.
 * 8. 연도별 1인당 GDP의 최댓값인 레코드를 찾으세요.
 * 9. 대륙별 1인당 GDP의 최댓값인 레코드를 찾으세요.
 * 10. 연도별, 대륙별 인구수를 출력하세요.
 *     인구수가 가장 많은 연도와 대륙은 어디인가요?
 * 11. 연도별, 대륙별 기대 수명의 평균을 출력하세요.
 *     기대 수명이 가장 긴 연도와 대륙은 어디인가요?
 * 12. 연도별, 대륙별 1인당 GDP의 평균을 출력하세요.
 *     1인당 GDP의 평균이 가장 큰 연도와 대륙은 어디인가요?
 * 13. 10번 문제의 결과에서 대륙이름이 컬럼이 되도록 출력하세요.
 * 14. 11번 문제의 결과에서 대륙이름이 컬럼이 되도록 출력하세요.
 * 15. 12번 문제의 결과에서 대륙이름이 컬럼이 되도록 출력하세요.
 */


create table gapminder (
    country     varchar2(100 char),
    continent   varchar2(100 char),
    year        number(4),
    life_exp    number,
    pop         number,
    gdp_percap  number
);

-- 테이블의 전체 행 개수
select count(*) from gapminder;  --> 1704

-- 각각의 컬럼에 null이 있는 지 여부?
select
    count(country), count(continent), count(year),
    count(life_exp), count(pop), count(gdp_percap)
from gapminder;
--> null이 있는 컬럼은 없음.

-- 첫 20개 행만 출력
select * from gapminder
order by country, year
offset 0 rows
fetch next 20 rows only;

-- 연속형 변수 vs 범주(카테고리)형 변수
-- 연속형 변수 - 숫자(정수 또는 실수). (예) 연도, 기대수명, 인구수, 1인당 GDP, ...
-- 연속형 변수의 통계량 - 최댓값, 최솟값, 합계, 평균, 분산, 표준편차, 중앙값(중위값), ...
-- 범주형 변수 - 문자열, 정수. (예) 국가이름, 대륙이름, 연도, ...
-- 범주형 변수의 통계량 - 개수(빈도수)

-- 국가 개수
select distinct country from gapminder order by country;
select count(distinct country) from gapminder;  --> 142

-- 연도 개수
select distinct year from gapminder order by year;
select count(distinct year) from gapminder;  --> 12

select 142 * 12 from dual;  --> 국가 개수 x 연도 개수 = 행 개수

select country, count(*)
from gapminder
group by country
order by country;

select year, count(*)
from gapminder
group by year
order by year;

-- 대륙 이름, 개수
select distinct continent from gapminder order by continent;
select count(distinct continent) from gapminder;

select continent, count(*)
from gapminder
group by continent
order by continent;

-- 연속형 변수 기술 통계량(descriptive statistics)
-- 기대수명(lief_exp) 기술 통계량
select
    round(avg(life_exp), 2) as "평균",
    round(variance(life_exp), 2) as "분산",
    round(stddev(life_exp), 2) as "표준편차",
    max(life_exp) as "최댓값",
    min(life_exp) as "최솟값",
    median(life_exp) as "중앙값"
from gapminder;


-- 인구 기술 통계량
select
    round(avg(pop), 2) as "평균",
    round(variance(pop), 2) as "분산",
    round(stddev(pop), 2) as "표준편차",
    max(pop) as "최댓값",
    min(pop) as "최솟값",
    median(pop) as "중앙값"
from gapminder;

-- 1인당 GDP 기술 통계량
select
    round(avg(gdp_percap), 2) as "평균",
    round(variance(gdp_percap), 2) as "분산",
    round(stddev(gdp_percap), 2) as "표준편차",
    max(gdp_percap) as "최댓값",
    min(gdp_percap) as "최솟값",
    median(gdp_percap) as "중앙값"
from gapminder;


-- 기대수명이 최댓값인 레코드 --> 고령화된 사회(국가)
select * from gapminder
where life_exp = (
    select max(life_exp) from gapminder
);


-- 인구가 최댓값인 레코드(row)
select * from gapminder
where pop = (
    select max(pop) from gapminder
);


-- 1인당 GDP가 최댓값인 레코드
select * from gapminder
where gdp_percap = (
    select max(gdp_percap) from gapminder
);


-- 우리나라 통계 자료
select * from gapminder
where lower(country) like '%kor%';

select * from gapminder
where country = 'Korea, Rep.'
order by year;


-- 연도별 1인당 GDP의 최댓값인 레코드
select year, max(gdp_percap)
from gapminder
group by year
order by year;

-- 다중 행, 다중 컬럼 서브쿼리
select * from gapminder
where (year, gdp_percap) in (
    select year, max(gdp_percap)
    from gapminder
    group by year
)
order by year;

-- rank() 함수를 이용한 그룹별 최댓값 찾기
select
    g.*,
    rank() over (partition by year order by gdp_percap desc) as "RANKING"
from gapminder g;

with t as (
    select
        g.*,
        rank() over (partition by year order by gdp_percap desc) as "RANKING"
    from gapminder g
)
select t.*
from t
where t.RANKING <= 6;  /* where t.RANKING = 1 */


-- 대륙별 1인당 GDP 최댓값 레코드
select
    continent, max(gdp_percap)
from gapminder
group by continent
;

select *
from gapminder
where (continent, gdp_percap) in (
    select continent, max(gdp_percap)
    from gapminder
    group by continent
);

with t as (
    select
        g.*,
        rank() over (partition by continent order by gdp_percap desc) as "RANKING"
    from gapminder g
)
select t.*
from t
where t.RANKING <= 6;


-- 연도별, 대륙별 인구수
select
    year, continent, sum(pop) as "TOTAL_POP"
from gapminder
group by year, continent
order by year, continent;

select
    year, continent, sum(pop) as "TOTAL_POP"
from gapminder
group by year, continent
order by continent, year;

-- 연도별, 대륙별 인구수가 가장 많은 연도, 대륙, 그때의 인구수.
select
    year, continent, sum(pop) as "TOTAL_POP"
from gapminder
group by year, continent
order by TOTAL_POP desc;

select
    year, continent, sum(pop) as "TOTAL_POP"
from gapminder
group by year, continent
order by TOTAL_POP desc
offset 0 rows
fetch next 1 rows only;

with t as (
    select year, continent, sum(pop) as "TOTAL_POP"
    from gapminder
    group by year, continent
)
select t.*
from t
where t.TOTAL_POP = (
    select max(t.TOTAL_POP) from t
);


-- 연도별, 대륙별 기대 수명의 평균
select
    year, continent, round(avg(life_exp), 2) as "AVG_LIFE_EXP"
from gapminder
group by year, continent
order by year, continent;

select
    year, continent, round(avg(life_exp), 2) as "AVG_LIFE_EXP"
from gapminder
group by year, continent
order by continent, year;

select
    year, continent, round(avg(life_exp), 2) as "AVG_LIFE_EXP"
from gapminder
group by year, continent
order by AVG_LIFE_EXP desc;

select
    year, continent, round(avg(life_exp), 2) as "AVG_LIFE_EXP"
from gapminder
group by year, continent
order by AVG_LIFE_EXP desc
offset 0 rows
fetch next 1 rows only;

with t as (
    select year, continent, avg(life_exp) as "AVG_LIFE_EXP"
    from gapminder
    group by year, continent
)
select t.*
from t
where t.AVG_LIFE_EXP = (
    select max(t.AVG_LIFE_EXP) from t
);

-- 연도별, 대륙별 1인당 GDP의 평균
select
    year, continent, round(avg(gdp_percap), 2) as "AVG_GDP_PERCAP"
from gapminder
group by year, continent
order by year, continent;

select
    year, continent, round(avg(gdp_percap), 2) as "AVG_GDP_PERCAP"
from gapminder
group by year, continent
order by continent, year;

select
    year, continent, round(avg(gdp_percap), 2) as "AVG_GDP_PERCAP"
from gapminder
group by year, continent
order by AVG_GDP_PERCAP desc;


-- pivot() 함수
with t as (
    select year, continent, pop from gapminder
)
select * from t
pivot(
    sum(pop) for continent in ('Africa' as "AFRICA",
                                'Americas' as "AMERICAS",
                                'Asia' as "ASIA",
                                'Europe' as "EUROPE",
                                'Oceania' as "OCEANIA")
)
order by year;

with t as (
    select year, continent, pop from gapminder
)
select * from t
pivot(
    sum(pop) for year in (1952, 1957, 1962, 1967, 1972, 1977, 
                          1982, 1987, 1992, 1997, 2002, 2007)
)
order by continent;


-- pivot() 함수를 사용한 연도별 대륙별 기대수명의 평균
with t as (
    select year, continent, life_exp from gapminder
)
select
    year, 
    round("AF", 2) as africa,
    round("AM", 2) as americas,
    round("AS", 2) as asia,
    round("EU", 2) as europe,
    round("OC", 2) as oceania
from t
pivot(
    avg(life_exp) for continent in ('Africa' as "AF",
                                    'Americas' as "AM",
                                    'Asia' as "AS",
                                    'Europe' as "EU",
                                    'Oceania' as "OC")
)
order by year;


-- pivot() 함수를 사용한 연도별, 대륙별 1인당 GDP 평균
with t as (
    select year, continent, gdp_percap from gapminder
)
select
    year, 
    round("AF", 2) as africa,
    round("AM", 2) as americas,
    round("AS", 2) as asia,
    round("EU", 2) as europe,
    round("OC", 2) as oceania
from t
pivot(
    avg(gdp_percap) for continent in ('Africa' as "AF",
                                    'Americas' as "AM",
                                    'Asia' as "AS",
                                    'Europe' as "EU",
                                    'Oceania' as "OC")
)
order by year;