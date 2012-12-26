<%@ page language="java" contentType="text/html;charset=utf-8" pageEncoding="utf-8"%>

<%@ include file="common.jsp" %>

<%
	this.sendBanPlayerMsg(request, response);
%>

<%!
	private void sendBanPlayerMsg(HttpServletRequest request, HttpServletResponse response){
		String data=request.getParameter("data");
		
		try{
			JSONObject  jsonObj = new JSONObject(data);
			if (jsonObj.length()>0) {
				String uid = jsonObj.getString("uid");
				String operType = jsonObj.getString("type");
				String endTime = jsonObj.getString("endTime");
				String reason = jsonObj.getString("content");
				String operUserId = jsonObj.getString("user_id");
				
				int playerId=Integer.valueOf(uid);
				PlayerData player=game.getPlayer(playerId, false);
				
				if(operType.equals("1")){
					// 封号
					Date banTime=new SimpleDateFormat("yyyy-MM-dd HH:mm:ss").parse(endTime);
					// 截至这个时间前禁止登录
					player.setBanLoginTime(banTime);
				}else if(operType.equals("0")){
					// 解封
					Date before=DateTime.AddMonths(Calendar.getInstance().getTime(), -10);
					player.setBanLoginTime(before);
				}
				outJson(response, "success");
			}
		}catch(Exception e){
			gmLog("sendBanPlayerMsg", e);
			outJson(response, "failure");
		}
	}
%>