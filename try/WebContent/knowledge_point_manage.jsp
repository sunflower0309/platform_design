<%@ page language="java" import="java.util.*,java.sql.*,com.platform.*" 
         contentType="text/html; charset=utf-8" pageEncoding="utf-8"
%>
<%
String connectString = "jdbc:mysql://localhost:3306/math_platform"
		+ "?autoReconnect=true&useUnicode=true&serverTimezone=UTC"
		+ "&characterEncoding=UTF-8"; 
String user="root"; String pwd="123";
Class.forName("com.mysql.cj.jdbc.Driver");
Connection con=DriverManager.getConnection(connectString,user,pwd);
Statement stmt=con.createStatement();
String fmt="select * from knowledge_point";
ResultSet rs=stmt.executeQuery(fmt);
List<point> pointlist=new ArrayList<point>();
List<point> finallist=new ArrayList<point>();
List<point> finallist1=new ArrayList<point>();
List<String> del=new ArrayList<String>();
List<String> del1=new ArrayList<String>();
while(rs.next()){
	point x=new point(rs.getInt(4),rs.getInt(1),rs.getInt(3),rs.getString(2));
	pointlist.add(x);
}
/* for(int i=0;i<pointlist.size();i++){
	out.println(pointlist.get(i).getname());
} */
StringBuilder sbuild=new StringBuilder("");
add_rec(0,pointlist,pointlist,sbuild);
finallist1=rebuild(0,pointlist,pointlist,finallist);
out.print(sbuild);
//out.print(pointlist.size());
/* for(int i=0;i<finallist1.size();i++){
	out.println(finallist1.get(i).getname());
	out.println(finallist1.get(i).getrank());
} */
System.out.println("getdelete");
String opt="";
int mark=0;
int markid=0;
int markrank=0;
if(request.getParameter("delete")!=null){
	String delpoint=request.getParameter("delpoint").toString();
	int delpointid=Integer.parseInt(delpoint);
	//System.out.println("delpoint:"+delpoint);
	for(int i=0;i<finallist1.size();i++){
		if(finallist.get(i).getid()==delpointid){
			mark=i;
			markid=finallist.get(i).getid();
			markrank=finallist.get(i).getrank();
			break;
		}
	}
	System.out.println("markrank:"+markrank);
	String fmt1=String.format("delete from knowledge_point where knowledge_id=%s",markid);
	del.add(fmt1);
	for(int i=mark+1;i<finallist.size();i++){
		if(finallist.get(i).getrank()>markrank){
			String format=String.format("delete from knowledge_point where knowledge_id=%s",finallist.get(i).getid());
			del.add(format);
		}
		else break;
	}
	System.out.println("size:"+del.size());
	for(int i=0;i<del.size();i++){
		stmt.execute(del.get(i));
	} 
	response.sendRedirect("redirect/knowledge_res.jsp");
}
int mark1=0;
int markid1=0;
int markrank1=0;
if(request.getParameter("add")!=null){
	String addpoint=new String(request.getParameter("addpoint").getBytes("iso-8859-1"), "utf-8"); 
	String addparentpoint=request.getParameter("addparentpoint");
	int parentid=Integer.parseInt(addparentpoint);
	for(int i=0;i<finallist1.size();i++){
		if(finallist.get(i).getid()==parentid){
			mark1=i;
			markid1=finallist.get(i).getid();
			markrank1=finallist.get(i).getrank();
			break;
		}
	}
	try{
		String fmt2=String.format("insert into knowledge_point values(null,'%s',%d,%d)",addpoint,markrank1+1,markid1);
		stmt.executeUpdate(fmt2);
	}
	catch(Exception e){
		System.out.print(e.getMessage());
	}
	response.sendRedirect("redirect/knowledge_res.jsp");
}
%>
<%!
private void add_rec(int upper,List<point> list,List<point> sublist,StringBuilder sb){
	for(int i=0;i<sublist.size();i++){
		if(sublist.get(i).getupper()==upper){
			if(i==0){
				sb.append("<ul><li>"+sublist.get(i).getname());
				List<point> newlist=new ArrayList<point>();
				for(int k=0;k<list.size();k++){
					if(list.get(k).getupper()==sublist.get(i).getid()){
						newlist.add(list.get(k));
					}
				}
				add_rec(sublist.get(i).getid(),list,newlist,sb);
				sb.append("</li>");
			}
			else{
				sb.append("<li>"+sublist.get(i).getname()+"</li>");
				List<point> newlist=new ArrayList<point>();
				for(int k=0;k<list.size();k++){
					if(list.get(k).getupper()==sublist.get(i).getid()){
						newlist.add(list.get(k));
					}
				}
				add_rec(sublist.get(i).getid(),list,newlist,sb);
				sb.append("</li>");
			}
		}
		if(i==sublist.size()-1){
			sb.append("</ul>");
		}
	}	
}

private List<point> rebuild(int upper,List<point> list, List<point> sublist,List<point> finallist){
	for(int i=0;i<sublist.size();i++){
		if(sublist.get(i).getupper()==upper){
			finallist.add(sublist.get(i));
			List<point> newlist=new ArrayList<point>();
			for(int k=0;k<list.size();k++){
				if(list.get(k).getupper()==sublist.get(i).getid()){
					newlist.add(list.get(k));
				}
			}
			rebuild(sublist.get(i).getid(),list,newlist,finallist);
		}		
	}	
	return finallist;
}

/* private List<String> deletepoint(int upper,List<point> list, List<point> sublist,List<String> del){
	for(int i=0;i<sublist.size();i++){
		if(sublist.get(i).getupper()==upper){
			String fmt=String.format("delete * from knowledge_point where knowledge_id=%s",sublist.get(i).getid());
			
			//finallist.add(sublist.get(i));
			del.add(fmt);
			List<point> newlist=new ArrayList<point>();
			for(int k=0;k<list.size();k++){
				if(list.get(k).getupper()==sublist.get(i).getid()){
					newlist.add(list.get(k));
				}
			}
			deletepoint(sublist.get(i).getid(),list,newlist,del);
		}		
	}
	return del;
} */

%>
<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<title>Insert title here</title>
</head>
<body>
<form action="knowledge_point_manage.jsp" method="post">
删除节点：<br>选择节点：<select name='delpoint'>
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
<input type="submit" name="delete" value="删除">   请注意，删除时会将下属的子节点一并删除
</form>

<form action="knowledge_point_manage.jsp" method="post">
添加节点：<br>
选择父节点：
<select name='addparentpoint'>
<option value="0">根节点</option>
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
输入节点名称：<input type='text' name='addpoint'>
<input type="submit" name="add" value="添加">
</form>
</body>
</html>