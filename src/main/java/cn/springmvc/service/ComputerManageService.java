package cn.springmvc.service;


import java.util.List;
import java.util.Map;

import cn.springmvc.model.ComputerInfo;

/**
 * service接口
 * @author Administrator
 *
 */
public interface ComputerManageService {
	//插入用户数据
	public int insertComputerInfo(ComputerInfo computerInfo);
	//查询用户数据
	public List<ComputerInfo> queryComputerInfo(ComputerInfo computerInfo);
	//分页查询
	public List<ComputerInfo> queryComputerInfoByPage(Map<String, Object> map);
	//删除用户数据
	public int deleteComputerInfo(ComputerInfo computerInfo);
	//更新用户
	public int updateComputerInfo(ComputerInfo computerInfo);
	//根据用户ID查询用户数据
	List<ComputerInfo> queryComputerInfoById(ComputerInfo computerInfo);
}
