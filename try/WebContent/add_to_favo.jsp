<%@ page language="java" import="java.util.*,java.sql.*" 
         contentType="text/html; charset=utf-8"
%>
<%
request.setCharacterEncoding("UTF-8");
String connectString = "jdbc:mysql://localhost:3306/math_platform"
		+ "?autoReconnect=true&useUnicode=true&serverTimezone=UTC"
		+ "&characterEncoding=UTF-8"; 
String user="root"; String pwd="123";
String type=request.getParameter("type");
String id=request.getParameter("id");
String stu_id=request.getParameter("stu_id");
String comment=new String(request.getParameter("comment").getBytes("ISO-8859-1"),"utf-8");
String res="ok";
Class.forName("com.mysql.cj.jdbc.Driver");
Connection con_kn=DriverManager.getConnection(connectString,user,pwd);
Statement stmt_kn=con_kn.createStatement();
try{
	String fmt=String.format("insert into favo_ques(stu_id,ques_id,comment,type) values(%s,%s,'%s','%s')",stu_id,id,comment,type);
	stmt_kn.executeUpdate(fmt);
}
catch(Exception e){
	res=e.getMessage();
}
response.getWriter().write(res);
%>
