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
--> 제약조건 타입: P(primary key), U(unique), C(check, not null), R(relation, foreign key)

-- 이름이 'SYS_'로 시작하는 제약조건들의 이름, 타입, 테이블 이름, 조건을 검색.
select constraint_name, constraint_type, table_name, search_condition
from user_constraints
where constraint_name like 'SYS_%';


-- 수정(modify): 기존에 만들어진 컬럼의 정의(데이터 타입, 기본값, null 여부) 수정.
-- ALTER TABLE table_name MODIFY 컬럼 선언 문법;
-- students 테이블에서 student_grade 컬럼(number(1, 0) default 1)을 
-- number(2, 0) not null로 변경.
alter table students modify student_grade number(2) not null;

-- students 테이블에서 student_name 컬럼에 가변길이 최대 20글자까지 저장할 수 있도록 수정.
alter table students modify student_name varchar2(20 char);

-- 기존에 설정되어 있던 기본값(default) 삭제.
-- 오라클인 경우, students 테이블에서 student_grade 컬럼의 기본값 설정을 삭제
alter table students modify student_grade default null;  --> defualt 값을 null로 설정
alter table students drop constraint SYS_C008402;  --> NN 제약조건 삭제

insert into students (student_id, student_name) values (3000, '오쌤2');
commit;
select * from students;


-- trauncate table 테이블_이름;
-- 테이블의 모든 행을 삭제. DDL. rollback되지 않음!
truncate table students;
rollback;  --> rollback을 수행해도 잘려진 행들이 복원되지 않음!


-- drop table 테이블_이름;
-- 오라클 버전 10g부터는 휴지통 기능이 추가. drop table은 테이블을 휴지통으로 삭제.
drop table students;
--> 테이블과 테이블에 설정된 제약조건들이 함께 삭제됨.

-- 휴지통으로 삭제된 테이블을 복구하는 방법.
flashback table students to before drop;

-- students 테이블을 휴지통으로 삭제
drop table students;

-- 휴지통에 있는 students 테이블을 완전 삭제
purge table students;
--> 휴지통(recyclebin)에서 students 테이블과 테이블에 설정된 제약조건들이 완전 삭제.
--> flashback 불가능.

-- 휴지통 비우기.
purge recyclebin;

-- ex_emp_dept 테이블을 완전 삭제
drop table ex_emp_dept purge;

-- PK와 FK 관계로 연결을 맺고 있는 2개의 테이블이 있을 때, 테이블 삭제 순서가 중요.
-- (1) FK를 갖고 있는 테이블(자식 테이블)을 먼저 삭제. PK를 갖는 테이블(부모 테이블)을 나중에 삭제.
-- (2) FK 제약조건을 삭제 후 테이블들을 삭제.
-- (3) drop table ... cascade constraints; 구문을 사용하면 연관된 FK 제약조건이 함께 삭제됨.

-- (1) 
-- ex_emp3 (FK) ---> ex_dept3 (PK) 관계의 테이블들에서 ex_dept3을 먼저 삭제하려고 하면 에러가 발생.
-- ex_emp2 (FK) ---> ex_dept3 (PK) 관계의 테이블들에서 ex_dept3을 먼저 삭제하려고 하면 에러가 발생.
-- ex_emp2과 ex_emp3을 먼저 삭제, 그 후에 ex_dept3을 삭제.
drop table ex_emp3;
drop table ex_emp2;
drop table ex_dept3;

-- (2) 
-- orders (FK) ---> customers (PK) 관계에 테이블에서 customers를 먼저 삭제하려고 하면 에러가 발생.
-- orders 테이블의 FK 제약조건을 삭제
alter table orders drop constraint fk_orders_cust_id;
-- orders와 customers의 관계가 끊어졌기 때문에, customers 테이블을 삭제하는 것이 가능.
drop table customers;


-- (3)
create table ex_parent (
    id number(1) primary key
);

create table ex_child (
    child_id number(1) primary key,
    parent_id number(1) references ex_parent (id)
);

drop table ex_parent cascade constraints;
--> cascade constraints 구문을 사용하면 (1) FK 제약조건이 삭제되고, (2) 테이블 삭제를 수행.
