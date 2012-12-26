<%@page import="Svc.WCUser"%>
<%@page import="java.util.ArrayList"%>
<%@page import="com.game5a.xkx2.TitleData"%>
<%@ page language="java" contentType="text/html;charset=utf-8" pageEncoding="utf-8"%>

<%@ include file="common.jsp" %>

<%
	this.getRegisterData(request, response);
%>

<%!
	private void getRegisterData(HttpServletRequest request, HttpServletResponse response){
	
		String data=request.getParameter("data");
		try{
			JSONObject jsonObj = new JSONObject(data);
			if (jsonObj.length()>0) {
				String time=jsonObj.getString("time");
				String sql = "SELECT id, registerTime from UserInfo WHERE registerTime >= '" + time + "' limit " + 50;
				CachedRowSet rs = Lucsky.Db.CreateBySource(dataSource5agameSvc).ExecuteQuery(sql);
				
				JSONArray jsonArray = new JSONArray();
				while (rs != null && rs.next()) {
					JSONObject jsonObject = new JSONObject();
					int id=rs.getInt("id");
					jsonObject.put("id", id);
					jsonObject.put("uid", id);
					jsonObject.put("type", 0);
					jsonObject.put("dt",rs.getString("registerTime"));
					jsonArray.put(jsonObject);
				}
				rs.close();
				
				outJson(response, jsonArray.toString());
			}
		}catch(Exception e){
			gmLog("getRegisterData", e);
			outJson(response, e.getMessage());
		}
	}

%>