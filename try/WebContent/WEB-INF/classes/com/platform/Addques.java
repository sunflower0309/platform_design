package com;
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
	public void add_ques_sub(String describe,String answer,String point) {
		String connectString = "jdbc:mysql://localhost:3306/math_platform"
				+ "?autoReconnect=true&useUnicode=true&serverTimezone=UTC"
				+ "&characterEncoding=UTF-8"; 
		String user="root"; String pwd="123";
		//Class.forName("com.mysql.cj.jdbc.Driver");		
		String des=describe.replace("\\","\\\\");
		String ans=answer.replace("\\","\\\\");
		String fmt="insert into subjective_question_info(sub_ques_describe,sub_ques_answer,sub_ques_know_point) values('%s','%s','%s')";
		String sql=String.format(fmt,des,ans,point);
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
