/*
 * 제약조건(constraint): 데이터의 무결성을 유지하기 위한 조건들.
 * 데이터 무결성: 테이블의 데이터가 변경(insert, update, delete)될 때 
 * 결점이 없는 데이터들로만 삽입/변경/삭제될 수 있도록 유지하는 것.
 * 1. primary key(PK, 고유키)
 *    - 테이블에서 유일한 1개의 행(row)을 선택할 수 있는 컬럼(들).
 *    - PK로 설정된 컬럼(들)은 null이 될 수 없고, 중복된 값을 가질 수 없음.
 * 2. not null(NN)
 *    - 반드시 값을 가져야만 하는 컬럼. null이 될 수 없는 컬럼. 중복되는 값들은 가질 수 있음.
 * 3. unique
 *    - 중복된 값을 가질 수 없는 컬럼. null은 여러개가 있을 수 있음.
 * 4. check
 *    - 컬럼에 삽입되는 값들이 어떤 특정 조건을 만족해야 하는 경우.
 *    - not null 제약조건은 check 제약조건의 특별한 경우.
 *    - check (column is not null)
 * 5. foreign key(FK, 외래키)
 *    - 다른 테이블의 고유키(PK)를 참조하는 컬럼.
 *    - (예) emp 테이블의 deptno(FK)는 dept 테이블의 deptno(PK)를 참조.
 *    - 다른 테이블에서 PK가 먼저 만들어져 있어야 FK 제약조건을 설정할 수 있음.
 */

-- 테이블을 생성할 때 제약조건 만들기 1: 제약조건의 이름을 설정하지 않는 경우.
-- 오라클은 제약조건들의 이름을 자동으로 만들어 줌. (예) SYS_C001234
-- 제약조건의 이름들은 제약조건을 변경하거나 삭제할 때 필요.
create table ex_tbl1 (
    id      number(4, 0) primary key,
    name    varchar2(10 char) not null,
    email   varchar2(100 char) unique,
    salary  number(10, 2) check (salary >= 0),
    memo    varchar2(1000 char)
);

insert into ex_tbl1
values (1001, '홍길동', 'hgd@itwill.co.kr', 12345, '안녕하세요');

commit;

select * from ex_tbl1;

-- 위 33번 줄의 SQL insert 문장을 처음 실행할 때는 성공.
-- 다시 한 번 실행하면 primary key 제약조건 위배로 에러가 발생.
-- PK로 설정된 컬럼에는 중복된 값이 insert될 수 없기 때문.

insert into ex_tbl1 (id, name) values (1002, '홍길동');  --> 성공

insert into ex_tbl1 (name, email) values ('홍길동', 'gildong@gmail.com');
--> 에러 발생: PK 컬럼은 null이 될 수 없기 때문에.

insert into ex_tbl1 (id) values (1003);
--> 에러 발생: name 컬럼(not null 제약조건)은 null이 될 수 없기 때문에.

insert into ex_tbl1 (id, name, email) values (2001, '홍길동', 'hgd@itwill.co.kr');
--> 에러 발생: email 컬럼(unique 제약조건)은 중복된 값이 삽입될 수 없기 때문에.

insert into ex_tbl1 (id, name, email) values (2001, '홍길동', 'gildong@gmail.com');

insert into ex_tbl1 (id, name, salary) values (3001, '김길동', -100);
--> 에러 발생: salary >= 0 체크 제약조건을 위배.


-- 테이블 생성할 때 제약조건 만들기 2: 제약조건 이름 설정.
-- (1) 컬럼을 선언할 때 제약조건 이름을 설정.
-- 컬럼_이름 데이터타입 constraint 제약조건_이름 제약조건
create table ex_tbl2 (
    id      number(4, 0) 
            constraint pk_ex_tbl2 primary key,
    name    varchar2(10 char)
            constraint nn_ex_tbl2_name not null,
    email   varchar2(100 char)
            constraint uq_ex_tbl2_email unique,
    salary  number(10, 2)
            constraint ck_ex_tbl2_salary check (salary >= 0),
    memo    varchar2(1000 char)
);


-- (2) 컬럼 선언 따로, 제약조건 선언을 따로 하는 방법.
-- constraint [제약조건_이름] 제약조건 (컬럼)
-- not null 제약조건인 경우에는 check 제약조건으로 선언해야 함!
create table ex_tbl3 (
    /* 컬럼 선언부 */
    id      number(4),
    name    varchar2(10 char),
    email   varchar2(100 char),
    salary  number(10, 2),
    memo    varchar2(1000 char),
    
    /* 제약조건 선언부 */
    constraint pk_ex_tbl3 primary key (id),
    constraint nn_ex_tbl3_name check (name is not null),  /* 주의!! */
    constraint uq_ex_tbl3_email unique (email),
    constraint ck_ex_tbl3_salary check (salary >= 0)
);

