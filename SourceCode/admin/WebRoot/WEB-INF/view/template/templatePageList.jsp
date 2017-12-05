<%@page import="com.xnx3.admin.entity.TemplatePage"%>
<%@page import="com.xnx3.admin.entity.Site"%>
<%@page import="com.xnx3.net.OSSUtil"%>
<%@page import="com.xnx3.j2ee.Global"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>  
<%@ taglib uri="http://www.xnx3.com/java_xnx3/xnx3_tld" prefix="x" %>
<%
String path = request.getContextPath();
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
%>
<jsp:include page="../iw/common/head.jsp">
	<jsp:param name="title" value="模版页面列表"/>
</jsp:include>
<script src="<%=basePath+Global.CACHE_FILE %>TemplatePage_type.js"></script>

<table class="layui-table" id="xnx3_body" style="margin:0px;">
  <thead>
    <tr>
      <th>页面名字</th>
      <th>类型</th>
      <th>备注</th>
      <th>操作</th>
    </tr> 
  </thead>
  <tbody class="tile__listedit" id="columnList">
  	<!-- display 显示或者隐藏，是否在导航中显示。若为0，则不加入排序 -->
  	<c:forEach items="${list}" var="templatePage">
        <tr>
        	<!--display${column['used']}-->
            <td >${templatePage['name'] }</td>
            <td style="width:90px;"><script type="text/javascript">document.write(type[${templatePage['type'] }]);</script></td>
            <td>${templatePage['remark'] }</td>
            <td style="width:160px;">
            	 <button onclick="editTemplatePageAttribute('${templatePage['name'] }');" class="layui-btn layui-btn-small"><i class="layui-icon">&#xe614;</i></button>
            	 <button onclick="editText('${templatePage['name'] }', ${templatePage['type'] });" class="layui-btn layui-btn-small"><i class="layui-icon">&#xe642;</i></button>
            	 <button onclick="deleteTemplatePage('${templatePage['id'] }', '${templatePage['name'] }');" class="layui-btn layui-btn-small"><i class="layui-icon">&#xe640;</i></button>
			</td>
        </tr>
    </c:forEach>
  </tbody>
</table>

<div style="padding:15px;">
	<button onclick="addTemplatePage();" class="layui-btn" style="margin-left: 10px;margin-bottom: 20px;">添加模版页面</button>
	<div style="float:right; margin-top:3px; color:#d2d2d2;"></div>
</div>
<div style="padding-right:15px; text-align: right;margin-top: -66px;">
	提示：&nbsp;&nbsp;&nbsp;
	<botton class=""><i class="layui-icon">&#xe614;</i></botton><span style="padding-left:12px;padding-right: 30px;">设置属性</span>
	<botton class=""><i class="layui-icon">&#xe642;</i></botton><span style="padding-left:12px;padding-right: 30px;">编辑内容</span>
	<botton class=""><i class="layui-icon">&#xe640;</i></botton><span style="padding-left:12px;padding-right: 30px;">删除</span>
</div>
 
<script type="text/javascript">
var index = parent.layer.getFrameIndex(window.name); //获取窗口索引

/**
 * 编辑页面的内容代码
 * @param name TemplatePage.name要编辑的模版页面名字
 * @param templateType 当前模版页的类型
 */
function editText(name, templateType){
	if(parent.currentMode == 2){
		//要将其切换回智能模式
		parent.window.htmledit_mode();
	}

	parent.document.getElementById("currentTemplatePageName").value = name;
	parent.loadIframe();
	
	try{
		if(templateType == <%=TemplatePage.TYPE_INDEX %>){
			//首页
			parent.document.getElementById("currentTemplateType").innerHTML = '首页模版';
			parent.document.getElementById("tongyong").style.display = '';
			parent.document.getElementById("lanmu").style.display = 'none';
			parent.document.getElementById("fenye").style.display = 'none';
			parent.document.getElementById("wenzhang").style.display = 'none';
			parent.document.getElementById("dongtailanmu").style.display = '';
			parent.document.getElementById("xiangqingduyou").style.display = 'none';
			parent.document.getElementById("liebiaoduyou").style.display = 'none';
		}else if(templateType == <%=TemplatePage.TYPE_NEWS_LIST %>){
			//列表页
			parent.document.getElementById("currentTemplateType").innerHTML = '列表页模版';
			parent.document.getElementById("tongyong").style.display = '';
			parent.document.getElementById("lanmu").style.display = '';
			parent.document.getElementById("fenye").style.display = '';
			parent.document.getElementById("wenzhang").style.display = '';
			parent.document.getElementById("dongtailanmu").style.display = '';
			parent.document.getElementById("xiangqingduyou").style.display = 'none';
			parent.document.getElementById("liebiaoduyou").style.display = '';
		}else{
			//内容页
			parent.document.getElementById("currentTemplateType").innerHTML = '详情页模版';
			parent.document.getElementById("tongyong").style.display = '';
			parent.document.getElementById("lanmu").style.display = '';
			parent.document.getElementById("fenye").style.display = 'none';
			parent.document.getElementById("wenzhang").style.display = '';
			parent.document.getElementById("dongtailanmu").style.display = '';
			parent.document.getElementById("xiangqingduyou").style.display = '';
			parent.document.getElementById("liebiaoduyou").style.display = 'none';
		}
	}catch(err){}
	
	//parent.document.getElementById('iframe').src='<%=basePath %>template/getTemplatePageText.do?pageName='+name;
	parent.layer.close(index);
}

/**
 * 添加模版页面
 */
function addTemplatePage(){
	layer.open({
		type: 2, 
		title:'添加模版页', 
		area: ['400px', '350px'],
		shadeClose: true, //开启遮罩关闭
		content: '<%=basePath %>template/templatePage.do'
	});
}


/**
 * 编辑模版页属性
 */
function editTemplatePageAttribute(pageName){
	layer.open({
		type: 2, 
		title:'编辑模版页属性', 
		area: ['400px', '350px'],
		shadeClose: true, //开启遮罩关闭
		content: '<%=basePath %>template/templatePage.do?pageName='+pageName
	});
}

/**
 * 删除模版页
 * id 要编辑的模版页的id
 * name 要删除的项的名字
 */
function deleteTemplatePage(id, name){
	var dtp_confirm = layer.confirm('确定要删除“'+name+'”？删除后不可恢复！', {
	  btn: ['删除','取消'] //按钮
	}, function(){
		layer.close(dtp_confirm);
		$.showLoading('正在删除');
		$.getJSON('<%=basePath %>template/deleteTemplatePage.do?id='+id,function(obj){
			$.hideLoading();
			if(obj.result == '1'){
				$.toast("删除成功", function() {
					window.location.reload();	//刷新当前页
				});
	     	}else if(obj.result == '0'){
	     		 $.toast(obj.info, "cancel", function(toast) {});
	     	}else{
	     		alert(obj.result);
	     	}
		});
	}, function(){
	});
}
</script>
</body>
</html>