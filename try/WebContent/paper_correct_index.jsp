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

String query_point_num="select knowledge_name from knowledge_point";
Class.forName("com.mysql.cj.jdbc.Driver");
Connection con_kn=DriverManager.getConnection(connectString,user,pwd);
StringBuilder table=new StringBuilder("");
if(request.getParameter("search")!=null){
	String key=new String(request.getParameter("search_paper").getBytes("ISO-8859-1"),"utf-8");


	
	String sql_empty=String.format("select * from paper_name where paper_name like '%%%s%%'",key);
	table.append("<table class='altrowstable' id='alternatecolor'><tr><th>标题</th><th>备注</th><th>查看</th></tr>");
	Statement stmt=con_kn.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE,ResultSet.CONCUR_READ_ONLY);

	ResultSet rs1=stmt.executeQuery(sql_empty);
	while(rs1.next()){
		String comment="";
		if(rs1.getString("paper_comment")!=null){
			comment=rs1.getString("paper_comment").toString();
		}
		table.append("<tr><td>"+rs1.getString("paper_name").toString()+
				"</td><td>"+comment+"</td><td><a href='class_for_paper.jsp?paper_id="+rs1.getString("paper_id").toString()+"' target='_blank'>查看</a></td></tr>");
	}
	table.append("</table>");
}
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<title>Insert title here</title>
<script type="text/javascript">
function altRows(id){
	if(document.getElementsByTagName){  
		
		var table = document.getElementById(id);  
		var rows = table.getElementsByTagName("tr"); 
		 
		for(i = 0; i < rows.length; i++){          
			if(i % 2 == 0){
				rows[i].className = "evenrowcolor";
			}else{
				rows[i].className = "oddrowcolor";
			}      
		}
	}
}
 
window.onload=function(){
	altRows('alternatecolor');
}
</script>
<style type="text/css">
table.altrowstable {
	width:85%;
	margin:0 auto;
	
	font-family: verdana,arial,sans-serif;
	font-size:11px;
	color:#333333;
	border-width: 1px;
	border-color: #a9c6c9;
	border-collapse: collapse;
}
table.altrowstable th {
	border-width: 1px;
	padding: 8px;
	border-style: solid;
	border-color: #a9c6c9;
}
table.altrowstable td {
	text-align:center;
	border-width: 1px;
	padding: 8px;
	border-style: solid;
	border-color: #a9c6c9;
}
table.altrowstable tr:hover {
	background-color:#ffff66;
}
.oddrowcolor{
	background-color:#d4e3e5;
}
.evenrowcolor{
	background-color:#c3dde0;
}
</style>
</head>
<br>
<body>
<p style="text-align:center;">搜索卷子：</p>
<form action="paper_correct_index.jsp" method="post" >
<div style="text-align:center;">输入关键字：<input type='text' id='search_paper' name='search_paper' value="" />
<input type="submit" name="search" value="搜索" > </div>

</form><br>
<%=table %>

</body>
</html>