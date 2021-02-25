<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%
	request.setCharacterEncoding("UTF-8");
	if(session.getAttribute("userid")==null){   // 로그인 한 사용자만 들어올 수 있다.
		
%>
	<script>
		alert('로그인 후 이용하세요');
		location.href='../login.jsp'; 
	</script>
<% 
	}else{
		if(request.getParameter("b_idx") == null || request.getParameter("b_idx").equals("")){
			%>
			<script>
					alert('잘못된 접근입니다.');
					location.href='../login.jsp'; 
			</script>
			<% 
		}else{
			// 제대로 들어왔을 경우
			String userid = (String)session.getAttribute("userid");
			String username = (String)session.getAttribute("username");
			String b_idx = request.getParameter("b_idx");
			String b_title = request.getParameter("b_title");
			String b_content = request.getParameter("b_content");
			
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
	        	  // update
	        	  sql ="update tb_board set b_title=?, b_content=? where b_idx=?";
	        	  pstmt = conn.prepareStatement(sql);
	        	  pstmt.setString(1, b_title);
	        	  pstmt.setString(2, b_content);
	        	  pstmt.setString(3, b_idx);
	        	  pstmt.executeUpdate();      
	          }
	       }catch(Exception e){
	          e.printStackTrace();
	       }
%>
			<script>
				alert('수정되었습니다');
				location.href='view.jsp?b_idx=<%=b_idx%>'; // 그냥 view로 넘기는게 아니라 idx로 넘겨야 내가 어디를 수정 했는지 알 수 있다.
			</script>
<%
		}
	}	
%>

	