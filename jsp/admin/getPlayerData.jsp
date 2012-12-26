<%@page import="com.game5a.xkx2.SceneData"%>
<%@page import="Svc.WCUser"%>
<%@page import="java.util.ArrayList"%>
<%@page import="com.game5a.xkx2.TitleData"%>
<%@ page language="java" contentType="text/html;charset=utf-8" pageEncoding="utf-8"%>

<%@ include file="common.jsp" %>

<%
	this.getPlayerData(request, response);
%>

<%!
	private void getPlayerData(HttpServletRequest request, HttpServletResponse response){
		
		String pid=request.getParameter("pid");
		if(isNullOrEmpty(pid)){
			outJson(response, "pid need");
			return;
		}
		
		int playerId=Integer.valueOf(pid);
		PlayerData player = game.getPlayer(playerId);
		if(player==null){
			outJson(response, "no this player");
			return;
		}
		
		// 标题
		StringBuilder playerDataBuilder=new StringBuilder();
		Table headTable=new Table(new Tr(new Td("<b>玩家基础属性:</b>")));
		playerDataBuilder.append(headTable);
		playerDataBuilder.append(new PageWriter().makeBr());
		
		// 玩家基础数据
		Table playerBaseTable=getBaseData(request, player, game);
		playerDataBuilder.append(playerBaseTable);
		playerDataBuilder.append(new PageWriter().makeBr());
		
		// 其他链接：背包、武功、装备、虎符、门派、帮派、属性、技能
		Table otherLinkTable=getOtherLink(request, response, player, game);
		playerDataBuilder.append(otherLinkTable);

		try{
			outJson(response, playerDataBuilder.toString());
		}catch(Exception e){
			gmLog("getPlayerData", e);
			outJson(response, e.getMessage());
		}
	}

	private Table getBaseData(HttpServletRequest request, PlayerData player, GameData game){
		List<String> datas=new ArrayList<String>();
		
		// 性别等级
        int tid = player.getDefaultTitleId();
        TitleData t = tid > 0 ? game.getTitleList().get(tid) : null;
        String ptitle=t != null ? t.Name : "无";
        boolean isOnline=player.isOnline();
        
        datas.add(0, player.getName()+"("+((player.getGender() == 1)?"男":"女")+","+player.getLevel()+"级, "+(isOnline?"在线":"离线")+")");
        
        datas.add(1, "称号:"+ptitle);
        datas.add(2, "经验:"+player.getExp()+"/"+player.getMaxExp());
        datas.add(3, "生命:"+player.getHealth()+"/"+player.getMaxHealth());
        datas.add(4, "内力:"+player.getMana()+"/"+player.getMaxMana());
        datas.add(5, "攻防:"+player.Attack()+"/"+player.Defence());
        datas.add(6, "声望:"+player.getFameVal());
        datas.add(7, "体力:"+player.getStamina());
        datas.add(8, "魅力:"+player.getCharm());
		String sign=player.getSign();
        datas.add(9, "签名:"+(isNullOrEmpty(sign)?"无":sign));
		String mood=player.getMood();
        datas.add(10, "心情:"+(isNullOrEmpty(mood)?"无":mood));
        datas.add(11, "在线:"+player.getOnlineCurrent()+"/"+player.getTodayOnline()+"/"+player.OnlineTotal);
        datas.add(12, "今日剩余战斗次数:"+(game.getVar().BattleNum-player.getBattleNum()));
        // 状态
        String banDetail="正常";
        boolean isBanTalk=player.isBanTalk();
        boolean isBanLogin=player.isBanLogin();
        if(isBanTalk){
        	banDetail="禁止发言";
        }else if(isBanLogin){
        	banDetail="禁止登录";
        }
        datas.add(13, "状态:"+banDetail);
        
        if(!player.isMarried()){
        	datas.add(14, "配偶:"+"无");
        }else{
        	int mateId=player.MateId;
            PlayerData mate=game.getPlayer(mateId);
            datas.add(14, "配偶:"+mate.getName());
        }
        
        SceneData sceneData=player.getScene();
        String sceneName="";
        if(sceneData!=null){
        	sceneName=sceneData.Name;
        }
        datas.add(15, "当前场景:"+sceneName);
        
      	//客服组长可以查看渠道帐号
      	String stype=request.getParameter("stype");
      	if(stype==null||stype.trim().equals("")){
      		stype="0";
      	}
   		int type=Integer.valueOf(stype);
   		String account="";
        if(type==1){
        	account=getAccount(player);
        }
       	datas.add(16, "渠道帐号:"+account);
        
        Tr tr0=new Tr(new Td(datas.get(0), "colspan=\"4\""));
		List<Tr> trList=new ArrayList<Tr>();
		trList.add(tr0);
		
		int i=1;
		int num=datas.size();
		while(i<=num-2){
			Td td0=new Td(datas.get(i));
			Td td1=new Td(datas.get(i+1));
			Tr tr=new Tr(td0, td1);
			trList.add(tr);
			i=i+2;
		}
		Table table=new Table(trList);
		
		return table;
	}
	
	@SuppressWarnings({ "unchecked" })
	private Table getOtherLink(HttpServletRequest request, HttpServletResponse response, PlayerData player, GameData game){
		List tdList=new ArrayList<Td>();
		
		String packHref=absolutePath+"pack.jsp?pid="+player.getId();
		Td pack=new Td(new PageWriter().makeLink(packHref, "背包"));
		tdList.add(pack);
		
		String kungfuHref=absolutePath+"kungfu.jsp?pid="+player.getId();
		Td kungfu=new Td(new PageWriter().makeLink(kungfuHref, "武功"));
		tdList.add(kungfu);
		
		String equipHref=absolutePath+"equip.jsp?pid="+player.getId();
		Td equip=new Td(new PageWriter().makeLink(equipHref, "装备"));
		tdList.add(equip);
		
		String totemHref=absolutePath+"totem.jsp?pid="+player.getId();
		Td totem=new Td(new PageWriter().makeLink(totemHref, "虎符"));
		tdList.add(totem);
		
		String menPaiHref=absolutePath+"menPai.jsp?pid="+player.getId();
		Td menPai=new Td(new PageWriter().makeLink(menPaiHref, "门派"));
		tdList.add(menPai);
		
		String factionHref=absolutePath+"faction.jsp?pid="+player.getId();
		Td faction=new Td(new PageWriter().makeLink(factionHref, "帮派"));
		tdList.add(faction);
		
		String attachPropertyHref=absolutePath+"attachProperty.jsp?pid="+player.getId();
		Td attachProperty=new Td(new PageWriter().makeLink(attachPropertyHref, "属性"));
		tdList.add(attachProperty);
		
		String skillHref=absolutePath+"skill.jsp?pid="+player.getId();
		Td skill=new Td(new PageWriter().makeLink(skillHref, "技能"));
		tdList.add(skill);
		
		String privilegeHref=absolutePath+"privilege.jsp?pid="+player.getId();
		Td privilege=new Td(new PageWriter().makeLink(privilegeHref, "特权"));
		tdList.add(privilege);
		
		Table table=new Table();
		List<Tr> trList=new ArrayList<Tr>();
		Tr tr=new Tr(tdList);
		trList.add(tr);
		table.setTrList(trList);
		
		return table;
	}
%>