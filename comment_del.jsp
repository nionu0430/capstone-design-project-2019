<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%request.setCharacterEncoding("utf-8");//다국어지원을 위한 인코딩지정(한글의 경우 깨질수 있으므로 utf-8로 지정)%>
<%@ include file="conn.jsp" %><!-- 데이터베이스 연결성정 -->
<%
/**
댓글삭제
**/

//post, get으로 보내진 name의 항목 값 받는다.
String seq = request.getParameter("seq");//게시물pk
String bseq = request.getParameter("bseq");//게시판pk

String sql = "delete from comment where seq=? and bseq=?";//회원조회
PreparedStatement pstmt = conn.prepareStatement(sql);
pstmt.setString(1, seq);//seq 파라미터
pstmt.setString(2, bseq);//bseq 파라미터
pstmt.executeUpdate();
%>
<script>
	alert('삭제되었습니다.');
	location.href='board_detail.jsp?seq=<%=bseq%>';
</script>