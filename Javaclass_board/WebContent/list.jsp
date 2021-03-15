<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.util.*"%>
<%@ page import="java.text.SimpleDateFormat"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page import="com.koreait.test.TestDTO" %>
<jsp:useBean id="testDTO" class="com.koreait.test.TestDTO"/>
<jsp:useBean id="dao" class="com.koreait.test.TestDAO"/>


<% 	
	
	// [페이징]
	String pageNum = request.getParameter("pageNum"); 		// int는 null값을 받을 수 없다. (String 가능)
	if(pageNum == null || pageNum.equals("")) {
		pageNum = "1";
	}
	
	
	int[] arr = new int[4];
	arr = dao.page(pageNum);
	
	 int totalCount =  arr[0];
     int pagePerCount = arr[1];
     int start = arr[2];
     int pageNums = arr[3];
     
     // 게시판 나열
     List<TestDTO> pagelist = new ArrayList<>();
     pagelist = dao.list(start, pagePerCount);
     
%>      
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>리스트test</title>
</head>
<body>
	<h2>리스트test</h2>
	<p>게시글 : <%=totalCount%>개</p>
	<!--게시글 만들때는 table이 편하다 -->
	<table border="1" width="800">
		<tr>
			<th>번호</th>
			<th>제목</th>
			<th>글쓴이</th>
			<th>조회수</th>
		</tr>
<%
		for(TestDTO test : pagelist) {
			
		
%>
		<tr>
         <td><%=test.getIdx()%></td>
         <td><a href="./view.jsp?b_idx=<%=test.getIdx()%>"><%=test.getTitle()%></a></td> 
         <td><%=test.getName()%>(<%=test.getUserid() %>)</td>
         <td><%=test.getHit()%></td>
      	</tr>
<%
		}
%>
	
		<tr>
			<td colspan="4">
			<%
				for(int i=1; i<=pageNums; i++){
					out.print("<a href='list.jsp?pageNum=" + i + "'>[" + i + "]</a>" + "&nbsp;&nbsp;");
				}
			%>
			</td>
		</tr>
		<tr>
			<td colspan="4"><input type="button" value="글작성" onclick="location.href='./write.jsp'">
			<input type="button" value="돌아가기" onclick="location.href='../list.jsp'"></td>
		</tr>
	</table>
</body>
</html>