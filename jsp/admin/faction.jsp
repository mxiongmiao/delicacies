<%@page import="com.game5a.xkx2.EffectType"%>
<%@page import="java.util.ArrayList"%>
<%@page import="com.game5a.xkx2.FactionEffectData"%>
<%@page import="com.game5a.xkx2.CampType"%>
<%@page import="com.game5a.xkx2.FactionSettingData"%>
<%@page import="com.game5a.xkx2.FactionOfferData"%>
<%@page import="com.game5a.xkx2.FactionMemberData"%>
<%@page import="com.game5a.xkx2.FactionData"%>
<%@ page language="java" contentType="text/html;charset=utf-8" pageEncoding="utf-8"%>

<%@ include file="common.jsp" %>

<%
	this.getFaction(request, response);
%>

<%!
	private void getFaction(HttpServletRequest request, HttpServletResponse response){
		String pid=request.getParameter("pid");
		int playerId=Integer.valueOf(pid);
		PlayerData player = game.getPlayer(playerId);
		
		FactionData faction=player.getFaction();
		if(faction==null){
			outJson(response, "未加入帮派");
			return;
		}
		
		int factionLevel=faction.Level;
		FactionMemberData factionMemberData = game.getFactionIns().GetFactionMember(playerId);
		FactionOfferData factionExploit = player.getFactionExploit();
		FactionOfferData factionConstruct = player.getFactionConstruct();
		
		// 获取帮派附加属性
		FactionSettingData factionSettingData=game.getFactionSetting(factionLevel);
		CampType camp=faction.Camp;
		StringBuilder effectBuilder=new StringBuilder();
		List<FactionEffectData> factionEffectList=new ArrayList<FactionEffectData>();
		if(camp==CampType.Bright){
			factionEffectList=factionSettingData.BrightEffects;
		}else{
			factionEffectList=factionSettingData.FallenEffects;
		}
		if(factionEffectList!=null&&!factionEffectList.isEmpty()){
			for (FactionEffectData f : factionEffectList){
				String effect=EffectType.getDesc(f.Key, f.Val, 0, 0);
				effectBuilder.append(effect).append(", ");
			}
		}

		Table table=new Table();
		List<Tr> trList=new java.util.ArrayList<Tr>();
		Tr nameTr=new Tr(new Td(faction.Name+"("+factionLevel+")"));
		Tr officerNameTr=new Tr(new Td("身份："+factionMemberData.FactionOfficerName()));
		Tr titleTr=new Tr(new Td("称号："+factionMemberData.Title));
		Tr exploitTr=new Tr(new Td("帮派贡献："+factionExploit.Val+"(本周："+factionExploit.Toweek+",累计："+factionExploit.Total+")"));
		Tr constructTr=new Tr(new Td("帮派建设："+factionConstruct.Val+"(本周："+factionConstruct.Toweek+",累计："+factionConstruct.Total+")"));
		Tr effectTr=new Tr(new Td("帮派附加属性："+(effectBuilder.length()==0?"无":effectBuilder.toString())));
		trList.add(nameTr);
		trList.add(officerNameTr);
		trList.add(titleTr);
		trList.add(exploitTr);
		trList.add(constructTr);
		trList.add(effectTr);
		table.setTrList(trList);
		
		outJson(response, table.toString());
	}

%>