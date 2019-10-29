<%@ page language="java" import="java.util.*,java.sql.*" 
         contentType="text/html; charset=utf-8"
%>

<%

String connectString = "jdbc:mysql://localhost:3306/math_platform"
		+ "?autoReconnect=true&useUnicode=true&serverTimezone=UTC"
		+ "&characterEncoding=UTF-8"; 
String user="root"; String pwd="123";
Class.forName("com.mysql.cj.jdbc.Driver");
request.setCharacterEncoding("UTF-8");
String paper_id=request.getParameter("paper_id");
String sub_id=request.getParameter("sub_id");
String sub_score=request.getParameter("sub_score");
int s=Integer.parseInt(sub_score);
String stu_id=request.getParameter("stu_id");
System.out.print(stu_id);
Connection con=DriverManager.getConnection(connectString,user,pwd);
Statement stmt=con.createStatement();
String sql=String.format("update paper_answer_info set score=%s,is_corrected='true' where paper_id='%s' and stu_id=%s and ques_type='sub' and ques_id=%s"
		,sub_score,paper_id,stu_id,sub_id);

/* String sqd=String.format("update paper_answer_info set score=%d,is_corrected='true' where paper_name='%s' and stu_id=%s and ques_type='sub' and ques_id=%s"
		,s,paper_name,"15352350","70"); */
stmt.executeUpdate(sql);//学生答案集合


response.getWriter().write("ok");
%>