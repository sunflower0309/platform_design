<%@ page language="java" import="java.util.*,java.sql.*" 
         contentType="text/html; charset=utf-8"
%>
<%! %>
<%

int count=0;
//out.print(request.getParameter("sub_score_1"));
String connectString = "jdbc:mysql://localhost:3306/math_platform"
		+ "?autoReconnect=true&useUnicode=true&serverTimezone=UTC"
		+ "&characterEncoding=UTF-8"; 
String user="root"; String pwd="123";
request.setCharacterEncoding("UTF-8");
String stu_id_se=session.getAttribute("username").toString();
if(stu_id_se.equals("")||stu_id_se==null){
	out.print("<script>alert('请先登录！');window.location='Login.jsp';</script>");
	//response.sendRedirect("Login.jsp");
}
Class.forName("com.mysql.cj.jdbc.Driver");
Connection con=DriverManager.getConnection(connectString,user,pwd);
Statement stmt=con.createStatement();
//String paper_name="extra3";
String paper_id=request.getParameter("paper_id");
String stu_id=request.getParameter("stu_id");
StringBuilder table=new StringBuilder("");
//String class_id=request.getParameter("class_id");
String getpaper=String.format("select * from paper_answer_info where paper_id='%s' and stu_id=%s",paper_id,stu_id);
System.out.println(getpaper);
table.append("<table class='gridtable'><tr><th>id</th><th>题目</th><th>答案</th><th>分值</th><th>得分</th><th>给分</th><th>是否给过分</th></tr>");

ResultSet rs_paper=stmt.executeQuery(getpaper);
while(rs_paper.next()){
	System.out.println("get");
	if(rs_paper.getString("ques_type").equals("sub")){
		
		Statement stmt1=con.createStatement();
		String sql1="";
		ResultSet rs1=null;
		sql1=String.format("select * from subjective_question_info where sub_id='%s'",rs_paper.getString("ques_id"));
		rs1=stmt1.executeQuery(sql1);
		rs1.next();
		
		table.append(String.format("<tr><td><input type='hidden' class='sub_id' name='id"+String.valueOf(count)+"' value='%s'/>%s</td>"
				,rs_paper.getString("ques_id"),rs_paper.getString("ques_id")));
		
		table.append(String.format("<td>%s</td>"
				,rs1.getString("sub_ques_describe")));
		table.append(String.format("<td><input type='hidden' name='answer"+String.valueOf(count)+"' value='%s'/>%s</td>"
				,rs_paper.getString("answer"),rs_paper.getString("answer")));
		table.append(String.format("<td><input type='hidden' name='max_score"+String.valueOf(count)+"' value='%s'/>%s</td>"
				,rs_paper.getString("max_score"),rs_paper.getString("max_score")));
		table.append("<td><input type='text' class='give_score' name='score"+String.valueOf(count)+"' value=0></td>");
		table.append("<td><input type='button'  onclick='giveScore(this)' value='给分'></td>");
		table.append("<td><input class='is_done'  value='false' readonly='readonly'></td></tr>");
		count+=1;
	}
}
table.append("</table>");

if(request.getParameter("finish")!=null){
	try{
		int sub=Integer.parseInt(request.getParameter("sub_score_1"));
		int obj=Integer.parseInt(request.getParameter("obj_score_1"));
		String sql=String.format("insert into paper_score(paper_id,stu_id,score) values('%s',%s,%d)",request.getParameter("paper_id"),stu_id,sub+obj);
		Statement stmt1=con.createStatement();
		stmt1.executeUpdate(sql);
		out.print("<script>alert('批卷成功！'); window.close(); </script>");
	}
	catch(Exception e){
		out.print("<script>alert('已经给过分了！');window.close(); </script>");
	}
}

%>
<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<title>Insert title here</title>
<script type="text/javascript"
  src="http://cdn.mathjax.org/mathjax/latest/MathJax.js?config=TeX-AMS-MML_HTMLorMML">
</script>
<!-- 引用jquery -->
<script src="http://libs.baidu.com/jquery/2.1.4/jquery.min.js"></script>
<script type="text/javascript">
var sc=0;
function giveScore(obj){
	var is_done=$(obj).parents("tr").find(".is_done").val();
	if(is_done=="true"){
		alert("已经给过分了");
		return;
	}
	else{
		var paper_id=document.getElementById("paper_id").value;
		var sub_score=$(obj).parents("tr").find(".give_score").val();
		var sub_id=$(obj).parents("tr").find(".sub_id").val();
		var stu_id=document.getElementById("stu_id").value;
		console.log(sub_score);
		var sub=parseInt(sub_score);
		sc=sc+sub;
		console.log(sc);
		$(obj).parents("tr").find(".is_done").val("true");
		document.getElementById("sub_score").value=sc;
		if(window.XMLHttpRequest){
			xmlhttp=new XMLHttpRequest();// IE7+, Firefox, Chrome, Opera, Safari 浏览器执行代码
		}
		else{
			xmlhttp=new ActiveXObject("Microsoft.XMLHTTP");// IE6, IE5 浏览器执行代码
		}
		xmlhttp.onreadystatechange=function(){
			if(xmlhttp.readyState==4&&xmlhttp.status==200){
				
			}
		}
		
		xmlhttp.open("GET","/try/update_score.jsp?paper_id="+paper_id+"&sub_score="+sub_score+"&sub_id="+sub_id+"&stu_id="+stu_id,true);
		xmlhttp.send();
	}
}
function objCorrect(){
	var paper_id=document.getElementById("paper_id").value;
	var stu_id=document.getElementById("stu_id").value;
	var xmlhttp;
	
	if(window.XMLHttpRequest){
		xmlhttp=new XMLHttpRequest();// IE7+, Firefox, Chrome, Opera, Safari 浏览器执行代码
	}
	else{
		xmlhttp=new ActiveXObject("Microsoft.XMLHTTP");// IE6, IE5 浏览器执行代码
	}
	xmlhttp.onreadystatechange=function(){
		if(xmlhttp.readyState==4&&xmlhttp.status==200){
			
			document.getElementById("obj_score").innerHTML="客观题得分:"+xmlhttp.responseText;
			var obj=parseInt(xmlhttp.responseText);
			document.getElementById("obj_score_1").value=obj;
		}
	}
	
	xmlhttp.open("GET","/try/obj_correct.jsp?paper_id="+paper_id+"&stu_id="+stu_id,true);
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
学生ID：<%=stu_id %>
<form method="post" action="correct_paper.jsp">

<!-- <input type='submit' name='paper_select' value="查找卷子"/> -->
<p style="text-align:center"><input type='button' name='obj_correct' onclick='objCorrect()' value="客观题批改"  ></p>
<div id='obj_score'></div>
<%=table %>
<p style="text-align:center"><input type='submit' name='finish' value="提交分数"  style="text-align:center"></p>
<input type="hidden" name='obj_score_1' id='obj_score_1' value=0>
<input type="hidden" name='sub_score_1' id='sub_score' value=0>
<input type="hidden" id='paper_id' name='paper_id' value=<%=paper_id %>>
<input type="hidden" id='stu_id' name='stu_id' value=<%=stu_id %>>

</form>


</body>
</html>