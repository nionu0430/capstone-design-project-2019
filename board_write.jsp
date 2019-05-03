<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%request.setCharacterEncoding("utf-8");//다국어지원을 위한 인코딩지정(한글의 경우 깨질수 있으므로 utf-8로 지정)%>
<%@ include file="conn.jsp" %><!-- 데이터베이스 연결성정 -->
<%
//로그인정보
String userid = (String)session.getAttribute("USERID");
String usernm = (String)session.getAttribute("USERNM");

String seq = (request.getParameter("seq")==null)?"":request.getParameter("seq");
String key = "";
String title = "";
String content = "";
String writer = "";
String wdate = "";
String rcnt = "";
String filenm = "";

//게시물 조회
if(!"".equals(seq)){
	String sql = "select * from board where seq=?";//게시물조회
	PreparedStatement pstmt = null;
	pstmt = conn.prepareStatement(sql);
	pstmt.setString(1, seq);
	ResultSet rs = pstmt.executeQuery();
	rs.next();
	
	key = rs.getString("seq");
	title = rs.getString("title");
	content = rs.getString("content");
	writer = rs.getString("writer");
	wdate = rs.getString("wdate");
	rcnt = rs.getString("rcnt");
	filenm = (rs.getString("filenm")==null)?"":rs.getString("filenm");
}
%>
<!doctype html>
<html lang='kr'>
	<head>
	<meta charset="UTF-8">
	<link rel="stylesheet" href="css/styles.css">
	<script src="js/jquery-1.11.0.min.js" type="text/javascript"></script>
	<script src="js/jquery-ui.min.js" type="text/javascript"></script>
	<script type="text/javascript"> 
		//submit
		function sub(){
			var form = document.form1;
			if($("#title").val()==""){
				alert("제목을 입력하세요.");
				$("#title").focus();
				return;
			}

			if($("#content").val()==""){
				alert("내용을 입력하세요.");
				return;
			}
			
			form.submit();
		}
	</script>
</head>
<body>

	<%@include file="menu.jsp"%>

	<br><br><br><br>

		<form method="post" name="form1" action="board_write_ok.jsp" enctype="multipart/form-data">
		<input type="hidden" name="seq" value="<%=seq%>"/>
		<input type="hidden" name="id" value="<%=userid%>"/>

		<table align="center" width="600">
			<tr>
				<td><font size="3">글쓰기</font></td>
			</tr>
		</table>
		<table width="600" align="center" class="tb">
			<tr>
				<th width="100">제목</th>
				<td align="left"><input type="text" name="title" id="title" size="50" value="<%=title%>"/></td>
			</tr>
			<tr>
				<th>내용</th>
				<td>
		            <textarea name="content" id="content" style="width:100%;height:200px;"><%=content%></textarea>
				</td>
			</tr>
			<tr>
				<th>첨부파일</th>
				<td>
		            <input type="file" name="upfile" id="upfile" size="50"/>

					<%if(!"".equals(filenm)){%>
						<br/><br/>
						<u><a href="down.jsp?seq=<%=seq%>"><%=filenm%></a></u>
					<%}%>
				</td>
			</tr>
			<tr>
				<th>작성자</th>
				<td>
		            <%=usernm%>
				</td>
			</tr>
			<tr height=50 align="center">
				<td colspan="2">
					<input type="button" name="btnWrite" value="저장" onclick="sub();"/>
					<a href="board_list.jsp"><input type="button" value="목록"></a>
				</td>
			</tr>
		</table>
		</form>	

</body>
</html>