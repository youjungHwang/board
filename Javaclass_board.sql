use jspstudy;

-- tb_itest(작성된 모든 게시글의 정보)
create table tb_itest(
	b_idx bigint auto_increment primary key,
    b_userid varchar(20) not null,
    b_userpw varchar(20) not null,
    b_name varchar(20) not null,
    b_title varchar(200) not null,
    b_hit bigint default 0,
    b_content text,
	b_filename varchar(200),
    b_filepath varchar(200),
	fb_regdate datetime default now()
);
select * from tb_itest;

-- 테이블안에 추가로 데이터 적을시, 테이블에 필드추가 후 drop 하고 다시 생성(야매)
-- 정석은 alter로 추가
drop table tb_itest;

-- [페이징 기능]
select *from tb_itest;

-- 전체갯수 인덱스로 안하고 필드명으로 하는이유) 나중에 순서가 바뀌면 다 바뀌니까 인덱스 안 쓰고 별명(as 별명)으로 -> 전체 개수 구함 
select count(b_idx) as total from tb_itest;

-- limit 갯수(데이터를 갯수만큼 가져오기)
select *from tb_itest limit 10;

-- limit 시작인덱스, 갯수(데이터의 시작점 갯수만큼 가져오기), 0이 첫번째
select *from tb_itest limit 0, 10;
select *from tb_itest limit 1, 10;

-- 최근글 열개(역순 만든 후) : 1page
select * from tb_itest order by b_idx desc limit 0, 10;

-- 다음 페이지 부터 셀때 : 2page, 3page --> 반복문 아니고 원하는 파라미터만 전달해서 그것만 떼어서 불러옴
select * from tb_itest order by b_idx desc limit 10, 10;
select * from tb_itest order by b_idx desc limit 20, 10;


-- [ip table]
create table tb_iptable(
	-- 테이블 idx
	ip_idx bigint auto_increment primary key,
	ip_box varchar(20) not null,
    -- 게시글idx
    ip_itestidx bigint not null
);

select *from  tb_iptable; 

-- 댓글용 테이블 만들기 (왜? 번호, 글쓴이, 아이디, 내용, 날짜의 데이터를 담아줘야하므로) , table에 담고 출처를 뭘로 구분 : b_idx(게시판 글 번호)로 -> 그럼 총 6개가 DB에 담겨야
create table tb_reitest(
	re_idx bigint auto_increment primary key,
    re_name varchar(20) not null,
    re_content varchar(1000) not null,
    re_itestIdx bigint not null
);

select *from  tb_reitest; 



