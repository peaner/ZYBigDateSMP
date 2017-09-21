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
<script type="text/javascript">
	$(function () {
		query();
		$('#computerIp').focusout(function() {
			var ip = document.getElementById('computerIp').value;
			if (!isValidIP(ip)) {
				var flg = window.confirm("输入显示屏IP不正确，请重新输入！");
				if (flg) {
					$("#computerIp").focus();
					document.getElementById("computerIp").style.color="red";
				}
			} else {
				document.getElementById("computerIp").style.color="black";
			}
		});
	});
	
	function isValidIP(ip)     
	{     
	    var reg =  /^(\d{1,2}|1\d\d|2[0-4]\d|25[0-5])\.(\d{1,2}|1\d\d|2[0-4]\d|25[0-5])\.(\d{1,2}|1\d\d|2[0-4]\d|25[0-5])\.(\d{1,2}|1\d\d|2[0-4]\d|25[0-5])$/;
	    return reg.test(ip);     
	}    
	
	function query() {
		$("#dg").datagrid({
			url : "../computerInfo/computerInfos.do",
			columns : [ [ {
				field : 'computerId',
				title : '显示屏ID',
				hidden: true,
				width : 150
			}, {
				field : 'computerName',
				title : '显示屏名称',
				width : 200
			}, {
				field : 'computerIp',
				title : '显示屏IP',
				width : 280
			}, {
				field:'operate',
				title:'操   作',
				align:'center',
				width:200,  
			    formatter:function(value, row, index){
			        var operateStr = '<a href="#" name="update" class="easyui-linkbutton" onclick="modifyRow('+ index +');"></a>'
			         +'<a href="#" name="delete" class="easyui-linkbutton" onclick="deleteRow(' + index +');"></a>';
			        return operateStr; 
			    }
			}] ],
			loadMsg : '加载中.......', //加载提示
			pagination : true, //显示分页工具栏
			rownumbers : true, //显示行号列
			singleSelect : true,//是允许选择一行
			autoRowHeight: true,
			queryParams : { //在请求数据是发送的额外参数，如果没有则不用谢
				computerName : document.getElementById('computerNameForSearch').value,
				flag : '1'
			},
			height : '310px',
			onLoadSuccess:function(data){ 
		        $("a[name='update']").linkbutton({text:'修改', plain:true, iconCls:'icon-edit'});
		        $("a[name='delete']").linkbutton({text:'删除', plain:true, iconCls:'icon-remove'});
		        $("#dg").datagrid('fixRowHeight');
			}
		});
		
		//设置分页控件
		$("#dg").datagrid('getPager').pagination({  
	        pageSize: 10,//每页显示的记录条数，默认为10  
	        pageList: [5, 10, 15],//可以设置每页记录条数的列表  
	        beforePageText: '第',//页数文本框前显示的汉字  
	        afterPageText: '页    共 {pages} 页',  
	        displayMsg: '当前显示 {from} - {to} 条记录   共 {total} 条记录'  
	    }); 
	};
	//设置分页控件
	/* var p = $("#dg").datagrid('getPager');
	$("#dg").datagrid('getPager').pagination({  
        pageSize: 5,//每页显示的记录条数，默认为10  
        pageList: [5, 10, 15],//可以设置每页记录条数的列表  
        beforePageText: '第',//页数文本框前显示的汉字  
        afterPageText: '页    共 {pages} 页',  
        displayMsg: '当前显示 {from} - {to} 条记录   共 {total} 条记录'  
    });  */
	
	//新增一条数据，打开新增页面
	function addOption(){
		clearAll();
		$("#computerName").focus();
		document.getElementById("flagForOption").value="1";
	};

	//修改指定行数据
	function modifyRow(index){
		var rows=$('#dg').datagrid('getRows');//获取所有当前加载的数据行
		if (rows[index]) {
			$('#computerId').val(rows[index].computerId);
			$('#computerName').val(rows[index].computerName);
			$('#computerIp').val(rows[index].computerIp);
	    	document.getElementById("flagForOption").value="2";
	    	$('#computerName').focus();
		} else {
			$.messager.alert('提示信息', "请选中需要修改的数据行！");
		}
	};

  //删除制定行数据（包括前台和后台DB）
	function deleteRow(index){
		var rows=$('#dg').datagrid('getRows');//获取所有当前加载的数据行
		var flg = window.confirm("确认删除显示屏名称为" + rows[index].computerName + "的数据？");	
		if (flg) {
			if (rows[index]) {
		        $.ajax({
		        	data:$.param({
		        		computerId:rows[index].computerId,
		        		computerName:rows[index].computerName,
		        		flag : '1'}),
		        	type: "post",
		 			url : "../computerInfo/deleteComputerInfo.do",
		 			success:function(data){
		 				if(data.result.indexOf("删除成功") > -1){
		 					$.messager.alert('提示信息', data.result);
		 					$('#dg').datagrid('deleteRow', index);
		 				} else {
		 					$.messager.alert('提示信息', data.result);
		 				}
		 				
		 			}
		 		});
		       
			} else {
				$.messager.alert('提示信息', "删除的数据行不存在！");
			}
		}
	};
	
	function save() {
		var ip = document.getElementById('computerIp').value;
		if (!isValidIP(ip)) {
			var flg = window.confirm("输入显示屏IP不正确，请重新输入！");
			if (flg) {
				$("#computerIp").focus();
				document.getElementById("computerIp").style.color="red";
				return;
			}
		} 
		var flg = document.getElementById("flagForOption").value;
		if (flg == 2) {
			$.ajax({
				data:$.param({
					computerId : document.getElementById('computerId').value,
	        		computerName : document.getElementById('computerName').value,
	        		computerIp : document.getElementById('computerIp').value,
	        		updatedUser:parent.document.getElementById("loginUserName").innerText,
					flag : '4'}),
	        	type: "post",
	 			url : "../computerInfo/updateComputerInfo.do",
	 			success:function(data){
					query();
					$.messager.alert('提示信息', data.result);
	 			}
			});
		} else if (flg == 1) {
			$.ajax({
				data:$.param({
	        		computerName : document.getElementById('computerName').value,
	        		computerIp : document.getElementById('computerIp').value,
	        		updatedUser:parent.document.getElementById("loginUserName").innerText,
					flag : '3'}),
	        	type: "post",
	 			url : "../computerInfo/addComputerInfo.do",
	 			success:function(data){
					query();
					$.messager.alert('提示信息', data.result);
	 			}
			});
		}
	}
	
	function clearAll() {
		document.getElementById("computerId").value="";
		document.getElementById("computerName").value="";
		document.getElementById("computerIp").value="";
		document.getElementById("flagForOption").value="1";
	}
</script>

</head>
<body>
<div style="min-width:1920px;">
	<div style="padding: 8px; height: auto; float:left">
	    <div style="font-size: 14px;" >
	    	<p><b>显示屏信息管理</b></p>
	    </div>
	    <div style="padding: 8px; height: auto; float:left">
		    &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
		             显示屏名称：<input type="text" style="margin-left:20px" name="computerName" id="computerNameForSearch"/>
		 	<a href="#" class="easyui-linkbutton" style="margin-left:50px; width:100px;" iconCls="icon-search" onclick="query();">查询</a>
			<a href="#" class="easyui-linkbutton" style="margin-left:80px; width:100px;" iconCls="icon-add" onclick="addOption();">新增</a>
	    
			<table id="dg" class="easyui-datagrid" style="margin-top:20px; width:710px;height:350px" rownumbers="false" pagination="true"></table>
  		</div>
		<div><input type="hidden" id="flagForOption" name="flag" value="1"/></div>
	</div>
	
	<div style="margin-top:20px; margin-left:15px; border-left:5px solid #D0D0D0; height: 400px; float:left">
		<div style="padding-left:15px; font-size: 14px; height: 400px" >
	    	<p style="margin-top:0px;"><b>显示屏信息管理</b></p>
	    	<table style="border:solid 1px #0066CC;margin-left:30px;margin-top:20px; border-collapse:separate; border-spacing:20px;">
	    		<tr>
		    		<td style="margin-top:3px;">显示屏名称：</td>
		    		<td style="margin-left:5px;"><input type="text" name="computerName" id="computerName"/></td>
	    		</tr>
	    		<tr style="margin-top:20px">
		    		<td>显示屏&nbsp;IP：</td>
		    		<td><input type="text" name="computerIp" id="computerIp"/></td>
	    		</tr>
	    		<tr style="display:none">
		    		<td>显示屏&nbsp;ID：</td>
		    		<td><input type="text" name="computerId" id="computerId"/></td>
	    		</tr>
	    		<tr style="height:210px; vertical-align:bottom;">
	    			<td colspan='2'>
	    				<input type="button" id="save" width="20px" height="10px" style="margin-left:106px;" value="保存"  onclick="save();"/>
	    				<input type="button" id="clear" width="20px" height="10px" style="margin-left:46px;" value="清空" onclick="clearAll();"/>
	    			</td>
	    		</tr>
	    	</table>
	    </div>
	</div>
</div>
</body>
</html>
