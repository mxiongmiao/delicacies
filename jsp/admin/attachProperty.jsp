<%@page import="com.game5a.xkx2.EffectType"%>
<%@page import="com.game5a.xkx2.EffectData"%>
<%@page import="java.util.Map"%>
<%@ page language="java" contentType="text/html;charset=utf-8" pageEncoding="utf-8"%>

<%@ include file="common.jsp" %>

<%
	this.getAttachProperty(request, response);
%>

<%!
	// 获取附加属性： 临时、永久、活动
	private void getAttachProperty(HttpServletRequest request, HttpServletResponse response){
		String pid=request.getParameter("pid");
		int playerId=Integer.valueOf(pid);
		PlayerData player = game.getPlayer(playerId);
		
		StringBuffer buffer=new StringBuffer();
		
		//临时附加属性
		List<EffectData> tempEffects=player.EffectList.GetListE();
		if(tempEffects!=null&&!tempEffects.isEmpty()){
			Table tempTable=new Table();
			List<Tr> tempTRList=new java.util.ArrayList<Tr>();
			tempTRList.add(new Tr(new Td("<b>临时附加属性("+tempEffects.size()+"):</b>")));
			
			for (EffectData e : tempEffects){
				String desc=EffectType.getDesc(e.Key, e.Val, 0, 0);
				String remain=e.RemainString();
				tempTRList.add(new Tr(new Td(desc+":剩余"+remain)));
			}
			
			tempTable.setTrList(tempTRList);
			buffer.append(tempTable);
		}
		
		//永久附加属性
		List<EffectData> foreverEffects=player.EffectList.GetListF();
		if(foreverEffects!=null&&!foreverEffects.isEmpty()){
			Table foreverTable=new Table();
			List<Tr> foreverTRList=new java.util.ArrayList<Tr>();
			foreverTRList.add(new Tr(new Td("<b>永久附加属性("+foreverEffects.size()+"):</b>")));
			
			for (EffectData e : foreverEffects){
				String desc=EffectType.getDesc(e.Key, e.Val, 0, 0);
				foreverTRList.add(new Tr(new Td(desc)));
			}
			
			foreverTable.setTrList(foreverTRList);
			buffer.append(foreverTable);
		}
		
		//活动附加属性
		List<EffectData> eventsEffects=game.getEffectList().GetListF();
		if(eventsEffects!=null&&!eventsEffects.isEmpty()){
			Table eventsTable=new Table();
			List<Tr> eventsTRList=new java.util.ArrayList<Tr>();
			eventsTRList.add(new Tr(new Td("<b>活动附加属性("+eventsEffects.size()+"):</b>")));
			
			for (EffectData e : eventsEffects){
				String desc=EffectType.getDesc(e.Key, e.Val, 0, 0);
				eventsTRList.add(new Tr(new Td(desc)));
			}
			
			eventsTable.setTrList(eventsTRList);
			buffer.append(eventsTable);
		}
		
		if(buffer.length()==0){
			buffer.append("暂无附加属性");
		}
		
		outJson(response, buffer.toString());
	}

%>