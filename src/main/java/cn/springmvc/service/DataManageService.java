package cn.springmvc.service;


import java.util.List;
import java.util.Map;

import cn.springmvc.model.DataSource;

/**
 * service接口
 * @author Administrator
 *
 */
public interface DataManageService {
	//插入用户数据
	public int insertDataSource(DataSource DataSource);
	//查询用户数据
	public List<DataSource> queryDataSource(Map<String, Object> map);
	//分页查询
	public List<DataSource> queryDataSourceByPage(Map<String, Object> map);
	//生成数据库
	public int executeCreateTableSql(Map<String, Object> map);
	//删除数据
	public int deleteDsInfo(DataSource DataSource);
	//更新数据
	public int editDsInfo(DataSource DataSource);
	//更新数据
	public int editDsMapInfo(Map<String, Object> map);
	
}
