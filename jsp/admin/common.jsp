<%@page import="Svc.WCUser"%>
<%@ page language="java" contentType="text/html;charset=utf-8" pageEncoding="utf-8"%>

<%@ page import="java.io.File"%>
<%@ page import="java.io.FileOutputStream"%>
<%@ page import="java.io.PrintWriter"%>
<%@ page import="java.io.BufferedWriter"%>
<%@ page import="java.io.FileWriter"%>
<%@ page import="java.io.InputStream"%>
<%@ page import="java.util.Map.Entry" %>
<%@ page import="java.util.Set" %>
<%@ page import="java.util.HashSet" %>
<%@ page import="java.util.List" %>
<%@ page import="java.text.SimpleDateFormat"%>
<%@ page import="java.util.Date"%>
<%@ page import="java.util.Calendar"%>

<%@ page import="java.sql.SQLException"%>
<%@ page import="javax.sql.rowset.CachedRowSet" %>

<%@ page import="org.json.JSONObject"%>
<%@ page import="org.json.JSONArray"%>

<%@ page import="com.game5a.xkx2.GameData"%>
<%@ page import="com.game5a.xkx2.OnlineMsgType"%>
<%@ page import="com.game5a.xkx2.PlayerData"%>
<%@ page import="Wap.GameServiceData"%>
<%@ page import="com.game5a.xkx2.LogType"%>
<%@ page import="Lucsky.DateTime"%>
<%@ page import="com.game5a.xkx2.FileLog"%>
<%@ page import="com.game5a.xkx2.PlayerData"%>

<%@ page import="org.dom4j.io.SAXReader"%>
<%@ page import="org.dom4j.Document"%>
<%@ page import="org.dom4j.Element"%>

<%@ include file="htmlUtil.jsp" %>

<%
	request.setCharacterEncoding("utf-8");
	
/**
	String ip = getRemoteIp(request);
	boolean validIp=validIP(request, ip);
	if(!validIp){
		outJson(response, "非法IP:"+ip);
		return;
	} else if(!isValidRequest(request)){
		outJson(response, "无效请求");
		return;
	}
*/
	setGame();
	if(game==null){
		outJson(response, "out of service");
		return;
	}
	setDataSource();
	setDataSource5agameSvc();
	setAbsolutePath(request);
%>

<%!

	protected String getRemoteIp(HttpServletRequest request){
		// qq
		String ip=request.getHeader("X-Forwarded-For-Pound");
		if(ip==null||ip.length()==0){
			// 泡泡
			ip=request.getHeader("x-real-ip");
		}
		if(ip==null||ip.length()==0){
			ip=request.getHeader("x-forwarded-for");
		}
		if(ip==null||ip.length()==0){
			ip = request.getRemoteAddr();
		}
		return ip;
	}


	protected GameData game=null;
	protected void setGame(){
		try{
			ServletContext context = getServletContext();
			GameServiceData service = (GameServiceData)context.getAttribute("Service");
			game = (GameData)service.Instance;
		}catch(Exception e){
			;
		}
	}
	
	protected void outJson(HttpServletResponse response, String msg){
		response.setContentType("text/html;charset=utf-8");
		response.setCharacterEncoding("utf-8");
		PrintWriter writer = null;
		try{
			writer = response.getWriter();
			writer.print(msg);
			writer=null;
		} catch(Exception e){
			;
		} finally{
			if(writer!=null){
				writer.close();
				writer=null;
			}
		}
	}
	
	protected boolean validIP(HttpServletRequest request, String ip){
		Set<String> allowIps=new GM(request).getAllowIps();		
		if(!allowIps.contains(ip)){
			return false;
		}
		return true;
	}
	
	protected boolean isValidRequest(HttpServletRequest request){
		String data=request.getParameter("data");
		String dt=request.getParameter("dt");
		String degist=request.getParameter("degist");
		
		if(dt==null||degist==null){
			return false;
		}
		
		if(data==null){
			data="";
		}
		
		String token = new GM(request).getToken();
		String input=data+dt+token;
		String md5=Lucsky.Encrypt.GetMd5Hash(input);
		if(!md5.equalsIgnoreCase(degist)){
			return false;
		}
		return true;
	}
	
	protected boolean isNullOrEmpty(String ... strArr){
		for(String str:strArr){
			if(str==null||str.isEmpty()||str.trim().isEmpty()){
				return true;				
			}
		}
		return false;
	}
	
	protected String dataSourceName="";
	protected void setDataSource(){
		StringBuilder builder=new StringBuilder();
		String split="/";
		String colon=":";
		builder.append("java").append(colon).append("comp").append(split).append("env").append(split).append("jdbc").append(split).append("Xkx2");
		dataSourceName=builder.toString();
	}
	
	protected String dataSource5agameSvc="";
	protected void setDataSource5agameSvc(){
		StringBuilder builder=new StringBuilder();
		String split="/";
		String colon=":";
		builder.append("java").append(colon).append("comp").append(split).append("env").append(split).append("jdbc").append(split).append("Service");
		dataSource5agameSvc=builder.toString();
	}

	protected String absolutePath="";
	protected void setAbsolutePath(HttpServletRequest request){
		StringBuilder builder = new StringBuilder();
		builder.append(request.getScheme()).append("://").append(request.getServerName()).append(":").append(request.getServerPort()).append(request.getContextPath()).append("/").append("admin/");
		absolutePath= builder.toString();
	}
	
	class GM {
		private String token="";
		private Set<String> allowIps=null;
		
		private HttpServletRequest request=null;
		
		GM(HttpServletRequest request){
			this.request=request;
			this.allowIps=new HashSet<String>();
			this.init();
		}

		@SuppressWarnings({ "unused", "unchecked" })
		private void init() {
			try{
				String realPath=getServletContext().getRealPath("/");
				if(!realPath.endsWith(File.separator)){
					realPath+=File.separator;
				}
				String gmFileName="gm.xml";
				File f=new File(realPath+"admin"+File.separator+gmFileName);
				
				SAXReader sr = new SAXReader();
				Document doc = sr.read(f);
				Element root = doc.getRootElement();
				
				// 初始化 token
				String tokenNode = "./token";
				List<Element> tokens=root.selectNodes(tokenNode);
				if(tokens==null||tokens.isEmpty()){
					// FIXME 不要抛出异常
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
		
		private Set<String> getAllowIps(){
			return this.allowIps;
		}
		
		private String getToken(){
			return this.token;
		}
	}
	
	protected String getAccount(PlayerData player){
		int userId=player.getUserId();
		try{
			String loginName=WCUser.GetLoginName(userId);
			String[] s=loginName.split("-");
			String account=s[1];
			if(s.length==1){
				account=s[0];
			}
			return account;
		}catch(Exception e){
			gmLog("getAccount", e);
		}
		return "";
	}
	
	protected void gmLog(String type, Exception e){
		String separator = System.getProperty("file.separator");
		
		String rootPath=FileLog.LogPath + separator+"gm"+separator+"admin";
		File file=new File(rootPath);
		if(!file.exists()){
			file.mkdir();
		}
		
		SimpleDateFormat yyyyMMdd = new SimpleDateFormat("yyyyMMdd");
		Lucsky.FileLog.Log(rootPath, type+"_jsp", e);
	}
	
 %>