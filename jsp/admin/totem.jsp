<%@page import="com.game5a.xkx2.ItemType"%>
<%@page import="com.game5a.xkx2.ItemData"%>
<%@page import="com.game5a.xkx2.ItemSetData"%>
<%@page import="com.game5a.xkx2.ItemLocationType"%>
<%@page import="com.game5a.xkx2.EquipItemData"%>
<%@ page language="java" contentType="text/html;charset=utf-8" pageEncoding="utf-8"%>

<%@ page import="com.game5a.xkx2.SkillData"%>
<%@ page import="com.game5a.xkx2.SkillSetData"%>
<%@ page import="com.game5a.xkx2.ItemUnitData"%>


<%@ include file="common.jsp" %>

<%
	this.getTotem(request, response);
%>

<%!
	private void getTotem(HttpServletRequest request, HttpServletResponse response){
		String pid=request.getParameter("pid");
		int playerId=Integer.valueOf(pid);
		PlayerData player = game.getPlayer(playerId);

		//已装备虎符
		ItemSetData itemSetData = player.Totem;
		List<ItemUnitData> itemUnitDataList=itemSetData.GetList();
		Table table=new Table();
		List<Tr> trList=new java.util.ArrayList<Tr>();
		trList.add(new Tr(new Td("已装备:")));
		for(ItemUnitData iu:itemUnitDataList){
			ItemData itemData=iu.Item;
			String itemName=itemData.Name;
			int itemCount=iu.Count;
			Tr tr=new Tr(new Td(itemName+"&nbsp;&nbsp;x"+itemCount));
			trList.add(tr);
		}
		trList.add(new Tr(new Td("-------------------")));
		trList.add(new Tr(new Td("未装备:")));
		
		// 未装备虎符
		List<ItemUnitData> itemList = player.getPackage().GetList(ItemType.Totem);
		for(ItemUnitData iu:itemList){
			ItemData itemData=iu.Item;
			String itemName=itemData.Name;
			int itemCount=iu.Count;
			Tr tr=new Tr(new Td(itemName+"&nbsp;&nbsp;x"+itemCount));
			trList.add(tr);
		}
		
		table.setTrList(trList);
		
		outJson(response, table.toString());
	}

%>