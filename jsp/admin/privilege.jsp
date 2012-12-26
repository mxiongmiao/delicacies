<%@page import="com.game5a.xkx2.PrivilegeData"%>
<%@page import="java.util.Map"%>
<%@ page language="java" contentType="text/html;charset=utf-8" pageEncoding="utf-8"%>

<%@ include file="common.jsp" %>

<%
	this.privilege(request, response);
%>

<%!
	private void privilege(HttpServletRequest request, HttpServletResponse response){
		String pid=request.getParameter("pid");
		int playerId=Integer.valueOf(pid);
		PlayerData player = game.getPlayer(playerId);
		
		Table table=new Table();
		List<Tr> trList=new ArrayList<Tr>();
		
		Map<Integer, Integer> map=player.getPrivilegeList();
		if(map!=null&&!map.isEmpty()){
			for(Entry<Integer, Integer> p : map.entrySet()){
				int id = p.getKey();
				PrivilegeData privilege = game.getPrivilegeList().get(id);
				trList.add(new Tr(new Td(privilege.Name+"("+privilege.Lv+")")));
			}
		}
		
		if(player.isVip()){
			String vipName=game.getVip().Name;
			int vipLv=player.getVipLevel();
			trList.add(new Tr(new Td(vipName+"("+vipLv+")")));
		}
		
		table.setTrList(trList);
		outJson(response, table.toString());
	}
%>