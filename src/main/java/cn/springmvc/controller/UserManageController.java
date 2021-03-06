package cn.springmvc.controller;

import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;







import javax.servlet.http.HttpServletRequest;
import javax.websocket.Session;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.context.request.RequestContextHolder;
import org.springframework.web.context.request.ServletRequestAttributes;
import org.springframework.web.servlet.handler.HandlerInterceptorAdapter;

import cn.common.CommonConstant;
import cn.springmvc.model.RoleInfo;
import cn.springmvc.model.UserInfo;
import cn.springmvc.service.RoleManageService;
import cn.springmvc.service.UserManageService;

@Controller
@RequestMapping("/userInfo")
public class UserManageController extends HandlerInterceptorAdapter {
	@Autowired
	private UserManageService userManageService;
	@Autowired
	private RoleManageService roleManageService;
	
	@ResponseBody
	@RequestMapping("login")
	public Map<String, Object> login(@ModelAttribute("userInfo") UserInfo userInfo) {
		Map<String, Object> map = new HashMap<String, Object>(); 
		
		List<UserInfo> users = userManageService.queryUserInfo(userInfo);
		if (users.size() == 0) {
			map.put("result", "\"" + userInfo.getUserName()+"\"用户不存在，请检查用户名是否正确！");
		} else if (users.size() > 1) {
			map.put("result", "\"" + userInfo.getUserName()+"\"用户不唯一，请检查用户名是否正确！");
		} else {
			if (!userInfo.getPassWord().equals(users.get(0).getPassWord())) {
				map.put("result", "用户名或密码不正确，请重新输入！");
			} else {
				//修改部分
				//问题====session应该在前端传递过来，这样才能利用好session监听浏览器的关闭，因为浏览器的关闭而session失效
				HttpServletRequest request =  ((ServletRequestAttributes)RequestContextHolder.getRequestAttributes()).getRequest();
				String session = (String) request.getSession().getAttribute(CommonConstant.SESSION_USER);
				
				if ("1".equals(session)) {
					map.put("result", "\"" + userInfo.getUserName()+"\"用户处于登录中！");
				}else {
					//没有检测到session，可以登录
					map.put("result","0");
					request.getSession().setMaxInactiveInterval(1);
					//更新登录状态
					Date date =new Date();
					SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
					users.get(0).setUpdatedTime(sdf.format(date));
					users.get(0).setStatus(CommonConstant.USER_TYPE_ON);
					users.get(0).setUpdatedUser(userInfo.getUserName());
					//修改部分
					request.getSession().setAttribute(CommonConstant.SESSION_USER, "1");
					userManageService.updateUserInfo(users.get(0));
				}
				
				/*if (CommonConstant.USER_TYPE_ON.equals(users.get(0).getStatus())) {
					map.put("result", "\"" + userInfo.getUserName()+"\"用户处于登录中！");
				} else {
					map.put("result","0");
					Subject currentSubject = SecurityUtils.getSubject();
					Session session = currentSubject.getSession();
							
					//更新登录状态
					Date date =new Date();
					SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
					users.get(0).setUpdatedTime(sdf.format(date));
					users.get(0).setStatus(CommonConstant.USER_TYPE_ON);
					users.get(0).setUpdatedUser(userInfo.getUserName());
					session.setAttribute(CommonConstant.SESSION_USER, users);
					userManageService.updateUserInfo(users.get(0));
				}*/
			}
		}
		
		return map;
	}
	
	@ResponseBody
	@RequestMapping("logout")
	public Map<String, Object> logout(@ModelAttribute("userInfo") UserInfo userInfo) {
		Map<String, Object> map = new HashMap<String, Object>(); 
		
		List<UserInfo> users = userManageService.queryUserInfo(userInfo);
		if (users.size() == 0) {
			map.put("result", "\"" + userInfo.getUserName()+"\"用户不存在，请检查用户名是否正确！");
		} else if (users.size() > 1) {
			map.put("result", "\"" + userInfo.getUserName()+"\"用户不唯一，请检查用户名是否正确！");
		} else {
			map.put("result","0");
			
			//修改部分
			HttpServletRequest request =  ((ServletRequestAttributes)RequestContextHolder.getRequestAttributes()).getRequest();
			
			/*Subject currentSubject = SecurityUtils.getSubject();
			Session session = currentSubject.getSession();*/
			
			//更新登录状态
			Date date =new Date();
			SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
			users.get(0).setUpdatedTime(sdf.format(date));
			users.get(0).setStatus(CommonConstant.USER_TYPE_OFF);
			users.get(0).setUpdatedUser(userInfo.getUserName());
			userManageService.updateUserInfo(users.get(0));
			request.getSession().removeAttribute(CommonConstant.SESSION_USER);
		}
		
		return map;
	}
	
	@ResponseBody
	@RequestMapping("modifyPwd")
	public Map<String, Object> modifyPwd(@ModelAttribute("userInfo") UserInfo userInfo) {
		Map<String, Object> map = new HashMap<String, Object>(); 
		
		List<UserInfo> users = userManageService.queryUserInfo(userInfo);
		if (users.size() == 0) {
			map.put("result", "\"" + userInfo.getUserName()+"\"用户不存在，请检查用户名是否正确！");
		} else if (users.size() > 1) {
			map.put("result", "\"" + userInfo.getUserName()+"\"用户不唯一，请检查用户名是否正确！");
		} else {
			Date date =new Date();
			SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
			users.get(0).setUpdatedTime(sdf.format(date));
			users.get(0).setUpdatedUser(userInfo.getUserName());
			users.get(0).setPassWord(userInfo.getPassWord());
			userManageService.updateUserInfo(users.get(0));
			map.put("result","成功更改密码！");
		}
		
		return map;
	}

	/**
	 * 结合easy ui返回json 数据
	 * @return
	 * @throws Exception
	 */
	@ResponseBody
	@RequestMapping("userInfos")
	public Map<String, Object> showUsers(@ModelAttribute("userInfo") UserInfo userInfo,@RequestParam(required = false,defaultValue ="1") Integer page,@RequestParam(required = false,defaultValue ="10") Integer rows) throws Exception{
		System.out.println(userInfo.getUserName());
		Map<String, Object> map = new HashMap<String, Object>(); 
		Map<String, Object> mapParam=new HashMap<String, Object>();
		mapParam.put("start", (page-1)*rows);
		mapParam.put("end", page*rows);
		mapParam.put("userName", userInfo.getUserName());
		List<UserInfo> users = userManageService.queryUserInfoByPage(mapParam);
		map.put("rows",users);
		map.put("total", userManageService.queryUserInfo(userInfo).size());
		return map;
	}	

	/**
	 * 接收前台传递过来的表单数据
	 * 用户的增加操作
	 * @return
	 */
	@ResponseBody
	@RequestMapping("addUserInfo")
	public Map<String, Object> addUserInfo(@ModelAttribute("userInfo") UserInfo userInfo) throws Exception{
		Map<String, Object> map = new HashMap<String, Object>();
		if (userManageService.queryUserInfo(userInfo).size() >= 1) {
			map.put("result", "\"" + userInfo.getUserName()+"\"用户已存在，无法添加！");
		} else {
			Date date =new Date();
			SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
			userInfo.setUpdatedUser(userInfo.getUpdatedUser());
			userInfo.setUpdatedTime(sdf.format(date));
			userInfo.setStatus(CommonConstant.USER_TYPE_OFF);
			int result = userManageService.insertUserInfo(userInfo);
			if (result==1) {
				map.put("result", "\"" + userInfo.getUserName()+"\"用户成功插入！");
			} else {
				map.put("result", "\"" + userInfo.getUserName()+"\"用户插入失败！");
			}
		}
		return map;
	}
	
	/**
	 * 接收前台传递过来的表单数据
	 * 用户信息的修改操作
	 * @return
	 */
	@ResponseBody
	@RequestMapping("updateUserInfo")
	public Map<String, Object> modifyUserInfo(@ModelAttribute("userInfo") UserInfo userInfo) throws Exception{
		Map<String, Object> map = new HashMap<String, Object>();
		// 判断用户名是否更该
		List<UserInfo> oldUsers = userManageService.queryUserInfoById(userInfo);
		if (oldUsers.size() == 1) {
			if (!oldUsers.get(0).getUserName().equals(userInfo.getUserName())) {
				// 判断新用户名是否存在
				List<UserInfo> newUsers = userManageService.queryUserInfo(userInfo);
				if (newUsers.size() > 0) {
					map.put("result", "\"" + userInfo.getUserName()+"\"用户名在数据库中已存在，不能执行更新操作！");
					return map;
				}
			} else {
				Date date =new Date();
				SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
				userInfo.setUpdatedTime(sdf.format(date));
				int result = userManageService.updateUserInfo(userInfo);
				if (result==1) {
					map.put("result", "\"" + oldUsers.get(0).getUserName()+"\"用户更新成功！");
				} else {
					map.put("result", "\"" + oldUsers.get(0).getUserName()+"\"用户跟新失败！");
				}
			}
		} else {
			map.put("result", "\"" + oldUsers.get(0).getUserName()+"\"用户不存在！");
		}
		return map;
	}
	
	/**
	 * 接收前台传递过来的表单数据
	 * 用户信息的删除操作
	 * @return
	 */
	@ResponseBody
	@RequestMapping("deleteUserInfo")
	public Map<String, Object> deleteUserInfo(@ModelAttribute("userInfo") UserInfo userInfo) throws Exception{
		Map<String, Object> map = new HashMap<String, Object>();
//		if("1".equals(userInfo.getStatus())) {
		int result = userManageService.deleteUserInfo(userInfo);
		if (result==1) {
			map.put("result", "\"" + userInfo.getUserName()+"\"用户删除成功！");
		} else {
			map.put("result", "\"" + userInfo.getUserName()+"\"用户删除失败！");
		}
//		} else {
//			map.put("result", "\"" + userInfo.getUserName()+"\"用户处于登录状态，请确保处于离线时进行删除操作！");
//		}
		return map;
	}
	
	/**
	 * 获取角色信息操作
	 * @return
	 */
	@SuppressWarnings({ "rawtypes", "unchecked" })
	@ResponseBody
	@RequestMapping("getRoleInfo")
	public Map<String, Object> getRoleInfos() {
		Map<String, Object> map = new HashMap<String, Object>();
		RoleInfo roleInfo = new RoleInfo();
		StringBuffer sbf = new StringBuffer();
		List roleArray = new ArrayList();
		List<RoleInfo> roles = roleManageService.queryRoleInfo(roleInfo);
		if (roles != null && roles.size() > 0) {
			sbf.append("[");
			for (int i = 0; i < roles.size(); i++) {
				if (!roleArray.contains(roles.get(i).getRoleName())) {
					roleArray.add(roles.get(i).getRoleName());
					if (i == 0) {
						sbf.append("{\"id\":1,\"text\":");
						sbf.append("\"" + roles.get(i).getRoleName() + "\"}");
					} else {
						sbf.append(",{\"text\":");
						sbf.append("\"" + roles.get(i).getRoleName() + "\"}");
					}
				}
			}
			sbf.append("]");
			map.put("result", sbf);
		} else {
			map.put("result", "角色信息不存在，请通知管理员！");
		}
		return map;
	}
	
	/**
	 * 根据用户名获取对应的角色权限
	 * @return
	 */
	@ResponseBody
	@RequestMapping("getRolePermission")
	public Map<String, Object> getRolePermission(@ModelAttribute("userInfo") UserInfo userInfo) {
		Map<String, Object> map = new HashMap<String, Object>();
		List<UserInfo> users = userManageService.queryUserInfo(userInfo);
		if (users.size() == 0) {
			map.put("result", "数据库不存在用户名为\""+userInfo.getUserName()+"\"的数据！");
		} else if (users.size() > 1) {
			map.put("result", "数据库已存在多条用户名为\""+userInfo.getUserName()+"\"的数据！");
		} else {
			String rolePermission = "";
			String role = users.get(0).getRole();
			String [] roleArray = role.split(",");
			for (int i = 0; i < roleArray.length; i++) {
				RoleInfo roleInfoTemp = new RoleInfo();
				roleInfoTemp.setRoleName(roleArray[i]);
				List<RoleInfo> roles = roleManageService.queryRoleInfo(roleInfoTemp);
				if (roles.size() == 0) {
					map.put("result", "数据库不存在角色名为\""+roleInfoTemp.getRoleName()+"\"的数据！");
				} else if (roles.size() > 1) {
					map.put("result", "数据库存在多条角色名为\""+roleInfoTemp.getRoleName()+"\"的数据！");
				} else {
					if (rolePermission == "") {
						rolePermission = roles.get(0).getPermission();
					} else {
						String [] permissionArray = roles.get(0).getPermission().split(",");
						for (int j = 0; j < permissionArray.length; j++) {
							if (!rolePermission.contains(permissionArray[j])) {
								rolePermission = rolePermission + "," + permissionArray[j];
							}
						}
					}
				}
			}
			map.put("result", rolePermission);
		}
		
		return map;
	}
}