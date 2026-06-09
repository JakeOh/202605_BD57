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
 *
 * 테이블에 삽입하는 값들의 개수가 컬럼 개수와 같고, 그 순서가 테이블의 컬럼 순서와 동일한 경우,
 * insert into 테이블_이름 values (값1, 값2, ...);
 */
insert into ex_students (student_id, student_name, birthday)
values (1001, '홍길동', '2026/06/05');
--> 오라클은 '2026/06/05' 문자열을 날짜 타입으로 변환해서 birthday 컬럼에 값을 삽입.

insert into ex_students (birthday, student_id, student_name)
values ('2000/06/05', 1002, '김길동');

insert into ex_students (student_id, student_name)
values (1003, '이길동');

insert into ex_students values (2000, '홍길동');
--> not enough values 에러

insert into ex_students
values (1004, '오쌤', '2000/01/01');

commit;  -- 테이블의 변경 내용을 데이터베이스에 영구히 저장.

select * from ex_students;

insert into ex_students (student_id)
values (12345);
--> 숫자 전체 자릿수(4)를 초과하는 값은 insert가 되지 않음.

insert into ex_students (student_id)
values ('abcd');
--> 오라클은 'abcd' 문자열을 숫자 타입으로 변환하다가 에러를 발생 시킴.

insert into ex_students (student_id)
values ('1010');
--> 오라클은 '1010' 문자열을 to_number() 함수를 사용해서 정수 1010으로 변환 후 삽입.

insert into ex_students (student_name)
values ('aaaaaaaaaaa');
--> 최대 10글자(character)까지 저장할 수 있는 컬럼에 11글자를 삽입하려고 하기 때문에 에러.

commit;

-- 오라클에서 문자열 타입 컬럼을 선언할 때 char(n byte)/char(n char) 또는 varchar2(n byte)/varchar2(n char).
-- byte/char 단위를 생략하면 기본값은 byte 단위.
-- 오라클에서 문자를 저장할 때 UTF-8 인코딩을 사용하는 경우,
-- 영문자, 숫자, 특수기호 -> 한 글자를 저장할 때 1 byte를 사용.
-- 한글, 일본어, 중국어, ... -> 한 글자를 저장할 때 3 byte를 사용.

create table ex_byte (
    col_str varchar2(5)  /* varchar2(5 byte)과 동일. */
);

insert into ex_byte values ('abc12');
insert into ex_byte values ('abc123');  --> 에러(6 byte)
insert into ex_byte values ('길동');  --> 에러(6 byte)
insert into ex_byte values ('홍12');


-- create table 연습: emp 테이블과 같은 이름과 같은 타입의 컬럼들을 갖는 테이블(ex_emp)
create table ex_emp (
    empno       number(4, 0),  /* 4자리 정수 */
    ename       varchar2(10 byte),  /* 최대 10 바이트까지 저장할 수 있는 문자열 */
    job         varchar2(9),  /* varchar2(9 byte)과 동일한 선언 */
    mgr         number(4),  /* number(4, 0)과 동일한 선언 */
    hiredate    date,
    sal         number(7, 2),  /* 전체 7자리 중 소숫점 이하는 2자리 */
    comm        number(7, 2),
    deptno      number(2)
);
