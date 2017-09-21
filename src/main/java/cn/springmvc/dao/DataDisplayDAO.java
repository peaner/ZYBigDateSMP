package cn.springmvc.dao;

import java.util.List;
import java.util.Map;

import cn.springmvc.model.DataDisplay;


/**
 * 数据库操作接口
 * 数据展示
 * @author PEANER-Li
 *
 */
public interface DataDisplayDAO {	
	//查询用户数据
	public List<DataDisplay> queryDataDisplay(Map<String,Object> map);
	//带分页查询用户数据
	public List<DataDisplay> queryDataDisplayByPage(Map<String,Object> map);
	//删除展示数据
	public int deleteDataDisplay(DataDisplay dataDisplay);
	//插入用户数据
	public int insertDataDisplay(DataDisplay dataDisplay);
	//修改 用户数据
	public int editDataDisplay(DataDisplay dataDisplay);
	//修改用户状态
	public int editDataDisplayRunType(Map<String,Object> map);
}
