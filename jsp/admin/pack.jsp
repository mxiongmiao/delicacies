<%@ page language="java" contentType="text/html;charset=utf-8" pageEncoding="utf-8"%>

<%@ page import="com.game5a.xkx2.ItemSetData"%>
<%@ page import="com.game5a.xkx2.ItemType"%>
<%@ page import="com.game5a.xkx2.ItemUnitData"%>
<%@ page import="com.game5a.xkx2.ItemData"%>


<%@ include file="common.jsp" %>

<%
	this.getPack(request, response);
%>

<%!
	private void getPack(HttpServletRequest request, HttpServletResponse response){
		String pid=request.getParameter("pid");
		int playerId=Integer.valueOf(pid);
		PlayerData player = game.getPlayer(playerId);
		ItemSetData itemSetData = player.getPackage();
		List<ItemUnitData> itemUnitDataList=itemSetData.GetList();
		
		Table head=new Table();
		List<Tr> hTrList=new java.util.ArrayList<Tr>();
		Tr left=new Tr(new Td("空余:"+(itemSetData.Total()-itemSetData.Count())+"/"+itemSetData.Total()));
		Tr money=new Tr(new Td("银两:"+player.getMoney()));
		Tr cheque=new Tr(new Td("银票:"+player.getCheque()));
		Tr deposit=new Tr(new Td("钱庄:"+player.getDeposit()));
		hTrList.add(left);
		hTrList.add(money);
		hTrList.add(cheque);
		hTrList.add(deposit);
		head.setTrList(hTrList);
		
		Table body=new Table();
		List<Tr> bTrList=new java.util.ArrayList<Tr>();
		bTrList.add(new Tr(new Td("--------------")));
		for(ItemUnitData itemUnitData : itemUnitDataList){
			ItemData itemData=itemUnitData.Item;
			String itemName=itemData.Name+"";
			boolean isBinding=itemUnitData.IsBinding;
			String itemCount=itemUnitData.Count+"";
			Tr line=new Tr(new Td(itemName+(isBinding?"(绑)":"")+"x"+itemCount));
			bTrList.add(line);
		}
		body.setTrList(bTrList);
		
		StringBuffer buffer = new StringBuffer();
		buffer.append(head);
		buffer.append(body);
		
		outJson(response, buffer.toString());
	}

%>