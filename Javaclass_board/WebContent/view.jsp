<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="com.koreait.test.ReplyDTO" %>
<%@ page import="java.util.*" %>
<jsp:useBean id="testDTO" class="com.koreait.test.TestDTO"/>
<jsp:useBean id="dao" class="com.koreait.test.TestDAO"/>


<%!
public String getClientIP(HttpServletRequest request) {
    String ip = request.getHeader("X-FORWARDED-FOR"); 
    
    if (ip == null || ip.length() == 0) {
        ip = request.getHeader("Proxy-Client-IP");
    }
 
    if (ip == null || ip.length() == 0) {
        ip = request.getHeader("WL-Proxy-Client-IP");  
    }
 
    if (ip == null || ip.length() == 0) {
        ip = request.getRemoteAddr() ;
    }
    
    return ip;
 
}
%>
 
 
<% String ip = getClientIP(request);%>



<% 
		// 제대로 들어온 경우
		String b_idx = request.getParameter("b_idx"); 
		if(b_idx == null || b_idx.equals("")) {
%>
			<script>
			alert('잘못된 접근입니다');
			location.href= "./list.jsp";
			</script>
<%
		}else{
			//ip을 먼저 sql에서 보내야 하므로 testDTO = dao.view(Integer.parseInt(b_idx)); 보다 먼저
			dao.ipCheck(ip, b_idx);
			
			// DTO, DAO - 메소드 불러오기
			testDTO = dao.view(Integer.parseInt(b_idx));
			
			
%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>글보기</title>
</head>
<body>
	<h2>글보기</h2>
	<p>제목 : <%=testDTO.getTitle()%></p>
	<p>작성자 : <%=testDTO.getName()%>(<%=testDTO.getUserid()%>)</p>
	<p>조회수 : <%=testDTO.getHit()%></p>
	<p>내용</p>
	<p>비밀번호: <input type="password" id="password"> <input type="button" value="확인" onclick="pwCheck()"></p>
	<input type="hidden" id="hiddenPw" value="<%=testDTO.getUserpw()%>">
	<script>
		function pwCheck(){
			
			const pw = document.getElementById("password").value;
			
			const pw2 = document.getElementById("hiddenPw").value;
			
			const btn = document.getElementById("btn");
			
			if(pw == pw2) {
				
				btn.innerHTML += ` <input type="button" value="수정" onclick="location.href='./edit.jsp?b_idx=<%=b_idx%>'">
					<input type="button" value="삭제" onclick="location.href='./delete.jsp?b_idx=<%=b_idx%>'"> `
			}
			
			
			
		};
	</script>
	<p><%=testDTO.getContent() %></p>
	<p>
		<%
		// [이미지 등록]
			if(testDTO.getFilename() != null && !testDTO.getFilename().equals("")){
				out.println("첨부파일");
				out.print("<img src='./upload/"+testDTO.getFilename()+"' alt='첨부파일' width='150'>");	
			}
		%>
	</p>
	<p id="btn">
	<input type="button" value="리스트" onclick="location.href='./list.jsp'"></p>
	<hr/>
	<form method="post" action="reply_ok.jsp">
	<input type="hidden" name="re_itestidx" value=<%=b_idx%>>
	<p>이름 : <input type="text" name="re_name"> 내용 : <input type="text" name="re_content"> <input type="submit" value="등록"></p> 
	</form>
	<hr/>
<%
	List<ReplyDTO> replyList = new ArrayList<>();
	replyList = dao.replylist(b_idx);
	
	for(ReplyDTO reply : replyList){
%>
	
	<p>이름 : <%=reply.getRe_name()%> 내용 : <%=reply.getRe_content()%></p>
<%

	}
	
%>
	
	
</body>
</html>
<%
			}
		
	
%>