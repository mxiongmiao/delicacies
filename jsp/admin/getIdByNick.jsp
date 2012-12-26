<%@page import="com.game5a.xkx2.Db"%>
<%@page import="java.security.InvalidParameterException"%>
<%@page import="java.util.ArrayList"%>
<%@page import="com.game5a.xkx2.TitleData"%>
<%@ page language="java" contentType="text/html;charset=utf-8" pageEncoding="utf-8"%>

<%@ include file="common.jsp" %>

<%
	this.getIdByNick(request, response);
%>

<%!
	private void getIdByNick(HttpServletRequest request, HttpServletResponse response){
		String data=request.getParameter("data");
		
		try{
			JSONObject  jsonObj = new JSONObject(data);
			if (jsonObj.length()>0) {
				String nick = jsonObj.getString("nick");
				nick=nick.trim();
				int playerId = Db.create().GetPlayerId(nick);
				if(playerId==0){
					outJson(response, "no user "+nick);
					return;
				}
				
				String href=absolutePath+"getPlayerData.jsp?pid="+playerId;
				String link=new PageWriter().makeLink(href, playerId+"");
				
				Table table=new Table();
				List<Tr> trList=new ArrayList<Tr>();
				Tr tr=new Tr(new Td(link));
				trList.add(tr);
				table.setTrList(trList);
				
				outJson(response, table.toString());
			}
		}catch(Exception e){
			gmLog("getIdByNick", e);
			outJson(response, e.getMessage());
		}
	}
	
%>