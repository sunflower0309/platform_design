<%@ page language="java" import="java.util.*,java.sql.*" 
         contentType="text/html; charset=utf-8"
%>
<% request.setCharacterEncoding("utf-8");
//out.print("here");
String msg = "";
String connectString = "jdbc:mysql://localhost:3306/math_platform"
		+ "?autoReconnect=true&useUnicode=true&serverTimezone=UTC"
		+ "&characterEncoding=UTF-8"; 
String user="root"; String pwd="123";


if(request.getMethod().equalsIgnoreCase("post")){
	String username = request.getParameter("username");
	String password = request.getParameter("password");
Class.forName("com.mysql.cj.jdbc.Driver");
Connection con = DriverManager.getConnection(connectString,user,pwd);
Statement stmt = con.createStatement();
String fmt="select password from user_info where username='%s'";
String str=String.format(fmt,username);
ResultSet rs=null;
rs=stmt.executeQuery(str);
if(rs.next()==false){
	msg="用户名不存在！";
}

else if(rs.getString("password").equals(password)){
	
	
	session.setAttribute("username",username);
    msg="登录成功";
    response.sendRedirect("mainpage.jsp");
    con.close();
}

else msg="用户名与密码不匹配，请重新输入";
}
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<title>登陆</title>
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
</head>
<body>
<div id="login">
<form action="Login.jsp"method="post"name="f">
<p>用户名  <input id="username"name="username"type="text"></P>
<p>密码 &nbsp;<input id="password"type="password"name="password"></p>

<input type="submit"name="sub"value="登陆" class="b">
<input type="button" value="注册"  class="b" onclick="window.location.href='register.jsp'">
</form><br><br>

<br><br>
<%=msg %>
</div>
</body>
</html>