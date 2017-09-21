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
	function queryDsInfo() {
		$("#dg").datagrid({
			url : "../dataDisplay/showDatas.do",
			columns : [ [ {
				field : 'id',
				title : '序    号',
				align:'center',
				width : 65,  //'auto'
				hidden:"true"
			}, {
				field : 'displayName',
				title : '展示名称',
				sortable : true,
				align:'center',
				width : 140
			} , {
				field : 'displaySorce',
				title : '展示程序包',
				sortable : true,
				align:'center',
				width : 140
			}, {
				field : 'runType',
				title : '状    态',
				sortable : true,
				align:'center',
				width : 90,
				formatter:function(value, row, index){
			        if(value=="0"){
			        	return "待启动";
			        }else if(value=="1"){
			        	return "已停止";
			        }else if(value=="2"){
			        	return "运行中";
			        }
			    }
			},{				
				field:'displayPreview',
				title:'展示预览',
				sortable : true,
				align:'center',
				width:165,
				fitColumns:true,
			    formatter:function(value, row, index){
			    	if(row.displayPreview != null && row.displayPreview != undefined  && row.displayPreview != ""){			    		
			    		return "<a href='" + row.displayPreview + "' target='_blank' iconCls='icon-add'>" + row.displayPreview + "</a>";			    		
			    	}else {
			    		return "";
			    	}
			    }				
			}, {
				field : 'remark',
				title : '备    注',
				align:'center',
				width : 160
			}, {
				field:'operate',
				title:'操   作',
				align:'center',
				width:185,  
			    formatter:function(value, row, index){			    	
			    	var operateStr = '<a href="#" name="opera'+index+'" class="easyui-linkbutton" onclick="operaData(' + index +');"></a>'
			         +'<a href="#" name="edit" class="easyui-linkbutton" onclick="openEditDsWindow('+ index +');"></a>'	
			         +'<a href="#" name="delete" class="easyui-linkbutton" onclick="deleteData(' + index +');"></a>';  
			        return operateStr; 
			    }
			}
			] ],
			//toolbar : '#toolbar', //表格菜单
			loadMsg : '加载中.......', //加载提示
			pagination : true, //显示分页工具栏
			rownumbers : true, //显示行号列
			singleSelect : true,//是允许选择一行
			queryParams : { //在请求数据是发送的额外参数，如果没有则不用谢
				displayNameSerch : $("#displayNameSerch").val(),
				displaySorceSerch :  $("#displaySorceSerch").val()
			},
			height : '410px',
			onLoadSuccess:function(data){ 
				$("a[name='opera']").linkbutton({text:'启动', plain:true, iconCls:'icon-reload'});
		        $("a[name='edit']").linkbutton({text:'修改', plain:true, iconCls:'icon-edit'});
		        $("a[name='delete']").linkbutton({text:'删除', plain:true, iconCls:'icon-remove'});
	           	$.each(data.rows, function(i, item) {
	        	   if(item.runType == "2"){
			            $("a[name=opera" + i + "]").linkbutton({text:'停止', plain:true, iconCls:'icon-reload'});
			        }else {
			        	$("a[name=opera" + i + "]").linkbutton({text:'启动', plain:true, iconCls:'icon-reload'});
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
    	$('#addfileName').empty();
    }
	
	//增加展示数据（先上传war包到对应的Tomcat目录下）
	function addDsInfo() {
		document.forms[0].target="rfFrame";
		$("#addDsForm").attr("target","rfFrame");
		var displayName = $("input[name='displayName']").val();
		var checkFlag = true;
		if(displayName == null || displayName == undefined || displayName == ""){
			 $.messager.alert('提示信息', "展示名称不能为空, 请输入展示名称");
			 checkFlag = false;
		}		
		var fileNameError = document.getElementById('addfileName').innerHTML;
		if(checkFlag && (fileNameError == null || fileNameError == undefined || fileNameError == "")){
			 $.messager.alert('提示信息', "选择文件错误, 请重新选择war压缩文件");
			 checkFlag = false;
		}
		if(checkFlag){
			var xhr = new XMLHttpRequest();
			xhr.open("POST", "../dataDisplay/uploadInfo.do", false);
			xhr.upload.addEventListener("progress", uploadProgress, false);
			xhr.addEventListener("load", uploadComplete, false);
			xhr.addEventListener("error", uploadFailed, false);
			xhr.addEventListener("abort", uploadCanceled, false);
			var fd = new FormData();
			fd.append("fileHandler", document.getElementById('fileToUpload').files[0]);		
			xhr.send(fd);	
		}
	}
	
	function fileSelected(type) {
    	var file = null;
    	var infoFlag = null;
    	var csId = null;
    	if(type == 1){
    		file = document.getElementById('fileToUpload').files[0];
    		infoFlag = "addfileName";
    		csId = "adddisplaySorce";
    	} else if(type == 2){
    		file = document.getElementById('editfileToUpload').files[0];
    		infoFlag = "editfileName";
    		csId = "editdisplaySorce";
    	}
		if (file == null) { $.messager.alert('提示信息', '文件为空, 请选择文件'); return; }
		var fileName = file.name;
		var file_typename = fileName.substring(fileName.lastIndexOf('.'), fileName.length);
		if (file_typename == '.war'){
			//计算文件大小
            var fileSize = 0;
            //如果文件大小大于1024字节X1024字节，则显示文件大小单位为MB，否则为KB
            if (file.size > 1024 * 1024) {
            	fileSize = Math.round(file.size * 100 / (1024 * 1024)) / 100;
            	if (fileSize > 500) {
                    $.messager.alert('提示信息', '错误，文件超过500MB，禁止上传！'); 
                    return;
                }
            	fileSize = fileSize.toString() + 'MB';
            }else {
                fileSize = (Math.round(file.size * 100 / 1024) / 100).toString() + 'KB';
            }
          	//将文件名和文件大小显示在前端label文本中
            document.getElementById(infoFlag).innerHTML = "<span style='color:Blue;'>文件名: " + file.name + "<span style='margin-left:25px;'></span>"+'大小: ' + fileSize + "</span>";
            $("input[id="+csId+"]").val(file.name);
        }else {
            $.messager.alert('提示信息', "文件类型错误, 请选择war压缩文件");
            //将错误信息显示在前端label文本中
            document.getElementById(infoFlag).innerHTML = "<span style='color:Red'>错误提示:上传文件应该是.war后缀而不应该是" + file_typename + ",请重新选择</span>";
            $("input[id="+csId+"]").val("");
            $("input[id=fileToUpload]").val("");
        }
	}
	
	function uploadProgress(evt) {
		if (evt.lengthComputable) {
			var percentComplete = Math.round(evt.loaded * 100 / evt.total);
			document.getElementById('progressNumber').innerHTML = percentComplete.toString()+ '%';
		} else {
			document.getElementById('progressNumber').innerHTML = 'unable to compute';
		}
	}
	
	function uploadComplete(evt) {
		//$.messager.alert('提示信息', evt.target.responseText);
		var result = eval('(' + evt.target.responseText + ')');
		if(result.path != "" && result.path != null && result.path != undefined){
			$("input[id='uploadPath']").val(result.path);
			$("input[id='addPath']").val(result.path);			
			$('#addUpdateUser').val(parent.document.getElementById("loginUserName").innerText);
			$("#addDsForm").form({ 
	    		url: "../dataDisplay/addDsInfoToDB.do",
	    	    success:function(data){    	    	
	    	    	var dataResult = eval('('+data+')');
	    	    	if(dataResult.message != null && dataResult.message != "" && dataResult.message != undefined){
	    	    		$.messager.alert('提示信息', dataResult.message);
	    	    	} else {    	    		
	    	    		$.messager.alert('提示信息', "新增展示页面数据成功");
	    	    		$('#addDsWindow').window('close');
	    	    		queryDsInfo();
	    	    	}
	    	    }
	    	});
		} else{
			$.messager.alert('提示信息', "新增过程中上传文件异常，展示页面数据添加失败");
		}
	}
	
	function uploadFailed(evt) {
		$.messager.alert('提示信息', "上传文件出现错误");
	}
	
	function uploadCanceled(evt) {
		$.messager.alert('提示信息', "由于网络原因上传文件被终止");
	} 
	
	function clearFileInput(name){
		var obj = document.getElementById(name) ;  
		obj.outerHTML=obj.outerHTML; 
	}
	
	function openEditDsWindow(index) {		
		$("input[id='selectIndex']").val(index);
		rebackEditDsAll();
		$('#editDsWindow').window('open');
	}
	
	function rebackEditDsAll() {
    	var selectIndex = $("input[id='selectIndex']").val();
    	$('#editDsForm').form("clear");
    	if(selectIndex != null && selectIndex != "" && selectIndex != undefined){
    		var rows=$('#dg').datagrid('getRows');//获取所有当前加载的数据行
    		$("input[id='editdisplayName']").val(rows[selectIndex].displayName);
    		$("input[id='editdisplaySorce']").val(rows[selectIndex].displaySorce);
    		$("input[id='editrunType']").val(rows[selectIndex].runType);
    		$("textarea[id='editRemark']").val(rows[selectIndex].remark);	
    		$("input[id='selectIndex']").val(selectIndex); //为了点击修改框中的清除按钮，恢复到默认值  		
    	}    	
    	$('#editfileName').empty();
    	$('#editDsWindow').window('close');
    }
	
	function editDsInfo() {
		document.forms[0].target="editrfFrame";
		$("#editDsForm").attr("target","editrfFrame");		
		var rows=$('#dg').datagrid('getRows');//获取所有当前加载的数据行
		var selectIndex = $("#selectIndex").val();
		var checkFlag = true;
		if(checkFlag && (rows[selectIndex].runType == 2)){
			$.messager.alert('提示信息', "展示页面[" + rows[selectIndex].displayName + "]的正在运行中，无法修改，请先停止展示！");
			checkFlag = false;
		}
    	if(checkFlag && selectIndex != null && selectIndex != "" && selectIndex != undefined){ 		
    		if($("input[id='editdisplayName']").val() == rows[selectIndex].displayName
    				&& $("input[id='editdisplaySorce']").val() == rows[selectIndex].displaySorce
    				&& $("textarea[id='editRemark']").val() == rows[selectIndex].remark){
    			$.messager.alert('提示信息', "展示相关信息无修改,请确认!");
    			checkFlag = false;
    		} else {
    			$("input[id='id']").val(rows[selectIndex].id);
    		}
    	}
    	
    	var displayName = $("input[id='editdisplayName']").val();
		if(checkFlag && (displayName == null || displayName == undefined || displayName == "")){
			 $.messager.alert('提示信息', "展示名称不能为空, 请输入展示名称");
			 checkFlag = false;
		}		
		var displaySorce = $("input[id='editdisplaySorce']").val();
		if(checkFlag && (displaySorce == null || displaySorce == undefined || displaySorce == "")){
			 $.messager.alert('提示信息', "未选择采集程序包或者程序包格式非WAR格式，请重新选择");
			 checkFlag = false;
		}
		
		if(checkFlag){
			$('#editUpdateUser').val(parent.document.getElementById("loginUserName").innerText);
			$('#editDsForm').form({			
				url: "../dataDisplay/editDataDisplay.do",
				success: function(data){
					var dataResult = eval('('+data+')');
	    	    	if(dataResult.result == null || dataResult.result == "" || dataResult.result == undefined){
	    	    		$.messager.alert('提示信息', "展示信息修改成功！");
	    	    		$('#editDsWindow').window('close');
		    	    	clearFileInput("editfileToUpload");
		    	    	$('#editfileName').empty();
		    	    	queryDsInfo();
	    	    	}else{
	    	    		$.messager.alert('提示信息', dataResult.result);	
	    	    	}
				}
			});	
		}
	}
	
	function operaData(index) {
		var rows=$('#dg').datagrid('getRows');//获取所有当前加载的数据行
		var select = false;
		if(rows[index].runType != 2){
			select = window.confirm("确认启动展示页面[" + rows[index].displayName + "]的发布吗？");	
			if(select){
				$.messager.progress({
					title:'提示消息',
					//msg:"展示页面[" + rows[index].displayName + "]发布",
					text:'正在启动发布... ',
					interval:5000});
				$.ajax({
		        	data:$.param({index:rows[index].id, updateUser:parent.document.getElementById("loginUserName").innerText}),
		        	type: "post",
		        	async:false,
		 			url : "../dataDisplay/startDataDisplay.do",
		 			success:function(data){
		 				$.messager.progress('close');
		 				if(data.result != null && data.result != undefined && data.result != ""){
		 					$.messager.alert('提示信息', data.result);
		 				}else{
		 					$.messager.alert('提示信息', "启动展示页面[" + rows[index].displayName + "]的发布成功");
		 					queryDsInfo();
		 				}
		 			}
		 		});
			}
		}else {
			select = window.confirm("确认停止展示页面[" + rows[index].displayName + "]的发布吗？");
			if(select){
				$.ajax({
		        	data:$.param({index:rows[index].id, updateUser:parent.document.getElementById("loginUserName").innerText}),
		        	type: "post",
		 			url : "../dataDisplay/stopDataDisplay.do",
		 			success:function(data){
		 				if(data.result != null && data.result != undefined && data.result != ""){
		 					$.messager.alert('提示信息', data.result);
		 				}else{
		 					$.messager.alert('提示信息', "停止展示页面[" + rows[index].displayName + "]的发布成功");
		 					queryDsInfo();
		 				}
		 			}
		 		});	
			}			
		}	
	}
	
	function clearFileInput(name){
		var obj = document.getElementById(name) ;  
		obj.outerHTML=obj.outerHTML; 
	}
	
	//删除数据
	function deleteData(index) {
		var rows=$('#dg').datagrid('getRows');//获取所有当前加载的数据行
		var select = false;
		if(rows[index].runType == 2){
			$.messager.alert('提示信息', "展示页面[" + rows[index].displayName + "]正在运行中，无法删除，请先停止运行！");
		} else {
			select = window.confirm("确认删除展示名[" + rows[index].displayName + "]的相关展示功能数据吗？");
		}
		if(select){
			$.ajax({
	        	data:$.param({id:rows[index].id}),
	        	type: "get",
	 			url : "../dataDisplay/deleteDataDispay.do",
	 			success:function(data){
	 				$.messager.alert('提示信息', data.result);
	 				queryDsInfo();
	 			}
	 		});
			//$('#dg').datagrid('deleteRow', index);
		}	
	}
	
	function clearInfo(){
		$('#displayNameSerch').val("");	
		$('#displaySorceSerch').val("");	
	}
</script>

</head>
<body onload="queryDsInfo()">
	<%-- <jsp:forward page="index.jsp"></jsp:forward> --%>
	<div style="padding: 8px; height: auto; width: 100%; position:relative; min-width:910px;">
	    <div style="font-size: 12px;" ></div>
		展示名称: <input class="easyui-validatebox" maxlength="100" type="text" name="displayNameSerch" id="displayNameSerch"/>
		<span style="margin-left:30px;">展示程序包名称:</span>
		<input class="easyui-validatebox" maxlength="100" name="displaySorceSerch" id="displaySorceSerch" />
		<a href="#" class="easyui-linkbutton" style="margin-left:40px;" iconCls="icon-search" onclick="queryDsInfo();">查&nbsp;&nbsp;&nbsp;&nbsp;询</a>
		<a href="#" class="easyui-linkbutton" style="margin-left:10px;" iconCls="icon-clear" onclick="clearInfo();">清&nbsp;&nbsp;&nbsp;&nbsp;空</a>
		<a href="#" class="easyui-linkbutton" style="margin-left:100px;" iconCls="icon-add" onclick="openAddDsWindow();">新&nbsp;&nbsp;&nbsp;&nbsp;增</a>
	</div>
	<table id="dg" class="easyui-datagrid" style="width:910px;height:350px" title="查询列表" iconCls="icon-save" rownumbers="false" pagination="true"></table>
	<div id="addDsWindow" class="easyui-window" title="新增展示页面" style="width: 420px; height: 280px; padding: 5px; background: #fafafa;">
        <div class="easyui-layout" fit="true" style="min-width:380px;">
            <div region="center" border="false" style="padding: 10px; background: #fff; border: 1px solid #ccc;">
                <form id="addDsForm" method="post" enctype="multipart/form-data">
				   <fieldset>
				   	   <p><label for="displayName">展示名称：&nbsp;&nbsp;</label>
				   	   <input style="margin-left:30px;width:200px;" maxlength="100" type="text" id="displayName" name="displayName" value=""/></p>
					   <p><label for="displaySorce">展示程序包：</label>					   
					   <input type="file" name="fileToUpload" id="fileToUpload" style="display:none;" onchange="fileSelected(1);"/>
					   <input style="margin-left:30px;" placeholder="请选择可运行war压缩包" maxlength="100" id="adddisplaySorce" name="displaySorce" value="" readonly="readonly"/>
					   <input type="button" value="浏览.." onclick= "fileToUpload.click()"/></p>
					   <p><span id="addfileName"></span> <span id="progressNumber"></span></p>
				   	   <p><input style="margin-left:30px; hidden:true" type="text" id="runType" name="runType" value="Stopped" hidden="true"/></p>
					   <P><input id="addPath" name="path" hidden ="hidden"/></p>					   					   
					   <p><label for="remark" style="vertical-align:top">备&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;注：</label>
					   <textarea style="margin-left:30px;width:200px;" maxlength="1000" name="remark" id="remark" cols=20 rows=3></textarea></p>
					   <input type="hidden" id="uploadPath" name="uploadPath" value=""/>
					   <p><input id="addUpdateUser" name="updateUser" hidden ="hidden"/></p>
					   <input style="margin-left:108px;" type="submit" name="addRow" value="提交" onclick='addDsInfo();'/>
					   <input style="margin-left:42px;" type="button" name="clearRow" value="清空" onclick='clearAddDsAll();'/>					   
				   </fieldset>
				   <iframe id="rfFrame" name="rfFrame" src="about:blank" style="display:none;"></iframe>
				</form>
            </div>
        </div>
    </div>
    <div id="editDsWindow" class="easyui-window" title="修改展示页面" style="width: 420px; height: 280px; padding: 5px; background: #fafafa;">
        <div class="easyui-layout" fit="true" style="min-width:380px;">
            <div region="center" border="false" style="padding: 10px; background: #fff; border: 1px solid #ccc;">
                <form id="editDsForm" method="post" enctype="multipart/form-data">
				   <fieldset>
				   	   <input type="hidden" id="id" name="id" value="序号"/>
				   	   <p><label for="displayName">展示名称：&nbsp;&nbsp;</label>
				   	   <input style="margin-left:30px;width:200px;" maxlength="100" type="text" id="editdisplayName" name="displayName" value=""/></p>
					   <p><label for="displaySorce">展示程序包：</label>
					   <input type="file" name="editfileToUpload" maxlength="100" id="editfileToUpload" style="display:none;" onchange="fileSelected(2);"/>
					   <input style="margin-left:30px;" id="editdisplaySorce" name="displaySorce" value="" readonly="readonly"/>
					   <input type="button" value="浏览.." onclick= "fileToUpload.click()" disabled ="disabled"/></p>
					   <p><span id="editfileName"></span> <span id="progressNumber"></span></p>
					   <p><input style="margin-left:30px; hidden:true" type="text" id="editrunType" name="runType" value="Stopped" hidden="true"/></p>
					   <p><label for="remark" style="vertical-align:top">备&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;注：</label>
					   <textarea style="margin-left:30px;width:200px;" maxlength="1000" name="remark" id="editRemark" cols=20 rows=3></textarea></p>
					   <P><input id="editPath" name="path" hidden ="hidden"/></p>
					   <P><input id="editUpdateUser" name="updateUser" hidden ="hidden"/></p>
					   <input type="hidden" id="selectIndex" name="selectIndex" value=""/>
					   <input style="margin-left:108px;" type="submit" name="editRow" value="提交" onclick='editDsInfo();'/>
					   <input style="margin-left:42px;" type="button" name="clearRow" value="取消" onclick='rebackEditDsAll();'/>					   
				   </fieldset>
				   <iframe id="editrfFrame" name="editrfFrame" src="about:blank" style="display:none;"></iframe>
				</form>
            </div>
        </div>
    </div>
</body>
</html>
