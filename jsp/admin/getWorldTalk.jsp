<%@ page language="java" contentType="text/html;charset=utf-8" pageEncoding="utf-8"%>

<%@ include file="common.jsp" %>

<%
	this.getWorldTalk(request, response);
%>

<%!
	@SuppressWarnings("unchecked")
	private void getWorldTalk(HttpServletRequest request,  HttpServletResponse response){
		String data=request.getParameter("data");
		CachedRowSet rs=null;
		try{
			JSONObject jsonObj = new JSONObject(data);
			if (jsonObj.length()>0) {
				int type = jsonObj.getInt("type");
				int mainCode=0;
				if(type==0){
					// 获取世界喊话
					mainCode=4;
				}else if(type==1){
					// 获取广播（置顶喊话）
					mainCode=3;
				}
				
				if(mainCode==0){
					// FIXME 单独指定异常目录， 或者不抛异常
					outJson(response, "check ur param 'type', it should be 0 or 1");
					return;
				}
				
				String sql = "select playerId,playerName,messageContent,makeTime from XkxChannelMsg where channelId in(select channelId from XkxChannelInfo where mainCode="+mainCode+" and maskCode=0) order by makeTime desc limit 100";
				String dataSourceName="java:comp/env/jdbc/Xkx2";
				rs = Lucsky.Db.CreateBySource(dataSourceName).ExecuteQuery(sql);
				
				JSONArray jsonArray = new JSONArray();
				while (rs != null && rs.next()) {
					int playerId=rs.getInt("playerId");
					PlayerData p = game.getPlayer(playerId);
					if (p == null){
						continue;
					}
					JSONObject jsonObject = new JSONObject();
					jsonObject.put("dt",rs.getString("makeTime"));
					jsonObject.put("uid",rs.getString("playerId"));
					jsonObject.put("nick", rs.getString("playerName"));
					jsonObject.put("info",rs.getString("messageContent"));
					jsonArray.put(jsonObject);
				}
				
				outJson(response, jsonArray.toString());
			}
		}catch(Exception e){
			gmLog("getWorldTalk", e);
			outJson(response, e.getMessage());
		}finally{
			if(rs!=null){
				try{
					rs.close();
				}catch(SQLException e){
					rs=null;
					outJson(response, e.getMessage());
				}
			}
		}
	}
%>