<%@ page language="java" import="java.util.*,java.sql.*,java.net.*" 
         contentType="text/html; charset=utf-8" 
%>

<%! int pageSize=8;
	int pageCount;
	int showPage;
	
%>
<%
//request.setCharacterEncoding("UTF-8");
String connectString = "jdbc:mysql://localhost:3306/math_platform"
		+ "?autoReconnect=true&useUnicode=true&serverTimezone=UTC"
		+ "&characterEncoding=UTF-8"; 
String user="root"; String pwd="123";
String stu_id_se=session.getAttribute("username").toString();
if(stu_id_se.equals("")||stu_id_se==null){
	out.print("<script>alert('请先登录！');window.location='Login.jsp';</script>");
	//response.sendRedirect("Login.jsp");
}
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
String point=new String(request.getParameter("knowledge_point").getBytes("ISO-8859-1"),"utf-8");
String type=new String(request.getParameter("type").getBytes("ISO-8859-1"),"utf-8");
String key=new String(request.getParameter("search_ques").getBytes("ISO-8859-1"),"utf-8");
System.out.print("list的"+point);
point = URLDecoder.decode(point,"GBK");
StringBuilder table=new StringBuilder("");
String sql_empty="";
table.append("<table><tr><th>id</th><th>题目</th><th>查看</th></tr>");
if(type.equals("sub")){
	if(key.isEmpty()||key==null){
		key="";
		sql_empty=String.format("select * from subjective_question_info where sub_ques_know_point='%s'",point);
	}
	else{
		sql_empty=String.format("select * from subjective_question_info where sub_ques_know_point='%s' and sub_ques_describe like '%%%s%%'",point,key);
	}

}
else if(type.equals("cho")){
	if(key.isEmpty()||key==null){
		key="";
		sql_empty=String.format("select * from objective_question_info_choice where obj_question_point='%s'",point);
	}
	else{
		sql_empty=String.format("select * from objective_question_info_choice where obj_question_point='%s' and obj_question_describe like '%%%s%%'",point,key);
	}
}
else if(type.equals("fill")){
	if(key.isEmpty()||key==null){
		key="";
		sql_empty=String.format("select * from objective_question_info_fill where obj_question_point='%s'",point);
	}
	else{
		sql_empty=String.format("select * from objective_question_info_fill where obj_question_point='%s' and obj_question_describe like '%%%s%%'",point,key);
	}
}
Statement stmt=con_kn.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE,ResultSet.CONCUR_READ_ONLY);
System.out.println(sql_empty);
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
if(type.equals("sub")){
	if(showPage<pageCount){
		for(int i=0;i<pageSize;i++){
			
			String des=rs1.getString("sub_ques_describe");
			String id=rs1.getString("sub_id").toString();
			des=des.replace("\\\\","\\");
			table.append("<tr><td><input type='hidden' value='"+id+"' class='sub_id'>"+id+"</td><td>"+des+
					"</td><td><a href='show_ques.jsp?ptype=sub&pid="+id+"'target='_blank'>查看</a></td></tr>");
			rs1.next();
		}
	}
	else if(showPage==pageCount){
		int last=recordCount-position+1;
		
		for(int i=0;i<last;i++){
			System.out.println("循环次数："+i);
			String des=rs1.getString("sub_ques_describe");
			String id=rs1.getString("sub_id").toString();
			des=des.replace("\\\\","\\");
			table.append("<tr><td><input type='hidden' value='"+id+"' class='sub_id'>"+id+"</td><td>"+des+
					"</td><td><a href='show_ques.jsp?ptype=sub&pid="+id+"' target='_blank'>查看</a></td></tr>");
			rs1.next();
		}
	}

}
else if(type.equals("cho")){
	if(showPage<pageCount){
		for(int i=0;i<pageSize;i++){
			String des=rs1.getString("obj_question_describe");
			String id=rs1.getString("obj_question_id").toString();
			des=des.replace("\\\\","\\");
			table.append("<tr><td><input type='hidden' value='"+id+"' class='cho_id'>"+id+"</td><td>"+des+
					"</td><td><a href='show_ques.jsp?ptype=cho&pid="+id+"'target='_blank'>查看</a></td></tr>");
			rs1.next();
		}
	}
	else if(showPage==pageCount){
		int last=recordCount-position+1;
		
		for(int i=0;i<last;i++){
			String des=rs1.getString("obj_question_describe");
			String id=rs1.getString("obj_question_id").toString();
			des=des.replace("\\\\","\\");
			table.append("<tr><td><input type='hidden' value='"+id+"' class='cho_id'>"+id+"</td><td>"+des+
					"</td><td><a href='show_ques.jsp?ptype=cho&pid="+id+"'target='_blank'>查看</a></td></tr>");
			rs1.next();
		}
	}
}
else if(type.equals("fill")){
	if(showPage<pageCount){
		for(int i=0;i<pageSize;i++){
			String des=rs1.getString("obj_question_describe");
			String id=rs1.getString("obj_question_id").toString();
			des=des.replace("\\\\","\\");
			table.append("<tr><td><input type='hidden' value='"+id+"' class='fill_id'>"+id+"</td><td>"+des+
					"</td><td><a href='show_ques.jsp?ptype=fill&pid="+id+"'target='_blank'>查看</a></td></tr>");
			rs1.next();
		}
	}
	else if(showPage==pageCount){
		int last=recordCount-position+1;
		
		for(int i=0;i<last;i++){
			String des=rs1.getString("obj_question_describe");
			String id=rs1.getString("obj_question_id").toString();
			des=des.replace("\\\\","\\");
			table.append("<tr><td><input type='hidden' value='"+id+"' class='fill_id'>"+id+"</td><td>"+des+
					"</td><td><a href='show_ques.jsp?ptype=fill&pid="+id+"'target='_blank'>查看</a></td></tr>");
			rs1.next();
		}
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
<meta charset="ISO-8859-1">
<title>Insert title here</title>
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

<script>

function delete_sub(obj){
	var sub_id=$(obj).parents("tr").find(".sub_id").val();
	console.log(sub_id);
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
	
	xmlhttp.open("GET","/try/delete_ques.jsp?id="+sub_id+"&type=sub",true);
	xmlhttp.send();
}
function delete_cho(obj){
	var cho_id=$(obj).parents("tr").find(".cho_id").val();
	console.log(cho_id);
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
	
	xmlhttp.open("GET","/try/delete_ques.jsp?id="+cho_id+"&type=cho",true);
	xmlhttp.send();
}
function delete_fill(obj){
	var fill_id=$(obj).parents("tr").find(".fill_id").val();
	console.log(fill_id);
	var tr = obj.parentNode.parentNode;
    tr.parentNode.removeChild(tr);
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
				console.log(xmlhttp.responseText);
				alert("出现错误，请重试");
			}
		}
	}
	
	xmlhttp.open("GET","/try/delete_ques.jsp?id="+fill_id+"&type=fill",true);
	xmlhttp.send();
}
</script>
</head>
<body>
<br><input type='button' name='main' onclick="window.location.href='mainpage.jsp'" value="返回主页">
<%=table %>
<br>
	第<%=showPage %>页（共<%=pageCount %>页）
	<br>
	<a href="ques_list.jsp?showPage=1&type=<%=type%>&search_ques=<%=key%>&knowledge_point=<%=point%>">首页</a>
	<a href="ques_list.jsp?showPage=<%=showPage-1%>&type=<%=type%>&search_ques=<%=key%>&knowledge_point=<%=point%>">上一页</a>
<%	//根据pageCount的值显示每一页的数字并附加上相应的超链接
		for(int i=1;i<=pageCount;i++){
	%>
			<a href="ques_list.jsp?showPage=<%=i%>&type=<%=type%>&search_ques=<%=key%>&knowledge_point=<%=point%>"><%=i%></a>
<%	}
	%>	
	<a href="ques_list.jsp?showPage=<%=showPage+1%>&type=<%=type%>&search_ques=<%=key%>&knowledge_point=<%=point%>">下一页</a>
	<a href="ques_list.jsp?showPage=<%=pageCount%>&type=<%=type%>&search_ques=<%=key%>&knowledge_point=<%=point%>">末页</a>
	<!-- 通过表单提交用户想要显示的页数 -->
	<!-- <form action="" method="get">
		跳转到第<input type="text" name="showPage" size="5">页
		<input type="submit" name="submit" value="跳转">
	</form>	 -->
</body>
</html>