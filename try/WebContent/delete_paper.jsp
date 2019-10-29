<%@ page language="java" import="java.util.*,java.sql.*,java.net.*" 
         contentType="text/html; charset=utf-8" 
%>
<%
String connectString = "jdbc:mysql://localhost:3306/math_platform"
		+ "?autoReconnect=true&useUnicode=true&serverTimezone=UTC"
		+ "&characterEncoding=UTF-8"; 
String user="root"; String pwd="123";

System.out.println("here");
Class.forName("com.mysql.cj.jdbc.Driver");
Connection con_kn=DriverManager.getConnection(connectString,user,pwd);
Statement stmt_kn=con_kn.createStatement();
String paper_id=new String(request.getParameter("id").getBytes("ISO-8859-1"),"utf-8");

try{
	
		
		String fmt1=String.format("delete from paper_score where paper_id='%s'",paper_id);
		String fmt2=String.format("delete from paper_info where paper_id='%s'",paper_id);
		String fmt3=String.format("delete from paper_answer_info where paper_id='%s'",paper_id);
		String fmt4=String.format("delete from paper_name where paper_id='%s'",paper_id);
		stmt_kn.execute(fmt1);stmt_kn.execute(fmt2);stmt_kn.execute(fmt3);stmt_kn.execute(fmt4);
		response.getWriter().write("ok");
	
}
catch(Exception e){
	System.out.println(e.getMessage());
	response.getWriter().write(e.getMessage());
	
}


%>
