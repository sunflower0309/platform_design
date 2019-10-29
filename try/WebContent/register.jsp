<%@ page language="java" import="java.util.*,java.sql.*" 
         contentType="text/html; charset=utf-8"
%>
<% request.setCharacterEncoding("utf-8");

String msg = "";
String connectString = "jdbc:mysql://localhost:3306/math_platform"
		+ "?autoReconnect=true&useUnicode=true&serverTimezone=UTC"
		+ "&characterEncoding=UTF-8"; 
String user="root"; String pwd="123";
String username = request.getParameter("username");
String password = request.getParameter("password");
if(request.getParameter("sub")!=null){
	if(request.getParameter("password").equals(request.getParameter("password_confirm"))){
		try{
			String sql1=String.format("insert into user_info(username,password) values('%s','%s') ",
					request.getParameter("username"),request.getParameter("password"));
			Connection con = DriverManager.getConnection(connectString,user,pwd);
			Statement stmt = con.createStatement();
			stmt.executeUpdate(sql1);
			out.print("<script>alert('注册成功'); window.location='Login.jsp' </script>");
		}
		catch(Exception e){
			out.print("<script>alert('用户名已存在'); </script>");
			System.out.print(e.getMessage());
		}
	}
	
	else{
		out.print("<script>alert('密码不匹配，请重新输入'); </script>");
		
	}
}
%>
<!DOCTYPE html>
<html>
<head>
<script src="http://libs.baidu.com/jquery/2.1.4/jquery.min.js"></script>
<script type="text/javascript">
function check(){
	var str1=document.getElementById("password").value;
	var str2=document.getElementById("password_confirm").value;
	var xmlhttp;
	if(str1==""||str2==""){
		document.getElementById("check").innerHTML="";
		return;
	}
	if(window.XMLHttpRequest){
		xmlhttp=new XMLHttpRequest();// IE7+, Firefox, Chrome, Opera, Safari 浏览器执行代码
	}
	else{
		xmlhttp=new ActiveXObject("Microsoft.XMLHTTP");// IE6, IE5 浏览器执行代码
	}
	xmlhttp.onreadystatechange=function(){
		if(xmlhttp.readyState==4&&xmlhttp.status==200){
			
			if(xmlhttp.responseText=="ok"){
				document.getElementById("check_result").innerHTML=xmlhttp.responseText;
				document.getElementById("diff").value="ok";
			}
			else{
				document.getElementById("check_result").innerHTML=xmlhttp.responseText;
				document.getElementById("diff").value="no";
			}
			
		}
	}
	
	xmlhttp.open("GET","/try/pass_check.jsp?q1="+str1+"&q2="+str2,true);
	xmlhttp.send();
}
</script>
<style>
	
	div {	font-family:宋体;
			margin:200px auto;
			text-align:center;
			padding-top:50px;
			border-radius:20px;
			width:300px;
			height:200px;
			
	}
	
	
	
</style>	
<meta charset="ISO-8859-1">
<title>注册</title>
</head>
<body>
<div id="register">
<form action="register.jsp"method="post"name="f">
用户名:&nbsp;&nbsp;<input id="username"name="username"type="text"><br><br>
密码:   &nbsp; &nbsp;<input id="password"type="password"name="password"><br><br>
确认密码:&nbsp;<input id="password_confirm"type="password"name="password_confirm" onblur='check()'><br><br>
<p id='check_result'></p>
<input type="hidden" name='diff' id='diff' value="no">
<input type="hidden" name='obj_score_1' id='obj_score_1' value=0>
<input type="submit"name="sub"value="注册" class="b">
<input type='button' name='login' onclick="window.location.href='Login.jsp'" value="返回登陆">
<!-- <input type="button" value="注册"  class="b"> -->
</form><br><br>

<br><br>
<%=msg %>
</div>
</body>
</html>