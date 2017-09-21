package cn.springmvc.controller;

import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import cn.common.CommonConstant;
import cn.springmvc.model.RoleInfo;
import cn.springmvc.model.UserInfo;
import cn.springmvc.service.RoleManageService;
import cn.springmvc.service.UserManageService;

@Controller
@RequestMapping("/roleInfo")
public class RoleManageController {

	@Autowired
	private UserManageService userManageService;
	@Autowired
	private RoleManageService roleManageService;
	
	/**
	 * 结合easy ui返回json 数据
	 * @return
	 * @throws Exception
	 */
	@ResponseBody
	@RequestMapping("roleInfos")
	public Map<String, Object> showRoles(@ModelAttribute("role") RoleInfo roleInfo,@RequestParam(required = false,defaultValue ="1") Integer page,@RequestParam(required = false,defaultValue ="10") Integer rows) throws Exception{
		Map<String, Object> map = new HashMap<String, Object>(); 
		Map<String, Object> mapParam=new HashMap<String, Object>();
		mapParam.put("start", (page-1)*rows);
		mapParam.put("end", page*rows);
		mapParam.put("roleName", roleInfo.getRoleName());
		List<RoleInfo> roles = roleManageService.queryRoleInfoByPage(mapParam);
		map.put("rows",roles);
		map.put("total", roleManageService.queryRoleInfo(roleInfo).size());
		return map;
	}
	
	/**
	 * 表单提交采用对象和参数一起提交
	 * @param roleInfo
	 * @param flag
	 * @return
	 */
	@ResponseBody
	@RequestMapping("addRoleInfo")
	public Map<String, Object> addRole(@ModelAttribute("role") RoleInfo roleInfo) throws Exception{	
		Map<String, Object> map = new HashMap<String, Object>();
		if (roleManageService.queryRoleInfo(roleInfo).size() >= 1) {
			map.put("result", "\""+roleInfo.getRoleName()+"\"角色已存在，无法新增！");
		} else {
			Date date =new Date();
			SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
			roleInfo.setUpdatedTime(sdf.format(date));
			int result = roleManageService.insertRoleInfo(roleInfo);//将页面数据插入数据库	
			if (result==1) {
				map.put("result", "\""+roleInfo.getRoleName()+"\"角色添加成功！");
			} else {
				map.put("result", "\""+roleInfo.getRoleName()+"\"角色添加失败！");
			}
		}
		return map;
	}
	
	@ResponseBody
	@RequestMapping("deleteRole")
	public Map<String, Object> deleteRole(@ModelAttribute("role") RoleInfo roleInfo) throws Exception{
		UserInfo userInfo = new UserInfo();
		Map<String, Object> map = new HashMap<String, Object>();
		userInfo.setRole(roleInfo.getRoleName());
		List<UserInfo> users = userManageService.queryUserInfoByRoleName(userInfo);
		boolean flg = false;
//		for (int i=0;i<users.size();i++) {
//			if (CommonConstant.USER_TYPE_ON.equals(users.get(i).getStatus())) {
//				flg = true;
//				break;
//			}
//		}
		if (users.size() > 0) {
			flg = true;
		}
		
		if (flg) {
			map.put("result", "有用户分配了\""+roleInfo.getRoleName()+"\"的角色权限，请先删除该角色对应的用户！");
		} else {
			int result = roleManageService.deleteRoleInfo(roleInfo);//将页面数据插入数据库	
			if (result==1) {
				map.put("result", "\""+roleInfo.getRoleName()+"\"角色删除成功！");
			} else {
				map.put("result", "\""+roleInfo.getRoleName()+"\"角色删除失败！");
			}
		}
		
		return map;
	}
	
	@ResponseBody
	@RequestMapping("updateRole")
	public Map<String, Object> modifyRole(@ModelAttribute("role") RoleInfo roleInfo) throws Exception{
		Map<String, Object> map = new HashMap<String, Object>();
		boolean flg = false;
		// 判断角色名称是否一样
		List<RoleInfo> roles=roleManageService.queryRoleInfoById(roleInfo);
		// 根据修改前的角色名称查询用户
		UserInfo userInfo = new UserInfo();
		userInfo.setRole(roles.get(0).getRoleName());
		List<UserInfo> users = userManageService.queryUserInfoByRoleName(userInfo);
		if (!roles.get(0).getRoleName().equals(roleInfo.getRoleName())) {
			// 根据修改后的角色名称查询数据，如果存在则抛出message
			List<RoleInfo> newRoles=roleManageService.queryRoleInfo(roleInfo);
			if (newRoles.size() > 0) {
				map.put("result", "数据库中已存在\""+roleInfo.getRoleName()+"\"角色，不能执行此操作！");
				return map;
			}
			
			for (int i=0;i<users.size();i++) {
				if (CommonConstant.USER_TYPE_ON.equals(users.get(i).getStatus())) {
					flg = true;
					break;
				}
			}
		}
		
		if (flg) {
			map.put("result", "有在线用户分配了\""+roles.get(0).getRoleName()+"\"的角色权限，该用户退出登录后才能修改！");
		} else {
			Date date =new Date();
			SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
			roleInfo.setUpdatedTime(sdf.format(date));
			int result = roleManageService.updateRoleInfo(roleInfo);
			if (result==1) {
				map.put("result", "\""+roles.get(0).getRoleName()+"\"角色更新成功！");
			} else {
				map.put("result", "\""+roles.get(0).getRoleName()+"\"角色跟新失败！");
			}
			
			if (!roles.get(0).getRoleName().equals(roleInfo.getRoleName())) {
				for (int i=0;i<users.size();i++) {
					users.get(i).setRole(users.get(i).getRole().replace(roles.get(0).getRoleName(), roleInfo.getRoleName()));
					users.get(i).setUpdatedUser(roleInfo.getUpdatedUser());
					users.get(i).setUpdatedTime(roleInfo.getUpdatedTime());
					userManageService.updateUserInfo(users.get(i));
				}
			}
		}
		
		return map;
	}
}