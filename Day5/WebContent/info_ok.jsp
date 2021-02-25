<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.sql.*"%>
<%
	// [과제] 깃허브에 올리기
	
	// 1. 로그인 세션 체크 (로그인 안 한사람 못 들어오게 막기)
	if(session.getAttribute("userid") == null){
%>
	<script>
		alert('로그인 후 이용하세요');
		location.href='./login.jsp'; 
	</script>
<% 
	}else{
		// 2. info.jsp로 부터 데이터를 전달 받음 - 내용이 같으니까 regist_ok.jsp 복사해옴
		request.setCharacterEncoding("UTF-8"); // 한글 깨지는 거 막기
		String userid = (String)session.getAttribute("userid"); // 데이터 받아오는게 아니라서 request.getParameter 안함
		String userpw = request.getParameter("userpw");
		String username = request.getParameter("username");
		String hp = request.getParameter("hp");
		String email = request.getParameter("email");
		String hobby[] = request.getParameterValues("hobby"); 
		String hobbystr = ""; 
		for(int i=0; i<hobby.length; i++){
			hobbystr = hobbystr + hobby[i] + " ";
		}
		String ssn1 = request.getParameter("ssn1");
		String ssn2 = request.getParameter("ssn2");
		String zipcode = request.getParameter("zipcode");
		String address1 = request.getParameter("address1");
		String address2 = request.getParameter("address2");
		String address3 = request.getParameter("address3");
		
		// 3. DB 연결
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
				// 4. 비밀번호가 맞는지 여부를 체크(select 이용)- 수정하는게 아니라 확인용도 <- id와 pw대입해서 모두 다 일치하는지 알아보기
				sql="select mem_idx from tb_member where mem_userid=? and mem_userpw=?"; // select mem_idx로 받아오기, select * from 할 필요 없음
				pstmt = conn.prepareStatement(sql);
				pstmt.setString(1, userid);
				pstmt.setString(2, userpw);
				rs = pstmt.executeQuery();
				
				if(rs.next()){ // 비밀번호가 맞을 경우
					// 5. update 문 실행
					sql = "update tb_member set mem_name=?, mem_hp=?, mem_email=?, mem_hobby=?, mem_ssn1=?, mem_ssn2=?, mem_zipcode=?, mem_address1=?, mem_address2=?, mem_address3=? where mem_userid=?"; // 위에서 squl 한 번 쓰면 기능 없어지므로 sql 다시 사용가능
					pstmt = conn.prepareStatement(sql);
					pstmt.setString(1, username);
					pstmt.setString(2, hp);
					pstmt.setString(3, email);
					pstmt.setString(4, hobbystr);
					pstmt.setString(5, ssn1);
					pstmt.setString(6, ssn2);
					pstmt.setString(7, zipcode);
					pstmt.setString(8, address1);
					pstmt.setString(9, address2);
					pstmt.setString(10, address3);
					pstmt.setString(11, userid);
					pstmt.executeUpdate();	
%>
	<!-- 6. info.jsp로 이동 (제대로 수정되었는지 확인) --> 
	<script>
		alert('회원정보가 수정되었습니다.');
		location.href='./info.jsp';
	</script>
<% 
				}else{ // 비밀번호가 틀릴경우 
%>
	<script>
		alert('비밀번호를 확인하세요');
		history.back(); 
	</script>
<% 				
				}
			}
		}catch(Exception e){
			e.printStackTrace();
		}
	}

	
%>


	

