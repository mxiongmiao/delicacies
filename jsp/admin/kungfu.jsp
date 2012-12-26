<%@page import="com.game5a.xkx2.RpgType"%>
<%@page import="com.game5a.xkx2.ForceData"%>
<%@page import="com.game5a.xkx2.ForceUnitData"%>
<%@page import="com.game5a.xkx2.SkillData"%>
<%@page import="com.game5a.xkx2.SkillUnitData"%>
<%@ page language="java" contentType="text/html;charset=utf-8" pageEncoding="utf-8"%>

<%@ include file="common.jsp" %>

<%
	this.getKungFu(request, response);
%>

<%!
	private void getKungFu(HttpServletRequest request, HttpServletResponse response){
		String pid=request.getParameter("pid");
		int playerId=Integer.valueOf(pid);
		PlayerData player = game.getPlayer(playerId);
		List<SkillUnitData> skillSetDataList=player.Skill.GetList();
		
		StringBuffer buffer = new StringBuffer();
		
		Table tHead=new Table();
		List<Tr> hTrList=new java.util.ArrayList<Tr>();
		Tr point=new Tr(new Td("潜能:"), new Td(player.getPoint()+"/"+player.getMaxPoint()));
		hTrList.add(point);
		tHead.setTrList(hTrList);
		
		// 武功
		Table wuGong=new Table();
		List<Tr> bTrList=new java.util.ArrayList<Tr>();
		bTrList.add(new Tr(new Td("武功：")));
		for(SkillUnitData skillUnitData : skillSetDataList){
			SkillData skillData=skillUnitData.Skill;
			String active="";
			int state=skillUnitData.State;
			if(state==0){
				active="未激活";
			}else if(state==1){
				active="已激活";
			}
			String skillName=skillData.Name+"";
			int level=skillUnitData.Level;
			Tr line=new Tr(new Td(skillName +"&nbsp;&nbsp;"+ level+"级&nbsp;&nbsp;"+active));
			bTrList.add(line);
		}
		bTrList.add(new Tr(new Td("-----------------------")));
		wuGong.setTrList(bTrList);
		buffer.append(tHead);
		buffer.append(wuGong);
		
		// 内功
		Table neiGong=new Table();
		List<Tr> nGbTrList=new java.util.ArrayList<Tr>();
		nGbTrList.add(new Tr(new Td("内功：")));
		List<ForceUnitData> forceList=player.Force.GetList();
		for(ForceUnitData f:forceList){
			ForceData forceData=f.Force;
			String active="";
			int state=f.State;
			if(state==0){
				active="未激活";
			}else if(state==1){
				active="已激活";
			}
			String forceName=forceData.Name+"";
			int level=f.Level;
			Tr line=new Tr(new Td(forceName+"&nbsp;&nbsp;"+level+"级&nbsp;&nbsp;"+active));
			nGbTrList.add(line);
		}
		nGbTrList.add(new Tr(new Td("-----------------------")));
		neiGong.setTrList(nGbTrList);
		buffer.append(neiGong);
		
		// 武功附加等级、内功等级上限
		Table other=new Table();
		List<Tr> otherTrList=new java.util.ArrayList<Tr>();
		if(player.getLevel()>=200){
			int vs = player.getRpg(RpgType.Vajra);
        	if (vs >= 3){
        		Tr tr=new Tr(new Td("武功附加等级:"+player.getSkillLvExt()));
        		otherTrList.add(tr);
        	}
		}
		otherTrList.add(new Tr(new Td("其他：")));
		otherTrList.add(new Tr(new Td("内功等级上限:"+player.getForceLvMax())));
		other.setTrList(otherTrList);
		buffer.append(other);
		
		outJson(response, buffer.toString());
	}

%>