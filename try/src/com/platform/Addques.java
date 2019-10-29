package com.platform;
import java.sql.*;
public class Addques {
	private String describe;
	private String answer;
	
	public String getdes() {
		return this.describe;
	}
	public String getans() {
		return this.answer;
	}
	public Addques(){
		
	}
	public void add_ques_sub(String describe,String answer,String point1,String point2,String diff) {
		String connectString = "jdbc:mysql://localhost:3306/math_platform"
				+ "?autoReconnect=true&useUnicode=true&serverTimezone=UTC"
				+ "&characterEncoding=UTF-8"; 
		String user="root"; String pwd="123";
		//Class.forName("com.mysql.cj.jdbc.Driver");		
		//String des=describe.replace("\\","\\\\");
		//String ans=answer.replace("\\","\\\\");
		String fmt="insert into subjective_question_info(sub_ques_describe,sub_ques_answer,sub_point1,sub_point2,diff) values('%s','%s','%s','%s',%s)";
		String sql=String.format(fmt,describe,answer,point1,point2,diff);
		//System.out.println(sql);
		try {
			Connection con=DriverManager.getConnection(connectString,user,pwd);
			Statement stmt=con.createStatement();
			stmt.executeUpdate(sql);
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}
	public void add_ques_fill(String describe,String answer,String point1,String point2,String diff) {
		String connectString = "jdbc:mysql://localhost:3306/math_platform"
				+ "?autoReconnect=true&useUnicode=true&serverTimezone=UTC"
				+ "&characterEncoding=UTF-8"; 
		String user="root"; String pwd="123";
		//Class.forName("com.mysql.cj.jdbc.Driver");		
		//String des=describe.replace("\\","\\\\");
		//String ans=answer.replace("\\","\\\\");
		String fmt="insert into objective_question_info_fill(obj_question_describe,obj_question_answer,obj_point1,obj_point2,diff) values('%s','%s','%s','%s',%s)";
		String sql=String.format(fmt,describe,answer,point1,point2,diff);
		//System.out.println(sql);
		try {
			Connection con=DriverManager.getConnection(connectString,user,pwd);
			Statement stmt=con.createStatement();
			stmt.executeUpdate(sql);
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}
	public void add_ques_cho(String describe,String choice,String answer,String point1,String point2,String diff) {
		String connectString = "jdbc:mysql://localhost:3306/math_platform"
				+ "?autoReconnect=true&useUnicode=true&serverTimezone=UTC"
				+ "&characterEncoding=UTF-8"; 
		String user="root"; String pwd="123";
		//Class.forName("com.mysql.cj.jdbc.Driver");		
		//String des=describe.replace("\\","\\\\");
		//String ans=answer.replace("\\","\\\\");
		String fmt="insert into objective_question_info_choice(obj_question_describe,obj_question_choice,obj_question_answer,obj_point1,obj_point2,diff) values('%s','%s','%s','%s','%s',%s)";
		String sql=String.format(fmt,describe,choice,answer,point1,point2,diff);
		//System.out.println(sql);
		try {
			Connection con=DriverManager.getConnection(connectString,user,pwd);
			Statement stmt=con.createStatement();
			stmt.executeUpdate(sql);
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}
}
