<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%request.setCharacterEncoding("utf-8");//다국어지원을 위한 인코딩지정(한글의 경우 깨질수 있으므로 utf-8로 지정)%>
<%@ include file="conn.jsp" %><!-- 데이터베이스 연결성정 -->
<%
/**
로그인 처리
**/

//post, get으로 보내진 name의 항목 값 받는다.
String userId = request.getParameter("userId");
String userPw = request.getParameter("userPw");

PreparedStatement pstmt = null;
ResultSet rs = null;
String sql = "";

//회원정보 조회
sql = "select count(*) as cnt from member where user_id=? and user_pw=?";//회원조회
pstmt = conn.prepareStatement(sql);
pstmt.setString(1, userId);
pstmt.setString(2, userPw);
rs = pstmt.executeQuery();
rs.next();
int cnt = rs.getInt("cnt");

//회원정보가 존재하면 로그인 세션 생성
if(cnt>0){
	sql = "select user_id, name from member where user_id=? and user_pw=?";//회원조회
	pstmt = conn.prepareStatement(sql);
	pstmt.setString(1, userId);
	pstmt.setString(2, userPw);
	rs = pstmt.executeQuery();
	rs.next();
	
	String id = rs.getString("user_id");
	String name = rs.getString("name");

	session.setAttribute("USERID", id);//아이디를 세션 정보로 생성한다.
	session.setAttribute("USERNM", name);//이름을 세션 정보로 생성한다.
%>
	<script>
		alert('안녕하세요. <%=name%>님');
		location.href='board_list.jsp';
	</script>
<%
//회원정보가 존재하지 않으면 메인으로 이동
}else{%>
	<script>
		alert('로그인 정보가 일치하지 않습니다.');
		location.href='board_list.jsp';
	</script>
<%}%>