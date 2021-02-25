<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%
	if(session.getAttribute("userid") == null){  
		// 즉, info.jsp로 못 들어오고 튕겨냄
%>
	<script>
		alert('로그인 후 이용하세요');
		location.href='./login.jsp'; 
	</script>
<%

	}else{  // 맨 밑에 닫아줌 202라인
	

	// 여기를 통과하면 DB 이용
	
	// [DB 연결]
	Connection conn = null;
	PreparedStatement pstmt =null;
	ResultSet rs =null;
	
	// MySQL Workbench와 연결
	String sql="";
	String url ="jdbc:mysql://localhost:3306/jspstudy";
	String uid = "root";
	String upw = "1234";
	
	//전역 변수
	String userid = (String)session.getAttribute("userid");
	String mem_name = "";
	String mem_hp = "";
	String mem_email="";
	String mem_hobby ="";
	String[] hobbyArr = null;
	String mem_ssn1 ="";
	String mem_ssn2 ="";
	String mem_zipcode="";
	String mem_address1="";
	String mem_address2="";
	String mem_address3="";
	
	
	try{
		Class.forName("com.mysql.jdbc.Driver"); // "" 은 드라이버의 패키지 이름 
		conn = DriverManager.getConnection(url, uid, upw);
		if(conn != null){
			sql="select * from tb_member where mem_userid=?";
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, userid);
			rs = pstmt.executeQuery();
			if(rs.next()){
				mem_name = rs.getString("mem_name");
				mem_hp = rs.getString("mem_hp"); // DB 에서 가져와서 담아주세요
				mem_email = rs.getString("mem_email");
				mem_hobby = rs.getString("mem_hobby");
				hobbyArr = mem_hobby.split(" ");
				mem_ssn1 = rs.getString("mem_ssn1");
				mem_ssn2 = rs.getString("mem_ssn2");
				mem_zipcode = rs.getString("mem_zipcode");
				mem_address1 = rs.getString("mem_address1");
				mem_address2 = rs.getString("mem_address2");
				mem_address3 = rs.getString("mem_address3");
			}
		}
	}catch(Exception e){
		e.printStackTrace();
	}
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>정보수정</title>
    <script src="https://code.jquery.com/jquery-3.5.1.min.js" integrity="sha256-9/aliU8dGd2tb6OSsuzixeV4y/faTqgFtohetphbbj0=" crossorigin="anonymous"></script>
    <!--우편번호 API, js 연결 전에 붙이기-->
    <script src="//t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
<script>
    function sample6_execDaumPostcode() {
        new daum.Postcode({
            oncomplete: function(data) {
                // 팝업에서 검색결과 항목을 클릭했을때 실행할 코드를 작성하는 부분.

                // 각 주소의 노출 규칙에 따라 주소를 조합한다.
                // 내려오는 변수가 값이 없는 경우엔 공백('')값을 가지므로, 이를 참고하여 분기 한다.
                var addr = ''; // 주소 변수
                var extraAddr = ''; // 참고항목 변수

                //사용자가 선택한 주소 타입에 따라 해당 주소 값을 가져온다.
                if (data.userSelectedType === 'R') { // 사용자가 도로명 주소를 선택했을 경우
                    addr = data.roadAddress;
                } else { // 사용자가 지번 주소를 선택했을 경우(J)
                    addr = data.jibunAddress;
                }

                // 사용자가 선택한 주소가 도로명 타입일때 참고항목을 조합한다.
                if(data.userSelectedType === 'R'){
                    // 법정동명이 있을 경우 추가한다. (법정리는 제외)
                    // 법정동의 경우 마지막 문자가 "동/로/가"로 끝난다.
                    if(data.bname !== '' && /[동|로|가]$/g.test(data.bname)){
                        extraAddr += data.bname;
                    }
                    // 건물명이 있고, 공동주택일 경우 추가한다.
                    if(data.buildingName !== '' && data.apartment === 'Y'){
                        extraAddr += (extraAddr !== '' ? ', ' + data.buildingName : data.buildingName);
                    }
                    // 표시할 참고항목이 있을 경우, 괄호까지 추가한 최종 문자열을 만든다.
                    if(extraAddr !== ''){
                        extraAddr = ' (' + extraAddr + ')';
                    }
                    // 조합된 참고항목을 해당 필드에 넣는다.
                    document.getElementById("sample6_extraAddress").value = extraAddr;
                
                } else {
                    document.getElementById("sample6_extraAddress").value = '';
                }

                // 우편번호와 주소 정보를 해당 필드에 넣는다.
                document.getElementById('sample6_postcode').value = data.zonecode;
                document.getElementById("sample6_address").value = addr;
                // 커서를 상세주소 필드로 이동한다.
                document.getElementById("sample6_detailAddress").focus();
            }
        }).open();
    }
</script>
    <script src="./js/info.js"></script>
</head>
<body>
    <h2>정보수정</h2>
    <form name="regform" id="regform" method="post" action="info_ok.jsp" onsubmit="return sendit()"> 
    
        <input type="hidden" name="isSsn" id="isSsn" value="n">
       
		<p>아이디: <%=userid %></p>
        <p id="idCheckMsg"></p>
        <p><label>비밀번호 : <input type="password" name="userpw" id="userpw" maxlength="20"></label></p>
        <p><label>비밀번호 확인 : <input type="password" name="userpw_re" id="userpw_re" maxlength="20"></label></p>
        <p><label>이름 : <input type="text" name="username" id="username" value="<%=mem_name%>"></label></p>
        <p><label>휴대폰 번호: <input type="text" name="hp" id="hp" value="<%=mem_hp%>"></label></p>
        <p><label>이메일: <input type="text" name="email" id="email" value="<%=mem_email%>"></label></p>
        <p>취미 : <label>드라이브: <input type="checkbox" name="hobby" value="드라이브" 
        <%
        	for(int i=0; i<hobbyArr.length; i++){
        		if(hobbyArr[i].equals("드라이브")){
        			out.print("checked");
        		}
        	}
        %>
        ></label>
        <label>등산: <input type="checkbox" name="hobby" value="등산"
        <%
        	for(int i=0; i<hobbyArr.length; i++){
        		if(hobbyArr[i].equals("등산")){
        			out.print("checked");
        		}
        	}
        %>
        ></label>
        <label>영화감상: <input type="checkbox" name="hobby" value="영화감상"
        <%
        	for(int i=0; i<hobbyArr.length; i++){
        		if(hobbyArr[i].equals("영화감상")){
        			out.print("checked");
        		}
        	}
        %> 
        ></label>
        <label>쇼핑: <input type="checkbox" name="hobby" value="쇼핑"
        <%
        	for(int i=0; i<hobbyArr.length; i++){
        		if(hobbyArr[i].equals("쇼핑")){
        			out.print("checked");
        		}
        	}
        %>    
        ></label>
        <label>게임: <input type="checkbox" name="hobby" value="게임"
        <%
        	for(int i=0; i<hobbyArr.length; i++){
        		if(hobbyArr[i].equals("게임")){
        			out.print("checked");
        		}
        	}
        %>    
        ></label>
        </p>
        <p>주민등록번호 : <input type="text" name="ssn1" id="ssn1" maxlength="6" value="<%=mem_ssn1%>"> - 
        <input type="text" name="ssn2" id="ssn2" maxlength="7" value="<%=mem_ssn2%>"> 
        <input type="button" id ="ssnBtn" value="주민등록번호 검증"></p>
        <p><label>우편번호 : <input type="text" name="zipcode"  id="sample6_postcode" value="<%=mem_zipcode%>" placeholder="우편번호" readonly></label> <input type="button" value="우편번호 검색"  onclick="sample6_execDaumPostcode()"></p>
        <p><label>주소 : <input type="text" name="address1"  id="sample6_address" placeholder="주소" value="<%=mem_address1%>"></label></p>
        <p><label>상세주소 : <input type="text" name="address2"  id="sample6_detailAddress" placeholder="상세주소" value="<%=mem_address2%>"></label></p>
        <p><label>참고항목 : <input type="text" name="address3"  id="sample6_extraAddress" placeholder="참고항목" value="<%=mem_address3%>"></label></p>
        <p><input type="submit" value="수정완료"> <input type="reset" value="다시작성">
        <input type="button" value="돌아가기" onclick="location.href='login.jsp'"></p>
    </form>
</body>
</html>
<%
	}
%>