<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>글쓰기test</title>
<script src="https://cdn.ckeditor.com/ckeditor5/26.0.0/classic/ckeditor.js"></script>
</head>
<body>
	<h2>글쓰기</h2>
	<form method="post" action="write_ok.jsp" enctype="multipart/form-data"> 
		<p>작성자 : <input type="text" name="b_name"></p> 
		<p>아이디 : <input type="text" name="b_userid"></p>
		<p>비밀번호 : <input type="password" name="b_userpw"></p>
		<p>제목 : <input type="text" name="b_title"></p>
		<p>내용</p>
		<p><textarea id="editor" rows="5" cols="40" name="b_content"></textarea></p>
		<p>파일 : <input type="file" name="b_filename"></p>
		<p><input type="submit" value="등록"> <input type="button" value="리스트" onclick="location.href='list.jsp'"></p>
	</form>
	<!-- editor 3개 -->
	<script>
    ClassicEditor
        .create( document.querySelector( '#editor' ) )
        .catch( error => {
            console.error( error );
        } );
	</script>
</body>
</html>
