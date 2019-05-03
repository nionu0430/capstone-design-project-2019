<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%request.setCharacterEncoding("utf-8");//다국어지원을 위한 인코딩지정(한글의 경우 깨질수 있으므로 utf-8로 지정)%>
<%@ include file="conn.jsp" %><!-- 데이터베이스 연결성정 -->
<%@ page import="java.io.*" %>
<%
/**
첨부파일다운로드
**/

String seq = request.getParameter("seq");

String sql = "select * from board where seq=?";//게시판 목록을 가져온다.
PreparedStatement pstmt = conn.prepareStatement(sql);
pstmt.setString(1, seq);
ResultSet rs = pstmt.executeQuery();
rs.next();

String filenm = rs.getString("filenm");
String filepath = rs.getString("filepath");

//파일 객체 생성
String dir = application.getRealPath("/Uploads");
File f = new File(dir+"/"+filepath);
if (f.length()<1 || !f.isFile()) {
	out.println("파일이 존재하지 않거나 내용이 없는 파일입니다");
	return;
}



// 파일을 전송한다
response.setContentType("application/octet-stream");
response.setHeader("Cache-Control", "no-cache");
response.addHeader("Content-disposition", "attachment; filename=" + new String(filenm.getBytes("euc-kr"),"8859_1"));

byte[] buffer = new byte[1024];
BufferedInputStream fis = null;
BufferedOutputStream fos = null;

try {
	out.clear();
	out = pageContext.pushBody(); // ※※※
	
	fis = new BufferedInputStream (new FileInputStream(f));
	fos = new BufferedOutputStream (response.getOutputStream());
	int read = 0;

	while((read = fis.read(buffer)) != -1){
		fos.write(buffer, 0, read);
	}
} catch (Exception e) {
	out.println("다운로드 에러 : " + e.getMessage());
} finally {
	fos.close();
	fis.close();
}


//=================================================================================================
%>