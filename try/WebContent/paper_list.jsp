<%@ page language="java" import="java.util.*,java.sql.*" 
         contentType="text/html; charset=utf-8" 
%>

<%! int pageSize=10;
	int pageCount;
	int showPage;
	
%>
<%
String stu_id_se=session.getAttribute("username").toString();
if(stu_id_se.equals("")||stu_id_se==null){
	out.print("<script>alert('请先登录！');window.location='Login.jsp';</script>");
	//response.sendRedirect("Login.jsp");
}
//request.setCharacterEncoding("UTF-8");
String connectString = "jdbc:mysql://localhost:3306/math_platform"
		+ "?autoReconnect=true&useUnicode=true&serverTimezone=UTC"
		+ "&characterEncoding=UTF-8"; 
String user="root"; String pwd="123";

String query_point_num="select knowledge_name from knowledge_point";
Class.forName("com.mysql.cj.jdbc.Driver");
Connection con_kn=DriverManager.getConnection(connectString,user,pwd);
Statement stmt_kn=con_kn.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE,ResultSet.CONCUR_READ_ONLY);
ResultSet rs_for_num=stmt_kn.executeQuery(query_point_num);
int point_num=1;
ArrayList<String> knowledge_point_list=new ArrayList<String>();
knowledge_point_list.add(null);
while(rs_for_num.next()){
	knowledge_point_list.add(rs_for_num.getString("knowledge_name"));
	point_num+=1;
}


//String point=new String(request.getParameter("knowledge_point").getBytes("ISO-8859-1"),"utf-8");
//String point_init=request.getParameter("knowledge_point");

String key=new String(request.getParameter("search_paper").getBytes("ISO-8859-1"),"utf-8");


StringBuilder table=new StringBuilder("");
String sql_empty=String.format("select * from paper_name where paper_name like '%%%s%%'",key);
table.append("<table class='altrowstable' id='alternatecolor'><tr><th>标题</th><th>备注</th><th>查看</th><th>删除</th></tr>");

Statement stmt=con_kn.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE,ResultSet.CONCUR_READ_ONLY);

ResultSet rs1=stmt.executeQuery(sql_empty);
rs1.last();
//获取最后一行的行号 
int recordCount=rs1.getRow();
//out.print(recordCount);
//计算分页后的总数 
rs1.beforeFirst();
pageCount=(recordCount%pageSize==0)?(recordCount/pageSize):(recordCount/pageSize+1);
String integer=request.getParameter("showPage");
if(integer==null){
	integer="1";
}
try{showPage=Integer.parseInt(integer);
}catch(NumberFormatException e){
	showPage=1;
}
if(showPage<=1){
	showPage=1;
}
if(showPage>=pageCount){
	showPage=pageCount;
}
int position=(showPage-1)*pageSize+1;
//设置游标的位置

rs1.absolute(position);

if(showPage<pageCount){
	for(int i=0;i<pageSize;i++){
		String comment="";
		if(rs1.getString("paper_comment")!=null){
			comment=rs1.getString("paper_comment").toString();
		}
		table.append("<tr><td><input type='hidden' value='"+rs1.getString("paper_id").toString()+"' class='paper_id'>"+rs1.getString("paper_name").toString()+
				"</td><td>"+comment+"</td><td><a href='paper_answer.jsp?paper_id="+rs1.getString("paper_id").toString()+"' target='_blank'>查看</a></td><td><input type='button' name='delete' value='删除' onclick='delete_paper(this)'></td></tr>");
		rs1.next();
	}
}
else if(showPage==pageCount){
	int last=recordCount-position+1;
	
	for(int i=0;i<last;i++){
		String comment="";
		if(rs1.getString("paper_comment")!=null){
			comment=rs1.getString("paper_comment").toString();
		}
		table.append("<tr><td><input type='hidden' value='"+rs1.getString("paper_id").toString()+"' class='paper_id'>"+rs1.getString("paper_name").toString()+
				"</td><td>"+comment+"</td><td><a href='paper_answer.jsp?paper_id="+rs1.getString("paper_id").toString()+"' target='_blank'>查看</a></td><td><input type='button' name='delete' value='删除' onclick='delete_paper(this)'></td></tr>");
		rs1.next();
	}
}
table.append("</table>");
/* if(request.getParameter("search")!=null){
	if(request.getParameter("type").equals("sub")){
		
	}
	
} */
%>
<!DOCTYPE html>
<html>
<head>
<script src="http://libs.baidu.com/jquery/2.1.4/jquery.min.js"></script>

<script>

function delete_paper(obj){
	var paper_id=$(obj).parents("tr").find(".paper_id").val();
	
	var tr = obj.parentNode.parentNode;
	var xmlhttp;
	if(window.XMLHttpRequest){
		xmlhttp=new XMLHttpRequest();// IE7+, Firefox, Chrome, Opera, Safari 浏览器执行代码
	}
	else{
		xmlhttp=new ActiveXObject("Microsoft.XMLHTTP");// IE6, IE5 浏览器执行代码
	}
	xmlhttp.onreadystatechange=function(){
		if(xmlhttp.readyState==4&&xmlhttp.status==200){	
			console.log(xmlhttp.responseText.length);
			if(xmlhttp.responseText.length==6){
				
				alert("删除成功");
				
			    tr.parentNode.removeChild(tr);
			}
			else{
				alert("出现错误，请重试");
			}
		}
	}
	
	xmlhttp.open("GET","/try/delete_paper.jsp?id="+paper_id,true);
	xmlhttp.send();
}
</script>
<meta charset="ISO-8859-1">
<title>Insert title here</title>
<script type="text/javascript"
  src="http://cdn.mathjax.org/mathjax/latest/MathJax.js?config=TeX-AMS-MML_HTMLorMML">
</script>
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
.oddrowcolor{
	background-color:#d4e3e5;
}
.evenrowcolor{
	background-color:#c3dde0;
}
</style>

</head>
<body>
<br>
<div style="text-align:center">
<%=table %>
<br>
	第<%=showPage %>页（共<%=pageCount %>页）
	<br>
	<a href="paper_list.jsp?showPage=1&search_paper=<%=key%>">首页</a>
	<a href="paper_list.jsp?showPage=<%=showPage-1%>&search_paper=<%=key%>">上一页</a>
<%	//根据pageCount的值显示每一页的数字并附加上相应的超链接
		for(int i=1;i<=pageCount;i++){
	%>
			<a href="paper_list.jsp?showPage=<%=i%>&search_paper=<%=key%>"><%=i%></a>
<%	}
	%>	
	<a href="paper_list.jsp?showPage=<%=showPage+1%>&search_paper=<%=key%>">下一页</a>
	<a href="paper_list.jsp?showPage=<%=pageCount%>&search_paper=<%=key%>">末页</a>
</div>	
</body>
</html>