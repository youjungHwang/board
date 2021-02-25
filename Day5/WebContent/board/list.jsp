<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%
	if(session.getAttribute("userid")==null){ // session.setAttribute("userid")은 login_ok.jsp에 있다(ctrl + h)
%>
	<script>
		alert('로그인 후 이용하세요');
		location.href='../login.jsp'; 
	</script>
<% 
	}else{	
		// DB 연결
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
       
        // MySQL Workbench와 연결
        String sql = "";
        String url = "jdbc:mysql://localhost:3306/jspstudy";
        String uid = "root";
        String upw = "1234";
          
        try{
          Class.forName("com.mysql.jdbc.Driver");
          conn = DriverManager.getConnection(url, uid, upw);
          if(conn != null){
        	  sql="select * from tb_board order by b_idx desc"; // 역순
        	  pstmt = conn.prepareStatement(sql);
        	  rs = pstmt.executeQuery();
          }
        }catch(Exception e){
        	e.printStackTrace();
        }
		
		
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>리스트</title>
</head>
<body>
	<h2>리스트</h2>
	<!--게시글 만들때는 table이 편하다 -->
	<table border="1" width="800">
		<tr>
			<th>번호</th>
			<th>제목</th>
			<th>글쓴이</th>
			<th>조회수</th>
			<th>좋아요</th>
			<th>날짜</th>
		</tr>
<%
	while(rs.next()){  // 반복문
		String b_idx = rs.getString("b_idx");
		String b_userid = rs.getString("b_userid");
		String b_name = rs.getString("b_name");
		String b_title = rs.getString("b_title");
		String b_regdate = rs.getString("b_regdate").substring(0, 10);
		String b_up = rs.getString("b_up");
		String b_hit= rs.getString("b_hit");
		
%>
		<tr>
			<td><%=b_idx%></td>
			<td><a href="./view.jsp?b_idx=<%=b_idx%>"><%=b_title%></a></td> <!-- 제목 누르면 글보기 이동, get방식★★ -->
			<td><%=b_name%>(<%=b_userid %>)</td>
			<td><%=b_hit%></td>
			<td><%=b_up%></td>
			<td><%=b_regdate%></td>
		</tr>
<%
	}
%>
		<tr>
			<td colspan="6">1 2 3 4 5 6 7 8 9 10</td>
		</tr>
		<tr>
			<td colspan="6"><input type="button" value="글작성" onclick="location.href='./write.jsp'">
			<input type="button" value="돌아가기" onclick="location.href='../login.jsp'"></td>
		</tr>
	</table>
</body>
</html>
<%
	}
%>