<%@ page language="java" import="java.util.*,java.sql.*,com.platform.*" 
         contentType="text/html; charset=utf-8"
%>
<%!String describe=""; 
String choice = "";
String answer=""; String type="";String id="";%>
<%
String connectString = "jdbc:mysql://localhost:3306/math_platform"
		+ "?autoReconnect=true&useUnicode=true&serverTimezone=UTC"
		+ "&characterEncoding=UTF-8"; 
String user="root"; String pwd="123";
String query_point_num="select knowledge_name from knowledge_point";
Class.forName("com.mysql.cj.jdbc.Driver");
Connection con_kn=DriverManager.getConnection(connectString,user,pwd);
Statement stmt_kn=con_kn.createStatement();
String stu_id=session.getAttribute("username").toString();
if(stu_id.equals("")||stu_id==null){
	out.print("<script>alert('请先登录！');window.location='Login.jsp';</script>");
	//response.sendRedirect("Login.jsp");
}
type=request.getParameter("type");

id=request.getParameter("id");
String[] lines=new String[4];
String fmt1="select * from knowledge_point";
ResultSet rs1=stmt_kn.executeQuery(fmt1);
List<point> pointlist=new ArrayList<point>();
List<point> finallist=new ArrayList<point>();
List<point> finallist1=new ArrayList<point>();
List<String> del=new ArrayList<String>();
List<String> del1=new ArrayList<String>();
String opt="";
while(rs1.next()){
	point x=new point(rs1.getInt(4),rs1.getInt(1),rs1.getInt(3),rs1.getString(2));
	pointlist.add(x);
}
/* for(int i=0;i<pointlist.size();i++){
	out.println(pointlist.get(i).getname());
} */
StringBuilder sbuild=new StringBuilder("");
point b=new point();
finallist1=b.rebuild(0,pointlist,pointlist,finallist);
if(type.equals("sub")){
	String sql=String.format("select * from subjective_question_info where sub_id=%s",id);
	Statement stmt=con_kn.createStatement();
	ResultSet rs=stmt.executeQuery(sql);
	while(rs.next()){
		out.print(String.format("<input type='hidden' id='id' value='%s'>",id));
		out.print(String.format("<input type='hidden' id='type' value='%s'>",type));
		describe=rs.getString("sub_ques_describe").replaceAll("&nbsp;", "");
		answer=rs.getString("sub_ques_answer").replaceAll("&nbsp;", "");
	}
}
else if(type.equals("cho")){
	String sql=String.format("select * from objective_question_info_choice where obj_question_id=%s",id);
	Statement stmt=con_kn.createStatement();
	ResultSet rs=stmt.executeQuery(sql);
	while(rs.next()){
		
		out.print(String.format("<input type='hidden' id='id' value='%s'>",id));
		out.print(String.format("<input type='hidden' id='type' value='%s'>",type));
		describe=rs.getString("obj_question_describe");
		choice=rs.getString("obj_question_choice");
		lines=choice.replaceAll("<p>","").replaceAll("</p>","").split("/");
		answer=rs.getString("obj_question_answer");
	}
}
else if(type.equals("fill")){
	String sql=String.format("select * from objective_question_info_fill where obj_question_id=%s",id);
	Statement stmt=con_kn.createStatement();
	ResultSet rs=stmt.executeQuery(sql);
	while(rs.next()){
		
		out.print(String.format("<input type='hidden' id='id' value='%s'>",id));
		out.print(String.format("<input type='hidden' id='type' value='%s'>",type));
		describe=rs.getString("obj_question_describe");
		answer=rs.getString("obj_question_answer");
	}
}
if(request.getParameter("preview2")!=null) {//预览问题描述
	if(request.getParameter("type").equals("cho")){
		try{
			describe=new String(request.getParameter("describe").getBytes("ISO-8859-1"),"utf-8");
			choice=new String(request.getParameter("choice").getBytes("ISO-8859-1"),"utf-8");
			answer=new String(request.getParameter("answer").getBytes("ISO-8859-1"),"utf-8");
			lines=choice.replaceAll("<p>","").replaceAll("</p>","").split("/");
		}
		catch (Exception e){
			e.getMessage();
		}
	}
	else{
		try{
			describe=new String(request.getParameter("describe").getBytes("ISO-8859-1"),"utf-8");
			
			answer=new String(request.getParameter("answer").getBytes("ISO-8859-1"),"utf-8");
		}
		catch (Exception e){
			e.getMessage();
		}
	}
}

if(request.getParameter("save2")!=null) {//保存描述
	if(request.getParameter("type").equals("cho")){
		try{
			describe=new String(request.getParameter("describe").getBytes("ISO-8859-1"),"utf-8").replace("\\","\\\\");
			choice=new String(request.getParameter("choice").getBytes("ISO-8859-1"),"utf-8").replace("\\","\\\\");
			answer=new String(request.getParameter("answer").getBytes("ISO-8859-1"),"utf-8").replace("\\","\\\\");
			String fmt="update objective_question_info_choice set obj_question_describe='%s',obj_question_choice='%s',obj_question_answer='%s' where obj_question_id=%s";
			String sql=String.format(fmt,describe,choice,answer,id);
			
			Class.forName("com.mysql.cj.jdbc.Driver");
			Connection con=DriverManager.getConnection(connectString,user,pwd);
			Statement stmt=con.createStatement();
			int cnt=stmt.executeUpdate(sql);
			describe="";
			choice="";
			answer="";
			type="";
			id="";
			out.print("<script>alert('修改成功！'); window.close(); </script>");
			
		}
		catch (Exception e){
			String err=e.getMessage();
			describe="";
			choice="";
			answer="";
			type="";
			id="";
			out.print("alert('插入失败，请重新尝试')");
		}
	}
	else if(request.getParameter("type").equals("sub")){
		try{
			describe=new String(request.getParameter("describe").getBytes("ISO-8859-1"),"utf-8").replace("\\","\\\\");
			//choice=new String(request.getParameter("choice").getBytes("ISO-8859-1"),"utf-8");
			answer=new String(request.getParameter("answer").getBytes("ISO-8859-1"),"utf-8").replace("\\","\\\\");
			String fmt="update subjective_question_info set sub_ques_describe='%s',sub_ques_answer='%s' where sub_id=%s";
			String sql=String.format(fmt,describe,answer,id);
			
			Class.forName("com.mysql.cj.jdbc.Driver");
			Connection con=DriverManager.getConnection(connectString,user,pwd);
			Statement stmt=con.createStatement();
			int cnt=stmt.executeUpdate(sql);
			describe="";
			choice="";
			answer="";
			type="";
			id="";
			out.print("<script>alert('修改成功！'); window.close(); </script>");
			
		}
		catch (Exception e){
			String err=e.getMessage();
			describe="";
			choice="";
			answer="";
			type="";
			id="";
			out.print("alert('插入失败，请重新尝试')");
		}
	}
	else if(request.getParameter("type").equals("fill")){
		try{
			describe=new String(request.getParameter("describe").getBytes("ISO-8859-1"),"utf-8").replace("\\","\\\\");
			//choice=new String(request.getParameter("choice").getBytes("ISO-8859-1"),"utf-8");
			answer=new String(request.getParameter("answer").getBytes("ISO-8859-1"),"utf-8").replace("\\","\\\\");
			String fmt="update objective_question_info_fill set obj_question_describe='%s',obj_question_answer='%s' where obj_question_id=%s";
			String sql=String.format(fmt,describe,answer,id);
			
			Class.forName("com.mysql.cj.jdbc.Driver");
			Connection con=DriverManager.getConnection(connectString,user,pwd);
			Statement stmt=con.createStatement();
			int cnt=stmt.executeUpdate(sql);
			describe="";
			choice="";
			answer="";
			type="";
			id="";
			out.print("<script>alert('修改成功！'); window.close(); </script>");
			
		}
		catch (Exception e){
			String err=e.getMessage();
			describe="";
			choice="";
			answer="";
			type="";
			id="";
			out.print(e.getMessage());
		}
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
        skipTags: ['script', 'noscript', 'style', 'textarea', 'pre','code','a','form'],
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
<!-- 样式文件 -->
<link rel="stylesheet" href="./umeditor/themes/default/css/umeditor.css">
<!-- 引用jquery -->
<script src="http://libs.baidu.com/jquery/2.1.4/jquery.min.js"></script>
<!-- 引入 etpl -->
<script src="http://s1.bdstatic.com/r/www/cache/ecom/etpl/3-2-0/etpl.js"></script>
<!-- 配置文件 -->
<script type="text/javascript" src="./umeditor/umeditor.config.js"></script>
<!-- 编辑器源码文件 -->
<script type="text/javascript" src="./umeditor/umeditor.js"></script>
<!-- 语言包文件 -->
<script type="text/javascript" src="./umeditor/lang/zh-cn/zh-cn.js"></script>
<!-- 实例化编辑器代码 -->
<script type="text/javascript">//对应的容器1号
    $(function(){
        window.um = UM.getEditor('container', {
        	/* 传入配置参数,可配参数列表看umeditor.config.js */
            toolbar: ['undo redo | bold italic underline | emotion image']
        });
    });
</script>
<script type="text/javascript">//对应的容器2号
    $(function(){
        window.um = UM.getEditor('container2', {
        	/* 传入配置参数,可配参数列表看umeditor.config.js */
            toolbar: ['undo redo | bold italic underline | emotion image']
        });
    });
</script>
<script type="text/javascript">//对应的容器2号
    $(function(){
        window.um = UM.getEditor('container3', {
        	/* 传入配置参数,可配参数列表看umeditor.config.js */
            toolbar: ['undo redo | bold italic underline | emotion image']
        });
    });
</script>
<title>Insert title here</title>
</head>
<body>
<form action="ques_edit.jsp?type=<%=type %>&id=<%=id%>" method="post">
输入题目描述：
<script id="container" name="describe" type="text/plain" style="width:600px;height:200px;">
<%=describe%>
</script>
<%if(type.equals("cho")){ %>
输入题目选项：
<script id="container2" name="choice" type="text/plain" style="width:600px;height:200px;">
<%=choice%>
</script>
<%} %>
输入题目答案：
<script id="container3" name="answer" type="text/plain" style="width:600px;height:200px;">
<%=answer%>
</script>
<input id="preview2" type="submit" value="预览" name="preview2">
<input id="save2" type="submit" value="保存" name="save2">
<input type='hidden' name='type' value=<%=type %>>
<input type='hidden' name='id' value=<%=id %>>
</form>
题目预览：<%=describe %>
<%if(type.equals("cho")){ %>
选项预览：A:<%=lines[0] %> B:<%=lines[1] %> C:<%=lines[2] %> D:<%=lines[3] %>
<%} %>
答案预览：<%=answer%>
</body>
</html>