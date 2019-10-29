<%@ page language="java" import="java.util.*,java.sql.*" 
         contentType="text/html; charset=utf-8"
%>
<%
String connectString = "jdbc:mysql://localhost:3306/math_platform"
		+ "?autoReconnect=true&useUnicode=true&serverTimezone=UTC"
		+ "&characterEncoding=UTF-8"; 
String user="root"; String pwd="123";
request.setCharacterEncoding("UTF-8");
String name=new String(request.getParameter("q").getBytes("ISO-8859-1"),"utf-8");
System.out.println(name);
String sql=String.format("select * from paper_name where paper_name='%s'",name);
Class.forName("com.mysql.cj.jdbc.Driver");
Connection con=DriverManager.getConnection(connectString,user,pwd);
Statement stmt=con.createStatement();
ResultSet rs=stmt.executeQuery(sql);
String msg1="卷子名称已存在";
String msg2="卷子名称可用";
if(rs.next()){
	response.getWriter().write(msg1);
}
else response.getWriter().write(msg2);
%>