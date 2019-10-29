<%@ page language="java" import="java.util.*,java.sql.*,com.platform.*" 

         contentType="text/html; charset=utf-8"
%>
<%!String add_sub_ques_msg1=""; 
String add_sub_ans_msg2 = "";
int add_sub_ques_id=0;%>
<%request.setCharacterEncoding("utf-8");
//out.print("here");
//String msg1 = "";

String err="";
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
if(request.getParameter("preview2")!=null) {//预览问题描述
	try{
		add_sub_ques_msg1=request.getParameter("describe");
		add_sub_ans_msg2=request.getParameter("answer");
		//out.print("here");
	}
	catch (Exception e){
		add_sub_ans_msg2 = e.getMessage();
	}
}

Addques a=new Addques(); 
if(request.getParameter("save2")!=null){
	String x=request.getParameter("describe").replaceAll("&nbsp;", "").replaceAll("<p>", "").replaceAll("</p>", "").trim();
	String y=request.getParameter("answer").replaceAll("&nbsp;", "").replaceAll("<p>", "").replaceAll("</p>", "").trim();
	//System.out.println(request.getParameter("describe").replaceAll("&nbsp;", "").replaceAll("<p>", "").replaceAll("</p>", "").trim());
	if(x.equals("")||y.equals("")){
		out.print("<script>alert('题目或答案不能为空');  </script>");
	}
	else{
		try{
			a.add_ques_sub(request.getParameter("describe").replace("\\","\\\\").replaceAll("<p>", "").replaceAll("</p>", ""), 
					request.getParameter("answer").replace("\\","\\\\").replaceAll("<p>", "").replaceAll("</p>", ""), 
					request.getParameter("point1"),request.getParameter("point2"),request.getParameter("diff"));
			/* Class.forName("com.mysql.cj.jdbc.Driver");
			Connection con=DriverManager.getConnection(connectString,user,pwd);
			Statement stmt=con.createStatement();
			add_sub_ques_msg1=request.getParameter("describe");
			add_sub_ques_msg1=add_sub_ques_msg1.replace("\\","\\\\");
			add_sub_ans_msg2=request.getParameter("answer").replace("\\","\\\\");
			String fmt="insert into subjective_question_info(sub_ques_describe,sub_ques_answer,sub_ques_know_point) values('%s','%s','%s')";
			String sql=String.format(fmt,add_sub_ques_msg1,add_sub_ans_msg2,request.getParameter("knowledge_point").toString());
			System.out.println(sql);
			stmt.executeUpdate(sql); */
			
			add_sub_ques_msg1="";
			add_sub_ans_msg2="";//保存后重置全局变量
			out.print("<script>alert('添加成功！'); window.location='redirect/re_addsub.jsp' </script>");
		}
		catch(Exception e){
			err=e.getMessage();
			add_sub_ques_msg1="";
			add_sub_ans_msg2="";
			out.print("alert('插入失败，请重新尝试')");
		}
	}
	
}
%>
<!-- //保存完答案，跳转到中间页面，显示继续添加/回到主页-->
<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<title>show</title>

<meta http-equiv="Content-Type" content="text/html;charset=utf-8"/>
<script type="text/x-mathjax-config">
MathJax.Hub.Config({
    showProcessingMessages: false,
    messageStyle: "none",
    extensions: ["tex2jax.js"],
    jax: ["input/TeX", "output/HTML-CSS"],
    tex2jax: {
        inlineMath:  [ ["$", "$"] ],
        displayMath: [ ["$$","$$"] ],
        skipTags: ['script', 'noscript', 'style', 'textarea', 'pre','code','a','form'],
        ignoreClass:"comment-content"
    },
    "HTML-CSS": {
        availableFonts: ["STIX","TeX"],
        showMathMenu: false
    }
});
MathJax.Hub.Queue(["Typeset",MathJax.Hub]);
</script>
<script type="text/javascript"
  src="http://cdn.mathjax.org/mathjax/latest/MathJax.js?config=TeX-AMS-MML_HTMLorMML">
</script>
<!-- 样式文件 -->
<link rel="stylesheet" href="./umeditor/themes/default/css/umeditor.css">
<!-- 引用jquery -->
<script src="http://libs.baidu.com/jquery/2.1.4/jquery.min.js"></script>
<!-- 引入 etpl -->
<script src="http://s1.bdstatic.com/r/www/cache/ecom/etpl/3-2-0/etpl.js"></script>
<!-- 配置文件 -->
<script type="text/javascript" src="./umeditor/umeditor.config.js"></script>
<!-- 编辑器源码文件 -->
<script type="text/javascript" src="./umeditor/umeditor.js"></script>
<!-- 语言包文件 -->
<script type="text/javascript" src="./umeditor/lang/zh-cn/zh-cn.js"></script>
<!-- 实例化编辑器代码 -->
<script type="text/javascript">//对应的容器1号
    $(function(){
        window.um = UM.getEditor('container', {
        	/* 传入配置参数,可配参数列表看umeditor.config.js */
            toolbar: ['undo redo | bold italic underline | emotion image']
        });
    });
</script>
<script type="text/javascript">//对应的容器2号
    $(function(){
        window.um = UM.getEditor('container2', {
        	/* 传入配置参数,可配参数列表看umeditor.config.js */
            toolbar: ['undo redo | bold italic underline | emotion image']
        });
    });
</script>
<script type="text/javascript">
getTitleData1=function(){
    var point1 = $("#point1").val();
    var point1 = $.trim(point1);  
    document.cookie = "id1=" + point1;    //将select选中的value写入cookie中
    console.log(point1);
};
getTitleData2=function(){
    var point2 = $("#point2").val();
    var point2 = $.trim(point2);
    document.cookie = "id2=" + point2;
    console.log(point2);
};
getTitleData3=function(){
    var point3 = $("#diff").val();
    var point3 = $.trim(point3);
    document.cookie = "id3=" + point3;
    console.log(point3);
};
selectIndex=function(){
    var id1 = 0;
    var id2 = 0;
    var id3 = 0;
    var coosStr = document.cookie;    //获取cookie中的数据
    var coos=coosStr.split("; ");     //多个值之间用; 分隔
    for(var i=0;i<coos.length;i++){   //获取select写入的id
        var coo=coos[i].split("=");
        if("id1"==coo[0]){
         	id1=coo[1];
      	}
        if("id2"==coo[0]){
            id2=coo[1];
        }
        if("id3"==coo[0]){
            id3=coo[1];
        }
    }
    var po1=document.getElementById("point1");
    
    if(po1 == 0){
        po1.selectedIndex = 0;
    }
    else{    //如果从cookie中获取的id和select中的一致则设为默认状态
        var len = po1.options.length;
        for(var i=0;i<len;i++){
            if(po1.options[i].value == id1){
                po1.selectedIndex=i;
                break;
            }
        }
    }
    var po2=document.getElementById("point2");
    if(po2 == 0){
        po2.selectedIndex = 0;
    }
    else{    //如果从cookie中获取的id和select中的一致则设为默认状态
        var len = po2.options.length;
        for(var i=0;i<len;i++){
            if(po2.options[i].value == id2){
                po2.selectedIndex=i;
                break;
            }
        }
    }
    var po3=document.getElementById("diff");
    if(po3 == 0){
        po3.selectedIndex = 0;
    }
    else{    //如果从cookie中获取的id和select中的一致则设为默认状态
        var len = po3.options.length;
        for(var i=0;i<len;i++){
            if(po3.options[i].value == id3){
                po3.selectedIndex=i;
                break;
            }
        }
    }
}


</script>
<style type="text/css">
textarea {
font-family:宋体;
margin:200px auto;
text-align:center;
padding-top:50px;
width:500px;
height:300px;
}
</style>
</head>
<body onload="selectIndex();">
<br>
<div >
<form action="add_question_sub.jsp" method="post" >

输入题目描述：
<script id="container" name="describe" type="text/plain" style="width:600px;height:200px;">
<%=add_sub_ques_msg1%>
</script><br>
输入题目答案：
<script id="container2" name="answer" type="text/plain" style="width:600px;height:200px;">
<%=add_sub_ans_msg2%>
</script>


选择所属知识点1：<select name='point1' id='point1' onchange='getTitleData1()'>
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
选择所属知识点2：<select name='point2' id='point2' onchange='getTitleData2()'>
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
题目难度：<select name='diff' id='diff' onchange='getTitleData3()'>
<option value='1'>1</option>
<option value='2'>2</option>
<option value='3'>3</option>
<option value='4'>4</option>
<option value='5'>5</option>
</select><br>
<input id="preview2" type="submit" value="预览" name="preview2">

<input id="save2" type="submit" value="保存" name="save2">
</form>

</div>
题目预览：<%=add_sub_ques_msg1 %>
答案预览：<%=add_sub_ans_msg2 %>

</body>
</html>