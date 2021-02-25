<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%
	String userid = request.getParameter("userid");
	String userpw = request.getParameter("userpw");
	
	
	// [DB 연결]
	Connection conn = null;
	PreparedStatement pstmt =null;
	ResultSet rs =null;
	
	// MySQL Workbench와 연결
	String sql="";
	String url ="jdbc:mysql://localhost:3306/jspstudy";
	String uid = "root";
	String upw = "1234";
	
	try{
		Class.forName("com.mysql.jdbc.Driver"); // "" 은 드라이버의 패키지 이름 
		conn = DriverManager.getConnection(url, uid, upw);
		if(conn != null){
			// DB 연결 
			sql = "SELECT mem_idx, mem_name from tb_member WHERE mem_userid=? AND mem_userpw=?";
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, userid);
			pstmt.setString(2, userpw);
			rs = pstmt.executeQuery(); // 결과값이 rs에 들어감
			
			if(rs.next()){ // 데이터가 있는지 없는지 확인
				// 로그인 성공한 사람  , 변수 3개
				session.setAttribute("userid", userid); // 직접침
				session.setAttribute("username", rs.getString("mem_name")); // DB에서 가져옴 - 왜? 메모리에 올라가 있어서 어느 페이지에 가서든 이용가능
				session.setAttribute("useridx", rs.getString("mem_idx"));// DB에서 가져옴 - 왜? 메모리에 올라가 있어서 어느 페이지에 가서든 이용가능
%>
	<script>
		alert('로그인 되었습니다.');
		location.href = "login.jsp"; // 다시 login.jsp로 넘어감 : 캐시 다 지워지고 새 페이지가 리프레쉬됨(아이디 비번 빈칸) = 새로고침 기능
	</script>

<% 			
			}else{
				// 로그인 실패한 사람
%>
	<script>
		alert('아이디 또는 비밀번호를 확인하세요');
		history.back(); // 다시 전 페이지로 돌아감 - login.jsp : 기존 데이터가 캐시(캐시:내 history정보)에 남은 상태로 돌아감 (아이디가 남아있음)
	</script>

<% 			
		    	}
			
			}
	}catch(Exception e){
		e.printStackTrace();
	}
%>	