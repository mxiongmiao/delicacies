<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%@ page import="java.io.File"%>
<%@ page import="java.lang.Exception"%>
<%@ page import="java.io.BufferedReader"%>
<%@ page import="java.io.InputStreamReader"%>
<%@ page import="java.io.FileInputStream"%>
<%@ page import="java.io.PrintWriter"%>
<%@ page import="java.util.Calendar"%>
<%@ page import="java.util.Date"%>
<%@ page import="java.text.SimpleDateFormat"%>
<%@ page import="java.util.Map"%>
<%@ page import="java.util.HashMap"%>
<%@ page import="java.util.List"%>
<%@ page import="java.util.ArrayList"%>
<%@ page import="java.util.Set"%>
<%@ page import="java.util.HashSet"%>
<%@ page import="org.json.JSONObject"%>
<%@ page import="org.json.JSONArray"%>
<%@ page import="java.util.Map.Entry"%>
<%@ page import="org.json.JSONException"%>
<%@ page import="org.dom4j.io.SAXReader"%>
<%@ page import="org.dom4j.Document"%>
<%@ page import="org.dom4j.Element"%>
<%@ page import="java.security.MessageDigest"%>
<%@ page import="java.math.BigDecimal"%>

<%
	this.doGGet(request, response);
%>

<%!
	public void doGGet(HttpServletRequest request, HttpServletResponse response) throws Exception{
		request.setCharacterEncoding("UTF-8");
		
		String ip=getRemoteIp(request);
		if(!validIP(ip)){
			outJson(response, "非法IP:"+ip);
			return;
		}else if(!isValidRequest(request)){
			outJson(response, "无效请求");
			return;
		}
	}
	
	private String getRemoteIp(HttpServletRequest request){
		String ip=request.getHeader("x-forwarded-for");
		if(ip==null){
			ip = request.getRemoteAddr();
		}
		return ip;
	}
	
	private boolean validIP(String ip){
		Set<String> allowIps=new GM().getAllowIps();
		
		if(!allowIps.contains(ip)){
			return false;
		}
		return true;
	}
	
	private boolean isValidRequest(HttpServletRequest request){
		String data=request.getParameter("data");
		String dt=request.getParameter("dt");
		String degist=request.getParameter("degist");
		
		if(isNullOrEmpty(dt,degist)){
			return false;
		}
		
		if(data==null){
			data="";
		}
		
		String token = new GM().getToken();
		String input=data+dt+token;
		String md5=MD5Hash.encrypt(input);
		if(!md5.equalsIgnoreCase(degist)){
			return false;
		}
		return true;
	}
	
	protected static double getYuan(long fen){
		if(fen==0L){
			return 0.00d;
		}
		
		BigDecimal bfen = new BigDecimal(fen);
		BigDecimal ten = new BigDecimal(10);
		
		BigDecimal ret = bfen.divide(ten).divide(ten);
		return ret.doubleValue();
	}
	
	protected void outJson(HttpServletResponse response, Object obj) {
		response.setContentType("text/html;charset=UTF-8");
		response.setCharacterEncoding("utf-8");
		PrintWriter writer=null;
		try{
			writer = response.getWriter();
			writer.print(obj.toString());
		} catch(Exception e){
			;
		} finally{
			if(writer!=null){
				writer.close();
			}
		}
	}
	
	protected boolean isNullOrEmpty(String ... strArr){
		for(String str:strArr){
			if(str==null||str.isEmpty()||str.trim().isEmpty()){
				return true;				
			}
		}
		return false;
	}
	
	protected void close(BufferedReader br){
		try{
			if(br!=null){
				br.close();
			}
		}catch(Exception e){
			;
		}
	}
	

	/**
	 * 虚拟货币
	 */
	public enum VMType 
	{
		/**
		 * 未定义
		 */
		Null(0)
		/**
		 * 1. 元宝
		 */
		, Gold(1)
		/**
		 * 2. 金豆
		 */
		, Silver(2)
		/**
		 * 3. 银两
		 */
		, Money(3)
		;

		// /////////////////////////////////////////////////////////////////////////////////////////////////////////////////

		private int Type = 0;

		private VMType(int type) 
		{
			this.Type = type;
		}

		public int getValue() 
		{
			return this.Type;
		}

		public static VMType parse(int val) 
		{
			for (VMType t : VMType.values()) 
			{
				if (val == t.getValue())
					return t;
			}
			return VMType.Null;
		}
	}
	
	class GM {
		private String token="";
		private Map<String, String> servicePathMap=null;
		private Set<String> allowIps=null;
		private String logPath="";
		
		GM(){
			servicePathMap=new HashMap<String, String>();
			allowIps=new HashSet<String>();
			
			this.init();
		}

		@SuppressWarnings({ "unused", "unchecked" })
		private void init() {
			try{
				// FIXME 线上需改这儿
				String path="E:/5aworkspace/Game/WebContent/report/gm.xml";
				//String path="/home/xkx2/tom/webapps/xkx2/gm.xml";
				File f=new File(path);
				SAXReader sr = new SAXReader();
				Document doc = sr.read(f);
				Element root = doc.getRootElement();
				
				logPath=root.attributeValue("logPath");
				
				// 初始化分区的日志目录
				String partnerService = "./partners";
				String partner = "./partner";
				List<Element> partnerServiceElements = root.selectNodes(partnerService);
				Element partnerServiceElement=partnerServiceElements.get(0);
				List<Element> partnerElements = partnerServiceElement.elements();
				for(Element pEle:partnerElements){
					String serviceCode = pEle.attributeValue("code");
					List<Element> sElements=pEle.elements();
					for(Element sELe:sElements){
						String sv = sELe.attributeValue("v");
						String key=serviceCode+sv;
						servicePathMap.put(key, sv);
					}
				}
				
				// 初始化 token
				String tokenNode = "./token";
				List<Element> tokens=root.selectNodes(tokenNode);
				if(tokens==null||tokens.isEmpty()){
					throw new RuntimeException("not set token");
				}
				Element tokenEle=tokens.get(0);
				String token=tokenEle.getTextTrim();
				this.token=token;
				
				// 初始化allow IP list
				String allowIp="./allowIp";
				List<Element> allowIpEles=root.selectNodes(allowIp);
				Element allowIpEle=allowIpEles.get(0);
				List<Element> allowIpElements=allowIpEle.elements();
				for(Element e : allowIpElements){
					String ip=e.getText();
					allowIps.add(ip);
				}
				
			}catch(Exception e){
				e.printStackTrace();
			}
		}
		
		String getLogPath(String serviceName){
			try{
				String v=getServicePathMap().get(serviceName);
				logPath=logPath.replace("{v}", v);
				return logPath;
			}catch(Exception e){
				return null;
			}
		}
		
		
		private String getToken(){
			return this.token;
		}
		
		private Map<String, String> getServicePathMap(){
			return this.servicePathMap;
		}
		
		private Set<String> getAllowIps(){
			return this.allowIps;
		}
	}
	
	static class MD5Hash {
		private static String encrypt(String x) {
			MessageDigest messageDigest = null;

			try {
				messageDigest = MessageDigest.getInstance("MD5");
				messageDigest.reset();
				messageDigest.update(x.getBytes("utf-8"));
			} catch (Exception e) {
				throw new RuntimeException(e);
			}

			byte[] byteArray = messageDigest.digest();
			StringBuilder md5SB = new StringBuilder();

			for (byte b:byteArray) {
				String hexString = Integer.toHexString(0xFF & b);
				if (hexString.length() == 1){
					md5SB.append("0").append(hexString);
				} else {
					md5SB.append(hexString);
				}
			}

			return md5SB.toString();
		}
	}
	
	protected static final SimpleDateFormat yyyyMMdd = new SimpleDateFormat("yyyyMMdd");
	protected static final SimpleDateFormat yyyy_MM_dd = new SimpleDateFormat("yyyy-MM-dd");
%>