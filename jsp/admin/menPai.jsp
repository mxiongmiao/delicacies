<%@page import="com.game5a.xkx2.EffectType"%>
<%@page import="java.util.Map"%>
<%@page import="com.game5a.xkx2.MenpaiData"%>
<%@ page language="java" contentType="text/html;charset=utf-8" pageEncoding="utf-8"%>

<%@ include file="common.jsp" %>

<%
	this.getMenPai(request, response);
%>

<%!
	private void getMenPai(HttpServletRequest request, HttpServletResponse response){
		String pid=request.getParameter("pid");
		int playerId=Integer.valueOf(pid);
		PlayerData player = game.getPlayer(playerId);
		
		MenpaiData menPai=player.getMenpai();

		Table table=new Table();
		List<Tr> trList=new java.util.ArrayList<Tr>();
		
		Tr nameTr=new Tr(new Td(menPai.Name+"("+menPai.Camp.getName()+")"));
		Tr goodValTr=new Tr(new Td("荣誉:"+player.getGoodVal()));
		Tr evilValTr=new Tr(new Td("罪恶:"+player.getEvilVal()));
		trList.add(nameTr);
		trList.add(goodValTr);
		trList.add(evilValTr);
		
		Map<EffectType, Integer> menPaiMap=player.getMenpai().Property;
		
		Tr propertyTr=new Tr(new Td("门派附加属性:"), new Td(""));
		trList.add(propertyTr);
		
		Set<Entry<EffectType, Integer>> entrySet = menPaiMap.entrySet();
		for(Entry<EffectType, Integer> entry:entrySet){
			EffectType key=entry.getKey();
			int val=entry.getValue();
			String desc=EffectType.getDesc(key, 1, val, player.getLevel());
			propertyTr=new Tr(new Td(desc));
			trList.add(propertyTr);
		}
		
		table.setTrList(trList);
		
		outJson(response, table.toString());
	}

%>