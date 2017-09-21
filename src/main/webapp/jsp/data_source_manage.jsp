<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page isELIgnored ="true" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8" name="viewport" content="width=device-width, initial-scale=1.0, minimum-scale=1.0, maximum-scale=1.0, user-scalable=no">
<title></title>
<link rel="stylesheet" type="text/css" href="../jquery-easyui-1.4.4/themes/default/easyui.css">
<link rel="stylesheet" type="text/css"	href="../jquery-easyui-1.4.4/themes/icon.css" />
<link rel="stylesheet" type="text/css"	href="../jquery-easyui-1.4.4/demo/demo.css" />
<link rel="stylesheet" type="text/css"	href="../css/file.css" />
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
			url : "../dataSource/showDatas.do",
			columns : [ [ {
				field : 'id',
				title : '序    号',
				align:'center',
				width : 65,
				hidden:"true"
			}, {
				field : 'dataName',
				title : '数据源名称',
				sortable : true,
				align:'center',
				width : 180
			} , {
				field : 'collectionSorce',
				title : '采集程序包',
				sortable : true,
				align:'center',
				width : 180
			}, {
				field : 'runType',
				title : '状    态',
				align:'center',
				sortable : true,
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
				field : 'path',
				title : '路  径',
				align:'center',
				width : 200,
				hidden:"true"
			}, {
				field:'operate',
				title:'操   作',
				align:'center',
				width:220,  
			    formatter:function(value, row, index){
			        var operateStr = '<a href="#" name="opera'+index+'" class="easyui-linkbutton" onclick="operaData(' + index +');"></a>'
			         + '<a href="#" name="edit" class="easyui-linkbutton" onclick="openEditDsWindow('+ index +');"></a>'
			         +'<a href="#" name="delete" class="easyui-linkbutton" onclick="deleteData(' + index +');"></a>';			         
			        return operateStr; 
			    }
			}
			] ],
			
			loadMsg : '加载中.......', //加载提示
			pagination : true, //显示分页工具栏
			rownumbers : true, //显示行号列
			singleSelect : true,//是允许选择一行
			queryParams : { //在请求数据是发送的额外参数
				dataNameSerch : $("#dataNameSerch").val(),
				collectionSorceSerch :  $("#collectionSorceSerch").val()
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
	
	function addDsInfo() {
		document.forms[0].target="rfFrame";
		$("#addDsForm").attr("target","rfFrame");
		var checkFlag = true;
		var daName = $("input[name='dataName']").val();
		if(daName == null || daName == undefined || daName == ""){
			checkFlag = false;
			$.messager.alert('提示信息', '数据源名称不能为空, 请输入数据源名称');
		}		
		var fileNameError = document.getElementById('addfileName').innerHTML;
		if(checkFlag && (fileNameError == null || fileNameError == undefined || fileNameError == "")){
			checkFlag = false;
			$.messager.alert('提示信息', "选择文件错误, 请重新选择zip压缩文件");
		}
		if(checkFlag){
			var xhr = new XMLHttpRequest();
			xhr.open("POST", "../dataSource/uploadInfo.do", false);
			xhr.upload.addEventListener("progress", uploadProgress, false);
			xhr.addEventListener("load", uploadComplete, false);
			xhr.addEventListener("error", uploadFailed, false);
			xhr.addEventListener("abort", uploadCanceled, false);
			//xhr.setRequestHeader("Content-Type", "multipart/form-data");
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
    		csId = "addCs";
    	} else if(type == 2){
    		file = document.getElementById('editfileToUpload').files[0];
    		infoFlag = "editfileName";
    		csId = "editCs";
    	}
		if (file == null) { alert('文件为空, 请重新选择文件'); return; }
		var fileName = file.name;
		var file_typename = fileName.substring(fileName.lastIndexOf('.'), fileName.length);
		if (file_typename == '.zip'){
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
            $.messager.alert('提示信息', "文件类型错误, 请选择zip压缩文件");
            //将错误信息显示在前端label文本中
            document.getElementById(infoFlag).innerHTML = "<span style='color:Red'>错误提示:上传文件应该是.zip后缀而不应该是" + file_typename + ",请重新选择</span>";
            $("input[id="+csId+"]").removeAttr("readonly");
            $("input[id="+csId+"]").val("");
            $("input[id="+csId+"]").attr("readonly","readonly");
            $("input[id=editfileToUpload]").val("");
            clearFileInput("editfileToUpload");
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
		var result = eval('(' + evt.target.responseText + ')');
		if(result.path != "" && result.path != null && result.path != undefined){
			$("input[id='uploadPath']").val(result.path);
			$("input[id='addPath']").val(result.path);
			$('#addUpdateUser').val(parent.document.getElementById("loginUserName").innerText);
			$("#addDsForm").form({ 
	    		url: "../dataSource/addDsInfoToDB.do",
	    	    success:function(data){
	    	    	var dataResult = eval('('+data+')');
	    	    	if(dataResult.message != null && dataResult.message != "" && dataResult.message != undefined){
	    	    		$.messager.alert('提示信息', dataResult.message);
	    	    	} else {	    	    		
	    	    		$.messager.alert('提示信息', "新增数据源成功");
	    	    		$('#addDsWindow').window('close');
	    	    		queryDsInfo();
	    	    	}
	    	    }
	    	});
		} else{
			$.messager.alert('提示信息', "新增过程中上传文件异常，数据源添加失败");
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
		$('#editDsWindow').window('open');
		var rows=$('#dg').datagrid('getRows');//获取所有当前加载的数据行
		$("input[id='editDs']").val(rows[index].dataName);
		$("input[id='editCs']").val(rows[index].collectionSorce);
		$("input[id='editpath']").val(rows[index].path);
		$("textarea[id='editRemark']").val(rows[index].remark);	
		$("input[id='selectIndex']").val(index); //为了点击修改框中的清除按钮，恢复到默认值
	}
	
	function editDsInfo() {
		document.forms[0].target="editrfFrame";
		$("#editDsForm").attr("target","editrfFrame");		
		var rows=$('#dg').datagrid('getRows');//获取所有当前加载的数据行
		var selectIndex = $("#selectIndex").val();
		var checkFlag = true;
		if(checkFlag && (rows[selectIndex].runType == 2)){
			$.messager.alert('提示信息', "数据源[" + rows[selectIndex].dataName + "]正在采集数据，无法修改，请先停止采集！");
			checkFlag = false;
		}
    	if(checkFlag && (selectIndex != null && selectIndex != "" && selectIndex != undefined)){    		
    		if($("input[id='editDs']").val() == rows[selectIndex].dataName
    				&& $("input[id='editCs']").val() == rows[selectIndex].collectionSorce
    				&& $("textarea[id='editRemark']").val() == rows[selectIndex].remark){
    			checkFlag = false;
    			$.messager.alert('提示信息', "数据源相关信息无修改,请确认!");
    		} else {
    			$("input[id='id']").val(rows[selectIndex].id);
    		}
    	}
    	
    	var daName = $("input[id='editDs']").val();
		if(checkFlag && (daName == null || daName == undefined || daName == "")){
			checkFlag = false;
			$.messager.alert('提示信息', "数据源名称不能为空, 请输入数据源名称");
		}
		
		var editCs = $("input[id='editCs']").val();
		if(checkFlag && (editCs == null || editCs == undefined || editCs == "")){
			checkFlag = false;
			$.messager.alert('提示信息', "未选择采集程序包或者程序包格式非ZIP格式，请重新选择");
		}
		
		if(checkFlag){
			$('#editUpdateUser').val(parent.document.getElementById("loginUserName").innerText);
			$('#editDsForm').form({
				url: "../dataSource/editDsInfo.do",
				success: function(data){
					var dataResult = eval('('+data+')');
	    	    	if(dataResult.result == null || dataResult.result == "" || dataResult.result == undefined){
	    	    		$.messager.alert('提示信息', "采集信息修改成功！");
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
	
	function deleteData(index) {
		var rows=$('#dg').datagrid('getRows');//获取所有当前加载的数据行
		var select = false;
		if(rows[index].runType == 2){
			$.messager.alert('提示信息', "数据源[" + rows[index].dataName + "]正在采集数据，无法删除，请先停止采集！");
		} else {
			select = window.confirm("警告：确认删除数据源[" + rows[index].dataName + "]对应所有信息吗？");
		}
		if(select){			
			$.ajax({
	        	data:$.param({id:rows[index].id}),
	        	type: "post",
	 			url : "../dataSource/deleteDsInfo.do",
	 			success:function(data){
	 				$.messager.alert('提示信息', data.result);
	 				queryDsInfo();
	 			}
	 		});
		}
	}
	
	function operaData(index) {
		var rows=$('#dg').datagrid('getRows');//获取所有当前加载的数据行
		var select = false;
		if(rows[index].runType != 2){
			select = window.confirm("确认启动数据源[" + rows[index].dataName + "]的数据采集吗？");	
			if(select){
				$.messager.progress({
					title:'提示消息',
					//msg:"展示页面[" + rows[index].displayName + "]发布",
					text:'正在启动采集... ',
					interval:5000});
				$.ajax({
		        	data:$.param({runType:rows[index].runType, index:rows[index].id, updateUser:parent.document.getElementById("loginUserName").innerText}),
		        	type: "post",
		        	async:false,
		 			url : "../dataSource/startDataCollection.do",
		 			success:function(data){
		 				$.messager.progress('close');
		 				if(data.result == "error"){
		 					$.messager.alert('提示信息', "启动数据源[" + rows[index].dataName + "]的采集失败");
		 				}else{
		 					$.messager.alert('提示信息', "启动数据源[" + rows[index].dataName + "]的采集成功");
		 					queryDsInfo();
		 				}
		 			}
		 		});
			}
		}else {
			select = window.confirm("确认停止数据源[" + rows[index].dataName + "]的数据采集吗？");
			if(select){
				$.ajax({
		        	data:$.param({runType:rows[index].runType, index:rows[index].id, updateUser:parent.document.getElementById("loginUserName").innerText}),
		        	type: "post",
		 			url : "../dataSource/stopDataCollection.do",
		 			success:function(data){
		 				if(data.result == "error"){
		 					$.messager.alert('提示信息', "停止数据源[" + rows[index].dataName + "]的采集失败");
		 				}else{
		 					$.messager.alert('提示信息', "停止数据源[" + rows[index].dataName + "]的采集成功");
		 					queryDsInfo();
		 				}
		 			}
		 		});
			}			
		}		
	}
	
	//打开新增页面
	function openAddDsWindow() {
		clearAddDsAll();
		$('#addDsWindow').window('open');
	}
	
    function clearAddDsAll() {
    	$('#addDsForm').form("clear");
    	$('#addfileName').empty();
    }
    
    function clearEditDsAll() {
    	var selectIndex = $("#selectIndex").val();
    	$('#editDsForm').form("clear");
    	if(selectIndex != null && selectIndex != "" && selectIndex != undefined){
    		var rows=$('#dg').datagrid('getRows');//获取所有当前加载的数据行
    		$("input[id='editDs']").val(rows[selectIndex].dataName);
    		$("input[id='editCs']").val(rows[selectIndex].collectionSorce);
    		$("input[id='editpath']").val(rows[selectIndex].path);
    		$("input[id='editrunType']").val(rows[selectIndex].runType);
    		$("textarea[id='editRemark']").val(rows[selectIndex].remark);	
    		$("input[id='selectIndex']").val(selectIndex); //为了点击修改框中的清除按钮，恢复到默认值    		
    	}    	
    	$('#editfileName').empty();
    	$('#editDsWindow').window('close');
    } 
    
	function clearInfo(){
		$('#dataNameSerch').val("");	
		$('#collectionSorceSerch').val("");	
	}
    
</script>



</head>
<body onload="queryDsInfo()">
	<%-- <jsp:forward page="index.jsp"></jsp:forward> --%>
	<div style="padding: 8px; height: auto; width: 100%; position:relative; min-width:910px;" >
	    <div style="font-size: 12px;" ></div>
		数据源名称: <input class="easyui-validatebox" type="text" name="dataNameSerch" id="dataNameSerch" maxlength="100"/>
		<span style="margin-left:30px;">采集程序包名称:</span>
		<input class="easyui-validatebox" name="collectionSorceSerch" id="collectionSorceSerch" maxlength="100"/>
		<a href="#" class="easyui-linkbutton" style="margin-left:40px;" iconCls="icon-search" onclick="queryDsInfo();">查&nbsp;&nbsp;&nbsp;&nbsp;询</a>
		<a href="#" class="easyui-linkbutton" style="margin-left:10px;" iconCls="icon-clear" onclick="clearInfo();">清&nbsp;&nbsp;&nbsp;&nbsp;空</a>
		<a href="#" class="easyui-linkbutton" style="margin-left:80px;" iconCls="icon-add" onclick="openAddDsWindow();">新&nbsp;&nbsp;&nbsp;&nbsp;增</a>
	</div>
	<table id="dg" class="easyui-datagrid" style="width:910px;height:350px" title="查询列表" iconCls="icon-save" rownumbers="false" pagination="true"></table>
	<div id="addDsWindow" class="easyui-window" title="新增数据源" style="width: 420px; height: 280px; padding: 5px; background: #fafafa;">
        <div class="easyui-layout" fit="true" style="min-width:380px;">
            <div region="center" border="false" style="padding: 10px; background: #fff; border: 1px solid #ccc;">
                <form id="addDsForm" method="post" enctype="multipart/form-data">
				   <fieldset>
				   	   <p><label for="dsName">数据源名称：</label>
				   	   <input style="margin-left:30px;width:200px;" type="text" id="ds" name="dataName" value="" maxlength="100"/></p>
					   <p><label for="csName">采集程序包：</label> 
					   <input type="file" name="fileToUpload" id="fileToUpload" style="display:none;" onchange="fileSelected(1);"/>
					   <input style="margin-left:30px;" id="addCs" name="collectionSorce" value="" placeholder="请选择zip压缩文件" readonly="readonly" maxlength="100"/>
					   <input type="button" value="浏览.." onclick= "fileToUpload.click()"/></p>
					   <p><span id="addfileName"></span> <span id="progressNumber"></span></p>
				   	   <p><input style="margin-left:30px; hidden:true" type="text" id="runType" name="runType" value="" hidden="true"/></p>
				   	   <P><input id="addPath" name="path" hidden ="hidden"/></p>
				   	   <P><input id="addUpdateUser" name="updateUser" hidden ="hidden"/></p>
					   <p><label for="remark" style="vertical-align:top;">备&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;注：</label>
					   <textarea style="margin-left:30px;width:200px;" maxlength="1000" name="remark" id="remark" cols=20 rows=3></textarea></p>
					   <input type="hidden" id="uploadPath" name="uploadPath" value=""/>
					   <input style="margin-left:108px;" type="submit" name="addRow" value="提交" onclick='addDsInfo();'/>
					   <input style="margin-left:42px;" type="button" name="clearRow" value="清空" onclick='clearAddDsAll();'/>					   
				   </fieldset>
				   <iframe id="rfFrame" name="rfFrame" src="about:blank" style="display:none;"></iframe>
				</form>
            </div>
        </div>
    </div>
    <div id="editDsWindow" class="easyui-window" title="修改数据源" style="width: 420px; height: 280px; padding: 5px; background: #fafafa;">
        <div class="easyui-layout" fit="true" style="min-width:380px;">
            <div region="center" border="false" style="padding: 10px; background: #fff; border: 1px solid #ccc;">
                <form id="editDsForm" method="post" enctype="multipart/form-data">
				   <fieldset>
				   	   <input type="hidden" id="id" name="id" value="序号"/>
				   	   <p><label for="dsName">数据源名称：</label><input style="margin-left:30px;width:200px;" maxlength="100" type="text" id="editDs" name="dataName" value=""/></p>
					   <p><label for="csName">采集程序包：</label>
					   <input type="file" name="editfileToUpload" id="editfileToUpload" style="display:none;" onchange="fileSelected(2);"/>
					   <input style="margin-left:30px;" maxlength="100" id="editCs" name="collectionSorce" value="" readonly="readonly"/>
					   <input style="margin-left:5px; " type="button" value="浏览.." disabled ="disabled" onclick= "fileToUpload.click()"/></p>
					   <!-- <input style="margin-left:30px;" id="editCs" name="collectionSorce" value="" /></p>
					   <p><label for="dsName">修改采集包：</label><input type="file" name="editfileToUpload" id="editfileToUpload" style="margin-left:30px;" onchange="fileSelected(2);"/></p>
					    --><!--<span id="fileSize"></span><span id="editfileName"></span><span id="fileSize"></span> --> 
					   <p><span id="editfileName"></span><span id="progressNumber"></span></p>
				   	   <p><input style="margin-left:30px; hidden:true" type="text" id="editrunType" name="runType" value="" hidden="true"/></p>
				   	   <P><input id="editPath" name="path" hidden ="hidden"/></p>
				   	   <P><input id="editUpdateUser" name="updateUser" hidden ="hidden"/></p>
					   <p><label for="remark" style="vertical-align:top">备&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;注：</label>
					   <textarea style="margin-left:30px;width:200px;" maxlength="1000" name="remark" id="editRemark" cols=20 rows=3></textarea></p>
					   <input type="hidden" id="selectIndex" name="selectIndex" value=""/>
					   <input style="margin-left:108px;" type="submit" name="editRow" value="提交" onclick='editDsInfo();'/>
					   <input style="margin-left:42px;" type="button" name="clearRow" value="取消" onclick='clearEditDsAll();'/>					   
				   </fieldset>
				   <iframe id="editrfFrame" name="editrfFrame" src="about:blank" style="display:none;"></iframe>
				</form>
            </div>
        </div>
    </div>
</body>
</html>
