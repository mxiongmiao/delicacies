<%@ page language="java" contentType="text/html;charset=utf-8" pageEncoding="utf-8"%>

<%@ include file="common.jsp" %>

<%
	this.getPayLog(request, response);
%>

<%!

	@SuppressWarnings("unchecked")
	private void getPayLog(HttpServletRequest request, HttpServletResponse response){
		String payId=request.getParameter("id");
		if(payId==null){
			return;
		}
		
		try {
			String sql = "select payId,payType,payValue,playerId,playerName,partnerCode,agentCode,oid,makeTime from XkxPay where payId > " + payId + " limit " + 30;
			CachedRowSet rs = Lucsky.Db.CreateBySource(dataSourceName).ExecuteQuery(sql);
			
		 	JSONArray jsonArray = new JSONArray();
			while (rs != null && rs.next()) {
				JSONObject jsonObject = new JSONObject();
				jsonObject.put("type", rs.getInt("payType"));
				jsonObject.put("price", rs.getInt("payValue"));
				
				int playerId=rs.getInt("playerId");
				jsonObject.put("uid", rs.getInt("playerId"));
				
				PlayerData p = game.getPlayer(playerId);
				int pLevel=p.getLevel();
				jsonObject.put("level", pLevel);
				
				jsonObject.put("id", rs.getInt("payId"));
				jsonObject.put("dt", rs.getString("makeTime"));
				
				jsonArray.put(jsonObject);
			}
			rs.close();
			
			outJson(response, jsonArray.toString());
		}catch(Exception e){
			gmLog("getPayLog", e);
			outJson(response, e.getMessage());
		}
	}

	enum PayType{
		Null(0), Gold(1), Silver(2), Money(3), Cheque(4);
		
		private int type=0;
		
		PayType(int type){
			this.type=type;
		}
		
		public static PayType parse(int type){
			for(PayType t:PayType.values()){
				if(type==t.getType()){
					return t;
				}
			}
			
			return Null;
		}
		
		public int getType(){
			return this.type;
		}
		
		public String getName(){
			if(type==1){
				return "元宝";
			}
			if(type==2){
				return "金豆";
			}
			if(type==3){
				return "银两";
			}
			if(type==4){
				return "银票";
			}
			return Null.getName();
		}
		
		@Override
		public String toString(){
			return this.getName();
		}
	}
%>