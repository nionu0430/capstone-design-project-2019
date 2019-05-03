<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%request.setCharacterEncoding("utf-8");//다국어지원을 위한 인코딩지정(한글의 경우 깨질수 있으므로 utf-8로 지정)%>
<%@ include file="conn.jsp" %><!-- 데이터베이스 연결성정 -->

<html lang='kr'>
	<head>
	
</head>
<body>

	<br><br><br><br>

	 <div id="app">
      {{ message }}
    </div>

    <script src="https://unpkg.com/vue@2.3.3"></script>
    <script>
      new Vue({
        el: '#app',
        data: {
          message: 'Hello Vue.js!'
        }
      })
    </script>

</body>
</html>