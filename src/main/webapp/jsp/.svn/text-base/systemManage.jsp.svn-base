<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page isELIgnored ="true" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title></title>
<link rel="stylesheet" type="text/css"
	href="../jquery-easyui-1.4.4/themes/default/easyui.css">
<link rel="stylesheet" type="text/css"
	href="../jquery-easyui-1.4.4/themes/icon.css" />
<link rel="stylesheet" type="text/css"
	href="../jquery-easyui-1.4.4/demo/demo.css" />
<link rel="stylesheet" type="text/css"
	href="../css/usermanage.css" />
<script type="text/javascript" src="../jquery-easyui-1.4.4/jquery.min.js"></script>
<script type="text/javascript" src="../jquery-easyui-1.4.4/jquery.easyui.min.js"></script>
<style type="text/css">
.span-style {
display:-moz-inline-box;
display:inline-block;
height:40px;
width:100px;
padding-left:30px;
text-align:left;
line-height:40px;
}
</style>
<script type="text/javascript">
	$(function () {
		computerSetting();
	});
	
	function computerSetting() {
		 document.getElementById('computerSet').style.background = '#E0ECFF';
		 $("#show").load("computerManage.jsp");
	}

</script>

</head>

<body>
<div style="min-width:1920px;">
	<div style="float:left; width:130px; height:420px; border-right:solid 5px #D0D0D0">
		<p><b>系统设置</b></p>
		<span class="span-style" id="computerSet" onclick="computerSetting();">显示屏设置</span>
	</div>
	<div id="show" style="float:left; margin-left:15px; width:83%; height:600px;">
	</div>	
</div>
</body>
</html>