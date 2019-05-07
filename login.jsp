<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="conn.jsp" %>
<%
//로그인정보
String userid = (String)session.getAttribute("USERID");
String usernm = (String)session.getAttribute("USERNM");
%>
<!doctype html>
<html lang='kr'>
	<head>
	<meta charset="UTF-8">
	<title>안녕하세요</title>
	<link rel="stylesheet" href="css/styles.css">
	<script src="js/jquery-1.11.0.min.js" type="text/javascript"></script>
	<script src="js/jquery-ui.min.js" type="text/javascript"></script>
	<script>
		$(document).ready(function(){
			//로그인
			$("#form1").on("submit", function() {
				var form = $("#form1")[0];

				if($("#userId").val()==""){
					alert("아이디를 입력하세요.");
					$("#userId").focus();
					return false;
				}
				if($("#userPw").val()==""){
					alert("비밀번호를 입력하세요.");
					$("#userPw").focus();
					return false;
				}

				form.submit();
			});

			$("#btnJoin").on("click", function(){
				location.href = "join.jsp";
			});
		});
	 </script>
</head>
<body>

	<%@include file="menu.jsp"%>
	
	<form class="form-horizontal" id="form1" method="post" action="login_ok.jsp">
		<table align="center" width="300">
		<tr height="200">
			<td colspan="2"></td>
		</tr>
		<tr height="50">
			<td colspan="2"><font size="5">LOG IN</font></td>
		</tr>
		<tr height="30">
			<td>아이디</td>
			<td><input type="userId" name="userId" id="userId" style="width:200px"></td>
		</tr>
		<tr height="30">
			<td>비밀번호</td>
			<td><input type="password" name="userPw" id="userPw" style="width:200px"></td>
		</tr>
		<tr height="50">
			<td colspan="2" align="center">
				<button type="submit" class="btn btn-primary">로그인</button>
				<button type="button" id="btnJoin" class="btn btn-success">회원가입</button>
			</td>
		</tr>
		</table>
	</form>

</body>
<html>
