/*
 * 제약조건(constraint): 데이터의 무결성을 유지하기 위한 조건들.
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
