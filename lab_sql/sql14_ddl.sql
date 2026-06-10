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

-- (2) 컬럼 이름 변경: ALTER TABLE table_name RENAME COLUMN column_name TO new_column_name;

-- (3) 제약조건 이름 변경: ALTER TABLE table_name RENAME CONSTRAINT original_name TO new_name;
