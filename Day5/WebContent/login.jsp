<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
	// [로그인] + 세션
	String userid = null;
	if(session.getAttribute("userid") != null){
		userid = (String)session.getAttribute("userid");  // admin을 String형변환헤서 userid에 넣어줌
	}
%>    
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>로그인</title>
</head>
<body>
	<h2>로그인</h2>
<%
	if(userid == null){  // 첫 방문시
%>
	<form method="post" action="Login_ok.jsp">
		<p><label>아이디 : <input type="text" name="userid"></label></p>
		<p><label>비밀번호 : <input type="password" name="userpw"></label></p>
		<p><input type="submit" value="로그인"> <input type="button" value="회원가입" onclick="location.href='./regist.jsp'"></p>
	</form>
<% 
	}else {
%>		
	<h3><%=userid %> (<%=session.getAttribute("username")%>)님 환영합니다.</h3>
	<p><input type="button" value="로그아웃" onclick="location.href='logout.jsp'">
	<input type="button" value="정보수정" onclick="location.href='info.jsp'">
	<input type="button" value="게시판" onclick="location.href='./board/list.jsp'"></p>
<% 
	}
%>
	
</body>
</html>