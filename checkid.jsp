<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%request.setCharacterEncoding("utf-8");//다국어지원을 위한 인코딩지정(한글의 경우 깨질수 있으므로 utf-8로 지정)%>
<%@ page import="java.util.*" %>
<%@ page import="java.io.*" %>
<%@ page import="net.sf.json.*" %>
<%@ include file="conn.jsp" %>

<%
/**
아이디중복체크
**/

String user_id	= request.getParameter("user_id");

PreparedStatement pstmt = null;
ResultSet rs = null;
String sql = "";

sql = "select count(*) as cnt from member where user_id=?";//회원조회
pstmt = conn.prepareStatement(sql);
pstmt.setString(1, user_id);
rs = pstmt.executeQuery();
rs.next();
int cnt = rs.getInt("cnt");

/*
response.setContentType("application/json");
JSONObject obj = new JSONObject();
if(cnt>0){
	obj.put("result", "200");
}else{
	obj.put("result", "100");
}
response.getWriter().write(obj.toString());
*/
out.println(cnt);
%>