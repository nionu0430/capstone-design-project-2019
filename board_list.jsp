<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%request.setCharacterEncoding("utf-8");//다국어지원을 위한 인코딩지정(한글의 경우 깨질수 있으므로 utf-8로 지정)%>
<%@ include file="conn.jsp" %><!-- 데이터베이스 연결성정 -->
<%
/*
게시판 상제
*/

//검색어
String keyword = (request.getParameter("keyword")==null || request.getParameter("keyword")=="")? "":request.getParameter("keyword");

//페이지번호
int pageNum = (request.getParameter("page")==null || request.getParameter("page")=="") ? 1 : Integer.parseInt(request.getParameter("page"));//page : default - 1

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
	<script type="text/javascript"> 
		function fn_paging(p){
			$("#page").val(p);
			document.form1.submit();
		}
	</script>
</head>
<body>

	<%@include file="menu.jsp"%>

	<br><br><br><br>

	<form method="post" name="form1">
		<input type="hidden" id="page" name="page" value="">
		
	</table>
	<table align="center" width="600">
		<tr>
			<td align="center">
			<strong style="font-size:20px;">검색(제목, 내용)</strong>&nbsp;&nbsp;&nbsp;
			<input type="text" name="keyword" value="<%=keyword%>" style="width:300px;height:30px;font-size:20px;"/>&nbsp;&nbsp;
			<input type="submit" value="검색" style="height:35px;font-size:20px;"/>
			</td>
		</tr>
	</table>
	</form>

	<br><br>

	<input type="hidden" id="page" name="page" value="">
	<table align="center" width="600">
		<tr>
			<td align="right">
			<%if(userid!=null){%>
			<input type="button" value="글쓰기" onclick="location.href='board_write.jsp'">
			<%}%>
			</td>
		</tr>
	</table>
	<table align="center" width="600" class="tb">
		<tr>
			<th width="10%">번호</th>
			<th>제목</th>
			<th width="15%">작성자</th>
			<th width="15%">날짜</th>
			<th width="10%">조회수</th>
		</tr>
		
			<%
			//상품 목록
			String sql = "";
			ResultSet rs = null;
			PreparedStatement pstmt = null;
			int list = 10; //page : default - 10
			int b_pageNum_list = 10; //블럭에 나타낼 페이지 번호 갯수
			int block = (int)Math.ceil(pageNum/(double)b_pageNum_list); //현재 리스트의 블럭 구하기
			int b_start_page = ((block-1)*b_pageNum_list)+1; //현재 블럭에서 시작페이지 번호
			int b_end_page = b_start_page+b_pageNum_list-1; //현재 블럭에서 마지막 페이지 번호
			
			if(keyword!=null && !"".equals(keyword)){
				sql = "select count(*) as cnt from board where title like ? or content like ?";//게시글 목록을 가져온다.
				pstmt = conn.prepareStatement(sql);
				pstmt.setString(1, '%'+keyword+'%');
				pstmt.setString(2, '%'+keyword+'%');
				rs = pstmt.executeQuery();
				rs.next();
			}else{
				sql = "select count(*) as cnt from board";//게시글  목록을 가져온다.
				pstmt = conn.prepareStatement(sql);
				rs = pstmt.executeQuery();
				rs.next();
			}
			
			int totalCount = rs.getInt("cnt");
			int limit = (pageNum-1)*list;
			int total_page = (int)Math.ceil(totalCount/(double)list); //총 페이지 수
			if(b_end_page > total_page){ b_end_page = total_page; }
			int total_block = (int)Math.ceil(total_page/(double)b_pageNum_list); //현재 리스트의 블럭 구하기
			int line_num = totalCount-(list*(pageNum-1));
			
			if(keyword!=null && !"".equals(keyword)){
				sql = "select * from board a left join member b on a.writer=b.user_id where a.title like ? or a.content like ? order by  a.upseq desc, a.depth asc limit "+limit+","+list;//게시글  목록을 가져온다.
				pstmt = conn.prepareStatement(sql);
				pstmt.setString(1, '%'+keyword+'%');
				pstmt.setString(2, '%'+keyword+'%');
				rs = pstmt.executeQuery();
			}else{
				sql = "select * from board a left join member b on a.writer=b.user_id order by a.upseq desc, a.depth asc limit "+limit+","+list;//게시글  목록을 가져온다.
				pstmt = conn.prepareStatement(sql);
				rs = pstmt.executeQuery();				
			}

			String seq = "";
			String upseq = "";
			String title = "";
			String content = "";
			String wdate = "";
			String name = "";
			String rcnt = "";
			int idx=0;
			int num=0;
			int depth = 0;
			String re = "";

			if(totalCount>0){
				while(rs.next()){
					seq = rs.getString("seq");//번호
					upseq = rs.getString("upseq");//상위번호
					title = rs.getString("title");//제목
					wdate = rs.getString("wdate");//날짜
					name = rs.getString("name");//작성자
					rcnt = rs.getString("rcnt");//조회수
					depth = rs.getInt("depth");//댓글depth
					
					//일련번호
					num = totalCount-((pageNum-1)*list)-idx;
			%>	
				<tr>
					<td align="center"><%=num%></td>
					<td style="text-align:left;padding-left:10px;">
						<%if(depth!=0){
							for(int i=0; i<depth; i++){
								re = re+"&nbsp;&nbsp;&nbsp;";
							}
							re = re+"ㄴ";
							out.println(re);
						}%>
						<a href="board_detail.jsp?seq=<%=seq%>"><%=title%></a>
					</td>
					<td align="center"><%=name%></td>
					<td align="center"><%=wdate%></td>
					<td align="center"><%=rcnt%></td>
				</tr>
			<%
					re = "";
					idx++;
				}
			}else{
			%>
				<tr>
					<td colspan="5" align="center">게시물이 없습니다.</td>
				</tr>
			<%
			}
			%>
			</table>
			
			<table align="center" width="600">
			<tr>
				<td align="center" height="50">
				<%
					if(block>1) out.print("<a onclick='javascript:fn_paging(\'1\')' style='cursor:pointer'>1</a>..");
					for(int j = b_start_page; j <=b_end_page; j++)
					{
						if(pageNum == j)
						{
							out.print("<strong>"+j+"</strong>&nbsp;&nbsp;&nbsp;");
						}
						else{
							out.print("<a onclick=\"javascript:fn_paging('"+j+"')\" style='cursor:pointer'>"+j+"</a>&nbsp;&nbsp;&nbsp;");
						}
					}
					if(total_block>block) out.print("..<a href=\"javascript:fn_paging('"+total_page+"')\" style='cursor:pointer'>"+total_page+"</a>");
				%>
				</td>
			</tr>
			</table>

</body>
</html>