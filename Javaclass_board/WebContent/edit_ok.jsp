<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="com.oreilly.servlet.multipart.DefaultFileRenamePolicy" %>
<%@ page import="com.oreilly.servlet.MultipartRequest" %>
<%
	request.setCharacterEncoding("UTF-8");
	if(session.getAttribute("userid")==null){   // 로그인 한 사용자만 들어올 수 있다.
		
%>
	<script>
		alert('로그인 후 이용하세요');
		location.href='../login.jsp'; 
	</script>
<% 
	}else{
			// edit.jsp에서  enctype="multipart/form-data" 하면 이제 request.getParameter로 못 받아옴 - 삭제
		
			// 제대로 들어왔을 경우
			String userid = (String)session.getAttribute("userid");
			String username = (String)session.getAttribute("username");
			// [첨부파일] 넘어오면 어디다가 저장할지 - WebContent > upload 폴더에 저장됨
			String uploadPath = request.getRealPath("upload");
			int size = 1024*1024*10;
			
			
			// DB 연결
	        Connection conn = null;
	        PreparedStatement pstmt = null;
	        ResultSet rs = null;
	       
	        
	        // MySQL Workbench와 연결
	        String b_idx =""; // 변수 선언을 여기에 해줘야 마지막줄 에러 안뜸
	        String sql = "";
	        String url = "jdbc:mysql://localhost:3306/jspstudy";
	        String uid = "root";
	        String upw = "1234";
	          
	        try{
	        //[업로드 객체 만들기]
	          MultipartRequest multi = new MultipartRequest(request, uploadPath, size, "UTF-8", new DefaultFileRenamePolicy());
	          if(multi.getParameter("b_idx") == null || multi.getParameter("b_idx").equals("")){
%>
			<script>
			alert('잘못된 접근입니다.');
			location.href='../login.jsp';
			</script>
<% 	        	  
	        }else{
        	b_idx = multi.getParameter("b_idx");
        	String b_title = multi.getParameter("b_title");
        	String b_content = multi.getParameter("b_content");
        	String b_file = multi.getFilesystemName("b_file");
        	
        	
        	
            Class.forName("com.mysql.jdbc.Driver");
            conn = DriverManager.getConnection(url, uid, upw);
            if(conn != null){
            	//file 있느냐 없느냐에 따라 sql문 나누기
            	if(b_file !=null && !b_file.equals("")){
            	  sql ="update tb_board set b_title=?, b_content=?, b_file=? where b_idx=?";
               	  pstmt = conn.prepareStatement(sql);
               	  pstmt.setString(1, b_title);
               	  pstmt.setString(2, b_content);
               	  pstmt.setString(3, b_file);
               	  pstmt.setString(4, b_idx);
            	}else{ // file 수정 안 했으면 기존 파일 보여주기
            	  sql ="update tb_board set b_title=?, b_content=? where b_idx=?";
            	  pstmt = conn.prepareStatement(sql);
              	  pstmt.setString(1, b_title);
              	  pstmt.setString(2, b_content);
              	  pstmt.setString(3, b_idx);
            	}
        	  pstmt.executeUpdate(); 
            }
          }
       }catch(Exception e){
          e.printStackTrace();
       }
%>
		<script>
			alert('수정되었습니다');
			location.href='view.jsp?b_idx=<%=b_idx%>'; // 그냥 view로 넘기는게 아니라 idx로 넘겨야 내가 어디를 수정 했는지 알 수 있다.
		</script>
<%
	}
%>

