<%@page import="Svc.WCUser"%>
<%@page import="java.util.ArrayList"%>
<%@page import="com.game5a.xkx2.TitleData"%>
<%@ page language="java" contentType="text/html;charset=utf-8" pageEncoding="utf-8"%>

<%@ include file="common.jsp" %>

<%
	this.getLoginData(request, response);
%>

<%!
	private void getLoginData(HttpServletRequest request, HttpServletResponse response){
	
		String data=request.getParameter("data");

		try{
			JSONObject jsonObj = new JSONObject(data);
			if (jsonObj.length()>0) {
				String time=jsonObj.getString("time");
				String sql="SELECT playerId, userId, makeTime FROM UserLogin WHERE makeTime >= '"+time+ "' limit 50";
				CachedRowSet rs = Lucsky.Db.CreateBySource(dataSource5agameSvc).ExecuteQuery(sql);
				JSONArray jsonArray = new JSONArray();
				
				while (rs != null && rs.next()) {
					int playerId=rs.getInt("playerId");
					PlayerData p = game.getPlayer(playerId);
					if (p == null){
						continue;
					}
					
					JSONObject jsonObject = new JSONObject();
					jsonObject.put("id", playerId);
					jsonObject.put("uid", rs.getInt("userId"));
					jsonObject.put("level", p.getLevel());
					// 暂指定为 0， 
					//jsonObject.put("type", p.getAgentCode());
					jsonObject.put("type", 0);
					jsonObject.put("dt",rs.getString("makeTime"));
					jsonArray.put(jsonObject);
				}
				rs.close();
				
				outJson(response, jsonArray.toString());
			}
			
		}catch(Exception e){
			gmLog("getLoginData", e);
			outJson(response, e.getMessage());
		}
	}

%>