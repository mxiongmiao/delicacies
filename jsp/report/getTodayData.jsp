<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%@ include file="common.jsp" %>

<%
	this.getTodayData(request, response);
%>

<%!
	private void getTodayData(HttpServletRequest request, HttpServletResponse response) {
		String sid=request.getParameter("sid");
		String path=new GM().getLogPath(sid);
		if(path==null){
			outJson(response, "not exist service, check the params");
			return;
		}
		File file = new File(path);
		if(!file.exists()){
			outJson(response, "no data");
			return;
		}
		
		String todayStr = yyyyMMdd.format(new Date());
		
		String payfileName="Pay_"+todayStr+".log";
		String onelineFileName="Online_"+todayStr+".log";
		String partnerFileName="Partner_"+todayStr+".log";
		
		File payFile = new File(path+payfileName);
		File onlineFile = new File(path+onelineFileName);
		File partnerFile = new File(path+partnerFileName);
		
		long income=0;
		long onlineNum=0L;
		long regNum=0L;
		Set<String> allPayPlayers=new HashSet<String>();
		
		// 计算收入和充值玩家数
		if(payFile.exists()){
			BufferedReader br = null;
			try{
				br = new BufferedReader(new InputStreamReader(new FileInputStream(payFile), "utf-8"));
				String line="";
				
				while((line=br.readLine())!=null){
		    		String[] split = line.split(",");
		    		int len=split.length;
		    		if(len!=9){
		    			continue;
		    		}
		    		
		    		boolean paySuccess=Integer.valueOf(split[4])==1?true:false;
		    		if(!paySuccess){
		    			continue;
		    		}
		    		
		    		int money=Integer.valueOf(split[3]);
		    		income+=money;
		    		String playerId=split[1];
		    		allPayPlayers.add(playerId);
		    	}
			}catch(Exception e){
				;
			}finally{
				close(br);
			}
		}
		
		// 计算当前在线人数
		if(onlineFile.exists()){
			BufferedReader br=null;
			try{
				br = new BufferedReader(new InputStreamReader(new FileInputStream(onlineFile), "utf-8"));
				String line="";
				
		    	String lastLine="";
		    	while((line=br.readLine())!=null){
		    		lastLine=line;
		    	}
		    	
		    	String[] split = lastLine.split(",");
		    	int len=split.length;
		    	if(len==2){
			    	onlineNum=Long.valueOf(split[1]);
		    	}
			}catch(Exception e){
				;
			}finally{
				close(br);
			}
		}
		
		// 计算今天注册人数
		if(partnerFile.exists()){
			Set<String> regSet=new HashSet<String>();
			BufferedReader br=null;
			try{
				br = new BufferedReader(new InputStreamReader(new FileInputStream(partnerFile), "utf-8"));
				String line="";
				
				while((line=br.readLine())!=null){
		    		String[] split = line.split(",");
		    		int len=split.length;
		    		if(len!=5){
		    			continue;
		    		}
		    		String pid=split[1];
		    		regSet.add(pid);
		    	}
				regNum=regSet.size();
			}catch(Exception e){
				;
			}finally{
				close(br);
			}
		}
		
		try{
			JSONObject jsonObject = new JSONObject();
			jsonObject.put("income", (long)getYuan(income));
			jsonObject.put("pay_wj_num", allPayPlayers.size());
			jsonObject.put("cu", onlineNum);
			jsonObject.put("reg_num", regNum);
			outJson(response, jsonObject);
		}catch(JSONException e){
			;
		}
	}
%>