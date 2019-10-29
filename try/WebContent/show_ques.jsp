<%@ page language="java" import="java.util.*,java.sql.*" 
         contentType="text/html; charset=utf-8"
%>
<%
request.setCharacterEncoding("UTF-8");
String connectString = "jdbc:mysql://localhost:3306/math_platform"
		+ "?autoReconnect=true&useUnicode=true&serverTimezone=UTC"
		+ "&characterEncoding=UTF-8"; 
String user="root"; String pwd="123";
int pgno=0;
int pgcnt=10;
String stu_id=session.getAttribute("username").toString();
if(stu_id.equals("")||stu_id==null){
	out.print("<script>alert('请先登录！');window.location='Login.jsp';</script>");
	//response.sendRedirect("Login.jsp");
}

String query_point_num="select knowledge_name from knowledge_point";
Class.forName("com.mysql.cj.jdbc.Driver");
Connection con_kn=DriverManager.getConnection(connectString,user,pwd);
Statement stmt_kn=con_kn.createStatement();
ResultSet rs_for_num=stmt_kn.executeQuery(query_point_num);
int point_num=1;
ArrayList<String> knowledge_point_list=new ArrayList<String>();
knowledge_point_list.add(null);
while(rs_for_num.next()){
	knowledge_point_list.add(rs_for_num.getString("knowledge_name"));
	point_num+=1;
}
String comment="";
out.print(String.format("<input type='hidden' id='stu_id' value='%s'>",stu_id));
String type=request.getParameter("ptype");
String ques_type=request.getParameter("ptype");
String id=request.getParameter("pid");
try{
	String fmt_favo=String.format("select * from favo_ques where stu_id=%s and ques_id=%s and type='%s'",stu_id,id,type);
	Statement stmt_favo=con_kn.createStatement();
	ResultSet rs_favo=stmt_favo.executeQuery(fmt_favo);

	while(rs_favo.next()){
		comment=rs_favo.getString("comment");
	}
}
catch(Exception e){
	
}
String describe="";
String choice="";
String answer="";
if(type.equals("sub")){
	String sql=String.format("select * from subjective_question_info where sub_id=%s",id);
	Statement stmt=con_kn.createStatement();
	ResultSet rs=stmt.executeQuery(sql);
	while(rs.next()){
		out.print(String.format("<input type='hidden' id='id' value='%s'>",id));
		out.print(String.format("<input type='hidden' id='type' value='%s'>",type));
		describe=rs.getString("sub_ques_describe").replaceAll("<p>", "").replaceAll("</p>", "");
		answer=rs.getString("sub_ques_answer").replaceAll("<p>", "").replaceAll("</p>", "");
	}
}
else if(type.equals("cho")){
	String sql=String.format("select * from objective_question_info_choice where obj_question_id=%s",id);
	Statement stmt=con_kn.createStatement();
	ResultSet rs=stmt.executeQuery(sql);
	while(rs.next()){
		
		out.print(String.format("<input type='hidden' id='id' value='%s'>",id));
		out.print(String.format("<input type='hidden' id='type' value='%s'>",type));
		describe=rs.getString("obj_question_describe").replaceAll("<p>", "").replaceAll("</p>", "");
		choice=rs.getString("obj_question_choice");
		
		answer=rs.getString("obj_question_answer").replaceAll("<p>", "").replaceAll("</p>", "");
	}
}
else if(type.equals("fill")){
	String sql=String.format("select * from objective_question_info_fill where obj_question_id=%s",id);
	Statement stmt=con_kn.createStatement();
	ResultSet rs=stmt.executeQuery(sql);
	while(rs.next()){
		
		out.print(String.format("<input type='hidden' id='id' value='%s'>",id));
		out.print(String.format("<input type='hidden' id='type' value='%s'>",type));
		describe=rs.getString("obj_question_describe").replaceAll("<p>", "").replaceAll("</p>", "");
		answer=rs.getString("obj_question_answer").replaceAll("<p>", "").replaceAll("</p>", "");
	}
}
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<script type="text/x-mathjax-config">
MathJax.Hub.Config({
    showProcessingMessages: false,
    messageStyle: "none",
    extensions: ["tex2jax.js"],
    jax: ["input/TeX", "output/HTML-CSS"],
    tex2jax: {
        inlineMath:  [ ["$", "$"] ],
        displayMath: [ ["$$","$$"] ],
        skipTags: ['script', 'noscript', 'style', 'textarea', 'pre','code','a'],
        ignoreClass:"comment-content"
    },
    "HTML-CSS": {
        availableFonts: ["STIX","TeX"],
        showMathMenu: false
    }
});
MathJax.Hub.Queue(["Typeset",MathJax.Hub]);
</script>
<script type="text/javascript"
  src="http://cdn.mathjax.org/mathjax/latest/MathJax.js?config=TeX-AMS-MML_HTMLorMML">
</script>
<script type="text/javascript">
function add_favo(){
	var stu_id=document.getElementById("stu_id").value;
	var id=document.getElementById("id").value;
	var type=document.getElementById("type").value;
	var comment=document.getElementById("comment").value;
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
			if(xmlhttp.responseText.length>10) alert("已经收藏！");
			else alert("收藏成功！");
		}
	}
	
	xmlhttp.open("GET","/try/add_to_favo.jsp?id="+id+"&type="+type+"&comment="+comment+"&stu_id="+stu_id,true);
	xmlhttp.send();
}
function show(){
	var ans=document.getElementById("ans");
	var btn=document.getElementById("control");
	if(ans.style.display=="inline"){
		ans.style.display="none";
		btn.innerHTML="点击显示答案";
	}
	else{
		ans.style.display="inline";
		btn.innerHTML="点击隐藏答案";
	}
}
</script>
<title>Insert title here</title>
</head>
<body style="text-align:center">
<br>
题目：<br>
<%=describe %>
<%if(type.equals("cho")){
	String[] lines=choice.replaceAll("<p>","").replaceAll("</p>","").split("/");
	out.print(String.format("A:'%s'<br>B:'%s'<br>C:'%s'<br>D:'%s'<br>", lines[0],lines[1],lines[2],lines[3]));
}%>
<br>
答案：<button onclick="show()" id="control">点击显示答案</button><br>
<p style="display:none;" id="ans"><%=answer %></p><br>
<%if(comment.equals("")){ %>
<input type="button" onclick="add_favo()" value="收藏">
评论：<input type="text" name="comment" id="comment">
<%} %>
<%if(!comment.equals("")){ %>
<br>
评论：<%=comment %>
<%} %>
<br><br>
<%if(stu_id.equals("admin")){ %>
<input type='button'  value='修改题目'onclick="window.location.href='ques_edit.jsp?type=<%=type %>&id=<%=id%>'">
<%} %>
</body>
</html>