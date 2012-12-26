<%@page import="com.game5a.xkx2.ChannelType"%>
<%@ page language="java" contentType="text/html;charset=utf-8" pageEncoding="utf-8"%>

<%@ include file="common.jsp" %>

<%
	this.sendWorldTalk(request, response);
%>

<%!
	@SuppressWarnings("unchecked")
	private void sendWorldTalk(HttpServletRequest request,  HttpServletResponse response){
		String data=request.getParameter("data");
		try{
			JSONObject  jsonObj = new JSONObject(data);
			if (jsonObj.length()>0) {
				int type = jsonObj.getInt("type");
				String content = jsonObj.getString("content");
				
				ChannelType channelType=ChannelType.World;
				if(type==0){
					channelType=ChannelType.World;
				}else if(type==1){
					channelType=ChannelType.System;
				}
				int ret=game.getChannel().SendMsg(channelType, 0, 0, "", content);
				outJson(response, "success");
			}
		}catch(Exception e){
			gmLog("sendWorldTalk", e);
			outJson(response, "failure");
		}
	}
%>