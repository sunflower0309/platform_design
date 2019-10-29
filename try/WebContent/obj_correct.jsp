<%@ page language="java" import="java.util.*,java.sql.*" 
         contentType="text/html; charset=utf-8"
%>

<%

String connectString = "jdbc:mysql://localhost:3306/math_platform"
		+ "?autoReconnect=true&useUnicode=true&serverTimezone=UTC"
		+ "&characterEncoding=UTF-8"; 
String user="root"; String pwd="123";
Class.forName("com.mysql.cj.jdbc.Driver");
request.setCharacterEncoding("UTF-8");
String paper_id=request.getParameter("paper_id");
String stu_id=request.getParameter("stu_id");
String sql1=String.format("select * from paper_answer_info where paper_id='%s' and ques_type='cho' and stu_id=%s",paper_id,stu_id);
String sql2=String.format("select * from paper_answer_info where paper_id='%s' and ques_type='fill' and stu_id=%s",paper_id,stu_id);
String sql3=String.format("select * from paper_info where paper_id='%s' and ques_type='cho' ",paper_id);
String sql4=String.format("select * from paper_info where paper_id='%s' and ques_type='fill' ",paper_id);
Connection con=DriverManager.getConnection(connectString,user,pwd);
Statement stmt=con.createStatement();
ResultSet rs1=stmt.executeQuery(sql1);//学生答案集合
List<String> cho_answer_list=new ArrayList<String>();
List<String> cho_score_list=new ArrayList<String>();
List<String> cho_id_list=new ArrayList<String>();
int score=0;
//System.out.print(paper_name);
int total_sc=0;
while(rs1.next()){
	
	String answer=rs1.getString("answer");
	//System.out.print(answer);
	cho_answer_list.add(answer);
	String max_score=rs1.getString("max_score");
	total_sc+=Integer.parseInt(max_score);
	cho_score_list.add(max_score);
	String ques_id=rs1.getString("ques_id");
	cho_id_list.add(ques_id);
}
ResultSet rs2=null;
rs2=stmt.executeQuery(sql3);
int count=0;
while(rs2.next()){
	
	if(rs2.getString("ques_answer").replaceAll("<p>","").replaceAll("</p>","").equalsIgnoreCase(cho_answer_list.get(count))){
		int sc=Integer.parseInt(cho_score_list.get(count));
		score+=sc;
		Statement stmt_up=con.createStatement();
		System.out.println("okcho");
		String sql=String.format("update paper_answer_info set score=%d,is_corrected='true' where paper_id='%s' and stu_id=%s and ques_type='cho' and ques_id=%s"
				,sc,paper_id,stu_id,cho_id_list.get(count));
		stmt_up.executeUpdate(sql);
	}
	else{
		Statement stmt_up=con.createStatement();
		System.out.print("nocho");
		String sql=String.format("update paper_answer_info set score=%d,is_corrected='true' where paper_id='%s' and stu_id=%s and ques_type='cho' and ques_id=%s"
				,0,paper_id,stu_id,cho_id_list.get(count));
		stmt_up.executeUpdate(sql);
	}
	count+=1;
	System.out.print(score);
} 

Statement stmt1=con.createStatement();
ResultSet rs3=stmt1.executeQuery(sql2);//学生答案集合
List<String> fill_answer_list=new ArrayList<String>();
List<String> fill_score_list=new ArrayList<String>();
List<String> fill_id_list=new ArrayList<String>();
int score_fill=0;

while(rs3.next()){
	String answer=rs3.getString("answer");
	
	fill_answer_list.add(answer);
	//System.out.println(answer);
	String max_score=rs3.getString("max_score");
	total_sc+=Integer.parseInt(max_score);
	fill_score_list.add(max_score);
	String ques_id=rs3.getString("ques_id");
	fill_id_list.add(ques_id);
}
ResultSet rs4=null;
rs4=stmt1.executeQuery(sql4);
int count_fill=0;
while(rs4.next()){
	if(rs4.getString("ques_answer").replaceAll("<p>","").replaceAll("</p>","").equals(fill_answer_list.get(count_fill))){
		int sc=Integer.parseInt(fill_score_list.get(count_fill));
		score_fill+=sc;
		Statement stmt_up=con.createStatement();
		
		String sql=String.format("update paper_answer_info set score=%d,is_corrected='true' where paper_id='%s' and stu_id=%s and ques_type='fill' and ques_id=%s"
				,sc,paper_id,stu_id,fill_id_list.get(count_fill));
		stmt_up.executeUpdate(sql);
	}
	else{
		Statement stmt_up=con.createStatement();
		
		String sql=String.format("update paper_answer_info set score=%d,is_corrected='true' where paper_id='%s' and stu_id=%s and ques_type='fill' and ques_id=%s"
				,0,paper_id,stu_id,fill_id_list.get(count_fill));
		stmt_up.executeUpdate(sql);
	}
	count_fill+=1;
	System.out.print(score_fill);
}
int obj_score=score+score_fill;
String scc="";
scc=String.valueOf(obj_score);

response.getWriter().write(scc);
%>