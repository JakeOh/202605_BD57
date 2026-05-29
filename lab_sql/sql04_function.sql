/*
 * 오라클 함수(function)
 * 1. 단일 행 함수
 *    - 행(row)이 하나씩 함수의 아규먼트로 전달되고, 행마다 결과값이 반환되는 함수.
 *    - (예) to_number, to_char, to_date, lower, upper, ...
 * 2. 다중 행 함수
 *    - 테이블에서 여러개의 행들이 함수의 아규먼트로 전달되고, 하나의 결과값이 반환되는 함수.
 *    - (예) 통계 관계 함수: count, sum, avg, ...
 */

-- to_char(컬럼, '포맷'): 컬럼의 값들을 '포맷' 형식의 문자열로 반환.
select
    ename, hiredate,
    to_char(hiredate, 'YYYY-MM-DD'),
    to_char(hiredate, 'MM-DD-YYYY')
from emp;

-- 사번, 이름, 입사연도를 출력
select
    empno, ename, to_char(hiredate, 'YYYY') as "입사연도"
from emp;

-- lower(문자열 컬럼): 소문자로 변환.
-- upper(문자열 컬럼): 대문자로 변환.
-- initcap(문자열 컬럼): 문자열에서 첫글자만 대문자로, 나머지는 소문자로 변환.
select
    lower('SMITH'), upper('smith'), initcap('smITH')
from dual;

select
    ename, lower(ename), upper(ename), initcap(ename)
from emp;

-- 직원 이름 중에 대/소문자 구분 없이 'a'가 포함된 직원들의 레코드.
select * from emp
where lower(ename) like '%a%';

select * from emp
where upper(ename) like '%A%';

-- replace(문자열 컬럼, 변환 전 문자, 변환 후 문자)
-- 원본 문자열에 포함된 변환 전의 문자를 변환 후의 문자로 변환.
select replace('smith', 'i', '*') from dual;
select replace('allen', 'l', '*') from dual;

select replace(ename, 'A', '-') from emp;

-- substr(문자열 컬럼, 자르기 시작 인덱스, 자를 문자 개수)
select substr('Hello, SQL!', 3, 6) from dual;

-- 직원 이름의 첫 2글자만 출력.
select substr(ename, 1, 2) from emp;

-- substr(문자열 컬럼, 자르기 시작 인덱스): 시작 인덱스부터 문자열 끝까지 자름.
select substr('Hello, SQL!', 10) from dual;

-- length(문자열 컬럼): 문자열의 글자 개수를 반환.
-- lengthb(문자열 컬럼): 문자열의 바이트(byte) 수를 반환.
select length('hello'), lengthb('hello') from dual;
select length('안녕하세요'), lengthb('안녕하세요') from dual;
--> 영문자(a, b, A, B, ...), 숫자(0, 1, 2, ...), 특수기호(!, @, #, ...)들은 오라클에 저장될 때 1바이트가 사용됨.
--> 한글 1글자는 3바이트가 사용됨.

-- 직원 이름이 6글자 이상인 직원들의 레코드.
select * from emp where length(ename) >= 6;

-- 직원 이름의 첫글자와 마지막 글자만 표기하고 중간은 '*'로만 출력.
select 
    ename, substr(ename, 1, 1), substr(ename, length(ename), 1)
from emp;

select
    substr(ename, 1, 1) || '*' || substr(ename, length(ename), 1) as "이름"
from emp;


-- to_date(문자열, '날짜 포맷'): '날짜 포맷' 형식으로 작성된 문자열을 날짜(date) 타입으로 변환.
select to_date('2026-05-29', 'YYYY-MM-DD') from dual;
select to_date('05-29-2026', 'MM-DD-YYYY') from dual;
select to_date('05-08-2026', 'DD-MM-YYYY') from dual;

-- 연도 2자리 표기법(YY와 RR의 차이점)
-- YY(현재 세기): 현재 세기의 끝 두 자리 연도.
-- RR(반올림 세기): 반올림해서 현재 세기가 될 수 있는 연도의 끝 두 자리.
--   현재 세기(21세기)
--   반올림해서 21세기가 되는 연도들: 1950 ~ 2049

select to_date('99-11-20', 'YY-MM-DD') from dual;  --> 2099-11-20
select to_date('99-11-20', 'RR-MM-DD') from dual;  --> 1999-11-20
select to_date('49-05-29', 'RR-MM-DD') from dual;  --> 2049-05-29

-- 1981 ~ 1982 사이에 입사한 직원들의 레코드.
select * from emp
where hiredate between to_date('81/01/01', 'RR/MM/DD') and to_date('82/12/31', 'RR/MM/DD');
