package cn.springmvc.service.impl;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import cn.springmvc.dao.ComputerManageDAO;
import cn.springmvc.model.ComputerInfo;
import cn.springmvc.service.ComputerManageService;

/**
 * sevice实现类处理
 * @author Administrator
 *
 */
@Service
public class ComputerManageServiceImpl implements ComputerManageService {

	@Autowired
	private ComputerManageDAO computerManageDAO;

	@Override
	public int insertComputerInfo(ComputerInfo computer) {
		return computerManageDAO.insertComputerInfo(computer);
	}

	@Override
	public List<ComputerInfo> queryComputerInfo(ComputerInfo computerInfo) {
		return computerManageDAO.queryComputerInfo(computerInfo);
	}
	
	@Override
	public List<ComputerInfo> queryComputerInfoById(ComputerInfo computerInfo) {
		return computerManageDAO.queryComputerInfoById(computerInfo);
	}

	@Override
	public List<ComputerInfo> queryComputerInfoByPage(Map<String, Object> map) {
		return computerManageDAO.queryComputerInfoByPage(map);
	}
	
	@Override			
	public int deleteComputerInfo(ComputerInfo computerInfo) {
		 return computerManageDAO.deleteComputerInfo(computerInfo);
	}

	@Override
	public int updateComputerInfo(ComputerInfo computerInfo) {
		 return computerManageDAO.updateComputerInfo(computerInfo);
	}
	
	
}
