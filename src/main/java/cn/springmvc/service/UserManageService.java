package cn.springmvc.service;


import java.util.List;
import java.util.Map;

import cn.springmvc.model.UserInfo;

/**
 * service接口
 * @author Administrator
 *
 */
public interface UserManageService {
	//插入用户数据
	public int insertUserInfo(UserInfo userInfo);
	//查询用户数据
	public List<UserInfo> queryUserInfo(UserInfo userInfo);
	//分页查询
	public List<UserInfo> queryUserInfoByPage(Map<String, Object> map);
	//删除用户数据
	public int deleteUserInfo(UserInfo userInfo);
	//更新用户
	public int updateUserInfo(UserInfo userInfo);
	//根据用户ID查询用户数据
	List<UserInfo> queryUserInfoById(UserInfo userInfo);
	//查询哟怒数据
	public List<UserInfo> queryUserInfoByRoleName(UserInfo userInfo);
}
