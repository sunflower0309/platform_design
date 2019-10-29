<%@ page language="java" import="java.util.*,java.sql.*,com.platform.*" 
         contentType="text/html; charset=utf-8"
%>
<%!String paper_name="";String paper_comment=""; %>
<%
String stu_id_se=session.getAttribute("username").toString();
if(stu_id_se.equals("")||stu_id_se==null){
	out.print("<script>alert('请先登录！');window.location='Login.jsp';</script>");
	//response.sendRedirect("Login.jsp");
}
request.setCharacterEncoding("UTF-8");
String connectString = "jdbc:mysql://localhost:3306/math_platform"
		+ "?autoReconnect=true&useUnicode=true&serverTimezone=UTC"
		+ "&characterEncoding=UTF-8"; 
String user="root"; String pwd="123";
int pgno=0;
int pgcnt=10;

String param=request.getParameter("pgno");
if(param!=null&&!param.isEmpty()){
	pgno=Integer.parseInt(param);
}
param=request.getParameter("pgcnt");
if(param!=null&&!param.isEmpty()){
	pgcnt=Integer.parseInt(param);
}
int pgprev=(pgno>0)?pgno-1:0;
int pgnext=pgno+1;
String query_point_num="select knowledge_name from knowledge_point";
Class.forName("com.mysql.cj.jdbc.Driver");
Connection con_kn=DriverManager.getConnection(connectString,user,pwd);
Statement stmt_kn=con_kn.createStatement();
String fmt1="select * from knowledge_point";
ResultSet rs=stmt_kn.executeQuery(fmt1);
List<point> pointlist=new ArrayList<point>();
List<point> finallist=new ArrayList<point>();
List<point> finallist1=new ArrayList<point>();
List<String> del=new ArrayList<String>();
List<String> del1=new ArrayList<String>();
String opt="";
while(rs.next()){
	point x=new point(rs.getInt(4),rs.getInt(1),rs.getInt(3),rs.getString(2));
	pointlist.add(x);
}
/* for(int i=0;i<pointlist.size();i++){
	out.println(pointlist.get(i).getname());
} */
StringBuilder sbuild=new StringBuilder("");
point b=new point();
finallist1=b.rebuild(0,pointlist,pointlist,finallist);

/* int j=0;
session.setAttribute("count",j);
List<sub_info> list_sub=new ArrayList<sub_info>();
session.setAttribute("list_sub", list_sub); */



StringBuilder table=new StringBuilder("");
table.append("<table class='hovertable'><tr><th>id</th><th>题目</th><th>分值</th><th>添加</th></tr>");
if(request.getParameter("search")!=null){
	String point1=new String(request.getParameter("point1").getBytes("ISO-8859-1"),"utf-8");
	String point2=new String(request.getParameter("point2").getBytes("ISO-8859-1"),"utf-8");
	String diff=new String(request.getParameter("diff").getBytes("ISO-8859-1"),"utf-8");
	String type=new String(request.getParameter("type").getBytes("ISO-8859-1"),"utf-8");
	String key=request.getParameter("search_ques");
	System.out.println(key);
	String sql_empty="";
	paper_name=request.getParameter("paper_name");
	paper_comment=request.getParameter("paper_comment");
	if(request.getParameter("type").equals("sub")){
		if(request.getParameter("search_ques").trim().isEmpty()){
			if(point1.equals("0")&&point2.equals("0")){
				sql_empty=String.format("select * from subjective_question_info where diff=%s",diff);
			}
			else if(point1.equals("0")&&(!point2.equals("0"))){
				sql_empty=String.format("select * from subjective_question_info where (sub_point1='%s' or sub_point2='%s') and diff=%s",point2,point2,diff);
			}
			else if(point2.equals("0")&&(!point1.equals("0"))){
				sql_empty=String.format("select * from subjective_question_info where (sub_point1='%s' or sub_point2='%s') and diff=%s",point1,point1,diff);
			}
			else{
				sql_empty=String.format("select * from subjective_question_info where sub_point1='%s' and sub_point2='%s' and diff=%s or sub_point2='%s' and sub_point1='%s' and diff=%s",point1,point2,diff,point1,point2,diff);
			}
			Statement stmt=con_kn.createStatement();
			ResultSet rs1=stmt.executeQuery(sql_empty);
			int i=0;
			while(rs1.next()){
				table.append(String.format(
			     		 "<tr><td><input type='hidden' value='%s' class='sub_id'>'%s'</td><td>%s</td><td><input type='text' class='sub_score'></td><td><input type='button' name='add' value='加入卷子' onclick='add_sub(this)'></td></tr>",
			     		rs1.getString("sub_id").toString(),rs1.getString("sub_id").toString(),rs1.getString("sub_ques_describe")));
				i+=1;
			}
		}
		else if(!request.getParameter("search_ques").trim().isEmpty()){
			if(point1.equals("0")&&point2.equals("0")){
				sql_empty=String.format("select * from subjective_question_info where diff=%s and sub_ques_describe like '%%%s%%'",diff,key);
			}
			else if(point1.equals("0")&&(!point2.equals("0"))){
				sql_empty=String.format("select * from subjective_question_info where (sub_point1='%s' or sub_point2='%s') and diff=%s and sub_ques_describe like '%%%s%%'",point2,point2,diff,key);
			}
			else if(point2.equals("0")&&(!point1.equals("0"))){
				sql_empty=String.format("select * from subjective_question_info where (sub_point1='%s' or sub_point2='%s') and diff=%s and sub_ques_describe like '%%%s%%'",point1,point1,diff,key);
			}
			else{
				sql_empty=String.format("select * from subjective_question_info where sub_point1='%s' and sub_point2='%s' and diff=%s and sub_ques_describe like '%%%s%%' or sub_point2='%s' and sub_point1='%s' and diff=%s and sub_ques_describe like '%%%s%%'",point1,point2,diff,key,point1,point2,diff,key);
			}
			Statement stmt=con_kn.createStatement();
			ResultSet rs1=stmt.executeQuery(sql_empty);
			int i=0;
			while(rs1.next()){
				table.append(String.format(
			     		 "<tr><td><input type='hidden' value='%s' class='sub_id'>'%s'</td><td>%s</td><td><input type='text' class='sub_score'></td><td><input type='button' name='add' value='加入卷子' onclick='add_sub(this)'></td></tr>",
			     		 rs1.getString("sub_id").toString(),rs1.getString("sub_id").toString(),rs1.getString("sub_ques_describe")));
				i+=1;
			}
		}
		table.append("</table>");
	}
	else if(request.getParameter("type").equals("obj_cho")){
		if(request.getParameter("search_ques").trim().isEmpty()){
			if(point1.equals("0")&&point2.equals("0")){
				sql_empty=String.format("select * from objective_question_info_choice where diff=%s",diff);
			}
			else if(point1.equals("0")&&(!point2.equals("0"))){
				sql_empty=String.format("select * from objective_question_info_choice where (obj_point1='%s' or obj_point2='%s') and diff=%s",point2,point2,diff);
			}
			else if(point2.equals("0")&&(!point1.equals("0"))){
				sql_empty=String.format("select * from objective_question_info_choice where (obj_point1='%s' or obj_point2='%s') and diff=%s",point1,point1,diff);
			}
			else{
				sql_empty=String.format("select * from objective_question_info_choice where obj_point1='%s' and obj_point2='%s' and diff=%s or obj_point2='%s' and obj_point1='%s' and diff=%s",point1,point2,diff,point1,point2,diff);
			}
			Statement stmt=con_kn.createStatement();
			ResultSet rs1=stmt.executeQuery(sql_empty);
			int i=0;
			while(rs1.next()){
				table.append(String.format(
			     		 "<tr><td><input type='hidden' value='%s' class='cho_id'>'%s'</td><td>%s</td><td><input type='text' class='cho_score'></td><td><input type='button' name='add' value='加入卷子' onclick='add_obj_cho(this)'></td></tr>",
			     		rs1.getString("obj_question_id").toString(),rs1.getString("obj_question_id").toString(),rs1.getString("obj_question_describe")));
				i+=1;
			}
		}
		else if(!request.getParameter("search_ques").trim().isEmpty()){
			if(point1.equals("0")&&point2.equals("0")){
				sql_empty=String.format("select * from objective_question_info_choice where diff=%s and obj_question_describe like '%%%s%%'",diff,key);
			}
			else if(point1.equals("0")&&(!point2.equals("0"))){
				sql_empty=String.format("select * from objective_question_info_choice where (obj_point1='%s' or obj_point2='%s') and diff=%s and obj_question_describe like '%%%s%%'",point2,point2,diff,key);
			}
			else if(point2.equals("0")&&(!point1.equals("0"))){
				sql_empty=String.format("select * from objective_question_info_choice where (obj_point1='%s' or obj_point2='%s') and diff=%s and obj_question_describe like '%%%s%%'",point1,point1,diff,key);
			}
			else{
				sql_empty=String.format("select * from objective_question_info_choice where obj_point1='%s' and obj_point2='%s' and diff=%s and obj_question_describe like '%%%s%%' or obj_point2='%s' and obj_point1='%s' and diff=%s and obj_question_describe like '%%%s%%'",point1,point2,diff,key,point1,point2,diff,key);
			}
			Statement stmt=con_kn.createStatement();
			ResultSet rs1=stmt.executeQuery(sql_empty);
			int i=0;
			while(rs1.next()){
				table.append(String.format(
			     		 "<tr><td><input type='hidden' value='%s' class='cho_id'>'%s'</td><td>%s</td><td><input type='text' class='cho_score'></td><td><input type='button' name='add' value='加入卷子' onclick='add_obj_cho(this)'></td></tr>",
			     		rs1.getString("obj_question_id").toString(),rs1.getString("obj_question_id").toString(),rs1.getString("obj_question_describe")));
				i+=1;
			}
		}
		table.append("</table>");
	}
	else if(request.getParameter("type").equals("obj_fill")){
		if(request.getParameter("search_ques").trim().isEmpty()){
			if(point1.equals("0")&&point2.equals("0")){
				sql_empty=String.format("select * from objective_question_info_fill where diff=%s",diff);
			}
			else if(point1.equals("0")&&(!point2.equals("0"))){
				sql_empty=String.format("select * from objective_question_info_fill where (obj_point1='%s' or obj_point2='%s') and diff=%s",point2,point2,diff);
			}
			else if(point2.equals("0")&&(!point1.equals("0"))){
				sql_empty=String.format("select * from objective_question_info_fill where (obj_point1='%s' or obj_point2='%s') and diff=%s",point1,point1,diff);
			}
			else{
				sql_empty=String.format("select * from objective_question_info_fill where obj_point1='%s' and obj_point2='%s' and diff=%s or obj_point2='%s' and obj_point1='%s' and diff=%s",point1,point2,diff,point1,point2,diff);
			}
			Statement stmt=con_kn.createStatement();
			ResultSet rs1=stmt.executeQuery(sql_empty);
			int i=0;
			while(rs1.next()){
				table.append(String.format(
			     		 "<tr><td><input type='hidden' value='%s' class='fill_id'>'%s'</td><td>%s</td><td><input type='text' class='fill_score'></td><td><input type='button' name='add' value='加入卷子' onclick='add_obj_fill(this)'></td></tr>",
			     		rs1.getString("obj_question_id").toString(),rs1.getString("obj_question_id").toString(),rs1.getString("obj_question_describe")));
				i+=1;
			}
		}
		else if(!request.getParameter("search_ques").trim().isEmpty()){
			if(point1.equals("0")&&point2.equals("0")){
				sql_empty=String.format("select * from objective_question_info_fill where diff=%s and obj_question_describe like '%%%s%%'",diff,key);
			}
			else if(point1.equals("0")&&(!point2.equals("0"))){
				sql_empty=String.format("select * from objective_question_info_fill where (obj_point1='%s' or obj_point2='%s') and diff=%s and obj_question_describe like '%%%s%%'",point2,point2,diff,key);
			}
			else if(point2.equals("0")&&(!point1.equals("0"))){
				sql_empty=String.format("select * from objective_question_info_fill where (obj_point1='%s' or obj_point2='%s') and diff=%s and obj_question_describe like '%%%s%%'",point1,point1,diff,key);
			}
			else{
				sql_empty=String.format("select * from objective_question_info_fill where obj_point1='%s' and obj_point2='%s' and diff=%s and obj_question_describe like '%%%s%%' or obj_point2='%s' and obj_point1='%s' and diff=%s and obj_question_describe like '%%%s%%'",point1,point2,diff,key,point1,point2,diff,key);
			}
			Statement stmt=con_kn.createStatement();
			ResultSet rs1=stmt.executeQuery(sql_empty);
			int i=0;
			while(rs1.next()){
				table.append(String.format(
			     		 "<tr><td><input type='hidden' value='%s' class='fill_id'>'%s'</td><td>%s</td><td><input type='text' class='fill_score'></td><td><input type='button' name='add' value='加入卷子' onclick='add_obj_fill(this)'></td></tr>",
			     		rs1.getString("obj_question_id").toString(),rs1.getString("obj_question_id").toString(),rs1.getString("obj_question_describe")));
				i+=1;
			}
		}
		table.append("</table>");
	}
}

int index_num=1;
if(request.getParameter("finish")!=null){//四个位置都不为空才可以添加数据
	
		String paper_name=request.getParameter("paper_name");
		String paper_comment=request.getParameter("paper_comment");
		String fmt_name="insert into paper_name(paper_name,paper_comment) values('%s','%s')";
		String sql_name=String.format(fmt_name,paper_name,paper_comment);
		Statement stmt_name=con_kn.createStatement();
		Statement stmt_name1=con_kn.createStatement();
		int name_insert=stmt_name.executeUpdate(sql_name);
		String getid="select paper_id from paper_name order by paper_id desc limit 1";
		ResultSet rs_last=stmt_name1.executeQuery(getid);
		
		rs_last.next();
		int paper_id=rs_last.getInt(1);
 
		int count1=(Integer)session.getAttribute("count_cho");
		ArrayList<String> list_cho_id_new=(ArrayList<String>)session.getAttribute("list_cho_id");
		ArrayList<String> list_cho_score_new=(ArrayList<String>)session.getAttribute("list_cho_score");
		for(int i=0;i<count1;i++){
			String cho_id=list_cho_id_new.get(i);
			String cho_score=list_cho_score_new.get(i);
			int score=Integer.parseInt(cho_score);
			String fmt=String.format("select * from objective_question_info_choice where obj_question_id=%s",cho_id);
			Statement stmt_cho1=con_kn.createStatement();
			ResultSet rs1=stmt_cho1.executeQuery(fmt);
			String answer="";
			while(rs1.next()){
				answer=rs1.getString("obj_question_answer");
			}
			String sql_cho=String.format("insert into paper_info(paper_name,ques_type,ques_id,ques_score,ques_answer,paper_id) values('%s','%s','%s',%d,'%s',%d)",
					paper_name,"cho",cho_id,score,answer,paper_id);
			Statement stmt_cho=con_kn.createStatement();
			stmt_cho.executeUpdate(sql_cho);
		}
		
		int count2=(Integer)session.getAttribute("count_fill");
		ArrayList<String> list_fill_id_new=(ArrayList<String>)session.getAttribute("list_fill_id");
		ArrayList<String> list_fill_score_new=(ArrayList<String>)session.getAttribute("list_fill_score");
		for(int i=0;i<count2;i++){
			String fill_id=list_fill_id_new.get(i);
			String fill_score=list_fill_score_new.get(i);
			int score=Integer.parseInt(fill_score);
			String fmt=String.format("select * from objective_question_info_fill where obj_question_id=%s",fill_id);
			Statement stmt_fill1=con_kn.createStatement();
			ResultSet rs1=stmt_fill1.executeQuery(fmt);
			String answer="";
			while(rs1.next()){
				answer=rs1.getString("obj_question_answer");
			}
			String sql_fill=String.format("insert into paper_info(paper_name,ques_type,ques_id,ques_score,ques_answer,paper_id) values('%s','%s','%s',%d,'%s',%d)",
					paper_name,"fill",fill_id,score,answer,paper_id);
			Statement stmt_fill=con_kn.createStatement();
			stmt_fill.executeUpdate(sql_fill);
		}
		
		int count3=(Integer)session.getAttribute("count_sub");
		ArrayList<String> list_sub_id_new=(ArrayList<String>)session.getAttribute("list_sub_id");
		ArrayList<String> list_sub_score_new=(ArrayList<String>)session.getAttribute("list_sub_score");
		for(int i=0;i<count3;i++){
			String sub_id=list_sub_id_new.get(i);
			String sub_score=list_sub_score_new.get(i);
			int score=Integer.parseInt(sub_score);
			String fmt=String.format("select * from subjective_question_info where sub_id=%s",sub_id);
			Statement stmt_sub1=con_kn.createStatement();
			ResultSet rs1=stmt_sub1.executeQuery(fmt);
			String answer="";
			while(rs1.next()){
				answer=rs1.getString("sub_ques_answer");
			}
			String sql_sub=String.format("insert into paper_info(paper_name,ques_type,ques_id,ques_score,ques_answer,paper_id) values('%s','%s','%s',%d,'%s',%d)",
					paper_name,"sub",sub_id,score,answer,paper_id);
			Statement stmt_sub=con_kn.createStatement();
			stmt_sub.executeUpdate(sql_sub);
		}
		
	
	int j=0;
	session.setAttribute("count_sub",j);
	List<String> list_sub_id=new ArrayList<String>();
	List<String> list_sub_score=new ArrayList<String>();
	session.setAttribute("list_sub_id", list_sub_id);
	session.setAttribute("list_sub_score", list_sub_score);

	session.setAttribute("count_cho",j);
	List<String> list_cho_id=new ArrayList<String>();
	List<String> list_cho_score=new ArrayList<String>();
	session.setAttribute("list_cho_id", list_cho_id);
	session.setAttribute("list_cho_score", list_cho_score);

	session.setAttribute("count_fill",j);
	List<String> list_fill_id=new ArrayList<String>();
	List<String> list_fill_score=new ArrayList<String>();
	session.setAttribute("list_fill_id", list_fill_id);
	session.setAttribute("list_fill_score", list_fill_score);
	
	paper_name="";
	out.print("<script>alert('添加成功！'); window.location='redirect/re_addpaperbyhand.jsp' </script>");
}
	

%>
<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<title>Insert title here</title>
<!-- 引用jquery -->
<script src="http://libs.baidu.com/jquery/2.1.4/jquery.min.js"></script>
<script>

var index=1;
function add_sub(obj){
	var sub_id=$(obj).parents("tr").find(".sub_id").val();
	var sub_score=$(obj).parents("tr").find(".sub_score").val();
	if(sub_score==""){
		alert("请输入分数！");
	}
	else{
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
				console.log(xmlhttp.responseText.length);
				if(xmlhttp.responseText.length==6){
					alert("添加成功");
				}
				else{
					alert("已经添加");
				}
			}
		}
		
		xmlhttp.open("GET","/try/add_ques_to_session.jsp?sub_id="+sub_id+"&sub_score="+sub_score+"&type=sub",true);
		xmlhttp.send();
	}
}
function add_obj_cho(obj){
	var cho_id=$(obj).parents("tr").find(".cho_id").val();
	var cho_score=$(obj).parents("tr").find(".cho_score").val();
	
	if(cho_score==""){
		alert("请输入分数！");
	}
	else{
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
					alert("添加成功");
				}
				else{
					alert("已经添加");
				}
			}
		}
		
		xmlhttp.open("GET","/try/add_ques_to_session.jsp?cho_id="+cho_id+"&cho_score="+cho_score+"&type=cho",true);
		xmlhttp.send();
	}
}
function add_obj_fill(obj){
	var fill_id=$(obj).parents("tr").find(".fill_id").val();
	var fill_score=$(obj).parents("tr").find(".fill_score").val();
	if(fill_score==""){
		alert("请输入分数！");
	}
	else{
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
					alert("添加成功");
				}
				else{
					alert("已经添加");
				}
			}
		}
		
		xmlhttp.open("GET","/try/add_ques_to_session.jsp?fill_id="+fill_id+"&fill_score="+fill_score+"&type=fill",true);
		xmlhttp.send();
	}
}


</script>
<script type="text/javascript"
  src="http://cdn.mathjax.org/mathjax/latest/MathJax.js?config=TeX-AMS-MML_HTMLorMML">
</script>
<style type="text/css">
table.hovertable {
	margin-top:10px;
	width:70%;
	font-family: verdana,arial,sans-serif;
	font-size:11px;
	color:#333333;
	border-width: 1px;
	border-color: #999999;
	border-collapse: collapse;
}
table.hovertable th {
	background-color:#c3dde0;
	border-width: 1px;
	padding: 8px;
	border-style: solid;
	border-color: #a9c6c9;
}
table.hovertable tr {
	background-color:#d4e3e5;
}
table.hovertable tr:hover {
	background-color:#ffff66;
}
table.hovertable td {
	text-align:center;
	border-width: 1px;
	padding: 8px;
	border-style: solid;
	border-color: #a9c6c9;
}
</style>
</head>
<body>
<br>
<form method="post" action="add_paper_by_hand.jsp" id="paper">

输入卷子名称：<input type='text' id='paper_name' name='paper_name' value=<%=paper_name %>><br>

输入卷子备注：<input type='text' id='paper_comment' name='paper_comment' value=<%=paper_comment %>>


<br><br>
<input type='text' id='search_ques' name='search_ques' value=""/>

<input type='submit' name='search'  value="搜索">

<select name='type'>
<option value='sub' selected='selected'>主观题</option>
<option value='obj_cho' >选择题</option>
<option value='obj_fill' >填空题</option>
</select>

选择所属知识点1：<select name='point1'>
<option value=0>无</option>
<%for(int i=0;i<finallist1.size();i++){ %>
<%String pre=""; %>
<option value=<%=finallist1.get(i).getid() %>>
<%for(int k=1;k<finallist1.get(i).getrank();k++){ %>
<% pre+="&nbsp;&nbsp;";%>
<%} %>
<%opt=pre+"   |-"+finallist1.get(i).getname(); %>
<%=opt %>
</option>
<%} %>
</select>
选择所属知识点2：<select name='point2'>
<option value=0>无</option>
<%for(int i=0;i<finallist1.size();i++){ %>
<%String pre=""; %>
<option value=<%=finallist1.get(i).getid() %>>
<%for(int k=1;k<finallist1.get(i).getrank();k++){ %>
<% pre+="&nbsp;&nbsp;";%>
<%} %>
<%opt=pre+"   |-"+finallist1.get(i).getname(); %>
<%=opt %>
</option>
<%} %>
</select>
<br>
题目难度：<select name='diff'>
<option value='1'>1</option>
<option value='2'>2</option>
<option value='3'>3</option>
<option value='4'>4</option>
<option value='5'>5</option>
</select>
<br>
<%=table %>


<input type="hidden" name='sub_id' id='sub_id' value="0">
<input type="hidden" name='sub_score' id='sub_score' value="0">
</form>


<div style="position:fixed;right:10px;
    bottom:500px;">
<input type='button' name='paper_preview' value='预览' onclick='window.open("paper_preview.jsp")'>&nbsp;
<input type='submit' form='paper' name='finish' value='提交' />
</div>

<div id="check"></div>
</body>
</html>