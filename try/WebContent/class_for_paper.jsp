<%@ page language="java" import="java.util.*,java.sql.*" 
         contentType="text/html; charset=utf-8"
%>
<%
String connectString = "jdbc:mysql://localhost:3306/math_platform"
		+ "?autoReconnect=true&useUnicode=true&serverTimezone=UTC"
		+ "&characterEncoding=UTF-8"; 
String user="root"; String pwd="123";

String query_point_num="select knowledge_name from knowledge_point";
Class.forName("com.mysql.cj.jdbc.Driver");
Connection con_kn=DriverManager.getConnection(connectString,user,pwd);
String paper_id=request.getParameter("paper_id");

String fmt=String.format("select * from class_id");
String fmt1=String.format("select * from class_stu");
Statement stmt=con_kn.createStatement();
Statement stmt1=con_kn.createStatement();

ResultSet rs=stmt.executeQuery(fmt);
ResultSet rs1=stmt1.executeQuery(fmt1);
List<String> classes=new ArrayList<String>();

List<List<String>> class_stu=new ArrayList<List<String>>();

int count=0;
while(rs.next()){
	classes.add(rs.getString("class_id"));
	count+=1;
}

for(int k=0;k<count;k++){
	
	List<String> students=new ArrayList<String>();
	while(rs1.next()){
		if(rs1.getString("class_id").equals(classes.get(k))){
			
			students.add(rs1.getString("stu_id"));			
		}
	}
	class_stu.add(students);
	
	rs1.first();
	rs1.previous();
}

for(int i=0;i<classes.size();i++){
	//System.out.println(classes.get(i));
	//System.out.println(class_stu.get(i));
}

%>
<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<title>Insert title here</title>
<script src="js/adapter.js"></script> <!--rem适配js-->
<script type="text/javascript">
function show(obj){
	var paper_id=document.getElementById("paper_id").value;
　　　document.getElementById("iframe1").src='correct_paper.jsp?paper_id='+paper_id+'&stu_id='+obj.value;
	
}
</script>
<link rel="stylesheet" href="css/base.css"> <!--初始化文件-->
<link rel="stylesheet" href="css/menu.css"> <!--主样式-->
</head>
<body>
<div id="menu" style="float:left;display:inline-block;" >
   

    <!--显示菜单-->
    <div id="open">
        <div class="navH">
            学生选择
            
        </div>
        <div class="navBox">
            <ul>
                
                <%for(int i=0;i<classes.size();i++){ %>
                <li>
                    <h2 class="obtain"><%=classes.get(i) %><i></i></h2>
                    <div class="secondary">
                    	<%for(int k=0;k<class_stu.get(i).size();k++){ %>
                        <h3 ><input type='button' name='add_sub'  value=<%=class_stu.get(i).get(k) %>  style="width:100%;" onclick="show(this)"></h3>
                        
                        <%} %>
                    </div>
                </li>
                <%} %>
                
            </ul>
        </div>
    </div>
</div>

<script src="js/menu.js"></script> <!--控制js-->
<iframe name= "iframe1" id="iframe1" width=1300 height=815 src= "void.jsp " scrolling= "auto " frameborder= "0 " 
style="float:right;border-style: solid;border-width: 5px;margin-right:100px;display:inline-block;"> </iframe> 
<input type="hidden" id='paper_id' name='paper_id' value=<%=paper_id %>>
</body>
</html>