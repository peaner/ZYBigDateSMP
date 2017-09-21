package cn.springmvc.service.impl;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import cn.springmvc.dao.UserManageDAO;
import cn.springmvc.model.UserInfo;
import cn.springmvc.service.UserManageService;

/**
 * sevice实现类处理
 * @author Administrator
 *
 */
@Service
public class UserManageServiceImpl implements UserManageService {

	@Autowired
	private UserManageDAO userManageDAO;

	@Override
	public int insertUserInfo(UserInfo user) {
		return userManageDAO.insertUserInfo(user);
	}

	@Override
	public List<UserInfo> queryUserInfo(UserInfo userInfo) {
		return userManageDAO.queryUserInfo(userInfo);
	}
	
	@Override
	public List<UserInfo> queryUserInfoById(UserInfo userInfo) {
		return userManageDAO.queryUserInfoById(userInfo);
	}

	@Override
	public List<UserInfo> queryUserInfoByPage(Map<String, Object> map) {
		return userManageDAO.queryUserInfoByPage(map);
	}
	
	@Override			
	public int deleteUserInfo(UserInfo userInfo) {
		 return userManageDAO.deleteUserInfo(userInfo);
	}

	@Override
	public int updateUserInfo(UserInfo userInfo) {
		 return userManageDAO.updateUserInfo(userInfo);
	}

	@Override
	public List<UserInfo> queryUserInfoByRoleName(UserInfo userInfo) {
		return userManageDAO.queryUserInfoByRoleName(userInfo);
	}
	
	
}
