<%@ page language="java" import="java.util.*,java.sql.*,com.platform.*" 
         contentType="text/html; charset=utf-8"
%>

<%
String stu_id_se=session.getAttribute("username").toString();
if(stu_id_se.equals("")||stu_id_se==null){
	out.print("<script>alert('请先登录！');window.location='Login.jsp';</script>");
	//response.sendRedirect("Login.jsp");
}
String connectString = "jdbc:mysql://localhost:3306/math_platform"
		+ "?autoReconnect=true&useUnicode=true&serverTimezone=UTC"
		+ "&characterEncoding=UTF-8"; 
String user="root"; String pwd="123";

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

request.setCharacterEncoding("UTF-8");

int index_num=1;
if(request.getParameter("finish")!=null){//四个位置都不为空才可以添加数据
	
		String paper_name=request.getParameter("paper_name");
		String paper_comment=request.getParameter("paper_comment");
		String fmt_name="insert into paper_name(paper_name,paper_comment) values('%s','%s')";
		String sql_name=String.format(fmt_name,paper_name,paper_comment);
		Statement stmt_name=con_kn.createStatement();
		int name_insert=stmt_name.executeUpdate(sql_name);
		Statement stmt_name1=con_kn.createStatement();
		
		String getid="select paper_id from paper_name order by paper_id desc limit 1";
		ResultSet rs_last=stmt_name1.executeQuery(getid);
		
		rs_last.next();
		int paper_id=rs_last.getInt(1);
		while(request.getParameter("num"+String.valueOf(index_num))!=null&&request.getParameter("type"+String.valueOf(index_num))!=null
				&&request.getParameter("score"+String.valueOf(index_num))!=null){
			String point1=request.getParameter("point1"+String.valueOf(index_num));
			String point2=request.getParameter("point2"+String.valueOf(index_num));
			String diff=request.getParameter("diff"+String.valueOf(index_num));
			String num=request.getParameter("num"+String.valueOf(index_num));
			String sql_empty="";
			if(request.getParameter("type"+String.valueOf(index_num)).equalsIgnoreCase("sub")){
					
				if(point1.equals("0")&&point2.equals("0")){
					sql_empty=String.format("select distinct * from subjective_question_info where diff=%s order by rand() limit %s",diff,num);
				}
				else if(point1.equals("0")&&(!point2.equals("0"))){
					sql_empty=String.format("select distinct * from subjective_question_info where (sub_point1='%s' or sub_point2='%s') and diff=%s order by rand() limit %s",point2,point2,diff,num);
				}
				else if(point2.equals("0")&&(!point1.equals("0"))){
					sql_empty=String.format("select distinct * from subjective_question_info where (sub_point1='%s' or sub_point2='%s') and diff=%s order by rand() limit %s",point1,point1,diff,num);
				}
				else{
					sql_empty=String.format("select distinct * from subjective_question_info where sub_point1='%s' and sub_point2='%s' and diff=%s or sub_point2='%s' and sub_point1='%s' and diff=%s order by rand() limit %s",point1,point2,diff,point1,point2,diff,num);
				}
					/* String fmt="select distinct * from subjective_question_info where sub_ques_know_point='%s' order by rand() limit %s";
					String sql1=String.format(fmt,request.getParameter("knowledge_point"+String.valueOf(index_num)),
							request.getParameter("num"+String.valueOf(index_num)));
					 */
					System.out.println(sql_empty);
					Statement stmt1=con_kn.createStatement();
					ResultSet rs_add1=null;
					rs_add1=stmt1.executeQuery(sql_empty);
					int rowcount=0;
					
					while(rs_add1.next()){
						Statement stmt3=con_kn.createStatement();//每次都要创建新的stmt，stmt执行一次后rs就会关闭，只使用一个stmt会报错
						String fmt2="insert into paper_info(paper_name,ques_type,ques_id,ques_score,ques_answer,paper_id) values('%s','%s','%s',%d,'%s',%d)";
						String sql2=String.format(fmt2,paper_name,"sub",rs_add1.getString("sub_id"),
								Integer.parseInt(request.getParameter("score"+String.valueOf(index_num))),rs_add1.getString("sub_ques_answer"),paper_id);
						stmt3.executeUpdate(sql2);
						rowcount+=1;
					}
					System.out.println(rowcount);
					
				
			}
			else if(request.getParameter("type"+String.valueOf(index_num)).equalsIgnoreCase("cho")){
				if(point1.equals("0")&&point2.equals("0")){
					sql_empty=String.format("select distinct * from objective_question_info_choice where diff=%s order by rand() limit %s",diff,num);
				}
				else if(point1.equals("0")&&(!point2.equals("0"))){
					sql_empty=String.format("select distinct * from objective_question_info_choice where (obj_point1='%s' or obj_point2='%s') and diff=%s order by rand() limit %s",point2,point2,diff,num);
				}
				else if(point2.equals("0")&&(!point1.equals("0"))){
					sql_empty=String.format("select distinct * from objective_question_info_choice where (obj_point1='%s' or obj_point2='%s') and diff=%s order by rand() limit %s",point1,point1,diff,num);
				}
				else{
					sql_empty=String.format("select distinct * from objective_question_info_choice where obj_point1='%s' and obj_point2='%s' and diff=%s or obj_point2='%s' and obj_point1='%s' and diff=%s order by rand() limit %s",point1,point2,diff,point1,point2,diff,num);
				}
					/* String fmt="select distinct * from objective_question_info_choice where obj_question_point='%s' order by rand() limit %s";
					String sql1=String.format(fmt,request.getParameter("knowledge_point"+String.valueOf(index_num)),
							request.getParameter("num"+String.valueOf(index_num))); */
							System.out.println(sql_empty);
					Statement stmt2=con_kn.createStatement();
					ResultSet rs_add2=null;
					rs_add2=stmt2.executeQuery(sql_empty);
					while(rs_add2.next()){
						
						Statement stmt4=con_kn.createStatement();
						String fmt2="insert into paper_info(paper_name,ques_type,ques_id,ques_score,ques_answer,paper_id) values('%s','%s','%s',%d,'%s',%d)";
						String sql2=String.format(fmt2,paper_name,"cho",rs_add2.getString("obj_question_id"),
								Integer.parseInt(request.getParameter("score"+String.valueOf(index_num))),rs_add2.getString("obj_question_answer"),paper_id);
						stmt4.executeUpdate(sql2);
					}
					
				
			}
			else if(request.getParameter("type"+String.valueOf(index_num)).equalsIgnoreCase("fill")){
				if(point1.equals("0")&&point2.equals("0")){
					sql_empty=String.format("select distinct * from objective_question_info_fill where diff=%s order by rand() limit %s",diff,num);
				}
				else if(point1.equals("0")&&(!point2.equals("0"))){
					sql_empty=String.format("select distinct * from objective_question_info_fill where (obj_point1='%s' or obj_point2='%s') and diff=%s order by rand() limit %s",point2,point2,diff,num);
				}
				else if(point2.equals("0")&&(!point1.equals("0"))){
					sql_empty=String.format("select distinct * from objective_question_info_fill where (obj_point1='%s' or obj_point2='%s') and diff=%s order by rand() limit %s",point1,point1,diff,num);
				}
				else{
					sql_empty=String.format("select distinct * from objective_question_info_fill where obj_point1='%s' and obj_point2='%s' and diff=%s or obj_point2='%s' and obj_point1='%s' and diff=%s order by rand() limit %s",point1,point2,diff,point1,point2,diff,num);
				}
				/* String fmt="select distinct * from objective_question_info_fill where obj_question_point='%s' order by rand() limit %s";
				String sql1=String.format(fmt,request.getParameter("knowledge_point"+String.valueOf(index_num)),
						request.getParameter("num"+String.valueOf(index_num))); */
						System.out.println(sql_empty);
				Statement stmt2=con_kn.createStatement();
				ResultSet rs_add2=null;
				rs_add2=stmt2.executeQuery(sql_empty);
				while(rs_add2.next()){
					
					Statement stmt4=con_kn.createStatement();
					String fmt2="insert into paper_info(paper_name,ques_type,ques_id,ques_score,ques_answer,paper_id) values('%s','%s','%s',%d,'%s',%d)";
					String sql2=String.format(fmt2,paper_name,"fill",rs_add2.getString("obj_question_id"),
							Integer.parseInt(request.getParameter("score"+String.valueOf(index_num))),rs_add2.getString("obj_question_answer"),paper_id);
					stmt4.executeUpdate(sql2);
				}
				
			
			}
			
			index_num+=1;
		
		
	}
		out.print("<script>alert('添加成功！'); window.location='redirect/re_addpaper.jsp' </script>");
	
	
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
function add_extra(){//添加新的栏位
	
	var extra="<tr>"+
		"<td>"+"<input type='text' name='num" +index+ "'/>"+"</td>"+
		"<td>"+"<select name='type"+index+"'>"+
		"<option value='sub' selected='selected'>"+"主观题"+"</option>"+
		"<option value='cho' >"+"选择题"+"</option>"+
		"<option value='fill' >"+"填空题"+"</option>"+
		"</select>"+"</td>"+"<td>"+"<select name='point1"+index+"'>"+
		"<option value=0>无</option>"+
		"<%for(int i=0;i<finallist1.size();i++){ %>"+
		"<%String pre=""; %>"+
		"<option value="+"<%=finallist1.get(i).getid() %>"+">"+
		"<%for(int k=1;k<finallist1.get(i).getrank();k++){ %>"+
		"<% pre+="&nbsp;&nbsp;";%>"+
		"<%} %>"+
		"<%opt=pre+"   |-"+finallist1.get(i).getname(); %>"+
		"<%=opt %>"+"</option>"+
		"<%} %>"+
		"</select>"+"</td>"+"<td>"+"<select name='point2"+index+"'>"+
		"<option value=0>无</option>"+
		"<%for(int i=0;i<finallist1.size();i++){ %>"+
		"<%String pre=""; %>"+
		"<option value="+"<%=finallist1.get(i).getid() %>"+">"+
		"<%for(int k=1;k<finallist1.get(i).getrank();k++){ %>"+
		"<% pre+="&nbsp;&nbsp;";%>"+
		"<%} %>"+
		"<%opt=pre+"   |-"+finallist1.get(i).getname(); %>"+
		"<%=opt %>"+"</option>"+
		"<%} %>"+
		"</select>"+"</td>"+"<td><select name='diff"+index+"'>"+
		"<option value='1'>1</option><option value='2'>2</option><option value='3'>3</option>"+
		"<option value='4'>4</option><option value='5'>5</option></select></td>"+
		"<td>"+"<input type='text' name='score" +index+ "'/>"+"</td>"+
		"</tr>";
	var txt1="here";	
	$("#add_paper tr:last").after(extra);//在最后一个tr处添加新的一行
	index+=1;
	
	
}

</script>
<style type="text/css">
table.hovertable {
	margin:0 auto;
	width:85%;
	font-family: verdana,arial,sans-serif;
	font-size:11px;
	color:#333333;
	border-width: 1px;
	border-color: #999999;
	border-collapse: collapse;
}
table.hovertable th {
	text-align:center;
	background-color:#c3dde0;
	border-width: 1px;
	padding: 8px;
	border-style: solid;
	border-color: #a9c6c9;
}
table.hovertable tr {
	background-color:#d4e3e5;
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
<form method="post" action="add_paper.jsp" id="paper">
<div style="text-align:center;">
输入卷子名称：<input type='text' id='paper_name' name='paper_name' ><br>

输入卷子备注：<input type='text' id='paper_comment' name='paper_comment' >
</div><br>
<table id="add_paper" class="hovertable">
<tr>
<td>数量</td>
<td>种类</td>
<td>知识点1</td>
<td>知识点2</td>
<td>难度</td>
<td>分值</td>
</tr>

</table>

<input type="hidden" name='check_result' id='check_result' value="0">
</form>
<div style="text-align:center;">
<button onclick="add_extra()">增加选项</button>

<input type='submit' form='paper' name='finish' value='提交' onclick='get_num()'/>
</div>
<div id="check"></div>
</body>
</html>