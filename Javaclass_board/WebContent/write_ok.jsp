<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="com.oreilly.servlet.multipart.DefaultFileRenamePolicy" %>
<%@ page import="com.oreilly.servlet.MultipartRequest" %>
<jsp:useBean id="test" class="com.koreait.test.TestDTO"/>
<jsp:useBean id="dao" class="com.koreait.test.TestDAO"/>
<%
	request.setCharacterEncoding("UTF-8");
%>

<%  
	    // [파일 관련 변수]
		String uploadPath = request.getRealPath("upload"); // 업로드 어디다가 할건지 path, Webcontent에 upload 폴더 만들기
		System.out.println(uploadPath);
		int size = 1024*1024*10; 
		
		
		// [파일]
        MultipartRequest multi = new MultipartRequest(request, uploadPath, size, "UTF-8", new DefaultFileRenamePolicy());
           
        // DTO에 set 후 DAO로 보내고 return받기
        // .setName - TestDTO 생성한 필드이름
        // "b_name" -  보낸쪽(write.jsp의 name)
        test.setName(multi.getParameter("b_name"));
        test.setUserid(multi.getParameter("b_userid"));
        test.setUserpw(multi.getParameter("b_userpw"));
        test.setTitle(multi.getParameter("b_title"));
        test.setContent(multi.getParameter("b_content"));
        test.setFilename(multi.getFilesystemName("b_filename")); // sql로 filename을 보내려고!
        
        if(dao.write(test) == 1 ){
%>
		<script>
     		alert('등록되었습니다.');
     		location.href='./list.jsp';
 		</script>
<% 
   }else {
%>
		<script>
     		alert('등록에 실패하였습니다.');
     		location.href='./write.jsp';
 		</script>
<%	   
   }
%>       
          
        
  