<%@ page language="java" import="java.util.*,java.sql.*" 
         contentType="text/html; charset=utf-8"
%>

<%
//答卷
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

Class.forName("com.mysql.cj.jdbc.Driver");
Connection con=DriverManager.getConnection(connectString,user,pwd);
Statement stmt=con.createStatement();
Statement stmt2=con.createStatement();
StringBuilder table=new StringBuilder("");
String paper_name="";
String paper_id=request.getParameter("paper_id");
String paper_comment="";
String getname=String.format("select * from paper_name where paper_id=%s",paper_id);
ResultSet rs2=stmt2.executeQuery(getname);
while(rs2.next()){
	paper_name=rs2.getString("paper_name");
	paper_comment=rs2.getString("paper_comment");
}
//String paper_name="extra";
int count=0;
String getpaper=String.format("select * from paper_info where paper_id=%s",paper_id);

table.append("<table class='gridtable'><tr><th>id</th><th>类型</th><th>题目</th><th>分值</th><th>答案</th></tr>");

ResultSet rs_paper=stmt.executeQuery(getpaper);
while(rs_paper.next()){
	Statement stmt1=con.createStatement();
	String sql1="";
	ResultSet rs1=null;
	if(rs_paper.getString("ques_type").equals("sub")){
		sql1=String.format("select * from subjective_question_info where sub_id='%s'",rs_paper.getString("ques_id"));
		rs1=stmt1.executeQuery(sql1);
		if(rs1!=null) rs1.next();
		table.append(String.format("<tr><td><input type='hidden' name='id"+String.valueOf(count)+"' value='%s'/>%s</td>"
				,rs_paper.getString("ques_id"),rs_paper.getString("ques_id")));
		table.append(String.format("<td><input type='hidden' name='type"+String.valueOf(count)+"' value='%s'/>%s</td>"
				,rs_paper.getString("ques_type"),"主观题"));
		table.append(String.format("<td>%s</td>"
				,rs1.getString("sub_ques_describe")));
		table.append(String.format("<td><input type='hidden' name='score"+String.valueOf(count)+"' value='%s'/>%s</td>"
				,rs_paper.getString("ques_score"),rs_paper.getString("ques_score")));
		//table.append("<td><input type='text' /></td></tr>");
		table.append("<td><textarea class='answer 'name='answer"+String.valueOf(count)+"'></textarea></td></tr>");
		//table.append("<td><input type='button' value='预览' onclick='preview(this)'></td></tr>");
		count+=1;
	}
	else if(rs_paper.getString("ques_type").equals("fill")){
		sql1=String.format("select * from objective_question_info_fill where obj_question_id='%s'",rs_paper.getString("ques_id"));
		rs1=stmt1.executeQuery(sql1);
		if(rs1!=null) rs1.next();
		table.append(String.format("<tr><td><input type='hidden' name='id"+String.valueOf(count)+"' value='%s'/>%s</td>"
				,rs_paper.getString("ques_id"),rs_paper.getString("ques_id")));
		table.append(String.format("<td><input type='hidden' name='type"+String.valueOf(count)+"' value='%s'/>%s</td>"
				,rs_paper.getString("ques_type"),"填空题"));
		table.append(String.format("<td>%s</td>"
				,rs1.getString("obj_question_describe")));
		table.append(String.format("<td><input type='hidden' name='score"+String.valueOf(count)+"' value='%s'/>%s</td>"
				,rs_paper.getString("ques_score"),rs_paper.getString("ques_score")));
		table.append("<td><input type='text' name='answer"+String.valueOf(count)+"'/></td></tr>");
		count+=1;
	}
	else if(rs_paper.getString("ques_type").equals("cho")){
		sql1=String.format("select * from objective_question_info_choice where obj_question_id='%s'",rs_paper.getString("ques_id"));
		rs1=stmt1.executeQuery(sql1);
		if(rs1!=null) rs1.next();
		String choice=rs1.getString("obj_question_choice");
		String[] lines=choice.replaceAll("<p>","").replaceAll("</p>","").split("/");
		String cho_fmt=String.format("A:'%s' B:'%s' C:'%s' D:'%s' ", lines[0],lines[1],lines[2],lines[3]);
		table.append(String.format("<tr><td><input type='hidden' name='id"+String.valueOf(count)+"' value='%s'/>%s</td>"
				,rs_paper.getString("ques_id"),rs_paper.getString("ques_id")));
		table.append(String.format("<td><input type='hidden' name='type"+String.valueOf(count)+"' value='%s'/>%s</td>"
				,rs_paper.getString("ques_type"),"选择题"));
		table.append(String.format("<td>%s<br>%s</td>"
				,rs1.getString("obj_question_describe"),cho_fmt));
		table.append(String.format("<td><input type='hidden' name='score"+String.valueOf(count)+"' value='%s'/>%s</td>"
				,rs_paper.getString("ques_score"),rs_paper.getString("ques_score")));
		table.append("<td><input type='text' name='answer"+String.valueOf(count)+"'/></td></tr>");
		count+=1;
	}
	
}
table.append("</table>");


if(request.getParameter("finish")!=null){
	try{
		int cnt=Integer.parseInt(request.getParameter("count"));
		String id=request.getParameter("paper_id");
		String stu_id=session.getAttribute("username").toString();
		for(int i=0;i<cnt;i++){
			System.out.print(i);
			//out.print(paper_name);
			
			String sql_insert=String.format("insert into paper_answer_info(paper_id,stu_id,ques_type,ques_id,answer,max_score) values('%s',%s,'%s',%s,'%s',%s)",
					id,stu_id,request.getParameter("type"+String.valueOf(i)),request.getParameter("id"+String.valueOf(i)),
					request.getParameter("answer"+String.valueOf(i)).replace("\\","\\\\"),request.getParameter("score"+String.valueOf(i)));
			Statement stmt1=con.createStatement();
			stmt1.executeUpdate(sql_insert);
		}
		out.print("<script>alert('提交成功！'); window.location='void.jsp' </script>");
	}
	catch(Exception e){
		System.out.println(e.getMessage());
		out.print("<script>alert('已经做过了！'); window.location='void.jsp' </script>");
	}
}

%>
<!DOCTYPE html>
<html>
<head>
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
<!-- 引用jquery -->
<script src="http://libs.baidu.com/jquery/2.1.4/jquery.min.js"></script>
<!-- 引入 etpl -->


<meta charset="ISO-8859-1">
<title>Insert title here</title>
</head>
<body><br><br>
<div style=" margin:0px auto;text-align:center;">试卷名：<%=paper_name %><br> 备注：<%=paper_comment %></div><br><br><br><br>
<form method="post" action="paper_answer.jsp" style="text-align:center">
<input type='hidden' name='paper_name' value=<%=paper_name %>>
<input type='hidden' name='paper_id' value=<%=paper_id %>>
<input type='hidden' name='count' value=<%=count %>>
<%=table %><br><br><br><br>
<input type='submit' name='finish' value="提交答案"/>

</form>
</body>
</html>