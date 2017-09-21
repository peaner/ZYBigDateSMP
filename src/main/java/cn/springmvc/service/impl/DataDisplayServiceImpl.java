package cn.springmvc.service.impl;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import cn.springmvc.dao.DataDisplayDAO;
import cn.springmvc.model.DataDisplay;
import cn.springmvc.service.DataDisplayService;

/**
 * sevice实现类处理
 * 数据展示
 * @author PEANER-Li
 *
 */
@Service
public class DataDisplayServiceImpl implements DataDisplayService {

	@Autowired
	private DataDisplayDAO dataDisplayDAO;
	
	@Override
	public List<DataDisplay> queryDataDisplay(Map<String,Object> map) {
		return dataDisplayDAO.queryDataDisplay(map);
	}

	@Override
	public List<DataDisplay> queryDataDisplayByPage(Map<String, Object> map) {
		return dataDisplayDAO.queryDataDisplayByPage(map);
	}

	@Override
	public int deleteDataDisplay(DataDisplay dataDisplay) {
		return dataDisplayDAO.deleteDataDisplay(dataDisplay);
	}

	@Override
	public int insertDataDisplay(DataDisplay dataDisplay) {
		return dataDisplayDAO.insertDataDisplay(dataDisplay);
	}

	@Override
	public int editDataDisplay(DataDisplay dataDisplay) {
		return dataDisplayDAO.editDataDisplay(dataDisplay);
	}

	@Override
	public int editDataDisplayRunType(Map<String, Object> map) {
		return dataDisplayDAO.editDataDisplayRunType(map);
	}

}
