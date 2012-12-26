<%@ page language="java" contentType="text/html;charset=utf-8" pageEncoding="utf-8"%>

<%@ page import="java.util.List" %>
<%@ page import="java.util.ArrayList" %>

<%!
	class Table {
		private List<Tr> trList;
		private Tr head;
		private String style;
		private String class_;
		
		public Table(){
		}
		
		public Table(List<Tr> list){
			this.trList=list;
		}
		
		public Table(Tr ...trs){
			if(trs.length>0){
				this.trList=new ArrayList<Tr>();
				for(Tr tr:trs){
					this.trList.add(tr);
				}
			}
		}
		
		public Tr getHead() {
			return head;
		}
		
		public void setHead(Tr head) {
			this.head = head;
		}
		
		public Table(List<Tr> list,String style){
			this.trList=list;
			this.style=style;
		}
		
		public List<Tr> getTrList() {
			return trList;
		}
		
		public void setTrList(List<Tr> trList) {
			this.trList = trList;
		}
		
		public String getStyle() {
			return style;
		}
		
		public void setStyle(String style) {
			this.style = style;
		}
		
		public String getClass_() {
			return class_;
		}
		
		public void setClass_(String class_) {
			this.class_ = class_;
		}
		
		@Override
		public String toString() {
			StringBuilder sb = new StringBuilder();
			sb.append("<table");
			if(!isEmptyStr(style)){
				sb.append(" style=\"").append(style).append("\"");
			}
			if(!isEmptyStr(class_)){
				sb.append(" class=\"").append(class_).append("\"");
			}
			sb.append(">");
			if(head!=null){
				sb.append(head);
			}
			if(trList!=null&&!trList.isEmpty()){
				for(Tr tr:trList){
					sb.append(tr);
				}
			}
			sb.append("</table>");
			return sb.toString();
		}
	}
	
	class Tr {
		private List<Column> columnList;
		private String style;
		
		public Tr(List<Column> list){
			this.columnList=list;
		}
		
		public Tr(Column ...tds){
			if(tds.length>0){
				this.columnList=new ArrayList<Column>();
				for(Column td:tds){
					this.columnList.add(td);
				}
			}
		}
		
		public Tr(List<Column> list,String style){
			this.columnList=list;
			this.style=style;
		}
		
		public List<Column> getColumnList() {
			return columnList;
		}
		
		public void setColumnList(List<Column> columnList) {
			this.columnList = columnList;
		}
		
		public String getStyle() {
			return style;
		}
		
		public void setStyle(String style) {
			this.style = style;
		}
		
		@Override
		public String toString() {
			StringBuilder sb = new StringBuilder();
			if(!isEmtpyList(columnList)){
				String tmp="tr";
				sb.append("<").append(tmp);
				if(style!=null&&!style.trim().equals("")){
					sb.append(" style=\"").append(style).append("\"");
				}
				sb.append(">");
				for(Column td:columnList){
					sb.append(td);
				}
				sb.append("</").append(tmp).append(">");
			}
			return sb.toString();
		}
	}
	
	abstract class Column {
		private String content;
		private String style;
		
		public Column(String content){
			this.content=content;
		}
		
		public Column(String content,String style){
			this.content=content;
			this.style=style;
		}
		
		protected abstract String getTagName();
		
		public String getContent() {
			return content;
		}
		
		public void setContent(String content) {
			this.content = content;
		}
		
		public String getStyle() {
			return style;
		}
		
		public void setStyle(String style) {
			this.style = style;
		}
		
		@Override
		public String toString() {
			StringBuilder sb = new StringBuilder();
			String tagName = getTagName();
			sb.append("<").append(tagName);
			if(!isEmptyStr(style)){
				sb.append(" style=\"").append(style).append("\"");
			}
			sb.append(">").append(content).append("</").append(tagName).append(">");
			return sb.toString();
		}
	}
	
	class Td extends Column{
		public Td(String content) {
			super(content);
		}
		
		public Td(String content, String style) {
			super(content, style);
		}
		
		@Override
		protected String getTagName() {
			return "td";
		}
	}
	
	class Th extends Column {
		public Th(String content, String style) {
			super(content, style);
		}
		
		public Th(String content) {
			super(content);
		}
		
		@Override
		protected String getTagName() {
			return "th";
		}
	}
	
	class PageWriter {
		
		PageWriter(){
		}
		
		protected Th makeTh(String content){
			return new Th(content);
		}
		
		protected Th makeTh(String content,String style){
			return new Th(content,style);
		}
		
		protected Td makeTd(String content,String style){
			return new Td(content,style);
		}
		
		protected Td makeTd(String content){
			return new Td(content);
		}
		
		protected Tr makeTr(List<Column> list){
			return new Tr(list);
		}
		
		protected Tr makeTr(List<Column> list,String style){
			return new Tr(list,style);
		}
		
		protected Table makeTable(List<Tr> list){
			return new Table(list);
		}
		
		protected Table makeTable(List<Tr> list,String style){
			return new Table(list,style);
		}
		
		protected String makeLink(String href,String title){
			StringBuilder sb = new StringBuilder();
			sb.append("<a href=\"").append(href).append("\">").append(title).append("</a>");
			return sb.toString();
		}
		
		protected String makeBr(){
			return "<br/>";
		}
		
		protected String makeLine(String content){
			return content+"<br/>";
		}
	}

	static boolean isEmptyStr(String str){
		if(str==null||str.trim().isEmpty()){
			return true;
		}
		return false;
	}
	
	@SuppressWarnings("rawtypes")
	static boolean isEmtpyList(List list){
		if(list==null||list.isEmpty()){
			return true;
		}
		return false;
	}
 %>