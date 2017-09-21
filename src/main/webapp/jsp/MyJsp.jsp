<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%
String path = request.getContextPath();
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
%>

<!DOCTYPE html>
<html>
<head>
<meta charset="utf-8">
<title>Upload Files using XMLHttpRequest - Minimal</title>
<script type="text/javascript">
	function fileSelected() {
		var file = document.getElementById('fileToUpload').files[0];
		if (file) {
			var fileSize = 0;
			if (file.size > 1024 * 1024){
				fileSize = (Math.round(file.size * 100 / (1024 * 1024)) / 100).toString()+ 'MB';
			}else{
				fileSize = (Math.round(file.size * 100 / 1024) / 100).toString()+ 'KB';
			}
			document.getElementById('fileName').innerHTML = 'Name: ' + file.name;
			document.getElementById('fileSize').innerHTML = 'Size: ' + fileSize;
			document.getElementById('fileType').innerHTML = 'Type: ' + file.type;
		}
	}
	function uploadFile() {
		var fd = new FormData();
		fd.append("fileHandler",document.getElementById('fileToUpload').files[0]);
		var xhr = new XMLHttpRequest();
		xhr.upload.addEventListener("progress", uploadProgress, false);
		xhr.addEventListener("load", uploadComplete, false);
		xhr.addEventListener("error", uploadFailed, false);
		xhr.addEventListener("abort", uploadCanceled, false);
		//接口地方
		xhr.open("POST", "../dataSource/uploadInfo.do");
		xhr.send(fd);
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
		/* This event is raised when the server send back a response */
		alert(evt.target.responseText);
	}
	function uploadFailed(evt) {
		alert("There was an error attempting to upload the file.");
	}
	function uploadCanceled(evt) {
		alert("The upload has been canceled by the user or the browser dropped the connection.");
	}
</script>
</head>
<body>
<input type="file" class="easyui-filebox" name="fileToUpload" id="fileToUpload" style="width:260px;" onchange="fileSelected();" /> 
<span id="fileName"></span> 
<span id="fileSize"></span> 
<span id="fileType"></span> 
<input type="button" onclick="uploadFile()" value="Upload" /> 
<span id="progressNumber"></span>
<a>status</a>
</body>
</html>