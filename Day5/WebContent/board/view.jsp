<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%
	if(session.getAttribute("userid")==null){ 
%>
<script>
		alert('로그인 후 이용하세요');
		location.href='../login.jsp'; 
</script>
<% 
}else{
		// 변수 여기다가 만들어야 끝까지 적용됨
		String userid = (String)session.getAttribute("userid");
		String username = (String)session.getAttribute("username");
		String b_idx="";
		String b_userid = "";
		String b_name = "";
		String b_title = "";
		String b_content = "";
		String b_regdate = "";
		String b_up = "";
		String b_hit = "";
		
		// DB 연결
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
       
        // MySQL Workbench와 연결
        String sql = "";
        String url = "jdbc:mysql://localhost:3306/jspstudy";
        String uid = "root";
        String upw = "1234";
		
		
		// view.jsp로 직접 페이지 접속한 경우 -> b_idx가 없으면 안된다(없으면 바로 에러) -> 튕겨냄
	if(request.getParameter("b_idx") == null || request.getParameter("b_idx").equals("")){
%>
<script>
		alert('잘못된 접근입니다.');
		location.href='../login.jsp'; 
</script>
<% 
	}else{
		// 제대로 들어온 경우
		b_idx = request.getParameter("b_idx"); // get방식으로 가져온것을 넣어줌!
		
		
          
        try{
          Class.forName("com.mysql.jdbc.Driver");
          conn = DriverManager.getConnection(url, uid, upw);
          if(conn != null){
            // select
            sql = "select * from tb_board where b_idx=?";
            pstmt= conn.prepareStatement(sql);
            pstmt.setString(1, b_idx);
            rs = pstmt.executeQuery();
            
            if(rs.next()){ // 데이터가 있다면 
        		 b_userid = rs.getString("b_userid");
        		 b_name = rs.getString("b_name");
        		 b_title = rs.getString("b_title");
        		 b_content = rs.getString("b_content");
        		 b_regdate = rs.getString("b_regdate");
        		 b_up = rs.getString("b_up");
        		 b_hit = rs.getString("b_hit");
            }
            
             
          }
       }catch(Exception e){
          e.printStackTrace();
       }

		
	}
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>글보기</title>
</head>
<body>
	<h2>글보기</h2>
	<p>제목 : <%=b_title%></p>
	<p>작성자 : <%=b_name%>(<%=b_userid%>)</p>
	<p>조회수 : <%=b_hit%></p>
	<p id="b_up">좋아요 : <%=b_up%></p>
	<p>날짜 : <%=b_regdate %></p>
	<p>내용</p>
	<p><%=b_content %></p>
	<p>
<%
	if(b_userid.equals(userid)){ // String userid = (String)session.getAttribute("userid"); 랑  b_userid = rs.getString("b_userid"); 같아야	
%>	
	<input type="button" value="수정" onclick="location.href='./edit.jsp?b_idx=<%=b_idx%>'"> <!-- 중요: idx 넘겨야 -->
	<input type="button" value="삭제" onclick="location.href='./delete.jsp?b_idx=<%=b_idx%>'"> 
<%
	}
%>
	
	<input type="button" value="좋아요" onclick="likey()">
	<input type="button" value="리스트" onclick="location.href='./list.jsp'"></p>
	<hr/>
	<script>
		'use strict';
		function likey(){
			const xhr = new XMLHttpRequest(); // XMLHttpRequest 객체 생성
			xhr.open("GET", "likey_ok.jsp?b_idx=<%=b_idx%>", true); 
			xhr.send();
			
			// XMLHttpRequest.DONE : 4
			xhr.onreadystatechange = function(){
				if(xhr.readyState == XMLHttpRequest.DONE && xhr.status == 200){
					document.getElementById("b_up").innerHTML = "좋아요 : " + xhr.responseText;
				}
			}
		}
	</script>	
	<!-- Workbench > Day5 > tb_reply -->
	<form method="post" action="reply_ok.jsp">
	<!-- value="<%=b_idx%>" : value에 게시글 글 번호 적은 이유는 이걸 DB에 보내야지 내가 댓글 쓰는 곳이 어디인지 알 수있다. -->
		<input type="hidden" name="re_boardIdx" value="<%=b_idx%>">
		<p><%=username%>(<%=userid%>) : <input type="text" name="re_content"> <input type="submit" value="확인"></p>
	</form>
	<hr/>
<%
	// 반복문 ->  댓글 밑에 나오게 하기 - select사용
	sql = "select * from tb_reply where re_boardIdx=? order by re_idx desc";
	pstmt = conn.prepareStatement(sql);
	pstmt.setString(1, b_idx); // 현재 글에대한 댓글이므로 b_idx
	rs = pstmt.executeQuery();
	
	while(rs.next()){
		String re_idx = rs.getString("re_idx");
		String re_userid = rs.getString("re_userid");
		String re_name = rs.getString("re_name");
		String re_content = rs.getString("re_content");
		String re_regdate = rs.getString("re_regdate");
		String re_boardIdx = rs.getString("re_boardIdx");
		
%>
	<p><%=re_name%>(<%=re_userid%>) : <%=re_content%>(<%=re_regdate%>)
	<% 
		if(userid.equals(re_userid)){ //userid는 session에 있는 것
			
		
	%>
	<input type="button" value="삭제" onclick="location.href='reply_delete.jsp?re_idx=<%=re_idx%>&b_idx=<%=b_idx%>'"> 
	<!-- re_idx : 댓글의 글번호 넘겨줌 , 원본 글 보냄 : b_idx (47줄) --> 
	<%
		}
	%>
	</p>
</body>
</html>
<%
		}
	}
%>