package cn.springmvc.service.impl;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import cn.springmvc.dao.RoleManageDAO;
import cn.springmvc.model.RoleInfo;
import cn.springmvc.service.RoleManageService;

/**
 * sevice实现类处理
 * @author Administrator
 *
 */
@Service
public class RoleManageServiceImpl implements RoleManageService {

	@Autowired
	private RoleManageDAO roleManageDAO;

	@Override
	public int insertRoleInfo(RoleInfo role) {
		return roleManageDAO.insertRoleInfo(role);
	}

	@Override
	public List<RoleInfo> queryRoleInfo(RoleInfo roleInfo) {
		return roleManageDAO.queryRoleInfo(roleInfo);
	}
	
	@Override
	public List<RoleInfo> queryRoleInfoById(RoleInfo roleInfo) {
		return roleManageDAO.queryRoleInfoById(roleInfo);
	}

	@Override
	public List<RoleInfo> queryRoleInfoByPage(Map<String, Object> map) {
		return roleManageDAO.queryRoleInfoByPage(map);
	}
	
	//删除用户数据
	public int deleteRoleInfo(RoleInfo roleInfo) {
		return roleManageDAO.deleteRoleInfo(roleInfo);
	}

	@Override
	public int updateRoleInfo(RoleInfo roleInfo) {
		return roleManageDAO.updateRoleInfo(roleInfo);
	}
	
	
}
