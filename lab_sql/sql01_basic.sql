/*
 * 블록 주석(block comment)
 * - 파일 또는 코드 문장에 대한 설명을 작성하는 부분. 실행되지 않는 부분.
 *
 * SQL Developer 워크시트에서 SQL 문장 실행 방법:
 * (1) Ctrl+Enter: 하나의 명령문을 실행.
 *     - 현재 커서가 있는 위치의 한 문장을 실행.
 *     - 마우스 드래그로 선택된 문장(들)을 실행.
 * (2) F5: 스크립트(sql 파일) 전체를 실행.
 *     - 스크립트 파일 실행 중에 에러가 발생하면 그 이후의 문장들은 실행되지 않음.
 */

-- inline comment(한줄 주석). 그 줄의 끝까지 주석.

-- 현재 접속한 데이터베이스 서버의 날짜를 출력.
select sysdate from dual;

select systimestamp from dual;  -- 현재 날짜와 시간을 출력.
