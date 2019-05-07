<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%request.setCharacterEncoding("utf-8");//다국어지원을 위한 인코딩지정(한글의 경우 깨질수 있으므로 utf-8로 지정)%>
<%@ include file="conn.jsp" %><!-- 데이터베이스 연결성정 -->
<%
/**
게시판 삭제
**/

//post, get으로 보내진 name의 항목 값 받는다.
String seq = request.getParameter("seq");

//정보게시판 게시물을 삭제한다.
String sql = "delete from board where seq=?";
PreparedStatement pstmt = conn.prepareStatement(sql);
pstmt.setString(1, seq);
pstmt.executeUpdate();

%>
<script>
	alert('삭제되었습니다.');
	location.href='board_list.jsp';
</script>
