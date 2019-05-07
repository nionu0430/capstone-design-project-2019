<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%request.setCharacterEncoding("utf-8");//다국어지원을 위한 인코딩지정(한글의 경우 깨질수 있으므로 utf-8로 지정)%>
<%@ include file="conn.jsp" %><!-- 데이터베이스 연결성정 -->

<%
/**
회원가입처리
**/
String user_id	= request.getParameter("user_id");
String user_pw	= request.getParameter("user_pw");
String name		= request.getParameter("name");
String telno	= request.getParameter("telno");

PreparedStatement pstmt = null;
ResultSet rs = null;
String sql = "";

sql = "insert into member(user_id, user_pw, name, telno) values (?, ?, ?, ?)";
pstmt = conn.prepareStatement(sql);
pstmt.setString(1, user_id);
pstmt.setString(2, user_pw);
pstmt.setString(3, name);
pstmt.setString(4, telno);
pstmt.executeUpdate();
%>

<script>
	alert("가입되었습니다.");
	location.href='index.jsp';
</script>