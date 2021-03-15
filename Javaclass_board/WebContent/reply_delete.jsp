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
		// 댓글의 글번호
		if(request.getParameter("re_idx") == null || request.getParameter("re_idx").equals("")){
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
			String re_idx = request.getParameter("re_idx");
			String b_idx = request.getParameter("b_idx"); // 용도: 삭제 후 view로 돌아갈 때 원본 글 번호 필요함
			
			
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
	        	     sql = "delete from tb_reply where re_idx=?";
	        	     pstmt = conn.prepareStatement(sql);
	        	     pstmt.setString(1,re_idx);
	        	     pstmt.executeUpdate();	        	  
	          }
	       }catch(Exception e){
	          e.printStackTrace();
	       }
%>
		<script>
			alert('삭제되었습니다');
			// view로 갈때, 원본 글 번호 필요함
			location.href='view.jsp?b_idx=<%=b_idx%>';
		</script>
<%
		}	
	}	
%>