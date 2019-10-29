<%@ page language="java" import="java.util.*,java.sql.*" 
         contentType="text/html; charset=utf-8" 
%>
<%! int pageSize=3;
	int pageCount;
	int showPage;
	
%>
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
//String stu_id=request.getParameter("stu_id");
String stu_id=session.getAttribute("username").toString();
String fmt=String.format("select * from favo_ques where stu_id=%s",stu_id);
StringBuilder table=new StringBuilder("");
//String sql_empty="";
Class.forName("com.mysql.cj.jdbc.Driver");
Connection con_kn=DriverManager.getConnection(connectString,user,pwd);
try{
	table.append("<table><tr><th>id</th><th>类型</th><th>题目</th><th>查看</th></tr>");


	Statement stmt=con_kn.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE,ResultSet.CONCUR_READ_ONLY);

	ResultSet rs1=stmt.executeQuery(fmt);
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
	ResultSet rs2=null;
	if(showPage<pageCount){
		for(int i=0;i<pageSize;i++){
			if(rs1.getString("type").equals("sub")){
				String fmt_sub=String.format("select * from subjective_question_info where sub_id=%s",rs1.getString("ques_id"));
				Statement stmt1=con_kn.createStatement();
				
				rs2=stmt1.executeQuery(fmt_sub);
				rs2.next();
				String des=rs2.getString("sub_ques_describe");
				des=des.replace("\\\\","\\");
				table.append("<tr><td>"+rs1.getString("ques_id").toString()+"</td><td>sub</td><td>"+des+
						"</td><td><a href='show_ques.jsp?ptype=sub&pid="+rs1.getString("ques_id").toString()+"'>查看</a></td></tr>");
				rs1.next();
			}
			else if(rs1.getString("type").equals("cho")){
				String fmt_obj=String.format("select * from objective_question_info_choice where obj_question_id=%s",rs1.getString("ques_id"));
				Statement stmt1=con_kn.createStatement();
				rs2=stmt1.executeQuery(fmt_obj);
				rs2.next();
				String des=rs2.getString("obj_question_describe");
				des=des.replace("\\\\","\\");
				table.append("<tr><td>"+rs1.getString("ques_id").toString()+"</td><td>cho</td><td>"+des+
						"</td><td><a href='show_ques.jsp?ptype=cho&pid="+rs1.getString("ques_id").toString()+"'>查看</a></td></tr>");
				rs1.next();
			}
			else if(rs1.getString("type").equals("fill")){
				String fmt_obj=String.format("select * from objective_question_info_fill where obj_question_id=%s",rs1.getString("ques_id"));
				Statement stmt1=con_kn.createStatement();
				rs2=stmt1.executeQuery(fmt_obj);
				rs2.next();
				String des=rs2.getString("obj_question_describe");
				des=des.replace("\\\\","\\");
				table.append("<tr><td>"+rs1.getString("ques_id").toString()+"</td><td>fill</td><td>"+des+
						"</td><td><a href='show_ques.jsp?ptype=fill&pid="+rs1.getString("ques_id").toString()+"'>查看</a></td></tr>");
				rs1.next();
			}
		}
	}
	else if(showPage==pageCount){
		int last=recordCount-position+1;
		for(int i=0;i<last;i++){
			if(rs1.getString("type").equals("sub")){
				String fmt_sub=String.format("select * from subjective_question_info where sub_id=%s",rs1.getString("ques_id"));
				Statement stmt1=con_kn.createStatement();
				rs2=stmt1.executeQuery(fmt_sub);
				rs2.next();
				String des=rs2.getString("sub_ques_describe");
				des=des.replace("\\\\","\\");
				table.append("<tr><td>"+rs1.getString("ques_id").toString()+"</td><td>sub</td><td>"+des+
						"</td><td><a href='show_ques.jsp?ptype=sub&pid="+rs1.getString("ques_id").toString()+"'target='_blank'>查看</a></td></tr>");
				rs1.next();
			}
			else if(rs1.getString("type").equals("cho")){
				String fmt_obj=String.format("select * from objective_question_info_choice where obj_question_id=%s",rs1.getString("ques_id"));
				Statement stmt1=con_kn.createStatement();
				rs2=stmt1.executeQuery(fmt_obj);
				rs2.next();
				String des=rs2.getString("obj_question_describe");
				des=des.replace("\\\\","\\");
				table.append("<tr><td>"+rs1.getString("ques_id").toString()+"</td><td>cho</td><td>"+des+
						"</td><td><a href='show_ques.jsp?ptype=cho&pid="+rs1.getString("ques_id").toString()+"'target='_blank'>查看</a></td></tr>");
				rs1.next();
			}
			else if(rs1.getString("type").equals("fill")){
				String fmt_obj=String.format("select * from objective_question_info_fill where obj_question_id=%s",rs1.getString("ques_id"));
				Statement stmt1=con_kn.createStatement();
				rs2=stmt1.executeQuery(fmt_obj);
				rs2.next();
				String des=rs2.getString("obj_question_describe");
				des=des.replace("\\\\","\\");
				table.append("<tr><td>"+rs1.getString("ques_id").toString()+"</td><td>fill</td><td>"+des+
						"</td><td><a href='show_ques.jsp?ptype=fill&pid="+rs1.getString("ques_id").toString()+"'target='_blank'>查看</a></td></tr>");
				rs1.next();
			}
		}
	}

	table.append("</table>");
}
catch(Exception e){
	e.getMessage();
}
%>
<!DOCTYPE html>
<html>
<head>
<script type="text/javascript"
  src="http://cdn.mathjax.org/mathjax/latest/MathJax.js?config=TeX-AMS-MML_HTMLorMML">
</script>
<meta charset="ISO-8859-1">
<title>Insert title here</title>
</head>
<body>
<br><input type='button' name='main' onclick="window.location.href='mainpage.jsp'" value="返回主页">
<%=table %>
<br>
	第<%=showPage %>页（共<%=pageCount %>页）
	<br>
	<a href="favorite.jsp?showPage=1&stu_id=<%=stu_id%>">首页</a>
	<a href="favorite.jsp?showPage=<%=showPage-1%>&stu_id=<%=stu_id%>">上一页</a>
<%	//根据pageCount的值显示每一页的数字并附加上相应的超链接
		for(int i=1;i<=pageCount;i++){
	%>
			<a href="favorite.jsp?showPage=<%=i%>&stu_id=<%=stu_id%>"><%=i%></a>
<%	}
	%>	
	<a href="favorite.jsp?showPage=<%=showPage+1%>&stu_id=<%=stu_id%>">下一页</a>
	<a href="favorite.jsp?showPage=<%=pageCount%>&stu_id=<%=stu_id%>">末页</a>
</body>
</html>