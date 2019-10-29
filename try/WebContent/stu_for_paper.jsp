<%@ page language="java" import="java.util.*,java.sql.*" 
         contentType="text/html; charset=utf-8"
%>
<%
String stu_id_se=session.getAttribute("username").toString();
if(stu_id_se.equals("")||stu_id_se==null){
	out.print("<script>alert('请先登录！');window.location='Login.jsp';</script>");
	//response.sendRedirect("Login.jsp");
}
String connectString = "jdbc:mysql://localhost:3306/math_platform"
		+ "?autoReconnect=true&useUnicode=true&serverTimezone=UTC"
		+ "&characterEncoding=UTF-8"; 
String user="root"; String pwd="123";
request.setCharacterEncoding("UTF-8");
String query_point_num="select knowledge_name from knowledge_point";
Class.forName("com.mysql.cj.jdbc.Driver");
Connection con_kn=DriverManager.getConnection(connectString,user,pwd);
String class_id=new String(request.getParameter("class_id").getBytes("ISO-8859-1"),"utf-8");
String fmt=String.format("select * from class_stu where class_id=%s",class_id);
Statement stmt=con_kn.createStatement();
ResultSet rs=stmt.executeQuery(fmt);
String paper_id=request.getParameter("paper_id");
System.out.println(paper_id);
StringBuilder table=new StringBuilder("");
table.append("<table><tr><th>学生</th><th>查看</th></tr>");
while(rs.next()){
	table.append("<tr><td>"+rs.getString("stu_id").toString()+
			"</td><td><a href='correct_paper.jsp?paper_id="+paper_id+"&stu_id="+rs.getString("stu_id").toString()+"&class_id="+class_id+"' target='_blank'>查看</a></td></tr>");
}
table.append("</table>");
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<title>Insert title here</title>
</head>
<body>
<%=table %>
</body>
</html>