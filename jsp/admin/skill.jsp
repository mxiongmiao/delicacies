<%@page import="com.game5a.xkx2.SettingType"%>
<%@ page language="java" contentType="text/html;charset=utf-8" pageEncoding="utf-8"%>

<%@ include file="common.jsp" %>

<%
	this.getSkill(request, response);
%>

<%!
	private void getSkill(HttpServletRequest request, HttpServletResponse response){
		String pid=request.getParameter("pid");
		int playerId=Integer.valueOf(pid);
		PlayerData player = game.getPlayer(playerId);

		Table table=new Table();
		List<Tr> trList=new java.util.ArrayList<Tr>();
		
		int enhanceSkillLevel = player.getSetting(SettingType.SkillIntensify);
		String enhanceSkillDesc = GameData.getSkillLvName(enhanceSkillLevel);
		Tr enhanceSkillTr=new Tr(new Td("强化："+enhanceSkillDesc+"("+enhanceSkillLevel+")"));
		trList.add(enhanceSkillTr);
		
		int combineSkillLevel = player.getSetting(SettingType.SkillSynth);
		String combineSkillDesc = GameData.getSkillLvName(combineSkillLevel);
		Tr combineSkillTr=new Tr(new Td("合成："+combineSkillDesc+"("+combineSkillLevel+")"));
		trList.add(combineSkillTr);
		
		int mineSkillLevel = player.getSetting(SettingType.SkillMine);
		String mineSkillDesc = GameData.getSkillLvName(mineSkillLevel);
		Tr mineSkillTr=new Tr(new Td("挖矿："+mineSkillDesc+"("+mineSkillLevel+")"));
		trList.add(mineSkillTr);
		
		table.setTrList(trList);
		
		outJson(response, table.toString());
	}

%>