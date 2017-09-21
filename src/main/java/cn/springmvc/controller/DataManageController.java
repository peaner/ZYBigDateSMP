package cn.springmvc.controller;

import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.dom4j.Document;
import org.dom4j.io.OutputFormat;
import org.dom4j.io.SAXReader;
import org.dom4j.io.XMLWriter;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;

import cn.common.CommonConstant;
import cn.springmvc.model.DataSource;
import cn.springmvc.service.DataManageService;
import cn.utils.CreatDBTableUtil;
import cn.utils.FileUploadUtil;
import cn.utils.FileUtil;
import cn.utils.PathUtil;

@Controller
@RequestMapping("/dataSource")
public class DataManageController {

	@Autowired
	private DataManageService dataManageService;
	
	/**
	 * 结合easy ui返回json 数据
	 * @param dataNameSerch
	 * @param collectionSorceSerch
	 * @param page
	 * @param rows
	 * @return
	 * @throws Exception
	 */
	@ResponseBody
	@RequestMapping("showDatas")
	public Map<String, Object> showDatas(@RequestParam("dataNameSerch") String dataNameSerch, 
			@RequestParam("collectionSorceSerch") String collectionSorceSerch, 
			@RequestParam(required = false,defaultValue ="1") Integer page,
			@RequestParam(required = false,defaultValue ="10") Integer rows) throws Exception{
		Map<String, Object> map = new HashMap<String, Object>(); 
		Map<String, Object> mapParam = new HashMap<String, Object>();
		mapParam.put("start", (page-1)*rows);
		mapParam.put("end", rows);
		mapParam.put("dataNameSerch", dataNameSerch);
		mapParam.put("collectionSorceSerch", collectionSorceSerch);
		List<DataSource> dataSources = dataManageService.queryDataSourceByPage(mapParam);
		map.put("rows",dataSources);
		map.put("total", dataManageService.queryDataSource(mapParam).size());
		return map;
	}
	
	/**
	 * 上传到服务器
	 * @param file
	 * @return
	 * @throws Exception
	 */
	@ResponseBody
	@RequestMapping("uploadInfo")
	public Map<String, Object> uploadInfo(@RequestParam("fileHandler") MultipartFile file) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		String filePath = PathUtil.getAllPath(CommonConstant.uploadZipPath);
		boolean flag = FileUploadUtil.processFileUpload(file, filePath, true);
		if (flag == true) {
			map.put("status", true);
			map.put("path", filePath);
		} else {
			map.put("status", false);
			map.put("path", "");
		}
		return map;
	}
	
	/**
	 * 增加数据源
	 * @param dataSource
	 * @return
	 * @throws Exception
	 */
	@ResponseBody
	@RequestMapping("addDsInfoToDB")
	public Map<String, Object> addDsInfoToDB(@ModelAttribute("dataSource") DataSource dataSource) throws Exception{
		Map<String, Object> map = new HashMap<String, Object>();
		Map<String, Object> mapParamDn = new HashMap<String, Object>();
		Map<String, Object> mapParamCs = new HashMap<String, Object>();
		mapParamDn.put("dataName", dataSource.getDataName());
		mapParamCs.put("collectionSorce", dataSource.getCollectionSorce());
		if(dataManageService.queryDataSource(mapParamDn).size() >= 1) {
			map.put("result", -1);
			map.put("message", "数据库已存在数据源为[" + dataSource.getDataName() + "]的数据, 新增数据失败！");
		}else if(dataManageService.queryDataSource(mapParamCs).size() >= 1) {
			map.put("result", -1);
			map.put("message", "数据库已存在采集包为[" + dataSource.getCollectionSorce() + "]的数据, 新增数据失败！");
		}else{
			Date date = new Date();
			SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
			if(dataSource.getRunType() == null || "".equals(dataSource.getRunType())){
				dataSource.setRunType(CommonConstant.DEFAULT_RUN_TYPE);
			}
			dataSource.setUpdateTime(sdf.format(date).toString());
			int result = dataManageService.insertDataSource(dataSource);
			map.put("result", String.valueOf(result));
			map.put("message", "");
		}	
		return map;
	}
	
	/**
	 * 删除数据源
	 * @param dataSource
	 * @return
	 * @throws Exception
	 */
	@ResponseBody
	@RequestMapping("deleteDsInfo")
	public Map<String, Object> deleteDsInfo(@ModelAttribute("deleteDsInfo") DataSource dataSource) throws Exception{	
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("result", "成功删除数据！");		
		//停止数据采集（修改监控配置文件的配置）
		setConfigFileStartType(CommonConstant.JAR_CONFIG_PATH, getJarName(dataSource.getId()), "0");		
		//删除数据库信息
		try {
			if(dataSource.getId() != null && !"".equals(dataSource.getId())){
				dataManageService.deleteDsInfo(dataSource);
			}			
		} catch (Exception e) {
			map.put("result", "删除数据失败！"+e.getMessage());
		}
		
		//删除文件 TODO
		return map;
	}
	
	/**
	 * 修改数据源
	 * @param dataSource
	 * @return
	 * @throws Exception
	 */
	@ResponseBody
	@RequestMapping("editDsInfo")
	public Map<String, Object> editDsInfo(@ModelAttribute("editDsInfo") DataSource dataSource) throws Exception{	
		Map<String, Object> map = new HashMap<String, Object>();
		//更新数据库信息
		try {
			if(dataSource.getId() != null && !"".equals(dataSource.getId())){
				Map<String, Object> mapParam = new HashMap<String, Object>();
				mapParam.put("dataName", dataSource.getDataName());
				//mapParam.put("collectionSorce", dataSource.getCollectionSorce());
				if(dataManageService.queryDataSource(mapParam).size() >= 1) {
					map.put("result", "数据源名称[" + dataSource.getDataName() + "]已经存在，数据采集信息修改失败！");
					return map;
				}
				Date date = new Date();
				SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
				dataSource.setUpdateTime(sdf.format(date).toString());
				dataManageService.editDsInfo(dataSource);
			}			
		} catch (Exception e) {
			map.put("result", "数据采集修改失败！"+e.getMessage());
		}
		
		//删除文件 TODO		
		return map;
	}
	
	/**
	 * 启动数据源采集
	 * @param path
	 * @return
	 * @throws Exception
	 */
	@ResponseBody
	@RequestMapping("startDataCollection")
	public Map<String, Object> startDataCollection(@RequestParam("runType") String runType, 
			@RequestParam("index") String index, @RequestParam("updateUser") String updateUser) throws Exception{
		Map<String, Object> map = new HashMap<String, Object>();
		String path = getPath(index);
		if(path == ""){
			map.put("result", "error");
			return map;
		}
		String batPath = path + "/" + CommonConstant.STRAT_JAR_BAT_NAME;
		if(CommonConstant.DEFAULT_RUN_TYPE.equals(runType)){			
			String sqlXmlPath = path + CommonConstant.UNZIP_CREATDB_XML_PATH;
			List<Map<String , Object>> dataTableSQL = new ArrayList<Map<String , Object>>();
			try {
				dataTableSQL = CreatDBTableUtil.getCreatDataTableSQL(sqlXmlPath);
			} catch (Exception e) {
				map.put("result", "error");
				return map;
			}
			//生成数据库
			if(dataTableSQL != null){
				for(Map<String , Object> sqlMap : dataTableSQL){
					try {
						dataManageService.executeCreateTableSql(sqlMap);
					} catch (Exception e) {
						map.put("result", "error");
						break;
					}
				}
			}			
			//生成jar包运行的bat文件
			StringBuffer sbf = new StringBuffer();
			sbf.append("c:");
			sbf.append("\r\n");
			sbf.append("cd " + path + CommonConstant.UNZIP_COLLECTION_JAR_PATH);
			sbf.append("\r\n");
			sbf.append("java -jar "+ getJarName(index) +".jar");			
			FileUtil.createNewFile(batPath, sbf.toString());
		}		
		
		//更新数据库状态
		if(map.get("result") == null) {	
			//启动数据采集（修改监控配置文件的配置）
			boolean setFlag = setConfigFileStartType(CommonConstant.JAR_CONFIG_PATH, getJarName(index), "1");
			if(!setFlag){
				map.put("result", "error");
				return map;
			}
			try {
				//启动数据采集
				Runtime.getRuntime().exec("cmd.exe /C start /b " + batPath);
			} catch (Exception e1) {
				map.put("result", "error");
				return map;
			}
			Map<String, Object> mapParam = new HashMap<String, Object>();
			//更新数据库信息
			try {
				if(index != null && !"".equals(index)){
					Date date = new Date();
					SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
					mapParam.put("id", index);
					mapParam.put("runType", CommonConstant.RUNNING_TYPE);
					mapParam.put("updateTime", sdf.format(date).toString());
					mapParam.put("updateUser", updateUser);
					dataManageService.editDsMapInfo(mapParam);
				}			
			} catch (Exception e) {
				map.put("result", "error");
			}
		}
		
		return map;
	}
	
	/**
	 * 获取路径
	 * @param id
	 * @return
	 */
	private String getPath(String id){
		String path = "";
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("id", id);
		List<DataSource> dataSourceList = dataManageService.queryDataSource(map);		
		if(dataSourceList != null && dataSourceList.size() ==1){
			path = dataSourceList.get(0).getPath();
		}
		return path;
	}
	
	/**
	 * 获取war包名称
	 * @param id
	 * @return
	 */
	private String getJarName(String id){
		String jarName = "";
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("id", id);
		List<DataSource> dataSourceList = dataManageService.queryDataSource(map);
		if(dataSourceList != null && dataSourceList.size() ==1){
			jarName = dataSourceList.get(0).getCollectionSorce();
			jarName = jarName.substring(0, jarName.length() - 4);
		}
		return jarName;
	}
	
	/**
	 * 停止数据源采集
	 * @param path
	 * @return
	 * @throws Exception
	 */
	@ResponseBody
	@RequestMapping("stopDataCollection")
	public Map<String, Object> stopDataCollection(@RequestParam("runType") String runType, @RequestParam("index") String index, @RequestParam("updateUser") String updateUser) throws Exception{
		Map<String, Object> map = new HashMap<String, Object>();
		//停止数据采集（修改监控配置文件的配置）
		boolean setFlag = setConfigFileStartType(CommonConstant.JAR_CONFIG_PATH, getJarName(index), "0");
		if(!setFlag){
			map.put("result", "error");
			return map;
		}		
		//更新数据库状态
		if(map.get("result") == null){
			Map<String, Object> mapParam = new HashMap<String, Object>();
			//更新数据库信息
			try {
				if(index != null && !"".equals(index)){
					Date date = new Date();
					SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
					mapParam.put("id", index);
					mapParam.put("runType", CommonConstant.STOPPED_TYPE);
					mapParam.put("updateTime", sdf.format(date).toString());
					mapParam.put("updateUser", updateUser);
					dataManageService.editDsMapInfo(mapParam);
				}			
			} catch (Exception e) {
				map.put("result", "error");
			}
		}
		
		return map;
	}
	
	/**
	 * 设置配置文件节点jarName下面的运行状态为0：停止     1：停止
	 * @param path
	 * @param jarName
	 * @throws IOException 
	 */
	private boolean setConfigFileStartType(String path, String jarName, String runType) {
		boolean setFlag = true;
		SAXReader sax = new SAXReader();
	    File xmlFile = new File(path);
	    FileOutputStream out = null;
	    XMLWriter writer = null;
	    try {
		    Document document = sax.read(xmlFile); 
		    document.getRootElement().element(jarName).element(CommonConstant.JAR_CONFIG_RUN_TYPE_NAME).setText(runType);
			//指定文件输出的位置
	        out =new FileOutputStream(path);
	        // 指定文本的写出的格式：
	        OutputFormat format=OutputFormat.createPrettyPrint();  
	        format.setEncoding("UTF-8");
	        //1.创建写出对象
	        writer=new XMLWriter(out,format);
	        //2.写出Document对象
	        writer.write(document);
	        //3.关闭流
	        writer.close();
        } catch(Exception e){
        	setFlag = false;
        } finally{        	
			try {
				if (out != null) {
					out.close();
				}
				if (writer != null) {
					writer.close();
				}
			} catch (IOException e) {
				setFlag = false;
			}        	
        }
	    return setFlag;
	}
}