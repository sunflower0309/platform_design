<%@ page language="java" import="java.util.*,java.sql.*" 
         contentType="text/html; charset=utf-8"
%>

<%

String connectString = "jdbc:mysql://localhost:3306/math_platform"
		+ "?autoReconnect=true&useUnicode=true&serverTimezone=UTC"
		+ "&characterEncoding=UTF-8"; 
String user="root"; String pwd="123";
request.setCharacterEncoding("UTF-8");
/* String sub_id=new String(request.getParameter("sub_id").getBytes("ISO-8859-1"),"utf-8");
String sub_score=new String(request.getParameter("sub_score").getBytes("ISO-8859-1"),"utf-8"); */
Class.forName("com.mysql.cj.jdbc.Driver");
Connection con_kn=DriverManager.getConnection(connectString,user,pwd);


int count1=(Integer)session.getAttribute("count_sub");
ArrayList<String> list_sub_id_new=(ArrayList<String>)session.getAttribute("list_sub_id");
ArrayList<String> list_sub_score_new=(ArrayList<String>)session.getAttribute("list_sub_score");

int count2=(Integer)session.getAttribute("count_cho");
ArrayList<String> list_cho_id_new=(ArrayList<String>)session.getAttribute("list_cho_id");
ArrayList<String> list_cho_score_new=(ArrayList<String>)session.getAttribute("list_cho_score");

int count3=(Integer)session.getAttribute("count_fill");
ArrayList<String> list_fill_id_new=(ArrayList<String>)session.getAttribute("list_fill_id");
ArrayList<String> list_fill_score_new=(ArrayList<String>)session.getAttribute("list_fill_score");
StringBuilder table=new StringBuilder("");
table.append("<table class='gridtable'><tr><th>id</th><th>题目</th><th>分值</th><th>删除</th></tr>");

for(int i=0;i<count2;i++){
	String a1=list_cho_id_new.get(i);
	String a2=list_cho_score_new.get(i);
	Statement stmt_kn=con_kn.createStatement();
	String sql=String.format("select * from objective_question_info_choice where obj_question_id=%s",a1);
	ResultSet rs=stmt_kn.executeQuery(sql);
	while(rs.next()){
		table.append(String.format("<tr><td><input type='hidden' value='%s' class='cho_id'>%s</td><td>%s</td><td>%s</td><td><input type='submit' name='delete' value='删除' onclick='delete_cho(this)'></td></tr>",
				a1,a1,rs.getString("obj_question_describe"),a2));
	}
}

for(int i=0;i<count3;i++){
	String a1=list_fill_id_new.get(i);
	String a2=list_fill_score_new.get(i);
	Statement stmt_kn=con_kn.createStatement();
	String sql=String.format("select * from objective_question_info_fill where obj_question_id=%s",a1);
	ResultSet rs=stmt_kn.executeQuery(sql);
	while(rs.next()){
		table.append(String.format("<tr><td><input type='hidden' value='%s' class='fill_id'>%s</td><td>%s</td><td>%s</td><td><input type='submit' name='delete' value='删除' onclick='delete_fill(this)'></td></tr>",
				a1,a1,rs.getString("obj_question_describe"),a2));
	}
}

for(int i=0;i<count1;i++){
	String a1=list_sub_id_new.get(i);
	String a2=list_sub_score_new.get(i);
	Statement stmt_kn=con_kn.createStatement();
	String sql=String.format("select * from subjective_question_info where sub_id=%s",a1);
	ResultSet rs=stmt_kn.executeQuery(sql);
	while(rs.next()){
		table.append(String.format("<tr><td><input type='hidden' value='%s' class='sub_id'>%s</td><td>%s</td><td>%s</td><td><input type='submit' name='delete' value='删除' onclick='delete_sub(this)'></td></tr>",
				a1,a1,rs.getString("sub_ques_describe"),a2));
	}
}

table.append("</table>");
int cnt=(Integer)session.getAttribute("count_sub");
//out.print(cnt);
/* if(request.getParameter("delete")!=null){
	Statement stmt_kn=con_kn.createStatement();
	int count2=(Integer)session.getAttribute("count_sub");
	ArrayList<String> list_sub_id_new1=(ArrayList<String>)session.getAttribute("list_sub_id");
	ArrayList<String> list_sub_score_new1=(ArrayList<String>)session.getAttribute("list_sub_score");
	for(int i=0;i<count2;i++){
		if(list_sub_id_new1.get(i).equals(request.getParameter("sub_id"))){
			list_sub_id_new1.remove(i);
			list_sub_score_new1.remove(i);
		}
	}
	count2-=1;
	session.setAttribute("count_sub",count2);
	session.setAttribute("list_sub_id", list_sub_id_new1);
	session.setAttribute("list_sub_score", list_sub_score_new1);
} */

%>
<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<title>Insert title here</title>
<!-- 引用jquery -->
<script src="http://libs.baidu.com/jquery/2.1.4/jquery.min.js"></script>
<script>


function delete_sub(obj){
	var sub_id=$(obj).parents("tr").find(".sub_id").val();
	var sub_score=$(obj).parents("tr").find(".sub_score").val();
	document.getElementById("sub_id").value=sub_id;
	document.getElementById("sub_score").value=sub_score;
	var xmlhttp;
	if(window.XMLHttpRequest){
		xmlhttp=new XMLHttpRequest();// IE7+, Firefox, Chrome, Opera, Safari 浏览器执行代码
	}
	else{
		xmlhttp=new ActiveXObject("Microsoft.XMLHTTP");// IE6, IE5 浏览器执行代码
	}
	xmlhttp.onreadystatechange=function(){
		if(xmlhttp.readyState==4&&xmlhttp.status==200){	
			console.log(xmlhttp.responseText);
		}
	}
	
	xmlhttp.open("GET","/try/delete_ques_to_session.jsp?sub_id="+sub_id+"&sub_score="+sub_score+"&type=sub",true);
	xmlhttp.send();
}
function delete_cho(obj){
	var cho_id=$(obj).parents("tr").find(".cho_id").val();
	var cho_score=$(obj).parents("tr").find(".cho_score").val();
	
	var xmlhttp;
	if(window.XMLHttpRequest){
		xmlhttp=new XMLHttpRequest();// IE7+, Firefox, Chrome, Opera, Safari 浏览器执行代码
	}
	else{
		xmlhttp=new ActiveXObject("Microsoft.XMLHTTP");// IE6, IE5 浏览器执行代码
	}
	xmlhttp.onreadystatechange=function(){
		if(xmlhttp.readyState==4&&xmlhttp.status==200){	
			console.log(xmlhttp.responseText);
		}
	}
	
	xmlhttp.open("GET","/try/delete_ques_to_session.jsp?cho_id="+cho_id+"&cho_score="+cho_score+"&type=cho",true);
	xmlhttp.send();
}
function delete_fill(obj){
	var fill_id=$(obj).parents("tr").find(".fill_id").val();
	var fill_score=$(obj).parents("tr").find(".fill_score").val();
	
	var xmlhttp;
	if(window.XMLHttpRequest){
		xmlhttp=new XMLHttpRequest();// IE7+, Firefox, Chrome, Opera, Safari 浏览器执行代码
	}
	else{
		xmlhttp=new ActiveXObject("Microsoft.XMLHTTP");// IE6, IE5 浏览器执行代码
	}
	xmlhttp.onreadystatechange=function(){
		if(xmlhttp.readyState==4&&xmlhttp.status==200){	
			console.log(xmlhttp.responseText);
		}
	}
	
	xmlhttp.open("GET","/try/delete_ques_to_session.jsp?fill_id="+fill_id+"&fill_score="+fill_score+"&type=fill",true);
	xmlhttp.send();
}
</script>
 
<style type="text/css">
table.gridtable {
	margin:0 auto;
	width:70%;
	font-family: verdana,arial,sans-serif;
	font-size:15px;
	color:#333333;
	border-width: 1px;
	border-color: #666666;
	border-collapse: collapse;
}
table.gridtable th {
	border-width: 1px;
	padding: 8px;
	border-style: solid;
	border-color: #666666;
	background-color: #dedede;
}
table.gridtable td {
	border-width: 1px;
	padding: 8px;
	border-style: solid;
	border-color: #666666;
	background-color: #ffffff;
}
table.gridtable tr {
	text-align:center;
}
</style>

 
</head>
<body>
<form method="post" action="paper_preview.jsp" id="paper">

<%=table %>
</form>
<input type="hidden" name='sub_id' id='sub_id' value="0">
<input type="hidden" name='sub_score' id='sub_score' value="0">
</body>
</html>