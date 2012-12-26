<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%@ include file="common.jsp" %>

<%
	this.getYersterdayData(request, response);
%>

<%!
	private void getYersterdayData(HttpServletRequest request, HttpServletResponse response) {
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
		
		// 昨天
		Calendar calendar = Calendar.getInstance();
		calendar.add(Calendar.DATE, -1);
		Date yesterDay = calendar.getTime();
		String yesterDayStr = yyyy_MM_dd.format(yesterDay);
		String yesterDayStr2 = yyyyMMdd.format(yesterDay);
		
		// 前天
		calendar.add(Calendar.DATE, -1);
		Date qianTian = calendar.getTime();
		String qianTianStr = yyyyMMdd.format(qianTian);
		
		// 7天前
		calendar.add(Calendar.DATE, -6);
		Date qiTian = calendar.getTime();
		String qiTianStr = yyyyMMdd.format(qiTian);
		
		// 30天前
		calendar.add(Calendar.DATE, -24);
		Date sanShiTian = calendar.getTime();
		String sanShiTianStr = yyyyMMdd.format(sanShiTian);
		
		// <玩家Id, 昨日登录次数>, 用来计算登录率
		Map<String, Integer> zuoTianLoginMap = new HashMap<String, Integer>();
		
		
		// 计算 收入、充值玩家数
		long income=0L;
		int yesterdayPayPlayerNum=0;
		String payfileName="Pay_"+yesterDayStr2+".log";
		File payFile=new File(path+payfileName);
		if(payFile.exists()){
			BufferedReader br=null;
			try{
				br = new BufferedReader(new InputStreamReader(new FileInputStream(payFile), "utf-8"));
				String line="";
				Set<String> allPayPlayers=new HashSet<String>();
				
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
				yesterdayPayPlayerNum=allPayPlayers.size();
				
			} catch(Exception e){
				;
			} finally{
				close(br);
			}
		}
		
		
		// 计算 付费率、dau、 arpu(当日总收入/当日充值用户数)、昨天登录人次
		double payRate=0.00d;
		int dau=0;
		double arpu=0.00d;
		int zuoTianLoginNum=0;
		
		String yesterdayLoginFileName="Login_"+yesterDayStr2+".log";
		File yesterdayLoginFile=new File(path+yesterdayLoginFileName);
		if(yesterdayLoginFile.exists()){
			BufferedReader br=null;
			try{
				br = new BufferedReader(new InputStreamReader(new FileInputStream(yesterdayLoginFile), "utf-8"));
				String line="";
				while((line=br.readLine())!=null){
		    		String[] split = line.split(",");
		    		int len=split.length;
		    		if(len!=10&&len!=11){
		    			continue;
		    		}
		    		
	    			String playerId=split[1];
	    			String ip=split[4];
	    			String operType=split[6];
		    		
		    		if(operType.equals("login")){
	    				zuoTianLoginNum++;
	    				
		    			Integer num=zuoTianLoginMap.get(playerId);
		    			if(num==null){
		    				num=1;
		    			}else{
		    				num++;
		    			}
	    				zuoTianLoginMap.put(playerId, num);
		    		}
		    	}

				// dau
				dau=zuoTianLoginMap.size();
				if(yesterdayPayPlayerNum==0||dau==0){
					payRate=0.00d;
				} else {
					payRate = 100 * new BigDecimal(yesterdayPayPlayerNum).divide(new BigDecimal(dau), 4, BigDecimal.ROUND_HALF_EVEN).doubleValue();
				}
				
				// arpu
				if(income==0L||yesterdayPayPlayerNum==0){
					arpu=0.00d;
				} else {
					arpu=new BigDecimal(income).divide(new BigDecimal(yesterdayPayPlayerNum), 2, BigDecimal.ROUND_HALF_EVEN).doubleValue();
				}
			}catch(Exception e){
				;
			}finally{
				close(br);
			}
		}
		
		
		// 计算 pcu 和 acu
		long pcu=0L;
		long acu=0L;
		String onelineFileName="Online_"+yesterDayStr2+".log";
		File yesterdayOnlineFile=new File(path+onelineFileName);
		if(yesterdayOnlineFile.exists()){
			long totalOnline=0L;
			long onlineRecordNum=0L;
			
			BufferedReader br=null;
			try{
				br = new BufferedReader(new InputStreamReader(new FileInputStream(yesterdayOnlineFile), "utf-8"));
				String line="";
				while((line=br.readLine())!=null){
		    		String[] split = line.split(",");
					String onlineNum=split[1];
					Long onlineNumLong= Long.valueOf(onlineNum);
					totalOnline+=onlineNumLong;
					if(onlineNumLong>pcu){
						pcu=onlineNumLong;
					}
					onlineRecordNum++;
		    	}
				
				if(totalOnline==0||onlineRecordNum==0){
					acu=0L;
				} else {
					acu=(long)new BigDecimal(totalOnline).divide(new BigDecimal(onlineRecordNum), 4, BigDecimal.ROUND_HALF_EVEN).doubleValue();
				}
			}catch(Exception e){
				;
			}finally{
				close(br);
			}
		}
		
		
		long zuoTianRegNum=0L;
		String partnerFileName="Partner_"+yesterDayStr2+".log";
		File partnerFile=new File(path + partnerFileName);
		if(partnerFile.exists()){
			Set<String> regSet=new HashSet<String>();
			BufferedReader br=null;
			try{
				br = new BufferedReader(new InputStreamReader(new FileInputStream(partnerFile), "utf-8"));
				String line="";
				
				while((line=br.readLine())!=null){
		    		String[] split = line.split(",");
		    		int len=split.length;
		    		if(len>5){
		    			continue;
		    		}
		    		String pid=split[1];
		    		regSet.add(pid);
		    	}
				zuoTianRegNum=regSet.size();
			}catch(Exception e){
				;
			}finally{
				close(br);
			}
		}
		
		// 计算次日登录率. 次日登陆人数(前日注册并昨日登录人数)/前日注册人数
		double ciRiLoginRate=0.00d;
		long qianRiRegAndZuoRiLoginNum=0L;
		String qianRipartnerFileName="Partner_"+qianTianStr+".log";
		File qianRipartnerFile=new File(path + qianRipartnerFileName);
		if(qianRipartnerFile.exists()){
			long qianTianRegNum=0L;
			Set<String> regSet=new HashSet<String>();
			
			BufferedReader br=null;
			try{
				br = new BufferedReader(new InputStreamReader(new FileInputStream(qianRipartnerFile), "utf-8"));
				String line="";
				
				while((line=br.readLine())!=null){
		    		String[] split = line.split(",");
		    		int len=split.length;
		    		if(len>5){
		    			continue;
		    		}
		    		String pid=split[1];
		    		regSet.add(pid);
		    	}
				qianTianRegNum=regSet.size();
			}catch(Exception e){
				;
			}finally{
				close(br);
			}
			
			for(String pid:regSet){
				boolean qianRiRegAndZuoRiLogin=zuoTianLoginMap.containsKey(pid);
				if(qianRiRegAndZuoRiLogin){
					qianRiRegAndZuoRiLoginNum++;
				}
			}
			
			
			if(!(qianRiRegAndZuoRiLoginNum==0L||qianTianRegNum==0L)){
				ciRiLoginRate=100*new BigDecimal(qianRiRegAndZuoRiLoginNum).divide(new BigDecimal(qianTianRegNum), 4, BigDecimal.ROUND_HALF_EVEN).doubleValue();
			}
		}
		
		
		// 计算7日登录率： 昨日的6天前那天注册并昨日登录的人次 / 昨日的 6 天前那天的注册人数
		double qiRiLoginRate=0.00d;
		String qiRipartnerFileName="Partner_"+qiTianStr+".log";
		File qiRipartnerFile=new File(path + qiRipartnerFileName);
		if(qiRipartnerFile.exists()){
			long liuRiQianRegAndZuoRiLoginNum=0L;
			long liuRiQianRegNum=0L;
			Set<String> qiTianRegSet=new HashSet<String>();
			
			BufferedReader br=null;
			try{
				br = new BufferedReader(new InputStreamReader(new FileInputStream(qiRipartnerFile), "utf-8"));
				String line="";
				
				while((line=br.readLine())!=null){
		    		String[] split = line.split(",");
		    		int len=split.length;
		    		if(len>5){
		    			continue;
		    		}
		    		String pid=split[1];
		    		qiTianRegSet.add(pid);
		    	}
				liuRiQianRegNum=qiTianRegSet.size();
			}catch(Exception e){
				;
			}finally{
				close(br);
			}
			
			for(String id:qiTianRegSet){
				boolean liuRiQianRegAndZuoRiLogin=zuoTianLoginMap.containsKey(id);
				if(liuRiQianRegAndZuoRiLogin){
					liuRiQianRegAndZuoRiLoginNum++;
				}
			}
			
			if(!(liuRiQianRegAndZuoRiLoginNum==0L||liuRiQianRegNum==0L)){
				qiRiLoginRate=100*new BigDecimal(liuRiQianRegAndZuoRiLoginNum).divide(new BigDecimal(liuRiQianRegNum), 4, BigDecimal.ROUND_HALF_EVEN).doubleValue();
			}
		}
		
		
		// 计算30日登录率： 昨日的29天前那天注册并昨日登录的人次 / 昨日的 29 天前那天的注册人数
		double sanShiRiLoginRate=0.00d;
		String sanShiRipartnerFileName="Partner_"+sanShiTianStr+".log";
		File sanShiRipartnerFile=new File(path + sanShiRipartnerFileName);
		if(sanShiRipartnerFile.exists()){
			long erShiJiuRiQianRegAndZuoRiLoginNum=0L;
			long erShiJiuRiQianRegNum=0L;
			Set<String> sanShiTianRegSet=new HashSet<String>();
			
			BufferedReader br=null;
			try{
				br = new BufferedReader(new InputStreamReader(new FileInputStream(sanShiRipartnerFile), "utf-8"));
				String line="";
				
				while((line=br.readLine())!=null){
		    		String[] split = line.split(",");
		    		int len=split.length;
		    		if(len>5){
		    			continue;
		    		}
		    		String pid=split[1];
		    		sanShiTianRegSet.add(pid);
		    	}
				erShiJiuRiQianRegNum=sanShiTianRegSet.size();
			}catch(Exception e){
				;
			}finally{
				close(br);
			}
			
			for(String id:sanShiTianRegSet){
				boolean sanShiRiQianRegAndZuoRiLogin=zuoTianLoginMap.containsKey(id);
				if(sanShiRiQianRegAndZuoRiLogin){
					erShiJiuRiQianRegAndZuoRiLoginNum++;
				}
			}
			
			if(!(erShiJiuRiQianRegAndZuoRiLoginNum==0L||erShiJiuRiQianRegNum==0L)){
				sanShiRiLoginRate=100*new BigDecimal(erShiJiuRiQianRegAndZuoRiLoginNum).divide(new BigDecimal(erShiJiuRiQianRegNum), 4, BigDecimal.ROUND_HALF_EVEN).doubleValue();
			}
		}
		
		
		try{
			JSONObject jsonObject = new JSONObject();
			
			jsonObject.put("income", (long)getYuan(income));
			jsonObject.put("pay_wj_num", yesterdayPayPlayerNum);
			// FIXME 首次充值玩家暂略
			jsonObject.put("first_pay_wj_num", 0);
			jsonObject.put("pay_rate", toStr(payRate, 2));
			jsonObject.put("arpu", getYuan((long)arpu));
			jsonObject.put("acu", acu);
			jsonObject.put("pcu", pcu);
			jsonObject.put("reg_num", zuoTianRegNum);
			jsonObject.put("login_num", zuoTianLoginNum);
			jsonObject.put("dau", dau);
			
			jsonObject.put("next_day_login", qianRiRegAndZuoRiLoginNum);
			jsonObject.put("next_day_login_rate", toStr(ciRiLoginRate, 2));
			jsonObject.put("seven_day_login_rate", toStr(qiRiLoginRate, 2));
			jsonObject.put("thirty_day_login_rate", toStr(sanShiRiLoginRate, 2));
			
			outJson(response, jsonObject);
		}catch(JSONException e){
			;
		}
	}

	//把double转换成字符串
	private static String toStr(double d, int decimalNum){
		if(decimalNum<0){
			throw new RuntimeException("decimalNum can not small than zero");
		}
		
		String str=d+"";
		String[] split = str.split("\\.");
		int length = split.length;
		
		if(decimalNum==0){
			if(length==0){
				return str;
			}else{
				return split[0];
			}
		} else {
			if(length==0){
				str+=".";
				for(int i=0;i<decimalNum;i++){
					str+="0";
				}
				return str;
			} else {
				String baseNumStr=split[0];
				String decimalStr = split[1];
				
				int realDecimalLength = decimalStr.length();
				if(decimalNum>realDecimalLength){
					for(int i=realDecimalLength;i<decimalNum;i++){
						decimalStr+="0";
					}
				} else {
					decimalStr = decimalStr.substring(0, decimalNum);
				}
				
				return baseNumStr+"."+decimalStr;
			}
		}
	}
%>