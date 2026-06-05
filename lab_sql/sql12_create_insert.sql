/*
 * SQL 문장의 종류
 * 1. DDL(Data Definition Language): create, alter, truncate, drop
 * 2. DQL(Data Query Language): select
 * 3. DML(Data Manipulation Language): insert, update, delete
 * 4. TCL(Transaction Control Language): commit, rollback
 *
 * 테이블 생성 SQL
 * create table 테이블_이름 (
 *     컬럼_이름 데이터타입 [[기본값] [제약조건]],
 *     ...
 * );
 *
 * ANSI SQL 국제 표준에 데이터베이스 간의 호환성을 유지하기 위해서 데이터 타입 이름들을 정의하고 있음.
 * 데이터 타입으로 사용되는 키워드(예약어)들은 데이터베이스 종류에 따라서 다름.
 * ANSI SQL 표준 데이터 타입 이름
 * 1. 숫자
 *    (1) integer, int: 4바이트 정수.
 *    (2) numeric(p, s): 전체 자릿수(p) 중에서 소숫점 이하 자릿수(s)인 실수.
 * 2. 문자열
 *    (1) char(n), character(n): 고정 길이(n 바이트) 문자열.
 *    (2) varchar(n): varying character. 가변 길이(n 바이트) 문자열.
 * 3. 날짜/시간
 *    (1) date: 날짜(년/월/일)
 *    (2) time: 시간(시/분/초)
 *    (3) timestamp: 날짜와 시간을 포함한 세부적인 시간. milli-second, micro-second, nano-second.
 * 4. 대용량 데이터
 *    (1) clob: character large object. 매우 용량이 큰 문자열 데이터.
 *    (2) blob: binary large object. 매우 용량이 큰 이진 데이터(mp3, mp4, jpg, ...).
 * Oracle에서 사용되는 데이터 타입 이름
 * 1. 숫자: number(p, s) - 전체 자릿수(p) 중에서 소숫점 이하 자릿수(s)인 숫자.
 * 2. 문자열:
 *    (1) 고정 길이 문자열: char(n)
 *    (2) 가변 길이 문자열: varchar2(n)
 * 3. 날짜:
 *    (1) date: 날짜와 시간(년/월/일 시/분/초)
 *    (2) timestamp: 최대 nano-second(1/1000000000)까지 저장할 수 있는 시간 단위.
 * 4. 대용량 데이터: 표준과 동일.
 */


/*
 * 테이블 이름: ex_students
 * 컬럼:
 *   (1) student_id: 학생 아이디. 숫자 타입(최대 4자리 정수).
 *   (2) student_name: 학생 이름. 문자열 타입(가변 길이 최대 10 글자).
 *   (3) birthday: 학생 생일. 날짜 타입.
 */
create table ex_students (
    student_id      number(4, 0),
    student_name    varchar2(10 char),
    birthday        date
);

/*
 * 테이블에 행(row)을 삽입(저장):
 * insert into 테이블_이름 (컬럼1, 컬럼2, ...) values (값1, 값2, ...);
 */
insert into ex_students (student_id, student_name, birthday)
values (1001, '홍길동', '2026/06/05');



