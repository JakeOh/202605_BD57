/*
 * view: 테이블을 바라보는 객체.
 * 검색에서 자주 사용되는 정보들을 저장해서 select 문장을 간단히 만들기 위해서 사용.
 * (문법) create [or replace] view 뷰_이름 as select 문장;
 *        drop view 뷰_이름;
 */

-- 사번, 이름, 부서번호, 부서이름을 갖는 뷰(view)를 생성.
create view v_emp_dept
as
select e.empno, e.ename, e.deptno, d.dname
from emp e
    join dept d on e.deptno = d.deptno
order by e.empno;

-- 생성된 뷰는 테이블을 사용하는 것처럼 select가 가능.
select empno, dname
from v_emp_dept;

select *
from v_emp_dept
where dname = 'SALES';


-- 사번, 이름, 업무, 급여, 부서번호, 부서이름을 갖는 뷰를 생성.
-- 같은 이름의 뷰가 데이터베이스에 없으면 생성(create)하고, 있으면 기존 뷰를 대체(replace).
create or replace view v_emp_dept
as
select e.empno, e.ename, e.job, e.sal, e.deptno, d.dname
from emp e, dept d
where e.deptno = d.deptno
order by e.empno;


-- view: 테이블을 바라보는 객체.
-- 실제 테이블의 내용이 변경되면, 뷰의 내용도 바뀜.
-- emp 테이블에서 사번이 7369인 직원의 업무를 '경리'로 업데이트.
update emp
set job = '경리'
where empno = 7369;

commit;

select * from v_emp_dept;
--> emp 테이블에서 업데이트한 내용이 뷰에서도 보임.

-- 뷰에서 변경된 내용은 실제 테이블에도 반영이 됨.
-- v_emp_dept 뷰에서 사번이 7369인 직원의 급여를 9999로 업데이트.
update v_emp_dept
set sal = 9999
where empno = 7369;
--> 업데이트 성공

select * from emp;
--> 뷰에서 업데이트가 성공하면 뷰가 바라보는 실제 테이블의 데이터가 업데이트됨.

-- v_emp_dept 뷰에서 사번이 7369인 직원의 부서이름을 '리서치'로 업데이트.
update v_emp_dept
set dname = '리서치'
where empno = 7369;
--> 1개 행 업데이트됨.

select * from v_emp_dept;
--> 뷰를 검색하면 모든 부서 이름 'RESEARCH'가  전부 '리서치'로 변경됨.
-- empno=7369인 레코드의 부서번호(deptno)와 일치하는 부서의 부서이름을 dept 테이블에서 업데이트.

select * from dept;


-- 부서번호, 부서별 평균 급여를 갖는 뷰를 생성
create or replace view v_avg_sal
as
select deptno, round(avg(sal), 2) as "AVG_SAL"
from emp
group by deptno
order by deptno;

select * from v_avg_sal;

-- emp 테이블에서 사번이 7839인 직원의 급여를 9999로 업데이트.
update emp
set sal = 9999
where empno = 7839;
--> v_avg_sal 뷰에서도 업데이트된 평균 급여를 보게 됨.

-- v_avg_sal 뷰에서 avg_sal 컬럼 값을 5000으로 업데이트?
update v_avg_sal
set AVG_SAL = 5000
where deptno = 10;
--> v_avg_sal은 업데이트할 수 없는 뷰.


/*
 * 테이블에 자동으로 증가되는 숫자를 저장할 수 있는 컬럼 만들기
 * (이유) PK 컬럼에 값을 쉽게 삽입하기 위해서.
 */
create table ex_test1 (
    id          number(6) generated always as identity
                constraint pk_test1 primary key,
    contents    varchar2(100 char)
);

insert into ex_test1 (contents) values ('점심 맛있게 드셨나요?');
insert into ex_test1 (contents) values ('점심 먹고 나니 졸리네요...');
--> id 컬럼에는 1부터 1씩 증가되는 정수들이 자동으로 삽입됨.

select * from ex_test1;


/*
 * FK가 참조하는 PK의 값을 변경하는 방법.
 */
create table departments (
    id      number(6) primary key,
    name    varchar2(100 char)
);

insert into departments values (100, '컴퓨터공학과');
insert into departments values (200, '국어국문학과');
commit;

select * from departments;

create table students (
    id      number(6) primary key,
    name    varchar2(100 char) not null,
    department_id   number(6) references departments (id)
);

insert into students values (1234, '오쌤', 100);
insert into students values (1235, '홍길동', 200);
commit;

delete from students where id = 1235;
commit;


select * from students;

-- 국어국문학과의 id를 200에서 201로 업데이트.
-- 국어국문학과의 id는 아직 자식 테이블 students에서 참조되지 않는 상태.
update departments
set id = 201
where id = 200;
--> 성공

-- 컴퓨터공학과의 id를 100에서 101으로 변경하는 방법.
-- 컴퓨터공학과의 id는 자식 테이블 students에서 참조되고 있는 상태.
update departments
set id = 101
where id = 100;
--> 자식 레코드가 있기 때문에 실패

-- 해결 방법 (1)
-- 1. departments 테이블에 id=101, name=컴퓨터공학과인 레코드를 삽입.
-- 2. students 테이블에서 department_id=100인 레코드들을 department_id=101로 업데이트.
-- 3. departments 테이블에서 id=100(컴퓨터공학과)인 레코드는 삭제.

-- 해결 방법 (2): 제약조건을 임시로 비활성화(disable)시켰다가 다시 활성화(enable)시키는 방법.
-- 1. 자식 테이블의 FK 제약조건을 비활성화
alter table students disable constraint SYS_C008413;
-- 2. 부모 테이블의 PK를 변경
update departments
set id = 101
where id = 100;  --> 업데이트 성공
-- 3. 자식 테이블에서 학과번호 100인 레코들을 모두 101로 변경
update students
set department_id = 101
where department_id = 100;
-- 4. 변경 내용 commit
commit;
-- 5. 자식 테이블의 FK 제약조건을 다시 활성화
alter table students enable constraint SYS_C008413;


-- 해결 방법 (3): 지연 제약조건(deferrable constraint)을 사용.
-- 제약조건을 만들 때 deferrable로 선언이 되어 있어야 함.
-- 기존에 non-deferrable(지연 가능하지 않은) 제약조건을 삭제:
alter table students drop constraint SYS_C008413;
-- 지연가능한(deferrable) FK 제약조건을 추가
alter table students
add constraint fk_studnets_dept_id 
    foreign key (department_id) references departments (id)
    deferrable initially immediate;
-- 1. 제약조건을 commit 시점까지 지연시킴.(commit될 때까지는 제약조건을 검증하지 않음.)
set constraint fk_studnets_dept_id deferred;
-- 2. 부모 테이블(departments)에서 101번 학과를 110번으로 업데이트.
update departments
set id = 110
where id = 101;
-- 3. 자식 테이블(students)에서 101 학과번호를 110으로 업데이트.
update students
set department_id = 110
where department_id = 101;
-- 4. 변경 내용을 commit -> 지연됐던 FK 제약조건을 검증함.
commit;
