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
String id=new String(request.getParameter("id").getBytes("ISO-8859-1"),"utf-8");
String type=new String(request.getParameter("type").getBytes("ISO-8859-1"),"utf-8");
System.out.println(type);
try{
	if(type.equals("sub")){
		System.out.println(type);
		String fmt1=String.format("delete from subjective_question_info where sub_id=%s",id);
		String fmt2=String.format("delete from paper_info where ques_type='sub' and ques_id='%s'",id);
		String fmt3=String.format("delete from paper_answer_info where ques_type='sub' and ques_id='%s'",id);
		String fmt4=String.format("delete from favo_ques where type='sub' and ques_id='%s'",id);
		stmt_kn.execute(fmt1);stmt_kn.execute(fmt2);stmt_kn.execute(fmt3);stmt_kn.execute(fmt4);
		response.getWriter().write("ok");
	}
	else if(type.equals("cho")){
		System.out.println(type);
		String fmt1=String.format("delete from objective_question_info_choice where obj_question_id=%s",id);
		String fmt2=String.format("delete from paper_info where ques_type='cho' and ques_id='%s'",id);
		String fmt3=String.format("delete from paper_answer_info where ques_type='cho' and ques_id='%s'",id);
		String fmt4=String.format("delete from favo_ques where type='cho' and ques_id='%s'",id);
		stmt_kn.execute(fmt1);stmt_kn.execute(fmt2);stmt_kn.execute(fmt3);stmt_kn.execute(fmt4);
		response.getWriter().write("ok");
	}
	else if(type.equals("fill")){
		System.out.println(type);
		String fmt1=String.format("delete from objective_question_info_fill where obj_question_id=%s",id);
		String fmt2=String.format("delete from paper_info where ques_type='fill' and ques_id='%s'",id);
		String fmt3=String.format("delete from paper_answer_info where ques_type='fill' and ques_id='%s'",id);
		String fmt4=String.format("delete from favo_ques where type='fill' and ques_id='%s'",id);
		stmt_kn.execute(fmt1);stmt_kn.execute(fmt2);stmt_kn.execute(fmt3);stmt_kn.execute(fmt4);
		response.getWriter().write("ok");
	}
}
catch(Exception e){
	System.out.println(e.getMessage());
	response.getWriter().write(e.getMessage());
	
}


%>
