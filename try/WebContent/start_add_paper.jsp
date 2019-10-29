<%@ page language="java" import="java.util.*,java.sql.*,java.net.URLDecoder" 
         contentType="text/html; charset=utf-8"
%>

<%

int j=0;
session.setAttribute("count_sub",j);
List<String> list_sub_id=new ArrayList<String>();
List<String> list_sub_score=new ArrayList<String>();
session.setAttribute("list_sub_id", list_sub_id);
session.setAttribute("list_sub_score", list_sub_score);

session.setAttribute("count_cho",j);
List<String> list_cho_id=new ArrayList<String>();
List<String> list_cho_score=new ArrayList<String>();
session.setAttribute("list_cho_id", list_cho_id);
session.setAttribute("list_cho_score", list_cho_score);

session.setAttribute("count_fill",j);
List<String> list_fill_id=new ArrayList<String>();
List<String> list_fill_score=new ArrayList<String>();
session.setAttribute("list_fill_id", list_fill_id);
session.setAttribute("list_fill_score", list_fill_score);
response.sendRedirect("add_paper_by_hand.jsp");
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<title>Insert title here</title>
</head>
<body>
<script type="text/javascript" language="javascript">

</script>	
<input type="button" value="go" onClick="window.location.href='add_paper_by_hand.jsp'" > 
</body>
</html>