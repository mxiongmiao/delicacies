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
	this.factions(request, response);
%>

<%!
	private void factions(HttpServletRequest request, HttpServletResponse response){
		List<FactionData> factions=new ArrayList<FactionData>();
		
		Lucsky.Db db=Lucsky.Db.CreateBySource(dataSourceName);
		String sql="SELECT factionId, factionName, factionDesc, factionTitle, factionMaster, factionLv, camp, fund, salary, credit, pwd, coin, ab, createTime, createPlayer FROM XkxFaction";
		try{
			CachedRowSet rs=db.ExecuteQuery(sql);
			while (rs != null && rs.next()) {
				int factionId=rs.getInt("factionId");
				String factionName=rs.getString("factionName");
				String factionDesc=rs.getString("factionDesc");
				String factionTitle=rs.getString("factionTitle");
				int factionMaster=rs.getInt("factionMaster");
				int factionLv=rs.getInt("factionLv");
				int camp=rs.getInt("camp");
				long fund=rs.getLong("fund");
				long salary=rs.getLong("salary");
				int credit=rs.getInt("credit");
				String pwd=rs.getString("pwd");
				int coin=rs.getInt("coin");
				String ab=rs.getString("ab");
				Date createTime=rs.getDate("createTime");
				int createPlayer=rs.getInt("createPlayer");
				
				FactionData factionData = new FactionData();
				factionData.Id=factionId;
				factionData.Name=factionName;
				factionData.Desc=factionDesc;
				factionData.Title=factionTitle;
				factionData.MasterId=factionMaster;
				factionData.Level=factionLv;
				factionData.Camp=CampType.parse(camp);
				factionData.Fund=fund;
				factionData.Salary=salary;
				factionData.Credit=credit;
				factionData.Pwd=pwd;
				factionData.Coin=coin;
				factionData.MasterId=createPlayer;
				
				factions.add(factionData);
			}
		}catch(Exception e){
			gmLog("factions", e);
			outJson(response, e.getMessage());
			return;
		}
		
		Table table=new Table();
		Tr tr0=new Tr(new Td("id&nbsp;&nbsp;"), new Td("名称"), new Td("等级"), new Td("人数"), new Td("资金"));
		List<Tr> trList=new java.util.ArrayList<Tr>();
		trList.add(tr0);
		
		String dt=request.getParameter("dt");
		String degist=request.getParameter("degist");
		String commonParamStr="?dt="+dt+"&degist="+degist;
		
		for(FactionData factionData:factions){
			Td id=new Td(factionData.Id+"");
			String href="factionData.jsp"+commonParamStr+"&id="+factionData.Id;
			Td Name=(new Td(new PageWriter().makeLink(href, factionData.Name)));
			Td Level=new Td(factionData.Level+"");
			Td Count=new Td(factionData.Count+"");
			Td Fund=new Td(factionData.Fund+"");

			List<Column> columnList=new java.util.ArrayList<Column>();
			columnList.add(0, id);
			columnList.add(1, Name);
			columnList.add(2, Level);
			columnList.add(3, Count);
			columnList.add(4, Fund);
			
			Tr tr=new Tr();
			tr.setColumnList(columnList);
			trList.add(tr);
		}
		table.setTrList(trList);
		
		outJson(response, table.toString());
	}

%>