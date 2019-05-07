<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%request.setCharacterEncoding("utf-8");//다국어지원을 위한 인코딩지정(한글의 경우 깨질수 있으므로 utf-8로 지정)%>
<%@ include file="conn.jsp" %><!-- 데이터베이스 연결성정 -->
<%@page import="java.util.Date"%>
<%@page import="java.text.SimpleDateFormat"%>
<%
/*
게시판 상세
*/

String seq = request.getParameter("seq");
String userid = (String)session.getAttribute("USERID");
String usernm = (String)session.getAttribute("USERNM");
%>
<!doctype html>
<html lang='kr'>
	<head>
	<meta charset="UTF-8">
	<link rel="stylesheet" href="css/styles.css">
	<script src="js/jquery-1.11.0.min.js" type="text/javascript"></script>
	<script src="js/jquery-ui.min.js" type="text/javascript"></script>
	<script type="text/javascript"> 
		//전송
		function sub(){
			var form = document.form1;
			<%
			//로그인한 경우만 댓글 입력가능하도록 미로그인시 댓글 입력 체크
			if(userid!=null){%>
				if($("#comment").val()==""){
					alert("댓글 내용을 입력하세요.");
					$("#comment").focus();
					return;
				}
			<%}%>
			
			form.submit();
		}
	</script>
</head>
<body>

	<%@include file="menu.jsp"%>

	<br><br><br><br>

		<%
		//게시물 카운터
		String sql3 = "update board set rcnt=rcnt+1 where seq=?";//게시판 조회수를 업데이트
		PreparedStatement pstmt3 = null;
		pstmt3 = conn.prepareStatement(sql3);
		pstmt3.setString(1, seq);
		pstmt3.executeUpdate();
		
		//게시물 목록을 조회한다.
		String sql = "select * from board a left join member b on a.writer=b.user_id where a.seq=?";//게시판 목록을 가져온다.
		PreparedStatement pstmt = conn.prepareStatement(sql);
		pstmt.setString(1, seq);
		ResultSet rs = pstmt.executeQuery();
		rs.next();

		String upseq = rs.getString("upseq");
		String title = rs.getString("title");
		String content = rs.getString("content");
		content = content.replaceAll("\r\n", "<br>");
		content = content.replaceAll("\r", "<br>");
		content = content.replaceAll("\n", "<br>");
		String writer = rs.getString("writer");
		String name = rs.getString("name");
		String wdate = rs.getString("wdate");
		int rcnt = rs.getInt("rcnt");
		String filenm = (rs.getString("filenm")==null)?"":rs.getString("filenm");
		%>
		<table align="center" width="600">
			<tr>
				<td><font size="3">상세보기</font></td>
			</tr>
		</table>
		<table width="600" align="center" class="tb">
			<tr>
				<th width="100">제목</th>
				<td align="left"><%=title%> (조회수: <%=rcnt%>)</td>
			</tr>
			<tr>
				<th>작성자</th>
				<td><%=name%> (작성일: <%=wdate%>)</td>
			</tr>
			<tr>
				<th height="100">내용</th>
				<td>
		            <%=content%>
				</td>
			</tr>
			<tr>
				<th>첨부파일</th>
				<td>
		            <u><a href="down.jsp?seq=<%=seq%>"><%=filenm%></a></u>
				</td>
			</tr>
		</table>

		<table align="center" width="600">
			<tr>
				<td align="right">
					<a href="board_list.jsp"><input type="button" value="목록"></a>
					<%if(writer.equals(userid)){%>
						<a href="board_write_re.jsp?upseq=<%=seq%>"><input type="button" value="답변"></a>
						<a href="board_write.jsp?seq=<%=seq%>"><input type="button" value="수정"></a>
						<a href="board_del.jsp?seq=<%=seq%>"><input type="button" value="삭제"></a>
					<%}%>
				</td>
			</tr>
		</table>

		<br/>
		<form method="post" name="form1" action="comment_ok.jsp">
			<input type="hidden" name="bseq" value="<%=seq%>"/>
			<input type="hidden" name="id" value="<%=userid%>"/>
		
			<table border=0 align="center" width="600">
				<%
				//댓글 목록
				String sql2 = "select * from comment a left join member b on a.writer=b.user_id where a.bseq=? order by a.seq asc";//댓글 목록을 가져온다.
				PreparedStatement pstmt2 = null;
				pstmt2 = conn.prepareStatement(sql2);
				pstmt2.setString(1, seq);
				ResultSet rs2 = pstmt2.executeQuery();
				while(rs2.next()){
					
					String cseq = rs2.getString("seq");
					String name2 = rs2.getString("name");
					String comment = rs2.getString("comment");
					String today = rs2.getString("wdate");
				%>
				<tr>
					<td width="100" height="30" align="center"><strong><%=name2%></strong></td>
					<td><%=comment%>&nbsp;&nbsp;[<%=today%>]
											
						<%if(userid!=null){
							if(writer.equals(userid)){%>
							<a href="comment_del.jsp?seq=<%=cseq%>&bseq=<%=seq%>&bname=qna"><u><font color='red'>삭제</font></u></a>
						<%}}%>
					</td>
				</tr>
			<%}%>
			
			<%if(userid!=null){%>
			<tr>
				<td width="100" align="center" height="100"><strong>댓글작성</strong></td>
				<td>
					<textarea name="comment" id="comment" style="width:400px;height:50px;"></textarea>
					<input type="button" name="btnWrite" value="작성" onclick="sub();" style="vertical-align:top;width:50px;height:55px;background:white;border:1px solid black;" onclick="sub();"/>
				</td>
			</tr>
			<%}%>
		</table>
		</form>
	
</body>
</html>