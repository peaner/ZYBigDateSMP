package cn.springmvc.dao;

import java.util.List;
import java.util.Map;

import cn.springmvc.model.UserInfo;

/**
 * 数据库操作接口
 * @author Administrator
 *
 */
public interface UserManageDAO {

	//插入用户数据
	public int insertUserInfo(UserInfo userInfo);
	//查询哟怒数据
	public List<UserInfo> queryUserInfo(UserInfo userInfo);
	//分页查询
	public List<UserInfo> queryUserInfoByPage(Map<String, Object> map);
	//根据用户ID查询用户数据
	public List<UserInfo> queryUserInfoById(UserInfo userInfo);
	//删除数据
	public int deleteUserInfo(UserInfo userInfo);
	//更新数据
	public int updateUserInfo(UserInfo userInfo);
	//查询哟怒数据
	public List<UserInfo> queryUserInfoByRoleName(UserInfo userInfo);
	
}
