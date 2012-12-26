<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%@ include file="common.jsp" %>

<%
	this.getYesterdayCoinCost(request, response);
%>

<%!
	private void getYesterdayCoinCost(HttpServletRequest request, HttpServletResponse response) {
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
		
		Calendar calendar = Calendar.getInstance();
		calendar.add(Calendar.DATE, -1);
		Date yesterDay = calendar.getTime();
		String yesterDayStr = yyyyMMdd.format(yesterDay);
		String fileName="Shop_"+yesterDayStr+".log";
		File f = new File(path+fileName);
		if(!f.exists()){
			return;
		}
		
		// <VMTypeVal-itemName,totalCost>
		Map<String, Long> captionCostMap=new HashMap<String, Long>();
		String line="";
		BufferedReader br=null;
		try{
			br = new BufferedReader(new InputStreamReader(new FileInputStream(f), "utf-8"));
			
	    	while((line=br.readLine())!=null){
	    		String[] split = line.split(",");
	    		int len=split.length;
	    		if(len<9||len>10){
	    			continue;
	    		}
	    		
	    		String costTime=split[0];
	    		String itemId=split[3];
	    		String itemName=split[4];
	    		String itemCount=split[5];
	    		String vMTypeStrVal=split[6];
	    		String cost=split[7];
	    		
	    		boolean isNullOrEmpty=isNullOrEmpty(costTime, itemId, itemName, vMTypeStrVal, cost);
	    		if(isNullOrEmpty){
	    			continue;
	    		}
	    		
	    		vMTypeStrVal=vMTypeStrVal.trim();
	    		if(vMTypeStrVal.equals("1") || vMTypeStrVal.equals("3")){
	    			int vmTypeVal=Integer.valueOf(vMTypeStrVal);
	        		String caption=vmTypeVal+"-"+itemName.trim();
	        		Long costSum=captionCostMap.get(caption);
	        		if(costSum==null){
	        			costSum=0L;
	        		}
	        		costSum+=Long.valueOf(cost);
	        		captionCostMap.put(caption, costSum);
	    		}
	    	}
		}catch(Exception e){
			;
		}finally{
			close(br);
		}
		
		if(captionCostMap.isEmpty()){
			return;
		}
		
		Map<String, String> vMTypeValNameMap = new HashMap<String, String>();
		vMTypeValNameMap.put(1+"", "元宝");
		vMTypeValNameMap.put(3+"", "金豆");
		
		JSONArray jsonArray = new JSONArray();
		Set<Entry<String, Long>> entrySet=captionCostMap.entrySet();
		
		try{
			for(Entry<String, Long> entry:entrySet){
				String price=entry.getValue()+"";
				String key=entry.getKey();
				String[] kSplit=key.split("-");
				String vmVal=kSplit[0];
				String iName=kSplit[1];
				
				String vmTypeName=vMTypeValNameMap.get(vmVal);
				String caption=vmTypeName+"-"+iName;
				
				JSONObject jsonObject = new JSONObject();
				jsonObject.put("price", price);
				jsonObject.put("caption", caption);
				jsonArray.put(jsonObject);
			}
		}catch(JSONException e){
			;
		}
		
		outJson(response, jsonArray.toString());
	}
%>