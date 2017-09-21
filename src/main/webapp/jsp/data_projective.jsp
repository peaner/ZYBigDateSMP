<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page isELIgnored ="true" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title></title>
<link rel="stylesheet" type="text/css" href="../jquery-easyui-1.4.4/themes/default/easyui.css">
<link rel="stylesheet" type="text/css"	href="../jquery-easyui-1.4.4/themes/icon.css" />
<link rel="stylesheet" type="text/css"	href="../jquery-easyui-1.4.4/demo/demo.css" />
<script type="text/javascript" src="../jquery-easyui-1.4.4/jquery.min.js"></script>
<script type="text/javascript"	src="../jquery-easyui-1.4.4/jquery.easyui.min.js"></script>
<script type="text/javascript">
	$(function () {
		$('#addDsWindow').window('close');
		$('#editDsWindow').window('close');
		$('#addfileName').empty();
		$('#editfileName').empty();
		$('#addfileName').hide();
		$('#editfileName').hide();
	});
	$(document).ready(function() {
		setComboxValue(1, null, null);		
	 });
	
	function setComboxValue(index, oldDisplayName, oldProjectiveScreen) {
		var displayName ="";
		var projectiveScreenValue ="";
		if(index ==1){ //查询页面
			displayName = "displayNameSerch";
			projectiveScreenValue = "projectiveScreenSerch";
		}else if (index ==2){ //新增页面
			displayName = "displayNameAdd";
			projectiveScreenValue = "projectiveScreenAdd";
		} else if(index ==3) { //修改页面
			displayName = "displayNameEdit";
			projectiveScreenValue = "projectiveScreenEdit";
		}
		if(displayName != "" && projectiveScreenValue!= ""){
			$.ajax({
			    type: "POST",
			    url: "../dataProjective/getDisplayNameComValue.do",
			    dataType: "json",
			    success: function(json) {
			        $("#" + displayName).combobox({
			        	data: json.rows,
				        valueField: 'id',
				        textField: 'displayName',
				        panelHeight:"auto",
			        	onSelect: function (data) {
			                if(index == 2){
			                	 $("input[id='addDisplayName']").val(data.displayName);
			                }else if(index == 3){
			                	$("input[id='editDisplayName']").val(data.displayName);
			                }			               
			            },
			            onLoadSuccess: function () {
			            	if(index == 3 && oldDisplayName != null){
			            		$(this).combobox('select', oldDisplayName);
			            	} else {
			            		$(this).combobox('select', '--请选择--');
			            	}
			            }
			        });
			    }
			});
			
			$.ajax({
			    type: "POST",
			    url: "../dataProjective/getProjectiveScreenValue.do",
			    dataType: "json",
			    success: function(json) {
			        $("#" + projectiveScreenValue).combobox({
			        	data: json.rows,
				        valueField: 'computerId',
				        textField: 'computerName',
				        panelHeight:"auto",
			        	onSelect: function (data) {
			        		if(index == 2){
			                	 $("input[id='addProjectiveScreen']").val(data.computerName);
			                }else if(index == 3){
			                	 $("input[id='editProjectiveScreen']").val(data.computerName);
			                }
			            },
			            onLoadSuccess: function () {
			            	if(index == 3 && oldProjectiveScreen != null){
			            		$(this).combobox('select', oldProjectiveScreen);
			            	} else {
			            		$(this).combobox('select', '--请选择--');
			            	}
			            }
			        });
			    }
			});
		}		
	}

	function queryInfo() {
		$("#dg").datagrid({
			url : "../dataProjective/showDatas.do",
			columns : [ [ {
				field : 'id',
				title : '序    号',
				align:'center',
				width : 65,
				hidden:true
			}, {
				field : 'displayName',
				title : '展示名称',
				sortable : true,
				align:'center',
				width : 180
			} , {
				field : 'projectiveScreen',
				title : '投放屏幕',
				sortable : true,
				align:'center',
				width : 180
			}, {
				field : 'runType',
				title : '状    态',
				sortable : true,
				align:'center',
				width : 100,
				formatter:function(value, row, index){
			        if(value=="0"){
			        	return "待启动";
			        }else if(value=="1"){
			        	return "已停止";
			        }else if(value=="2"){
			        	return "运行中";
			        }
			    }
			}, {
				field : 'remark',
				title : '备    注',
				align:'center',
				width : 200
			}, {
				field:'operate',
				title:'操   作',
				align:'center',
				width:220,  
			    formatter:function(value, row, index){
			        var operateStr = '<a href="#" name="projective'+index+'" class="easyui-linkbutton" onclick="projective('+index+');"></a>'
			         +'<a href="#" name="edit" class="easyui-linkbutton" onclick="openEditDsWindow('+ index +');"></a>'
			         +'<a href="#" name="delete" class="easyui-linkbutton" onclick="deleteData('+index+');"></a>';  
			        return operateStr; 
			    }
			}
			] ],
			loadMsg : '加载中.......', //加载提示
			pagination : true, //显示分页工具栏
			rownumbers : true, //显示行号列
			singleSelect : true,//是允许选择一行
			queryParams : { //在请求数据是发送的额外参数
				displayNameSerch : $('#displayNameSerch').combobox('getText'),
				projectiveScreenSerch :  $('#projectiveScreenSerch').combobox('getText')
			},
			height : '410px',
			onLoadSuccess:function(data){ 
		        $("a[name='projective']").linkbutton({text:'启动', plain:true, iconCls:'icon-reload'});
		        $("a[name='edit']").linkbutton({text:'修改', plain:true, iconCls:'icon-edit'});
		        $("a[name='delete']").linkbutton({text:'删除', plain:true, iconCls:'icon-remove'});
		        $.each(data.rows, function(i, item) {
		        	   if(item.runType == 2){
				            $("a[name=projective" + i + "]").linkbutton({text:'停止', plain:true, iconCls:'icon-reload'});
				        }else {
				        	$("a[name=projective" + i + "]").linkbutton({text:'启动', plain:true, iconCls:'icon-reload'});
				        }
		            });
		        $("#dg").datagrid('fixRowHeight');
			}
		});
		//设置分页控件  
		var p = $("#dg").datagrid('getPager');
		p.pagination({  
	        pageSize: 10,//每页显示的记录条数，默认为10  
	        pageList: [5, 10, 15],//可以设置每页记录条数的列表  
	        beforePageText: '第',//页数文本框前显示的汉字  
	        afterPageText: '页    共 {pages} 页',  
	        displayMsg: '当前显示 {from} - {to} 条记录   共 {total} 条记录'  
	    });
	};
		
	
	//打开新增页面
	function openAddDsWindow() {
		clearAddDsAll();
		$('#addDsWindow').window('open');
	}
	
	function clearAddDsAll() {
    	$('#addDsForm').form("clear");
    	setComboxValue(2, null, null);
	}
	
	function addDsInfo() {
		document.forms[0].target="addrfFrame";
		$("#addDsForm").attr("target","addrfFrame");
		var displayName = $("input[id='addDisplayName']").val();
		var checkFlag = true;
		if(displayName == null || displayName == "" || displayName == undefined){
			$.messager.alert('提示信息', "展示名称未选择，请重新选择！");
			checkFlag = false;
		}		
		var projectiveScreen =  $("input[id='addProjectiveScreen']").val();
		if(checkFlag && (projectiveScreen == null || projectiveScreen == "" || projectiveScreen == undefined)){
			$.messager.alert('提示信息', "展示屏幕未选择，请重新选择！");
			checkFlag = false;
		}
		if(checkFlag){
			$('#addUpdateUser').val(parent.document.getElementById("loginUserName").innerText);
			$("#addDsForm").form({ 
	    		url: "../dataProjective/addDsInfoToDB.do",
	    	    success:function(data){
	    	    	var dataResult = eval('('+data+')');
	    	    	if(dataResult.message != null && dataResult.message != "" && dataResult.message != undefined){
	    	    		$.messager.alert('提示信息', dataResult.message);
	    	    	} else {
	    	    		$.messager.alert('提示信息', "新增投放数据成功");
	    	    		$('#addDsWindow').window('close');    	    		
	    	    		queryInfo();
	    	    	}
	    	    }
	    	});
		}
	}
	
	function openEditDsWindow(index){
		$('#editDsWindow').window('open');	
		$("input[id='selectIndex']").val(index);
		rebackEditDsAll();
	}
	
	function rebackEditDsAll() {    	   	
    	var index = $("input[id='selectIndex']").val();    	
    	$('#editDsForm').form("clear");
    	if(selectIndex != null && selectIndex != "" && selectIndex != undefined){
    		var rows=$('#dg').datagrid('getRows');//获取所有当前加载的数据行
    		$("input[id='editDisplayName']").val(rows[index].displayName);
    		$("input[id='editProjectiveScreen']").val(rows[index].projectiveScreen);
    		$("textarea[id='editRemark']").val(rows[index].remark);	
    		$("input[id='selectIndex']").val(index); //为了点击修改框中的清除按钮，恢复到默认值 
    		setComboxValue(3, rows[index].displayName, rows[index].projectiveScreen);
    	}
	}
	
	function cancel(){
		rebackEditDsAll();
		$('#editDsWindow').window('close');
	}
	
	function projective(index){
		var rows=$('#dg').datagrid('getRows');//获取所有当前加载的数据行
		var select = false;
		if(rows[index].runType != 2){
			select = window.confirm("确认启动屏幕[" + rows[index].projectiveScreen + "]的数据投放吗？");	
			if(select){
				$.messager.progress({
					title:'提示消息',
					//msg:"展示页面[" + rows[index].displayName + "]发布",
					text:'正在启动投放... ',
					interval:5000});
				$.ajax({
		        	data:$.param({index:rows[index].id, updateUser:parent.document.getElementById("loginUserName").innerText}),
		        	type: "post",
		        	async:false,
		 			url : "../dataProjective/startDisplay.do",
		 			success:function(data){
		 				$.messager.progress('close');
		 				if(data.result != "" && data.result != undefined && data.result != null){
		 					//$.messager.alert('提示信息', "启动屏幕[" + rows[index].projectiveScreen + "]的数据投放失败");
		 					$.messager.alert('提示信息', data.result);
		 				}else{
		 					$.messager.alert('提示信息', "启动屏幕[" + rows[index].projectiveScreen + "]的数据投放成功");		 					
		 					queryInfo();
		 				}
		 			}
		 		});
			}
		}else {
			select = window.confirm("确认停止屏幕[" + rows[index].projectiveScreen + "]的数据投放吗？");
			if(select){
				$.messager.progress({
					title:'提示消息',
					//msg:"展示页面[" + rows[index].displayName + "]发布",
					text:'正在停止投放... ',
					interval:5000});
				$.ajax({
		        	data:$.param({index:rows[index].id, updateUser:parent.document.getElementById("loginUserName").innerText}),
		        	type: "post",
		 			url : "../dataProjective/stopDisplay.do",
		 			success:function(data){	
		 				$.messager.progress('close');
		 				if(data.result != "" && data.result != undefined && data.result != null){
		 					//$.messager.alert('提示信息', "停止屏幕[" + rows[index].projectiveScreen + "]的数据投放失败");
		 					$.messager.alert('提示信息', data.result);
		 				}else{
		 					$.messager.alert('提示信息', "停止屏幕[" + rows[index].projectiveScreen + "]的数据投放成功");
		 					queryInfo();
		 				}
		 			}
		 		});
			}			
		}	
	}
	
	function editDsInfo() {
		document.forms[0].target="editrfFrame";
		$("#editDsForm").attr("target","editrfFrame");		
		var rows=$('#dg').datagrid('getRows');//获取所有当前加载的数据行
		var selectIndex = $("#selectIndex").val();
		var checkFlag = true;
		if(checkFlag && (rows[selectIndex].runType == 2)){
			$.messager.alert('提示信息', "屏幕[" + rows[selectIndex].projectiveScreen + "]的正在投放相应的数据，无法修改，请先停止投放！");
			checkFlag = false;
		}
    	if(checkFlag && selectIndex != null && selectIndex != "" && selectIndex != undefined){    		
    		if($('#displayNameEdit').combobox('getText') == rows[selectIndex].displayName
    				&& $('#projectiveScreenEdit').combobox('getText') == rows[selectIndex].projectiveScreen
    				&& $("textarea[id='editRemark']").val() == rows[selectIndex].remark){
    			$.messager.alert('提示信息', "投放相关信息无修改,请确认!");
    			checkFlag = false;
    		} else {
    			$("input[id='id']").val(rows[selectIndex].id);
    		}
    	}
    	
    	var displayName = $('#displayNameEdit').combobox('getText');
		if(checkFlag && (displayName == null || displayName == undefined || displayName == "")){
			checkFlag = false;
			$.messager.alert('提示信息', "展示页面不能为空, 请选择展示页面");			 
		}		
		var projectiveScreen = $('#projectiveScreenEdit').combobox('getText');
		if(checkFlag && (projectiveScreen == null || projectiveScreen == undefined || projectiveScreen == "")){
			checkFlag = false; 
			$.messager.alert('提示信息', "展示屏幕不能为空, 请选择展示屏幕");			 
		}
		
		if(checkFlag){	
			$('#editUpdateUser').val(parent.document.getElementById("loginUserName").innerText);
			$('#editDsForm').form({
				url: "../dataProjective/editProjectiveData.do",
				success: function(data){
					var dataResult = eval('('+data+')');
	    	    	if(dataResult.result == null || dataResult.result == "" || dataResult.result == undefined){
	    	    		$.messager.alert('提示信息', "展示信息修改成功！");
	    	    		$('#editDsWindow').window('close');
		    	    	$('#editfileName').empty();
		    	    	queryInfo();
	    	    	}else{
	    	    		$.messager.alert('提示信息', dataResult.result);	
	    	    	}
				}
			});	
		}
	}
	
	function deleteData(index) {
		var rows=$('#dg').datagrid('getRows');//获取所有当前加载的数据行
		var select = false;
		if(rows[index].runType == 2){
			$.messager.alert('提示信息', "屏幕[" + rows[index].projectiveScreen + "]的正在投放相应的数据，无法删除，请先停止投放！");
		} else {
			select = window.confirm("确认删除屏幕[" + rows[index].projectiveScreen + "]的投放数据？");
		}	
		if(select){			
			$.ajax({
	        	data:$.param({id:rows[index].id}),
	        	type: "post",
	 			url : "../dataProjective/deleteProjectiveData.do",
	 			success:function(data){
	 				$.messager.alert('提示信息', data.result);
	 				queryInfo();
	 			}
	 		});
		}
	}
	
	function clearInfo(){
		setComboxValue(1, null, null);	
	}
	
</script>



</head>
<body onload="queryInfo()">
	<%-- <jsp:forward page="index.jsp"></jsp:forward> --%>
	<div style="padding: 8px; height: auto; width: 100%; position:relative; min-width:910px;">
	    <div style="font-size: 12px;" ></div>
		展示名称: <input class="easyui-combobox" type="text" name="displayNameSerch" 
		id="displayNameSerch" data-options="valueField:'id',textField:'displayName'"/>
		<span style="margin-left:30px;">投放屏幕名称:</span>
		<input class="easyui-combobox" type="text" name="projectiveScreenSerch" 
		id="projectiveScreenSerch" data-options="valueField:'computerId',textField:'computerName'"/>
		<a href="#" class="easyui-linkbutton" style="margin-left:40px;" iconCls="icon-search" onclick="queryInfo();">查&nbsp;&nbsp;&nbsp;&nbsp;询</a>
		<a href="#" class="easyui-linkbutton" style="margin-left:10px;" iconCls="icon-clear" onclick="clearInfo();">清&nbsp;&nbsp;&nbsp;&nbsp;空</a>
		<a href="#" class="easyui-linkbutton" style="margin-left:100px;" iconCls="icon-add" onclick="openAddDsWindow();">新&nbsp;&nbsp;&nbsp;&nbsp;增</a>
	</div>
	<table id="dg" class="easyui-datagrid" style="width:910px;height:350px" title="查询列表" iconCls="icon-save" rownumbers="false" pagination="true"></table>
	<div id="addDsWindow" class="easyui-window" title="新增投放" style="width: 350px; height: 280px; padding: 5px; background: #fafafa;">
        <div class="easyui-layout" fit="true" style="min-width:320px;">
            <div region="center" border="false" style="padding: 10px; background: #fff; border: 1px solid #ccc;">
                <form id="addDsForm" method="post" enctype="multipart/form-data">
				   <fieldset>
				   	   <p><label for="displayName">展示名称：&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</label>
				   	   <input class="easyui-combobox" type="text" name="displayNameAdd" id="displayNameAdd" data-options="valueField:'id',textField:'displayName'"/>
				   	   <input style="margin-left:30px;" type="text" id="addDisplayName" name="displayName" value="" hidden="true"/></p>
					   <p><label for="projectiveScreen">投放屏幕：&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</label>
					   <input class="easyui-combobox" type="text" name="projectiveScreenAdd" id="projectiveScreenAdd" data-options="valueField:'computerId',textField:'computerName'"/>
					   <input style="margin-left:30px;" type="text" id="addProjectiveScreen" name="projectiveScreen" value="" hidden="true"/></p>
				   	   <p><input style="margin-left:30px; hidden:true" type="text" id="runType" name="runType" value="" hidden="true"/></p>
					   <p><label for="remark" style="vertical-align:top">备&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;注：</label>					   
					   <textarea style="margin-left:30px;" maxlength="1000" name="remark" id="addRemark" cols=20 rows=3></textarea></p>
					   <p><input id="addUpdateUser" name="updateUser" hidden ="hidden"/></p>
					   <input style="margin-left:108px;" type="submit" name="addRow" value="提交" onclick='addDsInfo(); '/>
					   <input style="margin-left:42px;" type="button" name="clearRow" value="清空" onclick='clearAddDsAll();'/>					   
				   </fieldset>
				   <iframe id="addrfFrame" name="addrfFrame" src="about:blank" style="display:none;"></iframe>
				</form>
            </div>
        </div>
    </div>
    <div id="editDsWindow" class="easyui-window" title="修改投放" style="width: 420px; height: 300px; padding: 5px; background: #fafafa;">
        <div class="easyui-layout" fit="true" style="min-width:600px;">
            <div region="center" border="false" style="padding: 10px; background: #fff; border: 1px solid #ccc;">
                <form id="editDsForm" method="post" enctype="multipart/form-data">
				   <fieldset>
				  	   <input type="hidden" id="id" name="id" value="序号"/>
				   	   <p><label for="displayName">展示名称：&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</label>
				   	   <input class="easyui-combobox" type="text" name="displayNameEdit" id="displayNameEdit" data-options="valueField:'id',textField:'displayName'"/>
				   	   <input style="margin-left:30px;" type="text" id="editDisplayName" name="displayName" value="" hidden="true"/></p>
					   <p><label for="projectiveScreen">投放屏幕：&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</label>
					   <input class="easyui-combobox" type="text" name="projectiveScreenEdit" id="projectiveScreenEdit" data-options="valueField:'computerId',textField:'computerName'"/>
					   <input style="margin-left:30px;" type="text" id="editProjectiveScreen" name="projectiveScreen" value="" hidden="true"/></p>
				   	   <p><input style="margin-left:30px; hidden:true" type="text" id="runType" name="runType" value="" hidden="true"/></p>
					   <p><label for="remark" style="vertical-align:top">备&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;注：</label>
					   <textarea style="margin-left:30px;" maxlength="1000" name="remark" id="editRemark" cols=20 rows=3></textarea></p>
					   <input type="hidden" id="selectIndex" name="selectIndex" value=""/>
					   <P><input id="editUpdateUser" name="updateUser" hidden ="hidden"/></p>
					   <input style="margin-left:108px;" type="submit" name="addRow" value="提交" onclick='editDsInfo();'/>
					   <input style="margin-left:42px;" type="button" name="clearRow" value="取消" onclick='cancel(); '/>					   
				   </fieldset>
				   <iframe id="editrfFrame" name="editrfFrame" src="about:blank" style="display:none;"></iframe>
				</form>
            </div>
        </div>
    </div>
	
</body>
</html>
