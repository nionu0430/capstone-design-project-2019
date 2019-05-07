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
		<link rel="stylesheet" href="css/styles.css">
		<script src="js/jquery-1.11.0.min.js" type="text/javascript"></script>
		<script src="js/jquery-ui.min.js" type="text/javascript"></script>
		<script>
		$(document).ready(function(){

			//로그인
			$("#btnJoin").on("click", function() {
				var form = $("#form1")[0];

				if($("#user_id").val()==""){
					alert("아이디를 입력하세요.");
					$("#user_id").focus();
					return false;
				}
				if($("#chk").val()==""){
					alert("아이디를 중복확인을 하셔야 합니다.");
					$("#chk").focus();
					return false;
				}
				if($("#chk").val()=="N"){
					alert("이미 존재하는 아이디 입니다.");
					$("#chk").focus();
					return false;
				}
				if($("#user_pw").val()==""){
						alert("비밀번호를 입력하세요.");
						$("#user_pw").focus();
						return false;
				}
				if($("#re_pw").val()==""){
						alert("비밀번호확인을 입력하세요.");
						$("#re_pw").focus();
						return false;
				}
				if($("#user_pw").val()!=$("#re_pw").val()){
						alert("비밀번호와 비밀번호확인이 일치하지 않습니다.");
						$("#re_pw").focus();
						return false;
				}
				if($("#name").val()==""){
						alert("이름을 입력하세요.");
						$("#name").focus();
						return false;
				}
				if($("#telno").val()==""){
						alert("연락처를 입력하세요.");
						$("#telno").focus();
						return false;
				}

				form.submit();
			});

			//아이디중복확인(엔터클릭시)
			$("#userId").keyup(function(e){if(e.keyCode == 13)  fn_checkid(); });
		});

		//아이디중복확인
		function fn_checkid(){
			if($("#user_id").val()==""){
				alert("아이디를 입력하세요.");
				$("#user_id").focus()
				return;
			}

			$.ajax({
				type: 'post',
				url: "checkid.jsp",
				dataType: "text",
				data: $.param({
					user_id: $("#user_id").val()
				}),
				success: function(data) {
					var result = data.trim();
					if(result=="0"){
						$("#check_result").html("사용가능한 아이디입니다.");
						$("#chk").val("Y");
					}else{
						$("#check_result").html("존재하는 아이디입니다.");
						$("#chk").val("N");
					}
				}
		   });
		}
	 </script>
   <title>안녕하세요</title>
</head>
<body>

	<%@include file="menu.jsp"%>

	<br><br><br><br>
	<table align="center" width="600">
	<tr height="50">
		<td colspan="2"><font size="5">회원가입</font></td>
	</tr>
	</table>

	<form class="form-horizontal" id="form1" method="post" action="join_ok.jsp">
		<input type="hidden" name="chk" id="chk">
		<table align="center" width="600" class="tb">
		<tr height="30">
			<th>아이디</th>
			<td><input type="text" name="user_id" id="user_id" style="width:200px">
					<button type="button" onclick="fn_checkid();" class="btn btn-warning">아이디중복확인</button>
					<span id="check_result"></span>
					<input type="hidden" name="chk" id="chk">			
			</td>
		</tr>
		<tr height="30">
			<th>비밀번호</th>
			<td><input type="password" name="user_pw" id="user_pw" style="width:200px"></td>
		</tr>
		<tr height="30">
			<th>비밀번호확인</th>
			<td><input type="password" name="re_pw" id="re_pw" style="width:200px"></td>
		</tr>
		<tr height="30">
			<th>이름</th>
			<td><input type="text" name="name" id="name" style="width:200px"></td>
		</tr>
		<tr height="30">
			<th>연락처</th>
			<td><input type="text" name="telno" id="telno" style="width:200px"></td>
		</tr>
		</table>
		<table align="center" width="600">
		<tr height="50">
			<td colspan="2" align="center">
				<button type="button" id="btnJoin">가입신청</button>
			</td>
		</tr>
		</table>
	</form>

</body>
<html>
