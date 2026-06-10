/*
 * DDL(Data Definitin Language): create, alter, truncate, drop
 *
 * alter table: 테이블 (정의) 변경.
 * 1. 이름 변경: alter table ... rename ... to ...;
 * 2. 추가: alter table ... add ...;
 * 3. 삭제: alter table ... drop ...;
 * 4. 수정: alter table ... modify ...;
 */

-- 1. 이름 변경(rename): 테이블 이름, 컬럼 이름, 제약조건 이름을 변경.
-- (1) 테이블 이름 변경: ALTER TABLE table_name RENAME TO new_table_name;
-- ex_stuedents 테이블 이름을 students로 변경.
alter table ex_students rename to students;

-- (2) 컬럼 이름 변경: ALTER TABLE table_name RENAME COLUMN column_name TO new_column_name;
-- students 테이블의 birthday 컬럼의 이름을 student_birthday로 변경.
alter table students rename column birthday to student_birthday;

-- (3) 제약조건 이름 변경: ALTER TABLE table_name RENAME CONSTRAINT original_name TO new_name;
-- ex_tbl1 테이블에서 제약조건 SYS_C008351 이름을 pk_ex_tbl1으로 변경.
alter table ex_tbl1 rename constraint SYS_C008351 to pk_ex_tbl1;


-- 2. 추가(add): 컬럼 추가, 제약조건 추가.
-- (1) 컬럼 추가: alter table ... add 테이블 생성할 때 컬럼 선언 문법;
-- ALTER TABLE table_name ADD 컬럼_이름 데이터_타입 [[기본값] [제약조건]];
-- students 테이블에 student_email 이름의 컬럼(가변길이 문자열 최대 100 바이트)을 추가.
alter table students add student_email varchar2(100);

-- students 테이블에 student_grade 이름의 컬럼(1자리 정수, 기본값 1)을 추가.
alter table students add student_grade number(1) default 1;

insert into students (student_id, student_name) values (2000, '박길동');
commit;

select * from students;

-- (2) 제약조건 추가: alter table ... add 테이블 생성할 때 제약조건을 따로 선언하는 문법;
-- ALTER TABLE table_name ADD CONSTRAINT 제약조건_이름 제약조건_내용;
-- students 테이블에서 student_id 컬럼에 고유키(PK) 제약조건을 추가.
alter table students add constraint pk_students primary key (student_id);

-- students 테이블에서 student_name 컬럼에 not null 제약조건을 추가.
alter table students add constraint nn_students_name check (student_name is not null);
--> students 테이블의 데이터에는 student_name이 null인 데이터가 이미 존재.
--> not null 제약조건에 위배되기 때문에 not null 제약조건을 추가할 수 없음.
--> 해결 방법: student_name이 null인 데이터를 삭제하거나, null이 아닌 값을 채우고 나서 NN 제약조건을 추가할 수 있음.

-- students 테이블에서 student_name이 null인 데이터를 삭제.
delete from students where student_name is null;
commit;

-- 이제 위 45 행의 문장을 실행하면 alter table 명령은 성공.


-- 3. 삭제(drop): 컬럼 삭제, 제약조건 삭제.
-- (1) 컬럼 삭제: ALTER TABLE table_name DROP COLUMN 삭제할_컬럼_이름;
-- students 테이블에서 student_birthday 컬럼을 삭제.
alter table students drop column student_birthday;

-- (2) 제약조건 삭제: ALTER TABLE table_name DROP CONSTRAINT 삭제할_제약조건_이름;
-- students 테이블에서 nn_students_name 제약조건을 삭제.
alter table students drop constraint nn_students_name;

-- (참고) 메타 테이블(meta table): 테이블을 관리하기 위해서 데이터베이스가 생성하고 유지하는 테이블.
-- 오라클 메타 테이블의 예: user_tables, user_constraints, ...
-- 오라클은 메타 테이블에 테이블/컬럼/제약조건 이름을 저장할 때 일반적으로 "대문자"로 저장.
select * from user_tables;

-- scott 계정에서 생성한 테이블 이름들만 검색
select table_name from user_tables;

-- scott 계정의 테이블들 중에서 'ex_'로 시작하는 테이블 이름들만 검색.
select table_name from user_tables where table_name like 'EX_%';
--> (주의) like 'ex_%' 검색 조건을 사용하면 조건을 만족하는 행이 하나도 없음.

select * from user_constraints;
select constraint_name, constraint_type, table_name, search_condition
from user_constraints;

-- ex_tbl1 테이블에서 constraint_name, constraint_type, table_name, search_condition을 검색.
select constraint_name, constraint_type, table_name, search_condition
from user_constraints
where table_name = 'EX_TBL1';
--> 제약조건 타입: P(primary key), U(unique), C(check, not null)
