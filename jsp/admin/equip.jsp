<%@page import="com.game5a.xkx2.ItemUnitData"%>
<%@page import="com.game5a.xkx2.ItemType"%>
<%@page import="com.game5a.xkx2.ItemLocationType"%>
<%@page import="com.game5a.xkx2.EquipItemData"%>
<%@ page language="java" contentType="text/html;charset=utf-8" pageEncoding="utf-8"%>

<%@ include file="common.jsp" %>

<%
	this.getEquip(request, response);
%>

<%!
	private void getEquip(HttpServletRequest request, HttpServletResponse response){
		String pid=request.getParameter("pid");
		int playerId=Integer.valueOf(pid);
		PlayerData player = game.getPlayer(playerId);

		Table table=new Table();
		List<Tr> hTrList=new java.util.ArrayList<Tr>();
		hTrList.add(new Tr(new Td("攻击:"+player.Attack())));
		hTrList.add(new Tr(new Td("防御:"+player.Defence())));
		hTrList.add(new Tr(new Td("---------------")));
		hTrList.add(new Tr(new Td("已装备")));
		
		ItemUnitData weaponItem=player.WeaponItem;
		ItemUnitData armorItem=player.ArmorItem;
		ItemUnitData necklaceItem=player.NecklaceItem;
		ItemUnitData bootItem=player.BootItem;
		ItemUnitData bracerItem=player.BracerItem;
		
		if(weaponItem!=null){
			EquipItemData weapon = (EquipItemData)weaponItem.Item;
			Tr weaponTr=new Tr(new Td("武器:"+weapon.Name+"&nbsp;&nbsp;攻+"+weapon.Attack()+"&nbsp;&nbsp;防+"+weapon.Defence()));
			hTrList.add(weaponTr);
		}
		if(armorItem!=null){
			EquipItemData armor = (EquipItemData)armorItem.Item;
			Tr armorTr=new Tr(new Td("护甲:"+armor.Name+"&nbsp;&nbsp;攻+"+armor.Attack()+"&nbsp;&nbsp;防+"+armor.Defence()));
			hTrList.add(armorTr);
		}
		if(necklaceItem!=null){
			EquipItemData necklace = (EquipItemData)necklaceItem.Item;
			Tr necklaceTr=new Tr(new Td("项链:"+necklace.Name+"&nbsp;&nbsp;攻+"+necklace.Attack()+"&nbsp;&nbsp;防+"+necklace.Defence()));
			hTrList.add(necklaceTr);
		}
		if(bootItem!=null){
			EquipItemData boot = (EquipItemData)bootItem.Item;
			Tr bootTr=new Tr(new Td("鞋子:"+boot.Name+"&nbsp;&nbsp;攻+"+boot.Attack()+"&nbsp;&nbsp;防+"+boot.Defence()));
			hTrList.add(bootTr);
		}
		if(bracerItem!=null){
			EquipItemData bracer = (EquipItemData)bracerItem.Item;
			Tr bracerTr=new Tr(new Td("护腕:"+bracer.Name+"&nbsp;&nbsp;攻+"+bracer.Attack()+"&nbsp;&nbsp;防+"+bracer.Defence()));
			hTrList.add(bracerTr);
		}
		
		hTrList.add(new Tr(new Td("---------------")));
		hTrList.add(new Tr(new Td("未装备:")));
		
		List<ItemUnitData> itemList = player.getPackage().GetList(ItemType.Equip);
		for(ItemUnitData iu:itemList){
			hTrList.add(new Tr(new Td(iu.Name())));
		}
		table.setTrList(hTrList);
		
		outJson(response, table.toString());
	}

%>