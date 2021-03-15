<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>

	
		String userid = (String)session.getAttribute("userid");
		String username = (String)session.getAttribute("username");
		String b_idx = request.getParameter("b_idx"); // view에서 보낸 것 : value 수정 > onclick부분
		
		String b_title = "";
		String b_content = "";
		//[파일] 선언
		String b_file="";
		
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
        	  sql = "select * from tb_board where b_idx=?";
              pstmt= conn.prepareStatement(sql);
              pstmt.setString(1, b_idx);
              rs = pstmt.executeQuery();
              
              if(rs.next()){ // 데이터가 있다면 
          		 b_title = rs.getString("b_title");
          		 b_content = rs.getString("b_content");
          		 // [파일] 선언 후 가져옴 - 그 후 html에 p태그 추가
          		 b_file = rs.getString("b_file");
          		
              }
             
          }
       }catch(Exception e){
          e.printStackTrace();
       }
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>글수정</title>
</head>
<body>
	<h2>글수정</h2>
	<form method="post" action="edit_ok.jsp" enctype="multipart/form-data"> <!-- idx를 hidden으로 넘긴다★ 예) 결제 페이지 붙일때  -->
		<input type="hidden" name="b_idx" value="<%=b_idx%>">
		<p>작성자 : <%=username%>(<%=userid%>)</p>
		<p><label>제목 : <input type="text" name="b_title" value="<%=b_title%>"></label></p>
		<p>내용</p>
		<p><textarea rows="5" cols="40" name="b_content"><%=b_title%></textarea></p>  <!-- 왜? textarea는 value 속성이 없다 -->
		<p>
		<%
			if(b_file != null && !b_file.equals("")){
				out.println("첨부파일");
				out.print("<img src='../upload/"+b_file+"' alt='첨부파일' width='150'>");	 // 이미지 뜸
			}
		%>
		</p>
		<p><input type="file" name="b_file"></p> <!-- 파일 넣을 수 있는 공간 만듦 -->
		<p><input type="submit" value="수정"> <input type="button" value="돌아가기" onclick="history.back()"></p>
	</form>
</body>
</html>
<%
	}
%>