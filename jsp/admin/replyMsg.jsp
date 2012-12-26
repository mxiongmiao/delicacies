<%@ page language="java" contentType="text/html;charset=utf-8" pageEncoding="utf-8"%>

<%@ include file="common.jsp" %>
	
<% 
	this.replyMsg(request, response);
%>

<%!
	private void replyMsg(HttpServletRequest request, HttpServletResponse response){
		String data="";
		try {
			request.setCharacterEncoding("utf-8");
			data=request.getParameter("data");
			if(data==null||data.isEmpty()){
				return;
			}
			
			JSONObject jsonObj = new JSONObject(data);
			if (jsonObj.length()>0) {
				int id =  jsonObj.getInt("id");
				String reply_msg = jsonObj.getString("reply_msg");
				String reply_user_id = jsonObj.getString("reply_user_id");
				String reply_user_name = jsonObj.getString("reply_user_name");
				
				String dataSourceName="java:comp/env/jdbc/Xkx2";
				String sql="select msgState,playerId from XkxGmMsg where msgId = " + id;
				CachedRowSet rs = Lucsky.Db.CreateBySource(dataSourceName).ExecuteQuery(sql);
				
				if(rs!=null&&rs.size()>0&&rs.next()){
					int msgState=rs.getInt("msgState");
					boolean unReplied=false;
					if(msgState==0){
						unReplied=true;
					}
					if(unReplied){
						String now=DateTime.Now("yyyy-MM-dd HH:mm:ss");
						String updateSQL=String.format("update XkxGmMsg set opName='%s',rpyContent='%s',rpyTime='%s',msgState=%s where msgId=%s", reply_user_name ,reply_msg, now, 1, id);
						Lucsky.Db.CreateBySource(dataSourceName).Execute(updateSQL);
						game.sendOnlineMsg(rs.getInt("playerId"), OnlineMsgType.System, 0,"你发给客服的留言已被回复，请到聊天系统中的客服消息里查看",0);
					}else{
						outJson(response, "are u kidding! it has been replied before!");
					}
				}
				
				rs.close();
			}
		} catch (Exception e) {
			gmLog("replyMsg", e);
			outJson(response, e.getMessage());
		}
	}
%>