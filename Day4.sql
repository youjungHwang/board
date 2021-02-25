-- 데이터 베이스 생성  (ctrl 엔터로 실행)
create database jspstudy;

show databases;

use jspstudy;

-- 테이블 만들기
 CREATE TABLE tb_member(
	mem_idx bigint auto_increment primary key,
	mem_userid varchar(20) unique not null,
	mem_userpw varchar(20) not null,
	mem_name varchar(20) not null,
	mem_hp varchar(13) not null,
	mem_email varchar(50),
	mem_hobby varchar(100),
	mem_ssn1 char(6) not null,
	mem_ssn2 char(7) not null,
	mem_zipcode char(5) not null,
	mem_address1 varchar(100),
	mem_address2 varchar(100),
	mem_address3 varchar(100),
	mem_regdate datetime default now()
);

select * from tb_member;

insert into tb_member(mem_userid, mem_userpw, mem_name, mem_hp, mem_email, mem_hobby, mem_ssn1, mem_ssn2, mem_zipcode, mem_address1, mem_address2, mem_address3)
values ('ryuzy', '111111', '류정원', '010-1111-1111', 'ryuzy@naver.com', '등산', '001011', '3068518', '12345', '서울 서초구 양재동', '111-11', '1111'); 

-- 아이디 이미 있으면 select * from tb_member; 밑에 나오고 없으면 안나옴
select mem_idx from tb_member where mem_userid = 'apple12';

select mem_idx, mem_name from tb_member where mem_userid='apple12' and mem_userpw='111111';





