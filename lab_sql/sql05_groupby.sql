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
