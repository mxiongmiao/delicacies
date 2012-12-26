<%@ page language="java" contentType="text/html;charset=utf-8" pageEncoding="utf-8"%>

<%@ include file="common.jsp" %>

<%
	this.sendSysMsg(request, response);
%>

<%!
	private void sendSysMsg(HttpServletRequest request, HttpServletResponse response){
		String data=request.getParameter("data");
		
		try{
			JSONObject  jsonObj = new JSONObject(data);
			if (jsonObj.length()>0) {
				String uid = jsonObj.getString("uid");
				String content = jsonObj.getString("content");
				game.sendOnlineMsg(Integer.parseInt(uid), OnlineMsgType.System, 0, content, 0);
				outJson(response, "success");
			}
		}catch(Exception e){
			gmLog("sendSysMsg", e);
			outJson(response, "failure");
		}
	}
%>