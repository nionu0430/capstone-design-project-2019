<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<script>
	function fn_logout(){
		location.href='logout.jsp';
	}
</script>
<!--상단메뉴이렇게 하는건가-->
<table style="width:100%;background:#000000;height:40px;">
	<tr>
		<td align="center">
			<table width="1000">
			<tr>
				<td width=150>
					<span style="color:white;"><h3>YonseiAKN</h3></span>
				</td>
				<td style="color:#fff">
					<a href="board_list.jsp"><font color="#ffffff">게시판</font></a>&nbsp;&nbsp;&nbsp;|&nbsp;&nbsp;
					<a href="test.jsp"><font color="#ffffff">test</font></a>
				</td>
				<td align="right">
					<%
					if(usernm!=null){
					%>
					<font color="#ffff00" size="2"><strong><%=usernm%></strong></font>&nbsp;<font color="#ffffff">님&nbsp;안녕하세요.&nbsp;&nbsp;</font>
					<span onclick="fn_logout();"><font color="#ff6600"><strong><u>로그아웃</u></strong></font></span>
					<%}
					else if(usernm==null){%>
					<a href="login.jsp"><font color="#ffffff">로그인</font></a>;
					<a href="join.jsp"><font color="#ffffff">회원가입</font></a>
					<%}%>
				</td>
			</tr>
			</table>
		</td>
	</tr>
</table>
<br/>