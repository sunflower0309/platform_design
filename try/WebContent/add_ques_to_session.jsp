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

	int count1=(Integer)session.getAttribute("count_sub");

	ArrayList<String> list_sub_id_new=(ArrayList<String>)session.getAttribute("list_sub_id");
	ArrayList<String> list_sub_score_new=(ArrayList<String>)session.getAttribute("list_sub_score");
	boolean existed=false;
	for(int i=0;i<count1;i++){
		if(list_sub_id_new.get(i).equals(sub_id)){
			existed=true;
			break;
		}
	}
	if(existed==true){
		response.getWriter().write("existed");
	}
	else{
		list_sub_id_new.add(sub_id);
		list_sub_score_new.add(sub_score);
		count1+=1;
		session.setAttribute("list_sub_id", list_sub_id_new);
		session.setAttribute("list_sub_score", list_sub_score_new);

		session.setAttribute("count_sub",count1);
		response.getWriter().write("ok");
	}
}
else if(type.equals("cho")){
	String cho_id=new String(request.getParameter("cho_id").getBytes("ISO-8859-1"),"utf-8");
	String cho_score=new String(request.getParameter("cho_score").getBytes("ISO-8859-1"),"utf-8");

	int count1=(Integer)session.getAttribute("count_cho");

	ArrayList<String> list_cho_id_new=(ArrayList<String>)session.getAttribute("list_cho_id");
	ArrayList<String> list_cho_score_new=(ArrayList<String>)session.getAttribute("list_cho_score");
	boolean existed=false;
	for(int i=0;i<count1;i++){
		if(list_cho_id_new.get(i).equals(cho_id)){
			existed=true;
			break;
		}
	}
	if(existed==true){
		response.getWriter().write("existed");
	}
	else{
		list_cho_id_new.add(cho_id);
		list_cho_score_new.add(cho_score);
		count1+=1;
		session.setAttribute("list_cho_id", list_cho_id_new);
		session.setAttribute("list_cho_score", list_cho_score_new);

		session.setAttribute("count_cho",count1);
		response.getWriter().write("ok");
	}
}
else if(type.equals("fill")){
	String fill_id=new String(request.getParameter("fill_id").getBytes("ISO-8859-1"),"utf-8");
	String fill_score=new String(request.getParameter("fill_score").getBytes("ISO-8859-1"),"utf-8");

	int count1=(Integer)session.getAttribute("count_fill");
	
	ArrayList<String> list_fill_id_new=(ArrayList<String>)session.getAttribute("list_fill_id");
	ArrayList<String> list_fill_score_new=(ArrayList<String>)session.getAttribute("list_fill_score");
	boolean existed=false;
	for(int i=0;i<count1;i++){
		if(list_fill_id_new.get(i).equals(fill_id)){
			existed=true;
			break;
		}
	}
	if(existed==true){
		response.getWriter().write("existed");
	}
	else{
		list_fill_id_new.add(fill_id);
		list_fill_score_new.add(fill_score);
		count1+=1;
		session.setAttribute("list_fill_id", list_fill_id_new);
		session.setAttribute("list_fill_score", list_fill_score_new);

		session.setAttribute("count_fill",count1);
		response.getWriter().write("ok");
	}
}


%>