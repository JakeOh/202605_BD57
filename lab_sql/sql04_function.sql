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


-- nvl(var, value): var가 null이면 value를 반환하고, 그렇지 않으면 var를 그대로 반환.
select comm, nvl(comm, -1) from emp;

-- nvl2(var, value1, value2): var가 null이 아니면 value1을 반환, null이면 value2를 반환.
select comm, nvl2(comm, 1, 0) from emp;

-- 직원 이름, 급여(sal), 수당(comm), 연봉을 출력.
-- 연봉 = 급여 * 12 + 수당
select
    ename, sal, comm, sal * 12 + comm  --> 연봉이 null이 되는 경우가 있음.
from emp;

select
    ename, sal, comm, 
    sal * 12 + nvl(comm, 0) as "연봉"
from emp;

-- 연봉이 30,000 이상인 직원들의 부서번호, 이름, 급여, 수당, 연봉을 출력.
-- 연봉 내림차순 정렬.
select
    deptno, ename, sal, comm, 
    sal * 12 + nvl(comm, 0) as "ANNUAL SALARY"
from emp
where sal * 12 + nvl(comm, 0) >= 30000
order by "ANNUAL SALARY" desc;
--> select 절에서 설정한 별명(alias)는 where 절에서 사용할 수 없음!
--> order by 절에서는 사용할 수 있음.

-- 연봉이 10,000 이상 30,000 이하인 직원들의 사번, 이름, 연봉을 연봉 내림차순으로 출력.
select 
    empno, ename,
    sal * 12 + nvl(comm, 0) as "ANNUAL_SAL"
from emp
where sal * 12 + nvl(comm, 0) between 10000 and 30000
order by "ANNUAL_SAL" desc;


-- round(컬럼/식, 숫자): 반올림
select
    10 / 3,
    round(10 / 3, 1),  --> 소수점 둘째 자리에서 반올림해서 소수점 이하 한 자리까지만 표현.
    round(10 / 3, 2),  --> 반올림해서 소수점 이하 둘째 자리까지 표현
    round(10 / 3, 3)   --> 반올림해서 소수점 이하 셋째 자리까지 표현.
from dual;

select 
    round(153, -1), --> 일의 자리에서 반올림.
    round(153, -2)  --> 십의 자리에서 반올림. 
from dual;

-- trunc(컬럼/식, 숫자): 버림. 잘라냄.
select trunc(3.141592, 3), round(3.141592, 3) from dual;


-- decode(var, value, return1, return2):
-- var의 값이 value와 같으면 return1을 반환, 그렇지 않으면 return2 반환.
-- 10번 부서는 보너스를 50, 그 외의 부서들은 보너스를 100.
select
    ename, deptno,
    decode(deptno, 10, 50, 100) as "BONUS"
from emp;

-- decode(var, value1, return1, value2, return2, return3):
-- var의 값이 value1이면 return1을 반환,
-- 그렇지 않고 var의 값이 value2이면 return2를 반환,
-- 그렇지 않으면 return3을 반환.
-- 10번 부서는 보너스를 50, 20번 부서는 보너스를 100, 그 이외의 부서들은 200.
select
    ename, deptno,
    decode(deptno, 10, 50, 20, 100, 200) as "BONUS"
from emp;

-- decode 함수의 단점은 값이 같은 지만 비교할 수 있음. 크기 비교는 할 수 없음!
-- 조건식이 많아질 수록 아규먼트 개수가 매우 많아짐. 문장만 보고 결과를 예측하기 힘듦.

-- case-when 구문: decode() 함수를 대신할 수 있는 문법.
select
    ename, deptno,
    case
        when deptno = 10 then 50
        when deptno = 20 then 100
        else 200
    end as "BONUS"
from emp;

-- case-when 구문을 사용해서
-- 이름, 급여, 보너스(급여가 3000 이상이면 100, 2000 이상이면 150, 1000 이상이면 200, 그 이외에는 250)
select 
    ename, sal,
    case
        when sal >= 3000 then 100
        when sal >= 2000 then 150
        when sal >= 1000 then 200
        else 250
    end as "BONUS"
from emp;
    
