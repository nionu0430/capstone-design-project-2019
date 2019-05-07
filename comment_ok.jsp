<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%request.setCharacterEncoding("utf-8");//다국어지원을 위한 인코딩지정(한글의 경우 깨질수 있으므로 utf-8로 지정)%>
<%@ include file="conn.jsp" %><!-- 데이터베이스 연결성정 -->
<%
/**
댓글저장처리
**/

//post, get으로 보내진 name의 항목 값 받는다.
String paramid = request.getParameter("paramid");
String seq = request.getParameter("bseq");//게시물pk
String comment = request.getParameter("comment");//댓글
String userid = (String)session.getAttribute("USERID");//로그인 사용자ID 세션

//본인이 작성한 내용이 아니면 back
if(!userid.equals(paramid)){
	out.println("<script>history.back();</script>");
	if( true ) return ;
}

//댓글 등록
String sql = "insert into comment (bseq,comment,writer,wdate) values(?,?,?,now())";//댓글을 등록한다.
PreparedStatement pstmt = conn.prepareStatement(sql);
pstmt.setString(1, seq);//seq 파라미터
pstmt.setString(2, comment);//댓글 파라미터
pstmt.setString(3, userid);//로그인ID
pstmt.executeUpdate();

//알림
%>
<script>
	alert('댓글이 등록되었습니다.');
	location.href='board_detail.jsp?seq=<%=seq%>';
</script>