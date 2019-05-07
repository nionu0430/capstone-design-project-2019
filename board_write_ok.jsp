<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%request.setCharacterEncoding("utf-8");//다국어지원을 위한 인코딩지정(한글의 경우 깨질수 있으므로 utf-8로 지정)%>
<%@ include file="conn.jsp" %><!-- 데이터베이스 연결성정 -->
<%@page import="java.io.File"%>
<%@page import="java.util.Enumeration"%>
<%@page import="com.oreilly.servlet.multipart.DefaultFileRenamePolicy"%>
<%@page import="com.oreilly.servlet.MultipartRequest"%>
<%
/**
게시판등록
**/
//request.getParameter(name)
//post, get으로 보내진 name의 항목 값 받는다.
String paramid = "";
String seq = "";
String upseq = "";
String title = "";//제목
String content = "";//내용
String userid = (String)session.getAttribute("USERID");

//파일업로드 설정
String uploadPath = request.getRealPath("/Uploads");
int maxSize = 1024 * 1024 * 10; // 한번에 올릴 수 있는 파일 용량 : 10M로 제한
String fileName = ""; // 중복처리된 이름
String originalName = ""; // 중복 처리전 실제 원본 이름
long fileSize = 0; // 파일 사이즈
String fileType = ""; // 파일 타입
File file = null;
MultipartRequest multi = null;
Enumeration files = null;

try{
    // request,파일저장경로,용량,인코딩타입,중복파일명에 대한 기본 정책
    multi = new MultipartRequest(request, uploadPath,maxSize, "utf-8", new DefaultFileRenamePolicy());
     
	paramid = multi.getParameter("paramid");
    seq = (multi.getParameter("seq")==null)?"":multi.getParameter("seq");
	upseq = (multi.getParameter("upseq")==null)?"":multi.getParameter("upseq");
    title = multi.getParameter("title");
    content = multi.getParameter("content");

    // 전송한 전체 파일이름들을 가져옴
    files = multi.getFileNames();
     
    while(files.hasMoreElements()){
        // form 태그에서 <input type="file" name="여기에 지정한 이름" />을 가져온다.
        String file1 = (String)files.nextElement(); // 파일 input에 지정한 이름을 가져옴
        // 그에 해당하는 실재 파일 이름을 가져옴
        originalName = multi.getOriginalFileName(file1);
        // 파일명이 중복될 경우 중복 정책에 의해 뒤에 1,2,3 처럼 붙어 unique하게 파일명을 생성하는데
        // 이때 생성된 이름을 filesystemName이라 하여 그 이름 정보를 가져온다.(중복에 대한 처리)
        fileName = multi.getFilesystemName(file1);
        // 파일 타입 정보를 가져옴
        fileType = multi.getContentType(file1);
        // input file name에 해당하는 실재 파일을 가져옴
        file = multi.getFile(file1);
        // 그 파일 객체의 크기를 알아냄
        fileSize = file.length();     
    }
}catch(Exception e){
    e.printStackTrace();
}

//넘어온 게시물번호가 있으면
if("".equals(seq)){
	//게시물 등록
	String sql = "insert into board (title, content, writer, wdate, rcnt, filenm, filepath) values(?,?,?,now(),0,?,?)";//게시판을 등록한다.
	PreparedStatement pstmt = null;
	pstmt = conn.prepareStatement(sql);
	pstmt.setString(1, title);
	pstmt.setString(2, content);
	pstmt.setString(3, userid);
	pstmt.setString(4, originalName);
	pstmt.setString(5, fileName);
	pstmt.executeUpdate();

	int depth = 0;
	int newSeq = 0;
	int uSeq = 0;

	//String sql3 = "select last_insert_id() as seq";
	String sql3 = "select max(seq) as seq from board";
	PreparedStatement pstmt3 = null;
	pstmt3 = conn.prepareStatement(sql3);
	ResultSet rs3 = pstmt3.executeQuery();
	rs3.next();
	newSeq = rs3.getInt("seq");

	//댓글depth조회
	if(!"".equals(upseq)){
		//상위게시물정보
		String sql2 = "select * from board where seq=?";
		PreparedStatement pstmt2 = null;
		pstmt2 = conn.prepareStatement(sql2);
		pstmt2.setString(1, upseq);
		ResultSet rs2 = pstmt2.executeQuery();
		rs2.next();
		depth = rs2.getInt("depth")+1;
		uSeq = Integer.parseInt(upseq);
	}else{
		uSeq = newSeq;
	}

	String sql4 = "update board set upseq=?, depth=? where seq=?";
	PreparedStatement pstmt4 = null;
	pstmt4 = conn.prepareStatement(sql4);
	pstmt4.setInt(1, uSeq);
	pstmt4.setInt(2, depth);
	pstmt4.setInt(3, newSeq);
	pstmt4.executeUpdate();
}else{

	//본인이 작성한 내용이 아니면 back
	if(!userid.equals(paramid)){
		out.println("<script>history.back();</script>");
		if(true) return ;
	}

	if(files!=null){
		//게시물 수정
		String sql = "update board set title=?, content=?, filenm=?, filepath=? where seq=?";//게시판을 수정한다.
		PreparedStatement pstmt = null;
		pstmt = conn.prepareStatement(sql);
		pstmt.setString(1, title);
		pstmt.setString(2, content);
		pstmt.setString(3, originalName);
		pstmt.setString(4, fileName);
		pstmt.setString(5, seq);
		pstmt.executeUpdate();
	}else{
		//게시물 수정
		String sql = "update board set title=?, content=? where seq=?";//게시판을 수정한다.
		PreparedStatement pstmt = null;
		pstmt = conn.prepareStatement(sql);
		pstmt.setString(1, title);
		pstmt.setString(2, content);
		pstmt.setString(3, seq);
		pstmt.executeUpdate();
	}
}
%>

<script>
	alert('저장되었습니다.');
	location.href='board_list.jsp';
</script>
