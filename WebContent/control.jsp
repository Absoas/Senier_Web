<%@page import="DO.*"%>
<%@page import="bean.Db_connection"%>
<%@ page language="java" contentType="text/html; charset=utf-8"
	pageEncoding="utf-8" import = " bean.*,java.util.* "%>
	
	<% request.setCharacterEncoding("UTF-8"); %>
	
<jsp:useBean id = "uu" class="DO.check_DO"/>	
<jsp:useBean id = "DO" class="DO.Patient_DO"/>
<jsp:useBean id = "nu" class="DO.nurse_DO"/>
<jsp:useBean id = "to" class="DO.T_Patient_DO"/>
<jsp:useBean id = "sdo" class="DO.Patientinfo_DO"/>
<jsp:useBean id = "ndo" class="DO.PatientDetail_DO"/>
<jsp:useBean id = "db" class="bean.Db_connection"/>
<jsp:setProperty name ="nu" property = "*" />
<jsp:setProperty name ="sdo" property = "*" />
<jsp:setProperty name ="uu" property = "*" />
<jsp:setProperty name ="ndo" property = "*" />
<jsp:setProperty name ="DO" property = "*" />
<jsp:setProperty name ="to" property = "*" />

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<title>Insert title here</title>
</head>
<body>

	<%
	
	String action = request.getParameter("action");

	
	if(action.equals("list")){
		ArrayList<nurse_DO> datas = db.getDBList();
		request.setAttribute("datas", datas);
		pageContext.forward("loginList.jsp");
		
	}else if(action.equals("list1")){
		ArrayList<Patient_DO> datas1 = db.getDBList1();
		request.setAttribute("datas1", datas1);
		pageContext.forward("patientList.jsp");
		
	}else if(action.equals("list2")){
		ArrayList<T_Patient_DO> datas2 = db.getDBList2();
		request.setAttribute("datas2", datas2);

		ArrayList<T_Patient_DO> datas3 = db.getDBList3();
		request.setAttribute("datas3", datas3);
		
		pageContext.forward("Team1_patientList.jsp");
		
	}else if(action.equals("list3")){
		ArrayList<Patient_Sensor> s_datas = db.getSensorList();
		request.setAttribute("s_datas", s_datas);
		
		ArrayList<infusion_DO> i_datas = db.getInfusionList();
		request.setAttribute("i_datas", i_datas);
		
		pageContext.forward("selectSensor.jsp");
	
	}else if(action.equals("list4")){
	
		String param = request.getParameter("getId");
		int int_val = Integer.parseInt(param);
		Patient_DO too = db.getDB(int_val);
		
		request.setAttribute("to1", too);
		pageContext.forward("aList.jsp");
		
	}else if (action.equals("insert")){
		if(db.insertDB(nu)) {
			response.sendRedirect("control.jsp?action=list");
		}
		else
			throw new Exception("DB 입력오류");
		
	}else if (action.equals("patient_insert")){
		if(db.patient_insertDB(sdo)) {
			response.sendRedirect("insertDetail.jsp");
		}
		else
			throw new Exception("DB 입력오류");
	}
	else if (action.equals("detail_insert")){
		if(db.patientDetail_insertDB(ndo)) {
			response.sendRedirect("control.jsp?action=list1");
		}
		else
			throw new Exception("DB 입력오류");
		
	}else if(action.equals("delete")) {
		
		String id = request.getParameter("nid");
		String pw = request.getParameter("npw");
		String param = request.getParameter("id");
		int int_val = Integer.parseInt(param);
		
		System.out.println(int_val);
		System.out.println(id);
		System.out.println(pw);
		
		try{
			String rank = db.rankDB(id, pw);
			System.out.println(rank);
			
			if(rank.equals("수석간호사")){
				if(db.deleteDB(int_val)) {
					response.sendRedirect("control.jsp?action=list1");
					
				}else{
			    	throw new Exception("DB 삭제 오류");	
				}
			}else {
				out.println("<script>alert('권한이 없거나 로그인을 잘못하였습니다.!!'); history.go(-1);</script>");
			}
		}catch(NullPointerException e){
			out.println("<script>alert('권한이 없거나 로그인을 잘못하였습니다.!!'); history.go(-1);</script>");
		}
		
		//AASDasdasd
		
	}else if(action.equals("patient_update")) {
		if(db.updateDB(sdo)) {
			int id = sdo.getId();
			Patient_DO too = db.getDB(id);
			request.setAttribute("to1", too);
			pageContext.forward("updateDetail.jsp");
		}
		else
			throw new Exception("DB 갱신오류");
		
	}else if(action.equals("detail_update")) {
		if(db.deupdateDB(ndo)) {
		response.sendRedirect("main.jsp");
	}
	else
		throw new Exception("DB 갱신오류");
	}
		%>
</body>
</html>