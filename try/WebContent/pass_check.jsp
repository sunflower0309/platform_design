<%@ page language="java" import="java.util.*,java.sql.*" 
         contentType="text/html; charset=utf-8"
%>
<%
request.setCharacterEncoding("utf-8");
String str1=request.getParameter("q1");
String str2=request.getParameter("q2");
if(str1.equals(str2)){
	response.getWriter().write("ok");
}
else{
	response.getWriter().write("please check your password");
}
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<title>Insert title here</title>
</head>
<body>

</body>
</html>