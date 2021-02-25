use jspstudy;

create table tb_board(
	-- 기본키
	b_idx bigint auto_increment primary key,
    b_userid varchar(20) not null,
    b_name varchar(20) not null,
    b_title varchar(200) not null,
    b_hit bigint default 0,
    b_up bigint default 0,
    b_content text,
    b_regdate datetime default now()
);

select * from tb_board;

-- 댓글용 테이블 만들기 (왜? 번호, 글쓴이, 아이디, 내용, 날짜의 데이터를 담아줘야하므로) , table에 담고 출처를 뭘로 구분 : b_idx(게시판 글 번호)로 -> 그럼 총 6개가 DB에 담겨야
create table tb_reply(
	re_idx bigint auto_increment primary key,
    re_userid varchar(20) not null,
    re_name varchar(20) not null,
    re_content varchar(1000) not null,
    re_regdate datetime default now(),
    -- 외래키(기본키는 위에 tb_board > b_idx bigint auto_increment primary key)
    re_boardIdx bigint not null,
    foreign key(re_boardIdx) references tb_board(b_idx)

);

select * from tb_reply;

-- 좋아요 기능
create table tb_likey(
	up_userIdx bigint not null,
    up_boardIdx bigint not null
);

select * from tb_likey;

