<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<jsp:useBean id="reply" class="com.koreait.test.ReplyDTO"/>
<jsp:useBean id="dao" class="com.koreait.test.TestDAO"/>

<% 		
		request.setCharacterEncoding("UTF-8");
		if(request.getParameter("re_itestidx") == null || request.getParameter("re_itestidx").equals("")){
%>			
			<script>
					alert('잘못된 접근입니다.');
					location.href='./list.jsp'; 
			</script>
<% 			
		}else{
			// 제대로 된 경우
			
			String re_name = request.getParameter("re_name");
			String re_itestidx = request.getParameter("re_itestidx"); // 글번호 hidden으로 넘겨줌(view.jsp), view.jsp > name="re_boardIdx"를 get함
			String re_content = request.getParameter("re_content");
			
			reply.setRe_name(re_name);
			reply.setRe_itestidx(Integer.parseInt(re_itestidx));
			reply.setRe_content(re_content);
			
			if(	dao.addreply(reply) == 1){
%>
			<script>
				alert('댓글이 등록되었습니다.');
				location.href='./view.jsp?b_idx=<%=re_itestidx%>';
			</script>
<% 
			}else {
%>
				<script>
					alert('댓글 등록이 실패했습니다..');
					history.back();
				</script>
<% 
			}
		}
			
			
			
			
			
			
			
	       
%>