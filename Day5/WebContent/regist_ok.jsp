<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %> <!-- [DB연결 시작],  *: 다 쓰겠다 -->    
<%
	request.setCharacterEncoding("UTF-8"); // 한글 안 깨지게함 
	// "userid"는 id가 아니라 'name'을 가져옴(regist.jsp에서) - 이걸 통해 들어가서 value값(크롬에서 내가 입력한 값) 알아내는 것
	String userid = request.getParameter("userid"); 
	String userpw = request.getParameter("userpw");
	String username = request.getParameter("username");
	String hp = request.getParameter("hp");
	String email = request.getParameter("email");
	String hobby[] = request.getParameterValues("hobby"); // 배열처리
	String hobbystr = ""; // 원래 밑에 html 부분을 지우고 여기 위로 올린것.
	for(int i=0; i<hobby.length; i++){
		hobbystr = hobbystr + hobby[i] + " ";
	}
	String ssn1 = request.getParameter("ssn1");
	String ssn2 = request.getParameter("ssn2");
	String zipcode = request.getParameter("zipcode");
	String address1 = request.getParameter("address1");
	String address2 = request.getParameter("address2");
	String address3 = request.getParameter("address3");
	
	Connection conn = null;
	PreparedStatement pstmt =null;
	
	
	// [MySQL Workbench와 연결]
	String sql="";
	String url ="jdbc:mysql://localhost:3306/jspstudy";
	String uid = "root";
	String upw = "1234";
	
	try{
		Class.forName("com.mysql.jdbc.Driver"); // "" 은 드라이버의 패키지 이름  -- (경고창 메세지)com.mysql.cj.jdbc.Driver
		conn = DriverManager.getConnection(url, uid, upw);
		if(conn != null){
			sql += "insert into tb_member(mem_userid, mem_userpw, mem_name, mem_hp, mem_email, mem_hobby, mem_ssn1,";
			sql += " mem_ssn2, mem_zipcode, mem_address1, mem_address2, mem_address3) values";
			sql += " (?, ?, ?, ?, ?, ?, ?,";
			sql += " ?, ?, ?, ?, ?)"; // workbench > insert into에 넣은 내용을 복붙하면 한 줄로 나옴 - 보기 힘드니까 나눈것 sql += 이용, 값들은 ?로 처리.
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, userid);
			pstmt.setString(2, userpw);
			pstmt.setString(3, username);
			pstmt.setString(4, hp);
			pstmt.setString(5, email);
			pstmt.setString(6, hobbystr); // 위에 만듦
			pstmt.setString(7, ssn1);
			pstmt.setString(8, ssn2);
			pstmt.setString(9, zipcode);
			pstmt.setString(10, address1);
			pstmt.setString(11, address2);
			pstmt.setString(12, address3);
			pstmt.executeUpdate();
		}
	}catch(Exception e){
		e.printStackTrace();
	}
	
	
%>
<script>
	alert('회원가입 완료되었습니다.');
	location.href="login.jsp";
</script>