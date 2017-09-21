package cn.springmvc.dao;

import java.util.List;
import java.util.Map;

import cn.springmvc.model.DataSource;

/**
 * 数据库操作接口
 * @author Administrator
 *
 */
public interface DataManageDAO {

	//插入用户数据
	public int insertDataSource(DataSource DataSource);
	//查询哟怒数据
	public List<DataSource> queryDataSource(Map<String, Object> map);
	//分页查询
	public List<DataSource> queryDataSourceByPage(Map<String, Object> map);
	//生成数据库
	public int executeCreateTableSql(Map<String, Object> map);
	//删除用户数据
	public int deleteDsInfo(DataSource DataSource);
	//更新数据
	public int editDsInfo(DataSource DataSource);
	//更新数据
	public int editDsMapInfo(Map<String, Object> map);
}
