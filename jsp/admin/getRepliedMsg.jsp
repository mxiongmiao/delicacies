<%@ page language="java" contentType="text/html;charset=utf-8" pageEncoding="utf-8"%>

<%@ include file="common.jsp" %>

<%
	this.getRepliedMsg(request, response);
%>

<%!
	@SuppressWarnings("unchecked")
	private void getRepliedMsg(HttpServletRequest request, HttpServletResponse response){
		String msgId=request.getParameter("msgId");
		if(msgId==null){
			return;
		}
		
		try {
			String sql = "select msgId,playerId,name,msgContent,msgTime,msgState,gmId,opName,rpyContent,rpyTime from XkxGmMsg as xg left join XkxPlayer as xp on xg.playerId = xp.id where msgState=1 and msgId > " + msgId + " limit " + 20;
			CachedRowSet rs = Lucsky.Db.CreateBySource(dataSourceName).ExecuteQuery(sql);
			
		 	JSONArray jsonArray = new JSONArray();
			while (rs != null && rs.next()) {
				int playerId=rs.getInt("playerId");
				PlayerData p = game.getPlayer(playerId);
				if (p == null){
					continue;
				}
				
				JSONObject jsonObject = new JSONObject();
				jsonObject.put("id", rs.getString("msgId"));
				jsonObject.put("uid", playerId+"");
				jsonObject.put("msg", rs.getString("msgContent"));
				jsonObject.put("dt",rs.getString("msgTime"));
				jsonObject.put("nick",rs.getString("name"));
				jsonObject.put("vip_level",p.getVipLevel()+"");
				jsonObject.put("reply_msg",rs.getString("rpyContent"));
				jsonObject.put("dt_reply",rs.getString("rpyTime"));
				
				jsonArray.put(jsonObject);
			}
			rs.close();
			
			outJson(response, jsonArray.toString());
		}catch(Exception e){
			gmLog("getRepliedMsg", e);
			outJson(response, e.getMessage());
		}
	}
%>