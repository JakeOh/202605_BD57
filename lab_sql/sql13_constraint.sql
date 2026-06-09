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


-- Foreign Key(외래키): (다른/같은) 테이블의 PK를 참조하는 제약조건.
-- 데이터를 삽입/변경할 때 PK에 없는 값은 삽입/변경되지 못하도록 하기 위해서.
-- (1) PK를 갖는 테이블을 먼저 생성. 그 다음에 PK를 참조하는 FK를 갖는 테이블을 나중에 생성.
--     (예) 부서 테이블(dept)를 먼저 생성. 직원 테이블(emp) 테이블을 나중에 생성.
-- (2) PK 또는 FK 제약조건 설정 없이 테이블들을 먼저 생성. 그 다음에 제약조건들을 순서대로 추가(alter table).

-- PK를 갖는 테이블 생성. 다른 테이블에서 참조하게 될 테이블을 생성.
create table ex_dept3 (
    id      number(2),
    name    varchar2(10 char),
    constraint pk_ex_dept3 primary key (id),
    constraint nn_ex_dept3_name check (name is not null)
);

insert into ex_dept3 values (10, 'IT');
insert into ex_dept3 values (20, 'HR');
commit;

-- 컬럼 선언할 때 제약조건도 함께 선언하는 방법.
create table ex_emp2 (
    id      number(4)
            constraint pk_ex_emp2 primary key,
    name    varchar2(10 char)
            constraint nn_ex_emp2_name not null,
    dept_id number(2)
            constraint fk_ex_emp2_dept_id references ex_dept3 (id)
);

insert into ex_emp2 values (1000, '오쌤', 10);
commit;

insert into ex_emp2 values(2000, '홍길동', 50);
--> 에러 발생: 부모 키가 없음(ex_dept3 테이블에 없는 부서 번호).

-- 컬럼 선언 따로, 제약조건 선언 따로 하는 방법.
create table ex_emp3 (
    id      number(4),
    name    varchar2(10 char),
    dept_id number(2),
    constraint pk_ex_emp3 primary key (id),
    constraint nn_ex_emp3_name check (name is not null),
    constraint fk_ex_emp3_dept_id foreign key (dept_id) references ex_dept3 (id)
);


-- 기본값을 갖는 컬럼 선언
create table ex_contents (
    id              number(6)
                    constraint pk_ex_contents primary key,
    contents        varchar2(1000 char)
                    constraint nn_ex_contents not null,
    view_cnt        number(10)
                    default 0  /* 기본값 설정 */
                    constraint ck_view_cnt check (view_cnt >= 0),
    created_time    timestamp
                    default systimestamp  /* 기본값은 현재 시간 */
);

insert into ex_contents (id, contents) values (1, '안녕하세요!');
commit;

select * from ex_contents;
--> insert할 때 view_cnt와 created_time에 값을 주지 않았을 때, default에서 선언된 값이 자동으로 삽입됨.

insert into ex_contents values (2, 'Hello, SQL!', 100, '2026/01/01 15:30:20');
commit;

select * from ex_contents;
--> insert할 때 view_cnt와 created_time 값을 주면, 기본값은 무시됨.


/*
 * 연습문제 1.
 * 테이블 이름: customers(고객)
 * 컬럼:
 * (1) cust_id: 고객 아이디. 8 ~ 20 char의 문자열. primary key.
 * (2) cust_pw: 고객 비밀번호. 8 ~ 20 char의 문자열. not null.
 * (3) cust_email: 고객 이메일. 100 byte 가변 길이 문자열. unique.
 * (4) cust_gender: 고객 성별. 1자리 정수. 기본값 0. (0, 1, 2) 중 1개 값만 가능.
 * (5) cust_age: 고객 나이. 3자리 정수. 기본값 0. 0 이상 200 이하의 정수만 가능.
 */
drop table customers;

create table customers (
    cust_id     varchar2(20 char)
                constraint pk_customers primary key
                constraint ck_cust_id check (length(cust_id) >= 8),
    cust_pw     varchar2(20 char)
                constraint nn_cust_pw  not null
                constraint ck_cust_pw check (length(cust_pw) >= 8),
    cust_email  varchar2(100 byte)
                constraint uq_cust_email unique,
    cust_gender number(1)
                default 0
                constraint ck_cust_gender check (cust_gender in (0, 1, 2)),
    cust_age    number(3)
                default 0
                constraint ck_cust_age check (cust_age between 0 and 200)
);

/*
 * 연습문제 2.
 * 테이블 이름: orders(주문)
 * 컬럼:
 * (1) order_id: 주문번호. 10자리 정수. primary key.
 * (2) order_date: 주문 날짜. 기본값은 현재 시간.
 * (3) order_method: 주문 방법. 최대 8 byte 문자열. ('online', 'offline') 중 1개 값만 가능.
 * (4) cust_id: 주문 고객 아이디. 최대 20 char 문자열. not null. customers(cust_id)를 참조.
 */
drop table orders;

create table orders (
    order_id        number(10),
    order_date      date default sysdate,  /* timestamp default systimestamp */
    order_method    varchar2(8 byte),
    cust_id         varchar2(20 char),
    constraint pk_orders primary key (order_id),
    constraint ck_order_method check (order_method in ('online', 'offline')),
    constraint nn_orders_cust_id check (cust_id is not null),
    constraint fk_orders_cust_id foreign key (cust_id) references customers (cust_id)
);
