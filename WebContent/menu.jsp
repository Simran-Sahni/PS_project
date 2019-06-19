<%@page import="java.sql.DriverManager"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="java.sql.Statement"%>
<%@page import="java.sql.Connection"%>
<%@page import="java.sql.PreparedStatement"%>
<%@page import="java.sql.ResultSetMetaData" %>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<html>
<head>
<meta charset="ISO-8859-1">
<style>
ul {
 margin: 0;
 padding: 0;
 list-style: none;
 width: 150px;
 border-bottom: 1px solid #ccc;
 float:right;
 }
 
 ul li {
 position: relative;
 }
li ul {
 position: absolute;
 right:150px;
 top: 0;
 display: none;
 }
 li:hover ul{ display:block;}
ul li a {
 display: block;
 text-decoration: none;
 color: #777;
 background: #fff;
 padding: 5px;
 border: 1px solid #ccc;
 border-bottom: 0;
 }
</style>
<title>Menus</title>
<script src="http://openlayers.org/api/OpenLayers.js"></script>
</head>
<body>
<h2> District: 
<%
// Display the name of district selected
String name=request.getParameter("name");
if(name!=null){
out.println(name);
}
%>
</h2>
<%
//Connect to database postgresql
Class.forName("org.postgresql.Driver");
Connection conn=null;
		
		String url = "jdbc:postgresql://localhost:5432/CMS";
		String user ="postgres";
		String password = "geoserver";
		conn= DriverManager.getConnection(url,user,password);
	PreparedStatement pst;
	String sql = "SELECT * FROM public.district_x "; // Select districts from master table postgresql
	pst= conn.prepareStatement(sql);
	ResultSet rs= pst.executeQuery();
	ResultSetMetaData meta = rs.getMetaData();
	//int colCount = meta.getColumnCount(); // get no of columns
	String temp;
	%> 
<ul>
<%while(rs.next()){%>
        <li id="<%rs.getString(1);%>"><a href="#"><%out.println(rs.getString(1));
        	temp=rs.getString(1);
        %></a>
        <ul id='submenu'>
        <%
        String sql1 = "SELECT * FROM public." + temp; // Select department table
        PreparedStatement pst1;
    	pst1= conn.prepareStatement(sql1);
    	ResultSet rs1= pst1.executeQuery();  //Select all sub-departments
    	
        while(rs1.next()){%>
        	<li id="<%rs1.getString(1);%>" onclick="myFunction()"><a href="#"><%out.println(rs1.getString(1));%></a></li>
        <%}
        %>   
        
        </ul>
        
        
        </li>

           <%} %>

    </ul>
    
    <div style="width:50%; height:50%; visibility: hidden;" id="map" >
    </div>
<script defer="defer" type="text/javascript">
var map = new OpenLayers.Map('map');
var wms = new OpenLayers.Layer.WMS( "OpenLayers WMS",
    "http://localhost:8083/geoserver/wms", {layers: 'ind:ind'}     );
map.addLayer(wms);
map.zoomToMaxExtent();
function myFunction() {
  document.getElementById("map").style.visibility = 'visible';
}
</script>
</body>
</html>