<%@page session="false"%>
<%@page pageEncoding="LATIN1"%>
<%@page import="java.net.*,java.io.*,java.sql.*" %>
<%@ include file="databaseConnection.jsp" %>
<%
try {

	String gid = request.getParameter("gid");

	String myDataField = null;
	String myQuery = "SELECT gid, concessi_1 as name, ST_AsText(ST_Envelope(geom)) as extent,ST_AsText(ST_PointOnSurface(geom)) as centroid,ST_AsText(geom) as geom FROM \"KnowledgeBase\".\"DBGEO_concessions\" WHERE concession = " + gid;
	Connection myConnection = null;
	PreparedStatement myPreparedStatement = null;
	ResultSet myResultSet = null;
	Class.forName(driver).newInstance();
	myConnection = DriverManager.getConnection(url,username,password);
	myPreparedStatement = myConnection.prepareStatement(myQuery);
	myResultSet = myPreparedStatement.executeQuery();
	String myjson="{\"GetConcessionResult\":";
	boolean isfirst=true;
	while(myResultSet.next()){
		if(isfirst == true)
			isfirst=false;
		else
			myjson=myjson+",";
		myjson=myjson+"{";

		myDataField = myResultSet.getString("gid");
		myjson = myjson +"\"gid\":";
		myjson = myjson + myDataField;
		myjson = myjson + ",";

		myDataField = myResultSet.getString("name");
		myjson = myjson +"\"name\":";
		myjson = myjson + "\""+myDataField+"\"";
		myjson = myjson + ",";

		myDataField = myResultSet.getString("centroid");
		myjson = myjson +"\"centroid\":";
		myjson = myjson + "\""+myDataField+"\"";
		myjson = myjson + ",";

		myDataField = myResultSet.getString("extent");
		myjson = myjson +"\"extent\":";
		myjson = myjson + "\""+myDataField+"\"";
		myjson = myjson + ",";

		myDataField = myResultSet.getString("geom");
		myjson = myjson +"\"geom\":";
		myjson = myjson + "\""+myDataField+"\"";



		myjson=myjson+"}";

	}
	myjson=myjson+"}";
	myResultSet.close();
	myPreparedStatement.close();
	myConnection.close();

	out.print(myjson );
	}
	catch(ClassNotFoundException e){
		e.printStackTrace();
	}
	catch (SQLException ex){
		out.print("SQLException: "+ex.getMessage());
		out.print("SQLState: " + ex.getSQLState());
		out.print("VendorError: " + ex.getErrorCode());
	}


%>




