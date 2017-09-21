
package cn.springmvc.service.impl;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import cn.springmvc.dao.DataManageDAO;
import cn.springmvc.model.DataSource;
import cn.springmvc.service.DataManageService;

/**
 * sevice实现类处理
 * @author Administrator
 *
 */
@Service
public class DataManageServiceImpl implements DataManageService {

	@Autowired
	private DataManageDAO dataManageDAO;

	@Override
	public int insertDataSource(DataSource dataSource) {
		return dataManageDAO.insertDataSource(dataSource);
	}

	@Override
	public List<DataSource> queryDataSource(Map<String, Object> map) {
		return dataManageDAO.queryDataSource(map);
	}

	@Override
	public List<DataSource> queryDataSourceByPage(Map<String, Object> map) {
		return dataManageDAO.queryDataSourceByPage(map);
	}
	
	@Override
	public int executeCreateTableSql(Map<String, Object> map){
		return dataManageDAO.executeCreateTableSql(map); 	
	}

	@Override
	public int deleteDsInfo(DataSource dataSource) {
		return dataManageDAO.deleteDsInfo(dataSource); 
	}
	
	@Override
	public int editDsInfo(DataSource dataSource) {
		return dataManageDAO.editDsInfo(dataSource); 
	}

	@Override
	public int editDsMapInfo(Map<String, Object> map) {
		return dataManageDAO.editDsMapInfo(map); 	
	}
}
