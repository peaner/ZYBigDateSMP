<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page isELIgnored ="true" %>
<!DOCTYPE html>
<head>
<meta charset="utf-8">
<title>遵义大数据</title>
<link rel="stylesheet" type="text/css" href="../css/login.css" />
<script type="text/javascript" src="../jquery-easyui-1.4.4/jquery.min.js"></script>
<script type="text/javascript" src="../jquery-easyui-1.4.4/jquery.easyui.min.js"></script>
<script type="text/javascript">
$(function () {
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
});

function login() {
	$('#login').form({
		url: "../userInfo/login.do",
		success: function(data){
			var dataResult = eval('('+data+')');
			if (dataResult.result == 0) {
				window.location.href="/ZYBigDateSMP/jsp/index.jsp?userName="+$('#userName').val();
			} else {
				alert(dataResult.result);
			}
		}
	});
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

</script>
</head>
<body style="background-image:url(../images/bk.png);background-size:cover; background-repeat:no-repeat;">
<div class="container">
	<section id="content">
		<form id="login" action="">
			<h1>用户登录</h1>
			<div>
				<input type="text" placeholder="Username" required="" id="userName" name="userName" />
			</div>
			<div>
				<input type="password" placeholder="Password" required="" id="passWord" name="passWord" />
			</div>
			<div>
				<input type="submit" value="登   录" style="margin-left:100px; width:150px" onclick="login();"/>
<!-- 				<a href="#">Lost your password?</a>
				<a href="#">Register</a> -->
			</div>
		</form>
		<div class="button">
			<p>遵义大数据</p>
		</div><!-- button -->
	</section><!-- content -->
</div><!-- container -->
</body>
</html>