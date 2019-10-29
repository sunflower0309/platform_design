<%@ page language="java" import="java.util.*,java.sql.*,com.platform.*" 
         contentType="text/html; charset=utf-8" pageEncoding="utf-8"
%>
<%
String stu_id_se=session.getAttribute("username").toString();
if(stu_id_se.equals("")||stu_id_se==null){
	out.print("<script>alert('请先登录！');window.location='Login.jsp';</script>");
	//response.sendRedirect("Login.jsp");
}
request.setCharacterEncoding("utf-8");
String connectString = "jdbc:mysql://localhost:3306/math_platform"
		+ "?autoReconnect=true&useUnicode=true&serverTimezone=UTC"
		+ "&characterEncoding=UTF-8"; 
String user="root"; String pwd="123";

String query_point_num="select knowledge_name from knowledge_point";
Class.forName("com.mysql.cj.jdbc.Driver");
Connection con_kn=DriverManager.getConnection(connectString,user,pwd);
Statement stmt_kn=con_kn.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE,ResultSet.CONCUR_READ_ONLY);
String fmt="select * from knowledge_point";
ResultSet rs=stmt_kn.executeQuery(fmt);
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
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<title>主页</title>
<script>
　　function addsub(){
　　　　document.getElementById("iframe1").src='add_question_sub.jsp';
　　}
	function addcho(){    
　　　　document.getElementById("iframe1").src='add_question_obj_choice.jsp';
　　}
	function addfill(){    
	　　　　document.getElementById("iframe1").src='add_question_obj_fill.jsp';
	　　}
	function addpaper(){    
	　　　　document.getElementById("iframe1").src='start_add_paper.jsp';
	　　}
	function addpaperauto(){    
	　　　　document.getElementById("iframe1").src='add_paper.jsp';
	　　}
	function correctpaper(){    
	　　　　document.getElementById("iframe1").src='paper_correct_index.jsp';
	　　}
	function favo(){    
	　　　　document.getElementById("iframe1").src='favorite.jsp';
	　　}
	function pointmanage(){    
	　　　　document.getElementById("iframe1").src='knowledge_point_manage.jsp';
	　　}
</script>
<script src="js/adapter.js"></script> <!--rem适配js-->
	
 <link rel="stylesheet" href="css/base.css"> <!--初始化文件-->
<link rel="stylesheet" href="css/menu.css"> <!--主样式-->
</head>
<body>
<p style="float:right;">您好，<%=stu_id_se %>！<input type='button' name='logout' onclick="window.location.href='logout.jsp'" value="注销" style="border:1px solid #000000;"></p>

<br><br><br>




<div id="menu" style="float:left;display:inline-block;" >
   

    <!--显示菜单-->
    <div id="open">
        <div class="navH">
            功能菜单
            
        </div>
        <div class="navBox">
            <ul>
                <li>
                    <h2 class="obtain">题库管理<i></i></h2>
                    <div class="secondary">
                        <h3>
<form action="ques_list_manage.jsp" method="post" target="iframe1">
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
</select><br>
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
<select name='type'>
<option value='sub' selected='selected'>主观题</option>
<option value='cho' >选择题</option>
<option value='fill' >填空题</option>
</select><br>
输入关键字：<input type='text' id='search_ques' name='search_ques' value=""/>
<input type="submit" name="ques_list" value="搜索" style="border:1px solid #000000;"> <br>
请不要选择两个相同的知识点，否则会引起搜索错误！
</form></h3>
                        
                    </div>
                </li>
                <li>
                    <h2 class="obtain">试卷管理<i></i></h2>
                    <div class="secondary">
                        <h3><form action="paper_list.jsp" method="post" target="iframe1">

输入关键字：<input type='text' id='search_paper' name='search_paper' value=""/>
<input type="submit" name="paper_list" value="搜索" style="border:1px solid #000000;"> 
</form></h3>
                        
                    </div>
                </li>
                <li>
                    <h2 class="obtain">添加题目<i></i></h2>
                    <div class="secondary">
                        <h3 ><input type='button' name='add_sub'  value="添加主观题" onclick="addsub()" style="width:100%;"></h3>
                        <h3><input type='button' name='add_cho' onclick="addcho()" value="添加选择题" style="width:100%;"></h3>
                        <h3><input type='button' name='add_fill' onclick="addfill()" value="添加填空题"style="width:100%;"></h3>
                        
                    </div>
                </li>
                <li>
                    <h2 class="obtain">生成试卷<i></i></h2>
                    <div class="secondary">
                        <h3><input type='button' name='add_paper_hand' onclick="addpaper()" value="手动组卷"style="width:100%;"></h3>
                        <h3><input type='button' name='add_paper_auto' onclick="addpaperauto()" value="自动组卷"style="width:100%;"></h3>
                        
                    </div>
                </li>
                <li>
                    <h2 class="obtain">批改试卷<i></i></h2>
                    <div class="secondary">
                        <h3><input type='button' name='paper_correct' onclick="correctpaper()" value="批卷"style="width:100%;"></h3>
                        
                    </div>
                </li>
                <li>
                    <h2 class="obtain">管理知识点<i></i></h2>
                    <div class="secondary">
                        <h3><input type='button' name='point_manage' onclick="pointmanage()" value="知识点管理"style="width:100%;"></h3>
                        
                    </div>
                </li>
            </ul>
        </div>
    </div>
</div>

<script src="js/menu.js"></script> <!--控制js-->

<iframe name= "iframe1" id="iframe1" width=1300 height=815 src= "void.jsp " scrolling= "auto " frameborder= "0 " 
style="float:right;border-style: solid;border-width: 5px;margin-right:100px;display:inline-block;"> </iframe> 















<%-- <div>
<div style="text-align:left">
题库管理：
<form action="ques_list_manage.jsp" method="post" target="iframe1">
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
<select name='type'>
<option value='sub' selected='selected'>主观题</option>
<option value='cho' >选择题</option>
<option value='fill' >填空题</option>
</select>
输入关键字：<input type='text' id='search_ques' name='search_ques' value=""/>
<input type="submit" name="ques_list" value="搜索" > <br>
请不要选择两个相同的知识点，否则会引起搜索错误！
</form>
</div>

<br><br>

<p style="text-align:left">收藏夹：<br><input type="button" name="favorite" value="收藏夹" onclick="favo()" ><br><br></p>
<div style="text-align:left">
试卷管理：
<form action="paper_list.jsp" method="post" target="iframe1">

输入关键字：<input type='text' id='search_paper' name='search_paper' value=""/>
<input type="submit" name="paper_list" value="搜索" > 
</form>
</div>
<br>
<%if(stu_id_se.equals("admin")){ %>
<div style="text-align:left">


添加题目：
<br><input type='button' name='add_sub' onclick="addsub()" value="添加主观题">&nbsp;&nbsp;

<input type='button' name='add_cho' onclick="addcho()" value="添加选择题">&nbsp;&nbsp;

<input type='button' name='add_fill' onclick="addfill()" value="添加填空题">
</div>
<iframe name= "iframe1" id="iframe1" width=1000 height=615 src= "void.jsp " scrolling= "auto " frameborder= "0 " 
style="float:right;margin-top:-300px;border-style: solid;border-width: 5px;margin-right:100px"> </iframe> 
<br>
<div style="text-align:left">
组卷：
<br><input type='button' name='add_paper_hand' onclick="addpaper()" value="手动组卷">&nbsp;&nbsp;

<input type='button' name='add_paper_auto' onclick="addpaperauto()" value="自动组卷">
</div><br>
<div style="text-align:left">
批卷：
<br><input type='button' name='paper_correct' onclick="correctpaper()" value="批卷">
</div><br>
<div style="text-align:left">
知识点管理：
<br><input type='button' name='point_manage' onclick="pointmanage()" value="知识点管理">
</div><br>

<%} %>
</div> --%>
<br>
</body>
</html>