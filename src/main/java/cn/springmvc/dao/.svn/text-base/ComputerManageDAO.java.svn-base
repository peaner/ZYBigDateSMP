package cn.springmvc.dao;

import java.util.List;
import java.util.Map;

import cn.springmvc.model.ComputerInfo;

/**
 * 数据库操作接口
 * @author Administrator
 *
 */
public interface ComputerManageDAO {

	//插入用户数据
	public int insertComputerInfo(ComputerInfo computerInfo);
	//查询哟怒数据
	public List<ComputerInfo> queryComputerInfo(ComputerInfo computerInfo);
	//分页查询
	public List<ComputerInfo> queryComputerInfoByPage(Map<String, Object> map);
	//根据用户ID查询用户数据
	public List<ComputerInfo> queryComputerInfoById(ComputerInfo computerInfo);
	//删除数据
	public int deleteComputerInfo(ComputerInfo computerInfo);
	//更新数据
	public int updateComputerInfo(ComputerInfo computerInfo);
}
