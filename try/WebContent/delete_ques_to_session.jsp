<%@ page language="java" import="java.util.*,java.sql.*" 
         contentType="text/html; charset=utf-8"
%>

<%

String connectString = "jdbc:mysql://localhost:3306/math_platform"
		+ "?autoReconnect=true&useUnicode=true&serverTimezone=UTC"
		+ "&characterEncoding=UTF-8"; 
String user="root"; String pwd="123";
request.setCharacterEncoding("UTF-8");
String type=new String(request.getParameter("type").getBytes("ISO-8859-1"),"utf-8");
if(type.equals("sub")){
	String sub_id=new String(request.getParameter("sub_id").getBytes("ISO-8859-1"),"utf-8");
	String sub_score=new String(request.getParameter("sub_score").getBytes("ISO-8859-1"),"utf-8");
	int count2=(Integer)session.getAttribute("count_sub");
	ArrayList<String> list_sub_id_new1=(ArrayList<String>)session.getAttribute("list_sub_id");
	ArrayList<String> list_sub_score_new1=(ArrayList<String>)session.getAttribute("list_sub_score");
	for(int i=0;i<count2;i++){
		if(list_sub_id_new1.get(i).equals(request.getParameter("sub_id"))){
			list_sub_id_new1.remove(i);
			list_sub_score_new1.remove(i);
			break;
		}
	}
	count2-=1;
	session.setAttribute("count_sub",count2);
	session.setAttribute("list_sub_id", list_sub_id_new1);
	session.setAttribute("list_sub_score", list_sub_score_new1);
}
else if(type.equals("cho")){
	String cho_id=new String(request.getParameter("cho_id").getBytes("ISO-8859-1"),"utf-8");
	String cho_score=new String(request.getParameter("cho_score").getBytes("ISO-8859-1"),"utf-8");
	int count2=(Integer)session.getAttribute("count_cho");
	ArrayList<String> list_cho_id_new1=(ArrayList<String>)session.getAttribute("list_cho_id");
	ArrayList<String> list_cho_score_new1=(ArrayList<String>)session.getAttribute("list_cho_score");
	for(int i=0;i<count2;i++){
		if(list_cho_id_new1.get(i).equals(request.getParameter("cho_id"))){
			list_cho_id_new1.remove(i);
			list_cho_score_new1.remove(i);
			break;
		}
	}
	count2-=1;
	session.setAttribute("count_cho",count2);
	session.setAttribute("list_cho_id", list_cho_id_new1);
	session.setAttribute("list_cho_score", list_cho_score_new1);
}
else if(type.equals("fill")){
	String fill_id=new String(request.getParameter("fill_id").getBytes("ISO-8859-1"),"utf-8");
	String fill_score=new String(request.getParameter("fill_score").getBytes("ISO-8859-1"),"utf-8");
	int count2=(Integer)session.getAttribute("count_fill");
	ArrayList<String> list_fill_id_new1=(ArrayList<String>)session.getAttribute("list_fill_id");
	ArrayList<String> list_fill_score_new1=(ArrayList<String>)session.getAttribute("list_fill_score");
	for(int i=0;i<count2;i++){
		if(list_fill_id_new1.get(i).equals(request.getParameter("fill_id"))){
			list_fill_id_new1.remove(i);
			list_fill_score_new1.remove(i);
			break;
		}
	}
	count2-=1;
	session.setAttribute("count_fill",count2);
	session.setAttribute("list_fill_id", list_fill_id_new1);
	session.setAttribute("list_fill_score", list_fill_score_new1);
}



response.getWriter().write("ok");
%>