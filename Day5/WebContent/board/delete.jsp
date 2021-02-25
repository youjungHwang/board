<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%
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
			// 제대로 된 경우
			String userid = (String)session.getAttribute("userid");
			String username = (String)session.getAttribute("username");
			String b_idx = request.getParameter("b_idx");
			
			
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
	        	     sql = "delete from tb_board where b_idx=?";
	        	     pstmt = conn.prepareStatement(sql);
	        	     pstmt.setString(1, b_idx);
	        	     pstmt.executeUpdate();	        	  
	          }
	       }catch(Exception e){
	          e.printStackTrace();
	       }
%>
		<script>
			alert('삭제되었습니다');
			location.href='list.jsp';
		</script>
<%
		}	
	}	
%>