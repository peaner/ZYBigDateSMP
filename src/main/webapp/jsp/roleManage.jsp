<%@ page language="java" import="java.util.*" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page isELIgnored ="true" %>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv=”Content-Type” content=”text/html; charset="UTF-8">
<title></title>
<link rel="stylesheet" type="text/css"
	href="../jquery-easyui-1.4.4/themes/default/easyui.css">
<link rel="stylesheet" type="text/css"
	href="../jquery-easyui-1.4.4/themes/icon.css" />
<link rel="stylesheet" type="text/css"
	href="../jquery-easyui-1.4.4/demo/demo.css" />
<script type="text/javascript" src="../jquery-easyui-1.4.4/jquery.min.js"></script>
<script type="text/javascript"
	src="../jquery-easyui-1.4.4/jquery.easyui.min.js"></script>
<script type="text/javascript">
	$(function () {
		open();
		query();
		$('#role-tree').tree({
			data:
			[{    
			    "id":1,    
			    "text":"大数据服务",    
			    "iconCls":"icon-save",
			    "children":[{    
			        "text":"数据采集"
			    	},{    
			        "text":"数据展示"
			        },{      
			            "text":"数据投放"
			        }]
			},{    
			    "text":"系统管理", 
			    "iconCls":"icon-save",
			    "children":[{    
			        "text":"角色管理"   
			    },{    
			        "text":"用户管理"   
			    },{    
			        "text":"系统设置"   
			    }]    
			}]
		});
	});
	
	//设置登录窗口
	function open() {
        $('#showPermissionWindow').window({
            title: '权限分配窗口',
            width: 200,
            modal: true,
            shadow: true,
            closed: true,
            height: 360,
            top: 50,
            left: 550,
            resizable:false
        });
	}

	function query() {
		$("#dg").datagrid({
			url : "../roleInfo/roleInfos.do",
			columns : [ [{
				field : 'roleName',
				title : '角色名称',
				width : 100
			}, {
				field : 'permission',
				title : '权限',
				width : 280
			}, {
				field : 'explanation',
				title : '说明',
				width : 200
			}, {
				field : 'roleId',
				title : '角色ID',
				hidden: true,
				width : 100
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
				roleName : document.getElementById('roleNameForSearch').value,
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
	
	//新增一条数据，打开新增页面
	function addNewRole(){
		clearAll();
    	$('#roleName').focus();
	};
	
	//删除制定行数据（包括前台和后台DB）
	function deleteRow(index){
		var rows=$('#dg').datagrid('getRows');//获取所有当前加载的数据行
		var flg = window.confirm("确认删除角色名称为" + rows[index].roleName + "的数据？");	
		if (flg) {
			if (rows[index]) {
		        $.ajax({
		        	data:$.param({
		        		roleId:rows[index].roleId,
		        		roleName:rows[index].roleName,
		        		flag : '1'}),
		        	type: "post",
		 			url : "../roleInfo/deleteRole.do",
		 			success:function(data){
		 				if(data.result.indexOf("成功") > -1) {
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
	
	//修改指定行数据
	function modifyRow(index){
		var rows=$('#dg').datagrid('getRows');//获取所有当前加载的数据行
		if (rows[index]) {
			$('#roleId').val(rows[index].roleId);
			$('#roleName').val(rows[index].roleName);
			$('#explanation').val(rows[index].explanation);
			$('#permission').val(rows[index].permission);
	    	document.getElementById("flagForOption").value="2";
	    	$('#roleName').focus();
	    	
			var permission = document.getElementById("permission").value;
			setTreeChecked(permission);
		}
	};
	
	function showRoleTree(role) {
		document.getElementById("showPermissionWindow").style.visibility="visible";//显示
		$('#showPermissionWindow').window('open');
	};
	
	function saveSelectedTree() {
		// 更新选择的节点文本
		var nodes = $('#role-tree').tree('getChecked');
         var s = '';
         for (var i = 0; i < nodes.length; i++) {
        	 if (nodes[i].text!="大数据服务" && nodes[i].text!="系统管理") {
        		 if (s != '') {
                	 s += ',';  
                 }
        		 s += nodes[i].text;
        	 }
             
         }
         $("#permission").val(s);
         document.getElementById("showPermissionWindow").style.visibility="hidden";//隐藏
 		$('#showPermissionWindow').window('close');
	}
	
	function hiddenWindow() {
		var permission = document.getElementById("permission").value;
		setTreeChecked(permission);
		// 更新选择的节点文本
		document.getElementById("showPermissionWindow").style.visibility="hidden";//隐藏
         $('#showPermissionWindow').window('close');
	};
	
	function setTreeChecked(permission) {
		var nodes=$('#role-tree').tree('getChildren');
		if (nodes && nodes.length) {  
	        for (var i = 0; i < nodes.length; i++) {
	        	if (permission.indexOf(nodes[i].text) > -1) {
	        		//设置节点属性为选中状态  
		            $("#role-tree").tree('check',nodes[i].target);
	        	} else {
	        		$("#role-tree").tree('uncheck',nodes[i].target);
	        	}
	        }  
	    }
	}
	
	function saveRolePermission() {
		var flgForNull = 0;
		var roleName = document.getElementById('roleName').value;
		if (!roleName || typeof(roleName) == "undefined" || roleName == "")
		{
			flgForNull = 1;
			$.messager.alert('提示信息', "角色名称不能为空！");
		}
		
		/* var s = '';
		var nodes = $('#role-tree').tree('getChecked');
        for (var i = 0; i < nodes.length; i++) {
        	if (nodes[i].text!="大数据服务" && nodes[i].text!="系统管理") {
       		    if (s != '') {
               	    s += ',';  
                }
       		    s += nodes[i].text;
       	    }
        } */
        var s= document.getElementById("permission").value;
		if (!s || typeof(s) == "undefined" || s == "") {
			flgForNull = 1;
			$.messager.alert('提示信息', "权限不能为空！");
		}
		
		if (flgForNull == 0) {
	        var flg = document.getElementById("flagForOption").value;
	        if (flg == 2) {
	        	$.ajax({
	            	data:$.param({roleName : document.getElementById('roleName').value,
	            		explanation:document.getElementById("explanation").value,
	    				permission : s,
	    				roleId: document.getElementById('roleId').value,
	    				updatedUser:parent.document.getElementById("loginUserName").innerText,
	    				flag : '5'}),
	            	type: "post",
	     			url : "../roleInfo/updateRole.do",
	     			success:function(data){
	     				query();
	     				$.messager.alert('提示信息', data.result);
	     			}
	     		});
	        } else if (flg == 1) {
	        	$.ajax({
	            	data:$.param({roleName : document.getElementById('roleName').value,
	            		explanation:document.getElementById("explanation").value,
	            		updatedUser:parent.document.getElementById("loginUserName").innerText,
	    				permission : s,
	    				flag : '4'}),
	            	type: "post",
	     			url : "../roleInfo/addRoleInfo.do",
	     			success:function(data){
	     				query();
	     				$.messager.alert('提示信息', data.result);
	     			}
	     		});
	        }
	        
		}
	};
	
    function clearAll() {
    	document.getElementById("roleId").value="";
		document.getElementById("roleName").value="";
	    document.getElementById("explanation").value="";
		document.getElementById("permission").value="";
		document.getElementById("flagForOption").value="1";
    };
</script>


</head>
<body>
<div style="min-width:1920px;">
	<div style="padding: 8px; height: auto; float:left">
	    <div style="font-size: 14px;" >
	    	<p><b>角色管理</b></p>
	    </div>
	    <div style="padding: 8px; height: auto; float:left">
		    &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
		              角色名称：<input type="text" style="margin-left:20px" name="roleName" id="roleNameForSearch"/>
		 	<a href="#" class="easyui-linkbutton" style="margin-left:50px; width:100px;" iconCls="icon-search" onclick="query();">查询</a>
		 	<a href="#" class="easyui-linkbutton" style="margin-left:150px; width:100px;" iconCls="icon-add" onclick="addNewRole();">新增</a>
	 	
			<table id="dg" class="easyui-datagrid" style="margin-top:20px; width:810px; height:450px;" rownumbers="false" pagination="true"></table>
		</div>
		<div><input type="hidden" id="flagForOption" name="flag" value="1"/></div>
	</div>
	<div style="margin-top:20px; margin-left:15px; border-left:5px solid #D0D0D0; height: 390px; float:left">
		<div style="font-size: 14px;padding-left: 15px; height: 450px" >
	    	<p style="margin-top:0px;"><b>角色信息</b></p>
	    	<table style="border:solid 1px #0066CC; margin-left:15px;margin-top:15px; border-collapse:separate; border-spacing:10px;">
	    		<tr>
		    		<td>角色名称：</td>
		    		<td><input type="text" name="roleName" id="roleName"/></td>
	    		</tr>
	    		<tr style="margin-top:0px">
		    		<td>说&nbsp;&nbsp;&nbsp;&nbsp;明：</td>
		    		<td><textarea name="explanation" id="explanation" cols=20 rows=8 style="margin-top:0px"></textarea></td>
	    		</tr>
	    		<tr style="display:none">
		    		<td>角色ID：</td>
		    		<td><input type="text" name="roleId" id="roleId"/></td>
	    		</tr>
	    		<tr>
		    		<td><input type="button" id="roleAssign" width="30px" height="10px" style="margin-left:0px;" value="权限分配" onclick="showRoleTree();"/></td>
		    		<td><textarea name="permission" id="permission" cols=20 rows=2 readonly="true" style="margin-top:0px"></textarea></td>
	    		</tr>
	    		<tr style="height:70px; vertical-align:bottom;">
	    			<td colspan='2'>
	    				<input type="button" id="save" width="20px" height="10px" style="margin-left:76px;" value="保存" onclick="saveRolePermission();"/>
	    				<input type="button" id="clear" width="20px" height="10px" style="margin-left:46px;" value="清空" onclick="clearAll()"/>
	    			</td>
	    		</tr>
	    		
	    	</table>
	    	<br><br>
	    	
	    </div>
	</div>
	
	<div id="showPermissionWindow" class="easyui-window" title="权限分配窗口" collapsible="false" minimizable="false"
        maximizable="false" icon="icon-save" style="margin-top:1px; border:1px solid; width:170px; height: 320px; 
        position:relative; background: #fafafa; visibility: hidden">
		<span><b>权限分配</b></span>
		<ul id="role-tree" class="easyui-tree" checkbox="true" style="margin-top:30px"></ul>
		<span style="margin-top:30px; position: absolute; top:75%"><input style="margin-left:15px" type="button" value="确定" onclick="saveSelectedTree();"><input style="margin-left:35px" type="button" value="取消" onclick="hiddenWindow();"></span>
	</div>
</div>
</body>
</html>
