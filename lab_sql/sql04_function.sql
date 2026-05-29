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
