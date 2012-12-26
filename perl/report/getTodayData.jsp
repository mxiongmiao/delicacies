<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%@ include file="../common.jsp" %>

<%
	this.execute(request, response);
%>

<%!
	private void execute(HttpServletRequest request, HttpServletResponse response){
		String perlFileName="getTodayData.pl";
		String sid=request.getParameter("sid");
		String[] params={sid};
		String ret=executePerl(perlFileName, params);
	}


	private String executePerl(String perlFileName, String[] params){
		StringBuilder perlCmdBuilder=new StringBuilder();
		perlCmdBuilder.append("perl ");
		perlCmdBuilder.append(perlFileName).append(" ");
		for(String p : params){
			perlCmdBuilder.append(p).append(" ");
		}
		perlCmdBuilder.append(";");
		
		Process process = null;
		try{
			process=Runtime.getRuntime().exec(perlCmdBuilder.toString());
		}catch(java.io.IOException e){
			;
		}
		
		java.io.InputStream input=process.getInputStream();
		java.io.OutputStream out=process.getOutputStream();
		
		return"";
	}
%>