package cn.springmvc.controller;

import java.net.InetAddress;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;

import cn.common.CommonConstant;
import cn.springmvc.model.DataDisplay;
import cn.springmvc.model.DataProjective;
import cn.springmvc.service.DataDisplayService;
import cn.springmvc.service.DataProjectiveService;
import cn.utils.FileUploadUtil;
import cn.utils.FileUtil;
import cn.utils.PathUtil;

@Controller
@RequestMapping("/dataDisplay")
public class DataDisplayController {
	
	@Autowired
	private DataDisplayService dataDisplayService;
	@Autowired
	private DataProjectiveService dataProjectiveService;
	
	/**
	 * 结合easy ui返回json 数据
	 * @param displayName
	 * @param displaySorce
	 * @param page
	 * @param rows
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("showDatas")
	@ResponseBody
	public Map<String, Object> showDatas(@RequestParam("displayNameSerch") String displayName, 
			@RequestParam("displaySorceSerch") String displaySorce, 
			@RequestParam(required = false,defaultValue ="1") Integer page,
			@RequestParam(required = false,defaultValue ="10") Integer rows) throws Exception{
		Map<String, Object> map = new HashMap<String, Object>();
		Map<String, Object> mapParam = new HashMap<String, Object>();
		mapParam.put("start", (page-1)*rows);
		mapParam.put("end", rows);
		mapParam.put("displayName", displayName);
		mapParam.put("displaySorce", displaySorce);
		List<DataDisplay> dataDisplays = dataDisplayService.queryDataDisplayByPage(mapParam);
		map.put("rows", dataDisplays);
		mapParam = new HashMap<String, Object>();
		map.put("total", dataDisplayService.queryDataDisplay(mapParam).size());
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
		String filePath = PathUtil.getAllPath(CommonConstant.uploadWarPath);
		boolean flag = FileUploadUtil.processFileUpload(file, filePath, false);
		if (flag == true) {
			map.put("status", true);
			map.put("path", filePath + file.getOriginalFilename());
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
	public Map<String, Object> addDsInfoToDB(@ModelAttribute("dataDisplay") DataDisplay dataDisplay) throws Exception{
		Map<String, Object> map = new HashMap<String, Object>();
		Map<String, Object> mapParamDn = new HashMap<String, Object>();
		Map<String, Object> mapParamDs = new HashMap<String, Object>();
		mapParamDn.put("displayName", dataDisplay.getDisplayName());
		mapParamDs.put("displaySorce", dataDisplay.getDisplaySorce());
		if (dataDisplayService.queryDataDisplay(mapParamDn).size() >= 1) {
			map.put("result", -1);
			map.put("message", "数据库已存在展示名称为[" + dataDisplay.getDisplayName() + "]的数据, 新增数据失败！");
		}else if (dataDisplayService.queryDataDisplay(mapParamDs).size() >= 1) {
			map.put("result", -1);
			map.put("message", "数据库已存在展示程序包为[" + dataDisplay.getDisplaySorce() + "]的数据, 新增数据失败！");
		} else {
			Date date = new Date();
			SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
			if(dataDisplay.getRunType() == null || "".equals(dataDisplay.getRunType())){
				dataDisplay.setRunType(CommonConstant.DEFAULT_RUN_TYPE);
			}
			dataDisplay.setUpdateTime(sdf.format(date).toString());
			int result = dataDisplayService.insertDataDisplay(dataDisplay);
			map.put("result", String.valueOf(result));
			map.put("message", "");
		}	
		return map;
	}
	
	/**
	 * 启动展示页面发布
	 * @param path
	 * @return
	 * @throws Exception
	 */
	@ResponseBody
	@RequestMapping("startDataDisplay")
	public Map<String, Object> startDataDisplay(@RequestParam("index") String index, @RequestParam("updateUser") String updateUser) throws Exception{
		Map<String, Object> map = new HashMap<String, Object>();
		String path = getPath(index);
		if(path == ""){
			map.put("result", "无法获到展示程序war包的路径，启动展示页面发布失败！");
			return map;
		}
		
		Map<String, Object> mapParam = new HashMap<String, Object>();
		mapParam.put("id", index);
		mapParam.put("runType", CommonConstant.RUNNING_TYPE);				
		String warName = getWarName(index);				
		String serverIp = InetAddress.getLocalHost().getHostAddress();
		String serverPort = CommonConstant.WAR_CONFIG_SERVER_PORT_DEFAULT;
//		String serverIp = XmlOperateUtil.getWarConfigInfo(warName, CommonConstant.WAR_CONFIG_SERVER_IP);
//		String serverPort = XmlOperateUtil.getWarConfigInfo(warName, CommonConstant.WAR_CONFIG_SERVER_PORT);
//		String welcomeFile = XmlOperateUtil.getWarConfigInfo(warName, CommonConstant.WAR_CONFIG_WELCOME_FILE);
		if(warName == "" || serverIp == null || serverPort == null){
			map.put("result", "获取展示网址过程出错，启动展示页面发布失败！");
			return map;
		}
		
		try {
			FileUtil.copyFile(path, CommonConstant.copyToWarPath);
			Thread.sleep(5000);
		} catch (Exception e) {
			map.put("result", "展示程序war包发布到Tomcat的webapps目录过程出错，启动展示页面发布失败！");
			return map;
		}		
		
		//更新数据库信息
		try {
			if(index != null && !"".equals(index)){
				Date date = new Date();
				SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");				
				//URL格式：http://10.177.2.224:8080/WebTest/
				//String displayUrl = "http://" + serverIp + ":" + serverPort + "/" + warName + welcomeFile;
				String displayUrl = "http://" + serverIp + ":" + serverPort + "/" + warName + "/";
				mapParam.put("displayPreview", displayUrl);
				mapParam.put("updateTime", sdf.format(date).toString());
				mapParam.put("updateUser", updateUser);
				dataDisplayService.editDataDisplayRunType(mapParam);
			}			
		} catch (Exception e) {
			map.put("result", "展示程序war包发布到Tomcat成功，更新数据库过程中出现异常！");
		}
		
		return map;
	}
	
	/**
	 * 停止展示页面发布
	 * @param path
	 * @return
	 * @throws Exception
	 */
	@ResponseBody
	@RequestMapping("stopDataDisplay")
	public Map<String, Object> stopDataDisplay(@RequestParam("index") String index, @RequestParam("updateUser") String updateUser) throws Exception{
		Map<String, Object> map = new HashMap<String, Object>();
		if(getDisplayNameProjectiveType(index)){
			map.put("result", "该展示正在投放中，禁止停止！");
			return map;
		}
		
		String path = getPath(index);
		if(path == ""){
			map.put("result", "无法获到展示程序war包的路径，停止展示页面发布失败！");
			return map;
		}
		
		//删除对应的文件
		try {
			String[] pathArr = path.split("/");
			if(pathArr.length > 1){
				String pathName = CommonConstant.copyToWarPath + "/" + pathArr[pathArr.length -1];
				FileUtil.delFile(pathName);
				FileUtil.delFolder(pathName.substring(0, pathName.length()-4));
			}else {
				map.put("result", "停止Tomcat中对应程序的路径出现错误，停止展示页面发布失败！");
				return map;
			}			
		} catch (Exception e) {
			map.put("result", "删除对应Tomcat中的程序过程异常，停止展示页面发布失败！");
			return map;
		}
		
		Map<String, Object> mapParam = new HashMap<String, Object>();
		//更新数据库信息
		try {
			if(index != null && !"".equals(index)){
				Date date = new Date();
				SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
				mapParam.put("id", index);
				mapParam.put("runType", CommonConstant.STOPPED_TYPE);
				mapParam.put("displayPreview", "");
				mapParam.put("updateTime", sdf.format(date).toString());
				mapParam.put("updateUser", updateUser);
				dataDisplayService.editDataDisplayRunType(mapParam);
			}			
		} catch (Exception e) {
			map.put("result", "展示程序war包停止成功，更新数据库过程中出现异常！");
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
		List<DataDisplay> dataDisplayList = dataDisplayService.queryDataDisplay(map);		
		if(dataDisplayList != null && dataDisplayList.size() ==1){
			path = dataDisplayList.get(0).getPath();
		}
		return path;
	}
	
	/**
	 * 获取展示在投放中的状态
	 * @param id
	 * @return
	 */
	private boolean getDisplayNameProjectiveType(String id){
		boolean displayNameProjectiveType = false;
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("id", id);
		List<DataDisplay> dataDisplayList = dataDisplayService.queryDataDisplay(map);
		String displayName = "";
		if(dataDisplayList != null && dataDisplayList.size() ==1){
			displayName = dataDisplayList.get(0).getDisplayName();
		}
		if(displayName != ""){
			Map<String, Object> mapParam = new HashMap<String, Object>();
			mapParam.put("displayName", displayName);
			List<DataProjective> dataProjectives = dataProjectiveService.queryDataProjective(mapParam);
			if(dataProjectives != null){
				for(DataProjective dataProjective : dataProjectives){
					if(CommonConstant.RUNNING_TYPE.equals(dataProjective.getRunType())){
						displayNameProjectiveType = true;
						break;
					}
				}
			}
		}
		return displayNameProjectiveType;
	}
	
	/**
	 * 获取war包名称
	 * @param id
	 * @return
	 */
	private String getWarName(String id){
		String warName = "";
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("id", id);
		List<DataDisplay> dataDisplayList = dataDisplayService.queryDataDisplay(map);		
		if(dataDisplayList != null && dataDisplayList.size() ==1){
			warName = dataDisplayList.get(0).getDisplaySorce();
			warName = warName.substring(0, warName.length() - 4);
		}
		return warName;
	}
	
	
	
	/**
	 * 删除数据库信息
	 * @param dataDisplay
	 * @return
	 * @throws Exception
	 */
	@ResponseBody
	@RequestMapping("deleteDataDispay")
	public Map<String, Object> deleteDataDispay(@ModelAttribute("dataDisplay") DataDisplay dataDisplay) throws Exception{	
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("result", "成功删除数据！");
		String path = getPath(dataDisplay.getId());
		if(path == ""){
			map.put("result", "删除数据失败！");
			return map;
		}	
		//删除对应的文件
		try {
			String[] pathArr = path.split("/");
			if(pathArr.length > 1){
				String pathName = CommonConstant.copyToWarPath + "/" + pathArr[pathArr.length -1];
				FileUtil.delFile(pathName);
				FileUtil.delFolder(pathName.substring(0, pathName.length()-4));
			}else {
				map.put("result", "删除数据失败！");
				return map;
			}			
		} catch (Exception e) {
			map.put("result", "删除数据失败！");
			return map;
		}
		//删除数据库信息
		try {
			dataDisplayService.deleteDataDisplay(dataDisplay);
		} catch (Exception e) {
			map.put("result", "删除数据失败！"+e.getMessage());
		}
		
		return map;
	}
	
	/**
	 * 修改数据源
	 * @param dataSource
	 * @return
	 * @throws Exception
	 */
	@ResponseBody
	@RequestMapping("editDataDisplay")
	public Map<String, Object> editDataDisplay(@ModelAttribute("dataDisplay") DataDisplay dataDisplay) throws Exception{	
		Map<String, Object> map = new HashMap<String, Object>();
		String newDisplayName = dataDisplay.getDisplayName();
		String oldDisplayName = getDisplayName(dataDisplay.getId());
		Date date = new Date();
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		//更新数据库信息
		try {
			if(dataDisplay.getId() != null && !"".equals(dataDisplay.getId())){
				Map<String, Object> mapParam = new HashMap<String, Object>();
				mapParam.put("displayName", dataDisplay.getDisplayName());
				//mapParam.put("displaySorce", dataDisplay.getDisplaySorce());
				if (dataDisplayService.queryDataDisplay(mapParam).size() >= 1) {
					map.put("result", "展示名称["+dataDisplay.getDisplayName()+"]已经存在，数据展示信息修改失败！");
					return map;
				}
				dataDisplay.setUpdateTime(sdf.format(date).toString());
				//dataDisplay.setUpdateUser("HJKIUI");
				dataDisplayService.editDataDisplay(dataDisplay);
			}else{
				map.put("result", "数据展示修改失败！");
			}
			if(newDisplayName != null && !newDisplayName.equals(oldDisplayName)){
				Map<String, Object> mapParm = new HashMap<String, Object>();
				mapParm.put("oldDisplayName", oldDisplayName);
				mapParm.put("newDisplayName", newDisplayName);
				mapParm.put("updateTime", sdf.format(date).toString());
				mapParm.put("updateUser", dataDisplay.getUpdateUser());
				dataProjectiveService.editProjectiveDataByDisplayName(mapParm);
			}
		} catch (Exception e) {
			map.put("result", "出现异常，数据展示修改失败！"+e.getMessage());
		}
		
		//删除文件 TODO
		return map;
	}
	
	/**
	 * 获取展示名称
	 * @param id
	 * @return
	 */
	private String getDisplayName(String id){
		String displayName = "";
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("id", id);
		List<DataDisplay> dataDisplayList = dataDisplayService.queryDataDisplay(map);		
		if(dataDisplayList != null && dataDisplayList.size() ==1){
			displayName = dataDisplayList.get(0).getDisplayName();
		}
		return displayName;
	}

}
