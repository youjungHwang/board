<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.sql.*"%>

<%
   request.setCharacterEncoding("UTF-8");
   if(session.getAttribute("userid") == null){

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
         String up_userIdx = (String)session.getAttribute("useridx");
         String up_boardIdx = request.getParameter("b_idx");
		 int b_up = 0;
		 
		 // DB연결
         Connection conn = null;
         PreparedStatement pstmt = null;
         ResultSet rs = null;
         
         String sql = "";
         String url = "jdbc:mysql://localhost:3306/jspstudy";
         String uid = "root";
         String upw = "1234";
         
         try{
            Class.forName("com.mysql.jdbc.Driver");
            conn = DriverManager.getConnection(url, uid, upw);
            if(conn != null){
               sql = "select up_userIdx from tb_likey where up_userIdx=? and up_boardIdx=?";
               pstmt = conn.prepareStatement(sql);
               pstmt.setString(1,up_userIdx);
               pstmt.setString(2,up_boardIdx);
               rs = pstmt.executeQuery();
               if(!rs.next()) {
	               sql = "insert into tb_likey(up_userIdx, up_boardIdx) values(?,?)";
	               pstmt = conn.prepareStatement(sql);
	               pstmt.setString(1,up_userIdx);
	               pstmt.setString(2,up_boardIdx);
	               pstmt.executeUpdate(); 
               }
               sql = "select up_userIdx from tb_likey where up_boardIdx=?";
               pstmt = conn.prepareStatement(sql);
               pstmt.setString(1, up_boardIdx);
               rs = pstmt.executeQuery();
               while(rs.next()) {
            	   b_up++;
               }
               sql = "update tb_board set b_up=? where b_idx=?";
               pstmt = conn.prepareStatement(sql);
               pstmt.setInt(1, b_up);
               pstmt.setString(2, up_boardIdx);
               pstmt.executeUpdate();
        	   
               sql = "select b_up from tb_board where b_idx=?";
               pstmt = conn.prepareStatement(sql);
               pstmt.setString(1, up_boardIdx);
               rs = pstmt.executeQuery();
               if(rs.next()) {
            	   out.print(rs.getString("b_up"));
               }
            }
         }catch(Exception e){
            e.printStackTrace();
         }
      }
   }
%>