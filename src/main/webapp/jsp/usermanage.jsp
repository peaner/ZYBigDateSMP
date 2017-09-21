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
		open();
		query();
		
		$('#userName').focusout(function() {
			var username = document.getElementById('userName').value;
			if (username) {
				checkUserName(username);
			}
		});
		
		$('#passWord').focusout(function() {
			var passWord = document.getElementById('passWord').value;
			if (passWord) {
				checkPwd(passWord);
			}
		});
		
		$('#telNo').focusout(function() {
			var phone = document.getElementById('telNo').value;
			if (phone) {
				checkPhone(phone);
			}
		});
		
		$('#email').focusout(function() {
			var mail = document.getElementById('email').value;
			if (mail) {
				checkMail(mail);
			}
		});
		
		$.ajax({
        	url : "../userInfo/getRoleInfo.do",
 			success:function(data){
 				$('#role-tree').tree({
 					data:JSON.parse(data.result)
 				});
 			}
 		});
		
		clearAll();
	});
	
	//设置登录窗口
	function open() {
        $('#showPermissionWindow').window({
            title: '角色分配窗口',
            width: 200,
            modal: true,
            shadow: true,
            closed: true,
            height: 330,
            top: 50,
            left: 550,
            resizable:false
        });
	}
	//var ed = $('#dg').datagrid('getEditor', {index:1,field:'birthday'});

	$.extend($.fn.datagrid.defaults.editors, {    
    pwd: {    
        init: function(container, options){    
            var input = $('<input type="password" class="pwd" name="pwd">').appendTo(container);    
            return input.numberspinner(options);    
        },    
        destroy: function(target){    
            $(target).numberspinner('destroy');    
        },    
        getValue: function(target){    
            return $(target).numberspinner('getValue');    
        },    
        setValue: function(target, value){    
            $(target).numberspinner('setValue',value);    
        },    
        resize: function(target, width){    
            $(target).numberspinner('resize',width);    
        }    
    }    
}); 
	
	
	function query() {
		$("#dg").datagrid({
			url : "../userInfo/userInfos.do",
			columns : [ [ {
				field : 'userId',
				title : '用户ID',
				hidden: true,
				width : 100
			}, {
				field : 'userName',
				title : '用户名称',
				width : 100
			}, {
				field : 'passWord',
				title : '用户密码',
				width : 80,
				formatter:function(value, row, index){
			        var operateStr = '<input type="password" style="background:transparent;border:0" id="pwd'+index+'" name="pwd" value="'+value+'"/>';
			        return operateStr; 
			    }
			    //editor:'pwd'
			},{
				field : 'name',
				title : '姓名',
				width : 80
			},{
				field : 'telNo',
				title : '电话号码',
				width : 100
			}, {
				field : 'email',
				title : '邮箱',
				width : 150
			}, {
				field : 'role',
				title : '角色',
				width : 100
			}, {
				field : 'status',
				title : '登录状态',
				width : 80
			}, {
				field:'operate',
				title:'操   作',
				align:'center',
				width:225,  
			    formatter:function(value, row, index){
			        var operateStr = '<a href="#" name="update" class="easyui-linkbutton" onclick="modifyRow('+ index +');"></a>'
			         +'<a href="#" name="delete" class="easyui-linkbutton" onclick="deleteRow(' + index +');"></a>'
			         +'<a href="#" name="modifyStatus" class="easyui-linkbutton" onclick="modifyStatus(' + index +');"></a>';
			        return operateStr; 
			    }
			}] ],
			loadMsg : '加载中.......', //加载提示
			pagination : true, //显示分页工具栏
			rownumbers : true, //显示行号列
			singleSelect : true,//是允许选择一行
			autoRowHeight: true,
			queryParams : { //在请求数据是发送的额外参数，如果没有则不用谢
				userName : document.getElementById('userNameForSearch').value,
				flag : '1'
			},
			height : '330px',
			onLoadSuccess:function(data){ 
		        $("a[name='update']").linkbutton({text:'修改', plain:true, iconCls:'icon-edit'});
		        $("a[name='delete']").linkbutton({text:'删除', plain:true, iconCls:'icon-remove'});
		        $("a[name='modifyStatus']").linkbutton({text:'踢出', plain:true, iconCls:'icon-unlock'});
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
	function addNewUser(){
		clearAll();
		document.getElementById("flagForOption").value="1";
		$("#userName").focus();
	};
	
	function checkUserName(name) {
		if (!(/^[a-zA-z][a-zA-Z0-9_]{2,9}$/.test(name))) {
			var flg = window.confirm("输入用户名不正确，用户名由 3-10位的字母下划线和数字组成，请重新输入！");
			if (flg) {
				document.getElementById("userName").style.color="red";
				$("#userName").focus();
			}
		} else {
			document.getElementById("userName").style.color="black";
		}
	}
	
	function checkPwd(pwd) {
		if (!(/^[0-9A-Za-z]{6,20}$/.test(pwd))) {
			var flg = window.confirm("输入密码不正确,密码由6-20字母和数字组成，请重新输入！");
			if (flg) {
				document.getElementById("passWord").style.color="red";
				$("#passWord").focus();
			}
		} else {
			document.getElementById("passWord").style.color="black";
		}
	}
	
	function checkPhone(phone){ 
	    if(!(/^1[34578]\d{9}$/.test(phone))){ 
		    var flg = window.confirm("输入电话号码不正确，请重新输入！");
			if (flg) {
				document.getElementById("telNo").style.color="red";
				$("#telNo").focus();
			}
		} else {
			document.getElementById("telNo").style.color="black";
		}
	}
	
	function checkMail(mail) {
		var filter  = /^([a-zA-Z0-9_\.\-])+\@(([a-zA-Z0-9\-])+\.)+([a-zA-Z0-9]{2,4})+$/;
		if (!filter.test(mail)) {
			var flg = window.confirm("输入邮箱不正确，请重新输入！");
			if (flg) {
				document.getElementById("email").style.color="red";
				$("#email").focus();
			}
		}else {
			document.getElementById("email").style.color="black";
		}
	}
	
	function modifyRow(index){
		var id="pwd"+index;
		var rows=$('#dg').datagrid('getRows');//获取所有当前加载的数据行
		if (rows[index]) {
			if( rows[index].status == "在线") {
				$.messager.alert('提示信息', "用户已在线，请退出后再修改！");
			} else {
				//document.getElementById("showStatus").style.display="";
				$('#userId').val(rows[index].userId);
				$('#userName').val(rows[index].userName);
				$('#name').val(rows[index].name);
				$('#passWord').val(document.getElementById(id).value);
				$('#telNo').val(rows[index].telNo);
				$('#email').val(rows[index].email);
				$('#role').val(rows[index].role);
				$('#status').combobox('select', rows[index].status);
		    	document.getElementById("flagForOption").value="2";
		    	$('#userName').focus();
		    	var role = document.getElementById("role").value;
				setTreeChecked(role);
			}
			
		}
	};
	
	//修改用户登录状态
	function modifyStatus(index) {
		var rows=$('#dg').datagrid('getRows');//获取所有当前加载的数据行
		var id="pwd"+index;
		if (rows[index].status == "离线") {
			$.messager.alert('提示信息', "用户为离线状态，不能执行此操作！");
		} else if (rows[index].userName == parent.document.getElementById("loginUserName").innerText) {
			$.messager.alert('提示信息', "用户为自身，不能执行此操作！");
		} else {
			$.ajax({
            	data:$.param({
            		userId :  rows[index].userId,
            		userName : rows[index].userName,
            		name : rows[index].name,
            		passWord : document.getElementById(id).value,
            		telNo : rows[index].telNo,
            		email : rows[index].email,
            		status : "离线",
            		role : rows[index].role,
            		updatedUser:parent.document.getElementById("loginUserName").innerText,
    				flag : '9'}),
            	type: "post",
     			url : "../userInfo/updateUserInfo.do",
     			success:function(data){
     				query();
     				$.messager.alert('提示信息', data.result);
     			}
     		});
		}
	}
    
  //删除制定行数据（包括前台和后台DB）
	function deleteRow(index){
		var rows=$('#dg').datagrid('getRows');//获取所有当前加载的数据行
		var flg = false;
		var loginUserName = parent.document.getElementById("loginUserName").innerText;
		if(rows[index].userName == loginUserName) {
			$.messager.alert('提示信息', "删除的用户信息数据与登录用户一致，不能删除！");
		} else {
			if (rows[index].status.indexOf("在线") > -1) {
				//flg = window.confirm("\""+rows[index].userName+"\"用户处于在线状态，是否删除该用户？");
				$.messager.alert('提示信息', "该用户在线，无法删除！");
			} else {
				flg = window.confirm("确认删除用户名称为" + rows[index].userName + "的数据？");
			}
			if (flg) {
				if (rows[index]) {
			        $.ajax({
			        	data:$.param({userId:rows[index].userId,
			        			userName:rows[index].userName,flag : '1'}),
			        	type: "post",
			 			url : "../userInfo/deleteUserInfo.do",
			 			success:function(data){
			 				if(data.result.indexOf("成功")>-1) {
			 					$('#dg').datagrid('deleteRow', index);
			 					$.messager.alert('提示信息', data.result);
			 				}else {
			 					$.messager.alert('提示信息', data.result);
			 				}
			 			}
			 		});
			        
				} else {
					$.messager.alert('提示信息', "删除的数据行不存在！");
				}
			}
		}
		
	};
	
	function showRoleTree() {
		
		var role = document.getElementById("role").value;
			setTreeChecked(role);
			document.getElementById("showPermissionWindow").style.visibility="visible";//显示
			$('#showPermissionWindow').window('open');
	};
	
	function setTreeChecked(role) {
		var nodes=$('#role-tree').tree('getChildren');
		if (nodes && nodes.length) {  
	        for (var i = 0; i < nodes.length; i++) {
	        	if (role.indexOf(nodes[i].text) > -1) {
	        		//设置节点属性为未选中状态  
		            $("#role-tree").tree('check',nodes[i].target);
	        	} else {
	        		$("#role-tree").tree('uncheck',nodes[i].target);
	        	}
	        }  
	    }
	}
	
	function hiddenWindow() {
		var role = document.getElementById("role").value;
		setTreeChecked(role);
		// 更新选择的节点文本
		document.getElementById("showPermissionWindow").style.visibility="hidden";//隐藏
		$('#showPermissionWindow').window('close');
/* 		 var nodes = $('#role-tree').tree('getChecked');
         var s = '';
         for (var i = 0; i < nodes.length; i++) {
             if (s != '') 
                 s += ',';
             s += nodes[i].text;
         } */
	};
	
	function saveSelectedTree() {
		// 更新选择的节点文本
		var nodes = $('#role-tree').tree('getChecked');
         var s = '';
         for (var i = 0; i < nodes.length; i++) {
             if (s != '') 
                 s += ',';
             s += nodes[i].text;
         }
         $("#role").val(s);
         document.getElementById("showPermissionWindow").style.visibility="hidden";//隐藏
 		$('#showPermissionWindow').window('close');
	}
	
	function saveRolePermission() {
		var flgForNull = 0;
		
		//用户名非空判断
		var userNameCheck = document.getElementById("userName").value;
		if (!userNameCheck || typeof(userNameCheck) == "undefined" || userNameCheck == "") {
			flgForNull = 1;
			$.messager.alert('提示信息', "用户名不能为空, 请输入！");
		}
		
		//密码非空判断
		var pwdCheck = document.getElementById("passWord").value;
		if (!pwdCheck || typeof(pwdCheck) == "undefined" || pwdCheck == "") {
			flgForNull = 1;
			$.messager.alert('提示信息', "密码不能为空, 请输入！");
		}
		
		//姓名非空判断
		var nameCheck = document.getElementById("name").value;
		if (!nameCheck || typeof(nameCheck) == "undefined" || nameCheck == "") {
			flgForNull = 1;
			$.messager.alert('提示信息', "姓名不能为空, 请输入！");
		}
		
		
		//判断角色是否分配
		/* var nodes = $('#role-tree').tree('getChecked');
        var s = '';
        for (var i = 0; i < nodes.length; i++) {
            if (s != '' ) 
                s += ',';
            s += nodes[i].text;
        } */
        var s=document.getElementById("role").value;
        if (!s || typeof(s) == "undefined" || s == "") {
			flgForNull = 1;
			$.messager.alert('提示信息', "角色分配不能为空！");
		}
		
        if (flgForNull == 0) {
        	var flg = document.getElementById("flagForOption").value;
            if (flg == 2) { //修改数据
            	$.ajax({
                	data:$.param({
                		userId :  document.getElementById('userId').value,
                		userName : document.getElementById('userName').value,
                		name : document.getElementById('name').value,
                		passWord : document.getElementById('passWord').value,
                		telNo : document.getElementById('telNo').value,
                		email : document.getElementById('email').value,
                		status : $('#status').combobox('getText'),
                		role : s,
                		updatedUser:parent.document.getElementById("loginUserName").innerText,
        				flag : '9'}),
                	type: "post",
         			url : "../userInfo/updateUserInfo.do",
         			success:function(data){
         				query();
         				$.messager.alert('提示信息', data.result);
         			}
         		});
            } else if (flg == 1) { //新增数据
            	$.ajax({
                	data:$.param({
                		userName : document.getElementById('userName').value,
                		passWord : document.getElementById('passWord').value,
                		telNo : document.getElementById('telNo').value,
                		email : document.getElementById('email').value,
                		name : document.getElementById('name').value,
                		role : s,
                		updatedUser:parent.document.getElementById("loginUserName").innerText,
        				flag : '7'}),
                	type: "post",
         			url : "../userInfo/addUserInfo.do",
         			success:function(data){
         				query();
         				$.messager.alert('提示信息', data.result);
         			}
         		});
            }
            
        }
        
	};
	
	function clearAll() {
		document.getElementById("userId").value="";
		document.getElementById("userName").value="";
		document.getElementById("name").value="";
    	document.getElementById("passWord").value="";
    	document.getElementById("telNo").value="";
    	document.getElementById("email").value="";
    	document.getElementById("status").value="";
    	document.getElementById("role").value="";
    	document.getElementById("flagForOption").value="1";
    	document.getElementById("showStatus").style.display="none";
	}
	
</script>



</head>
<body>
<div style="min-width:1920px;">
	<div style="padding: 8px; height: auto; float:left">
	    <div style="font-size: 14px;" >
	    	<p><b>用户管理</b></p>
	    </div>
	    <div style="padding: 8px; height: auto; float:left">
		    &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
		              用户名称：<input type="text" name="userName" id="userNameForSearch"/>
		 	<a href="#" class="easyui-linkbutton" style="margin-left:50px; width:100px;" iconCls="icon-search" onclick="query();">查询</a>
			<a href="#" class="easyui-linkbutton" style="margin-left:150px; width:100px;" iconCls="icon-add" onclick="addNewUser();">新增</a>
		
			<table id="dg" class="easyui-datagrid" style="width:940px;height:350px"  
	      	 rownumbers="false" pagination="true"></table>
    	</div>
		<div><input type="hidden" id="flagForOption" name="flag" value="1"/></div>
	</div>
	<div style="margin-top:20px; border-left:5px solid #D0D0D0; height: 400px; float:left">
		<div style="padding-left:15px; font-size: 14px; height: 400px" >
	    	<p style="margin-top:0px;"><b>用户信息</b></p>
	    	<table style="border:solid 1px #0066CC; margin-left:15px;margin-top:20px; border-collapse:separate; border-spacing:20px;">
	    		<tr>
		    		<td style="margin-top:3px; width:80px">用户名：</td>
		    		<td><input type="text" name="userName" id="userName"/></td>
	    		</tr>
	    		<tr>
		    		<td>密&nbsp;&nbsp;&nbsp;&nbsp;码：</td>
		    		<td><input type="password" name="passWord" id="passWord"/></td>
	    		</tr>
	    		<tr>
		    		<td>姓&nbsp;&nbsp;&nbsp;&nbsp;名：</td>
		    		<td><input type="text" name="name" id="name"/></td>
	    		</tr>
	    		<tr>
		    		<td>手&nbsp;&nbsp;&nbsp;&nbsp;机：</td>
		    		<td><input type="text" name="telNo" id="telNo"/></td>
	    		</tr>
	    		<tr>
		    		<td>邮&nbsp;&nbsp;&nbsp;&nbsp;箱：</td>
		    		<td><input type="text" name="email" id="email"/></td>
	    		</tr>
	    		<tr id="showStatus" style="display:none">
		    		<td>登录状态：</td>
		    		<td>
		    		<!-- <input type="text" name="status" id="status"/> -->
			    		<select panelHeight="auto" class="easyui-combobox" name="status" id="status" style="width:140px;">
			    			<option value="离线">离线</option>
						    <option value="在线">在线</option>
						</select>
		    		</td>
	    		</tr>
	    		<tr style="display:none">
		    		<td>用户ID：</td>
		    		<td><input type="text" name="userId" id="userId"/></td>
	    		</tr>
	    		<tr>
		    		<td><input type="button" id="roleAssign" width="30px" height="10px" style="margin-left:0px;" value="角色分配" onclick="showRoleTree();"/></td>
		    		<td><textarea name="role" id="role" cols=20 rows=1 readonly="true" style="margin-top:0px"></textarea></td>
	    		</tr>
	    		<tr style="height:50px; vertical-align:bottom;">
	    			<td colspan='2'>
	    				<input type="button" id="save" width="20px" height="10px" style="margin-left:76px;" value="保存" onclick="saveRolePermission();"/>
	    				<input type="button" id="clear" width="20px" height="10px" style="margin-left:46px;" value="清空" onclick="clearAll()"/>
	    			</td>
	    		</tr>
	    	</table>
	    </div>
	</div>
	<div id="showPermissionWindow" class="easyui-window" title="权限分配窗口" collapsible="false" minimizable="false"
        maximizable="false" icon="icon-save" style="margin-top:1px; border:1px solid; width:170px; height: 320px; 
        position:relative; background: #fafafa; visibility: hidden">
		<span><b>角色分配</b></span>
		<ul id="role-tree" class="easyui-tree" checkbox="true" style="margin-top:30px"></ul>
		<span style="margin-bottom:10px; position: absolute; top:80%">
			<input style="margin-left:15px" type="button" value="确定" onclick="saveSelectedTree();">
			<input style="margin-left:35px" type="button" value="取消" onclick="hiddenWindow();">
		</span>
	</div>
</div>
</body>
</html>
