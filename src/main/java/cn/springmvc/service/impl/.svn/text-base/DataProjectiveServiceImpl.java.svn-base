package cn.springmvc.service.impl;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import cn.springmvc.dao.DataProjectiveDAO;
import cn.springmvc.model.DataProjective;
import cn.springmvc.service.DataProjectiveService;


/**
 * sevice实现类处理
 * 数据投放
 * @author PEANER-Li
 *
 */
@Service
public class DataProjectiveServiceImpl implements DataProjectiveService {

	@Autowired
	private DataProjectiveDAO dataProjectiveDAO;
	
	
	@Override
	public List<DataProjective> queryDataProjective(Map<String, Object> map) {
		return dataProjectiveDAO.queryDataProjective(map);
	}

	@Override
	public List<DataProjective> queryDataProjectiveByPage(Map<String, Object> map) {
		return dataProjectiveDAO.queryDataProjectiveByPage(map);
	}

	@Override
	public int insertProjectiveData(DataProjective dataProjective) {
		return dataProjectiveDAO.insertProjectiveData(dataProjective);
	}

	@Override
	public int deleteProjectiveData(DataProjective dataProjective) {
		return dataProjectiveDAO.deleteProjectiveData(dataProjective);
	}

	@Override
	public int editProjectiveData(DataProjective dataProjective) {
		return dataProjectiveDAO.editProjectiveData(dataProjective);
	}

	@Override
	public int editProjectiveDataByDisplayName(Map<String, Object> map) {
		return dataProjectiveDAO.editProjectiveDataByDisplayName(map);
	}
	
	@Override
	public int editProjectiveDataByScreen(Map<String, Object> map) {
		return dataProjectiveDAO.editProjectiveDataByScreen(map);
	}

}
