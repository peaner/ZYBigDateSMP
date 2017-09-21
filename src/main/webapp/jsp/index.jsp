<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>遵义大数据服务与管理平台SMP</title>
<link rel="stylesheet" type="text/css" href="../css/default.css" />
<link rel="stylesheet" type="text/css"
	href="../js/themes/default/easyui.css" />
<link rel="stylesheet" type="text/css" href="../js/themes/icon.css" />
<script type="text/javascript" src="../js/jquery-1.4.4.min.js"></script>
<script type="text/javascript" src="../js/jquery.easyui.min.1.2.2.js"></script>
<script type="text/javascript" src="../js/outlook2.js"> </script>

<script type="text/javascript">

    var str = "";
    var readyMenu = "";
    var userNameUrl = location.search.split("=")[1];

    $.ajax({
    	data:$.param({
    		userName: userNameUrl,
    		flag : '1'}),
    		type: "post",
			url : "../userInfo/getRolePermission.do",
			async: false,
			success:function(data){
				str = data.result;
				 var menuStr = "";
			   	 if (str.indexOf("数据采集")>-1 || str.indexOf("数据展示")>-1 || str.indexOf("数据投放")>-1) {
			   		
			   		 if (str.indexOf("数据采集")>-1) {
			   			 menuStr = "{\"menus\":[";
			   			 menuStr = menuStr + "{\"menuid\":\"1\",\"icon\":\"icon-sys\",\"menuname\":\"大数据服务\",\"menus\":[";
			   			 menuStr = menuStr + "{\"menuid\":\"13\",\"menuname\":\"数据采集\",\"icon\":\"icon-collection\",\"url\":\"data_source_manage.jsp\"}";
			   		 }
			   		
			   		 if (str.indexOf("数据展示")>-1) {
			   			 if (menuStr == "") {
			   				 menuStr = "{\"menus\":[";
			      			 menuStr = menuStr + "{\"menuid\":\"1\",\"icon\":\"icon-sys\",\"menuname\":\"大数据服务\",\"menus\":[";
			      			 menuStr = menuStr + "{\"menuid\":\"14\",\"menuname\":\"数据展示\",\"icon\":\"icon-display\",\"url\":\"data_display.jsp\"}";
			   			 } else {
			   				 menuStr = menuStr + ",{\"menuid\":\"14\",\"menuname\":\"数据展示\",\"icon\":\"icon-display\",\"url\":\"data_display.jsp\"}";
			   			 }
			   		 }
			   				 
			   		if (str.indexOf("数据投放")>-1) {
			  			 if (menuStr == "") {
			  				 menuStr = "{\"menus\":[";
			     			 menuStr = menuStr + "{\"menuid\":\"1\",\"icon\":\"icon-sys\",\"menuname\":\"大数据服务\",\"menus\":[";
			     			 menuStr = menuStr + "{\"menuid\":\"15\",\"menuname\":\"数据投放\",\"icon\":\"icon-protective\",\"url\":\"data_projective.jsp\"}";
			  			 } else {
			  				 menuStr = menuStr + ",{\"menuid\":\"15\",\"menuname\":\"数据投放\",\"icon\":\"icon-protective\",\"url\":\"data_projective.jsp\"}";
			  			 }
			  		}
			   		if (menuStr != "") {
			   			menuStr = menuStr + "]}";
			   		}
			  		
			   	 }
			   
			   	var strSystem = "";
			   	if (str.indexOf("角色管理")>-1 || str.indexOf("用户管理")>-1 || str.indexOf("系统设置")>-1) {
			   		
			  		 if (str.indexOf("角色管理")>-1) {
			  			strSystem = strSystem + "{\"menuid\":\"8\",\"icon\":\"icon-sys\",\"menuname\":\"系统管理\",\"menus\":[";
			  			strSystem = strSystem + "{\"menuid\":\"21\",\"menuname\":\"角色管理\",\"icon\":\"icon-role\",\"url\":\"roleManage.jsp\"}";
			  		 }
			  		
			  		 if (str.indexOf("用户管理")>-1) {
			  			 if (strSystem == "") {
			  				strSystem = strSystem + "{\"menuid\":\"8\",\"icon\":\"icon-sys\",\"menuname\":\"系统管理\",\"menus\":[";
			  				strSystem = strSystem + "{\"menuid\":\"22\",\"menuname\":\"用户管理\",\"icon\":\"icon-users\",\"url\":\"usermanage.jsp\"}";
			  			 } else {
			  				strSystem = strSystem + ",{\"menuid\":\"22\",\"menuname\":\"用户管理\",\"icon\":\"icon-users\",\"url\":\"usermanage.jsp\"}";
			  			 }
			  		 }
			  				 
			  		if (str.indexOf("系统设置")>-1) {
			 			 if (strSystem == "") {
			 				strSystem = strSystem + "{\"menuid\":\"8\",\"icon\":\"icon-sys\",\"menuname\":\"系统管理\",\"menus\":[";
			 				strSystem = strSystem + "{\"menuid\":\"23\",\"menuname\":\"系统设置\",\"icon\":\"icon-set\",\"url\":\"systemManage.jsp\"}";
			 			 } else {
			 				strSystem = strSystem + ",{\"menuid\":\"23\",\"menuname\":\"系统设置\",\"icon\":\"icon-set\",\"url\":\"systemManage.jsp\"}";
			 			 }
			 		}
			  		
			  		if (strSystem != "") {
			  			strSystem = strSystem + "]}";
			  		}
			 		
			  	 }
			   	
			  	 
			  	 if (menuStr!= "" && strSystem!="") {
			  		readyMenu = menuStr+","+strSystem+"]}";
			  	 } else if (menuStr=="" && strSystem!="") {
			  		readyMenu = "{\"menus\":["+strSystem+"]}";
			  	 } else if (menuStr!="" && strSystem=="") {
			  		readyMenu = menuStr+"]}";
			  	 }
			  		 
			  	
			}
		});
    
    	var _menus = JSON.parse(readyMenu);

    	function checkPwdForTxtNewPass(pwd) {
    		if (!(/^[0-9A-Za-z]{6,20}$/.test(pwd))) {
    			var flg = window.confirm("输入密码不正确,密码由6-20字母和数字组成，请重新输入！");
    			if (flg) {
    				document.getElementById("txtNewPass").style.color="red";
    				$("#txtNewPass").focus();
    			}
    		} else {
    			document.getElementById("txtNewPass").style.color="black";
    		}
    	}
    	
    	function checkPwdForTxtRePass(pwd) {
    		if (!(/^[0-9A-Za-z]{6,20}$/.test(pwd))) {
    			var flg = window.confirm("输入密码不正确,密码由6-20字母和数字组成，请重新输入！");
    			if (flg) {
    				document.getElementById("txtRePass").style.color="red";
    				$("#txtRePass").focus();
    			}
    		} else {
    			document.getElementById("txtRePass").style.color="black";
    		}
    	}
				
        //设置登录窗口
        function openPwd() {
            $('#w').window({
                title: '修改密码',
                width: 300,
                modal: true,
                shadow: true,
                closed: true,
                height: 160,
                resizable:false
            });
        }
        //关闭登录窗口
        function closePwd() {
            $('#w').window('close');
        }

        //修改密码
        function serverLogin() {
            var $newpass = $('#txtNewPass');
            var $rePass = $('#txtRePass');

            if ($newpass.val() == '') {
                msgShow('系统提示', '请输入密码！', 'warning');
                return false;
            }
            if ($rePass.val() == '') {
                msgShow('系统提示', '请在一次输入密码！', 'warning');
                return false;
            }

            if ($newpass.val() != $rePass.val()) {
                msgShow('系统提示', '两次密码不一至！请重新输入', 'warning');
                return false;
            }
/* 
            $.post('/ajax/editpassword.ashx?newpass=' + $newpass.val(), function(msg) {
                msgShow('系统提示', '恭喜，密码修改成功！<br>您的新密码为：' + msg, 'info');
                $newpass.val('');
                $rePass.val('');
                close();
            })
             */
            $.ajax({
            	data:$.param({
            		userName : location.search.split("=")[1],
            		passWord : $newpass.val(),
    				flag : '2'}),
            	type: "post",
     			url : "../userInfo/modifyPwd.do",
     			success:function(data){
     				$.messager.alert('提示信息', data.result);
     				closePwd();
     			}
     		});
            
        }

        $(function() {

            openPwd();

            $('#editpass').click(function() {
                $('#w').window('open');
            });

            $('#btnEp').click(function() {
                serverLogin();
            });

			$('#btnCancel').click(function(){closePwd();});

            $('#loginOut').click(function() {
                var r= window.confirm('您确定要退出本次登录吗?');
                if (r) {
                	$.ajax({
    		        	data:$.param({
    		        		userName: document.getElementById("loginUserName").innerText,
    		        		flag : '1'}),
    		        	type: "post",
    		 			url : "../userInfo/logout.do",
    		 			success:function(data){
    		 				if(data.result != 0) {
    		 					alert(data.result);
    		 				} else {
    		 					location.href = '/ZYBigDateSMP/jsp/login.jsp';
    		 				}
    		 			}
    		 		});  
                }
            });
            
            $('#txtNewPass').focusout(function() {
        		var passWord = document.getElementById('txtNewPass').value;
        		if (passWord) {
        			checkPwdForTxtNewPass(passWord);
        		}
        	});
            
            $('#txtRePass').focusout(function() {
        		var passWord = document.getElementById('txtRePass').value;
        		if (passWord) {
        			checkPwdForTxtRePass(passWord);
        		}
        	});
        }); 
              
</script>


<!-- 要解决的是判断什么是刷新什么是关闭浏览器 ，不然刷新也会使用户的登录状态改变，这样就会有bug 
         还有一点是要将这些公用的js代码放在公共域，以求达到代码的解耦，使代码的复用性更强-->

<!-- <script type="text/javascript" language="javascript">
	$(window).unload(function() {
		var a_n = window.event.screenX - window.screenLeft;    
	    var a_b = a_n > document.documentElement.scrollWidth-20;    
	    if(a_b && window.event.clientY< 0 || window.event.altKey){    
	         alert("关闭页面行为"); 
	         /* alert("获取到了页面要关闭的事件了！");
	 		console.log("获取到了页面要关闭的事件了！"); */
	 		$.ajax({
	 			data : $.param({
	 				userName : document.getElementById("loginUserName").innerText,
	 				flag : '1'
	 			}),
	 			type : "post",
	 			url : "../userInfo/logout.do",
	 			success : function(data) {
	 				if (data.result != 0) {
	 					alert(data.result);
	 				} else {
	 					location.href = '/ZYBigDateSMP/jsp/login.jsp';
	 				}
	 			}
	 		});
	    }else{ 
	         alert("跳转或者刷新页面行为");   
	      } 
	});
</script> -->

</head>
<body class="easyui-layout" style="overflow-y: hidden" scroll="no" onunload="CloseOpen(event)">
	<noscript>
		<div
			style=" position:absolute; z-index:100000; height:2046px;top:0px;left:0px; width:100%; background:white; text-align:center;">
			<img src="../images/noscript.gif" alt='抱歉，请开启脚本支持！' />
		</div>
	</noscript>
	<div region="north" split="true" border="false"
		style="overflow: hidden; height: 40px;
        background: url(../images/layout-browser-hd-bg.gif) #7f99be repeat-x center 60%;
        line-height: 35px;color: #fff; font-family: Verdana, 微软雅黑,黑体">
		<span style="float:right; padding-right:20px; font-size: 14px;"
			class="head">欢迎<span id="loginUserName">${param.userName}</span>
			<a href="#" id="editpass" style="font-size: 14px;">修改密码</a> <a
			href="#" id="loginOut" style="font-size: 14px;">安全退出</a></span> <span
			style="padding-left:10px; font-size: 16px; "><img
			src="../images/logo4.png" width="30" height="30" align="absmiddle" />
			遵义大数据服务与管理平台SMP</span>
	</div>
	<div region="south" split="true"
		style="height: 35px; background: #D2E0F2; ">
		<div class="footer"
			style="float:center; padding-right:20px; font-size: 15px;">©2016
			遵义贵人购.All Rights Reserved</div>
	</div>
	<div region="west" hide="true" split="true" title="导航菜单"
		style="width:180px;" id="west">
		<div id="nav" class="easyui-accordion" fit="true" border="false"></div>

	</div>
	<div id="mainPanle" region="center"
		style="background: #eee; overflow-y:hidden">
		<div id="tabs" class="easyui-tabs" fit="true" border="false"></div>
	</div>


	<!--修改密码窗口-->
	<div id="w" class="easyui-window" title="修改密码" collapsible="false"
		minimizable="false" maximizable="false" icon="icon-save"
		style="width: 300px; height: 150px; padding: 5px;
        background: #fafafa;">
		<div class="easyui-layout" fit="true">
			<div region="center" border="false"
				style="padding: 10px; background: #fff; border: 1px solid #ccc;">
				<table cellpadding=3>
					<tr>
						<td>新密码：</td>
						<td><input id="txtNewPass" type="password" class="txt01" /></td>
					</tr>
					<tr>
						<td>确认密码：</td>
						<td><input id="txtRePass" type="password" class="txt01" /></td>
					</tr>
				</table>
			</div>
			<div region="south" border="false"
				style="text-align: right; height: 30px; line-height: 30px;">
				<a id="btnEp" class="easyui-linkbutton" icon="icon-ok"
					href="javascript:void(0)"> 确定</a> <a id="btnCancel"
					class="easyui-linkbutton" icon="icon-cancel"
					href="javascript:void(0)">取消</a>
			</div>
		</div>
	</div>

	<div id="mm" class="easyui-menu" style="width:150px;">
		<div id="mm-tabupdate">刷新</div>
		<div class="menu-sep"></div>
		<div id="mm-tabclose">关闭</div>
		<div id="mm-tabcloseall">全部关闭</div>
		<div id="mm-tabcloseother">除此之外全部关闭</div>
		<div class="menu-sep"></div>
		<div id="mm-tabcloseright">当前页右侧全部关闭</div>
		<div id="mm-tabcloseleft">当前页左侧全部关闭</div>
		<div class="menu-sep"></div>
		<div id="mm-exit">退出</div>
	</div>

	<!-- <script type="text/javascript" src="../js/closed.js"></script> -->
</body>
</html>