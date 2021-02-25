<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.sql.*"%>
<%
	String userid = request.getParameter("userid");

	Connection conn = null;
	PreparedStatement pstmt =null;
	ResultSet rs = null; // select 한 결과를 ResultSet에 담는다


	// [MySQL Workbench와 연결]
	String sql="";
	String url ="jdbc:mysql://localhost:3306/jspstudy";
	String uid = "root";
	String upw = "1234";
	
	
	try{
		Class.forName("com.mysql.jdbc.Driver");
		conn = DriverManager.getConnection(url, uid, upw);
		if(conn != null){
			sql = "select mem_idx from tb_member where mem_userid=?";
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, userid);
			rs = pstmt.executeQuery();
			
			// [워크벤치 연동]
			if(rs.next()){ 
				// 데이터 있을 때 = 중복 아이디가 있는 경우
				out.print("no");
			}else{
				// 중복 아이디가 없는 경우
				out.print("ok");
			}
		}
	}catch(Exception e){
		e.printStackTrace();
	}
%>