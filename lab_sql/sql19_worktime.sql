/*
 * OECD 국가 연평균 근로 시간
 * github에 있는 연평균_근로시간_OECD.xlsx 파일의 테이블을 데이터베이스에 저장, 분석.
 * 1. 우리나라(한국)의 연평균 근로시간을 출력하세요.
 * 2. 2018년에 한국의 평균 근로시간보다 근로시간이 더 긴 국가들을 찾아보세요.
 * 3. 2018년의 평균 근로시간 상위 5개 국가들을 찾아보세요.
 * 4. 가장 긴 근로시간은 몇 년도의 어느 나라인 지 찾아보세요.
 * 5. 각각의 연도에서 평균 근로시간이 가장 많은 나라들을 찾아보세요.
 */

-- 엑셀 파일의 내용을 저장할 수 있는 테이블 생성
create table worktimes (
    country varchar2(20 char),
    y2014   number(4),
    y2015   number(4),
    y2016   number(4),
    y2017   number(4),
    y2018   number(4)
);

-- 데이터 탐색
-- 전체 행의 개수
select count(*) from worktimes;  --> 35

-- 각각의 컬럼에 null이 있는 지 여부
select count(country), count(y2014), count(y2015), count(y2016), count(y2017), count(y2018)
from worktimes;

-- 중복되지 않는 나라 이름 개수
select count(distinct country) from worktimes;  --> 35

select * from worktimes;

-- 1. 우리나라(한국)의 연평균 근로시간
select * from worktimes where country = '한국';
--> 0개 행.
--> '한국' 글자 앞에 공백(또는 특수문자)`이 포함되어져 있어서.

select * from worktimes where country like '%한국%';  --> 1개 행.

-- 데이터 정제
-- 모든 국가 이름 앞에 포함된 공백(특수문자)을 제거
-- trim(문자열[컬럼]): 문자열의 앞뒤(시작과 끝)에 포함된 공백(스페이스, 탭, 엔터)들을 제거.
select '   hello  sql   ', trim('   hello  sql   ') from dual;

select country, trim(country) from worktimes;
--> 나라 이름 앞에 포함된 공백을 제거하지 못함!


-- replace(문자열[컬럼], 바꾸기전 문자열, 바꿀 문자열)
select '   hello  sql   ', replace('   hello  sql   ', ' ', '') from dual;
--> '   hello sql   ' 문자열에서 공백(스페이스)을 빈 문자열로 대체.

select country, replace(country, '　', '') from worktimes;


-- substr(문자열[컬럼], 자르기 시작할 인덱스): 문자열[컬럼]에서 시작 인덱스부터 문자열 끝까지를 잘라줌.
select '   hello sql   ', substr('   hello  sql   ', 4) from dual;

select country, substr(country, 4) from worktimes;

-- 테이블 업데이트: 나라 이름 앞에 있는 모든 공백들을 제거
update worktimes
set country = substr(country, 4);

commit;

select * from worktimes where country = '한국';


-- 2. 2018년에 한국의 연평균 근로시간보다 근로시간이 더 긴 국가들
-- 2018년 한국 연평균 근로시간
select country, y2018 from worktimes where country = '한국';  --> 1993H

-- 2018년 자료들 중에서만, 근로시간이 2018년 한국 연평균 근로시간(1993H)보다 긴 국가들
select country, y2018 from worktimes
where y2018 > (select y2018 from worktimes where country = '한국');

-- 모든 연도에서, 근로시간이 2018년 한국 연평균 근로시간(1993H)보다 긴 국가들
select * from worktimes
where y2014 > (select y2018 from worktimes where country = '한국')
    or y2015 > (select y2018 from worktimes where country = '한국')
    or y2016 > (select y2018 from worktimes where country = '한국')
    or y2017 > (select y2018 from worktimes where country = '한국')
    or y2018 > (select y2018 from worktimes where country = '한국');


-- 3. 2018년의 연평균 근로시간 상위 5개 국가들
-- (1) offset ~ fetch 구문
select * from worktimes
order by y2018 desc
offset 0 rows
fetch next 5 rows only;

-- (2) rank() 윈도우 함수
select 
    w.*,
    rank() over (order by y2018 desc) as ranking
from worktimes w;

with t as (
    select
        w.*,
        rank() over (order by y2018 desc) as ranking
    from worktimes w
)
select * from t
where t.ranking <= 5;


-- 각각의 연도에서 연평균 근로시간이 가장 긴 나라
-- 2014년에서 연평균 근로시간이 가장 긴 나라
select * from worktimes
where y2014 = (select max(y2014) from worktimes);

-- 2015년에서 연평균 근로시간이 가장 긴 나라
select * from worktimes
where y2015 = (select max(y2015) from worktimes);

select * from worktimes
where y2016 = (select max(y2016) from worktimes);

select * from worktimes
where y2017 = (select max(y2017) from worktimes);

select * from worktimes
where y2018 = (select max(y2018) from worktimes);

-- 4. 가장 긴 근로시간은 몇 년도의 어느 나라일까?
-- unpivot(): 컬럼의 내용들을 행으로 바꿈. 가로로 긴 데이터 --> 세로로 긴 데이터.
-- unpivot(컬럼으로_사용할_이름 for 변수 in (column1, column2, ...))
select * from worktimes
unpivot(avg_work_time for year in (y2014, y2015, y2016, y2017, y2018));

