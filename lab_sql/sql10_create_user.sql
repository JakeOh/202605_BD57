/*
 * Oracle 사용자 계정 생성
 */

-- 오라클 12c 버전부터는 사용자 계정 이름 앞에 C## 접두사를 붙여야만 되도록 변경.
-- 사용자 계정 이름을 C##으로 시작하고 싶지 않을 때는 세션 정보를 먼저 변경하면 됨.
alter session set "_ORACLE_SCRIPT" = true;

-- 사용자 계정 hr, 비밀번호 hr인 계정을 생성
-- create user 사용자_계정 identified by 비밀번호;
create user hr identified by hr;

-- 생성된 사용자 계정에 권한 부여(접속, 검색, 생성, 변경, ... 권한)
-- grant 사용자_계정 to 권한_종류;
-- hr 계정에 관리자 권한을 부여
grant dba to hr;
