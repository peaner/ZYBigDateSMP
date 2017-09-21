package cn.springmvc.controller;

import java.net.InetAddress;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.concurrent.Callable;
import java.util.concurrent.ExecutionException;
import java.util.concurrent.Executor;
import java.util.concurrent.Executors;
import java.util.concurrent.FutureTask;
import java.util.concurrent.TimeUnit;
import java.util.concurrent.TimeoutException;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import cn.common.CommonConstant;
import cn.server.ProjectiveServer;
import cn.springmvc.model.ComputerInfo;
import cn.springmvc.model.DataDisplay;
import cn.springmvc.model.DataProjective;
import cn.springmvc.service.ComputerManageService;
import cn.springmvc.service.DataDisplayService;
import cn.springmvc.service.DataProjectiveService;

@Controller
@RequestMapping("/dataProjective")
public class DataProjectiveController {
	
	@Autowired
	private DataProjectiveService dataProjectiveService;
	@Autowired
	private DataDisplayService dataDisplayService;
	@Autowired
	private ComputerManageService computerManageService;
	
	@RequestMapping("showDatas")
	@ResponseBody
	public Map<String, Object> showProjective(@RequestParam("displayNameSerch") String displayName, 
			@RequestParam("projectiveScreenSerch") String projectiveScreen,
			@RequestParam(required = false,defaultValue ="1") Integer page,
			@RequestParam(required = false,defaultValue ="10") Integer rows) throws Exception{
		Map<String, Object> map = new HashMap<String, Object>();
		Map<String, Object> mapParam = new HashMap<String, Object>();
		mapParam.put("start", (page-1)*rows);
		mapParam.put("end", rows);
		mapParam.put("displayName", setSelectCondition(displayName));
		mapParam.put("projectiveScreen", setSelectCondition(projectiveScreen));
		List<DataProjective> dataProjectives = dataProjectiveService.queryDataProjectiveByPage(mapParam);
		map.put("rows", dataProjectives);
		map.put("total", dataProjectiveService.queryDataProjective(null).size());
		return map;
	}
	
	
	/**
	 * 增加投放数据
	 * @param dataSource
	 * @return
	 * @throws Exception
	 */
	@ResponseBody
	@RequestMapping("addDsInfoToDB")
	public Map<String, Object> addDsInfoToDB(@ModelAttribute("dataProjective") DataProjective dataProjective) throws Exception{
		Map<String, Object> map = new HashMap<String, Object>();
		Map<String, Object> mapParam = new HashMap<String, Object>();
		mapParam.put("displayName", dataProjective.getDisplayName());
		mapParam.put("projectiveScreen", dataProjective.getProjectiveScreen());
		if (dataProjectiveService.queryDataProjective(mapParam).size() >= 1) {
			map.put("result", -1);
			map.put("message", "显示屏幕[" + dataProjective.getProjectiveScreen() + "]已经选择展示[" + dataProjective.getDisplayName() + "]的数据, 新增数据失败！");
		} else {
			Date date = new Date();
			SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
			if(dataProjective.getRunType() == null || "".equals(dataProjective.getRunType())){
				dataProjective.setRunType(CommonConstant.DEFAULT_RUN_TYPE);
			}
			dataProjective.setUpdateTime(sdf.format(date).toString());
			int result = dataProjectiveService.insertProjectiveData(dataProjective);
			map.put("result", String.valueOf(result));
			map.put("message", "");
		}	
		return map;
	}
	
	/**
	 * 删除数据库信息
	 * @param dataDisplay
	 * @return
	 * @throws Exception
	 */
	@ResponseBody
	@RequestMapping("deleteProjectiveData")
	public Map<String, Object> deleteProjectiveData(@ModelAttribute("dataProjective") DataProjective dataProjective) throws Exception{	
		Map<String, Object> map = new HashMap<String, Object>();
		int result = 0;
		//删除数据库信息
		try {
			result = dataProjectiveService.deleteProjectiveData(dataProjective);
		} catch (Exception e) {
			map.put("result", "删除数据失败！"+e.getMessage());
		}
		
		if (result == 1) {
			map.put("result", "成功删除数据！");
		} else {
			map.put("result", "删除数据失败！");
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
	@RequestMapping("editProjectiveData")
	public Map<String, Object> editProjectiveData(@ModelAttribute("dataProjective") DataProjective dataProjective) throws Exception{	
		Map<String, Object> map = new HashMap<String, Object>();
		//更新数据库信息
		try {
			Map<String, Object> mapParam = new HashMap<String, Object>();
			mapParam.put("displayName", dataProjective.getDisplayName());
			mapParam.put("projectiveScreen", dataProjective.getProjectiveScreen());
			if (dataProjectiveService.queryDataProjective(mapParam).size() >= 1) {
				map.put("result", "显示屏幕[" + dataProjective.getProjectiveScreen() + "]已经选择展示[" + dataProjective.getDisplayName() + "]的数据, 修改数据失败！");
				return map;
			} else {
				if(dataProjective.getId() != null && !"".equals(dataProjective.getId())){
					Date date = new Date();
					SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
					dataProjective.setUpdateTime(sdf.format(date).toString());
					dataProjectiveService.editProjectiveData(dataProjective);
				}
			}			
		} catch (Exception e) {
			map.put("result", "更新数据失败！"+e.getMessage());
		}
		
		return map;
	}
	
	private String setSelectCondition(String selectCondition){
		if("--请选择--".equals(selectCondition)){
			selectCondition = "";
		}		
		return selectCondition;
	}
	
	/**
	 * 初始化展示下拉框的值
	 * @return
	 * @throws Exception
	 */
	@ResponseBody
	@RequestMapping("getDisplayNameComValue")
	public Map<String, Object> getDisplayNameComValue() throws Exception{
		Map<String, Object> map = new HashMap<String, Object>();
		Map<String, Object> mapParam = new HashMap<String, Object>();
		List<DataDisplay> dataDisplays = dataDisplayService.queryDataDisplay(mapParam);
		map.put("rows", dataDisplays);
		return map;
	}
	
	/**
	 * 初始化显示屏幕下拉框的值
	 * @return
	 * @throws Exception
	 */
	@ResponseBody
	@RequestMapping("getProjectiveScreenValue")
	public Map<String, Object> getProjectiveScreenValue() throws Exception{
		Map<String, Object> map = new HashMap<String, Object>();
		ComputerInfo mapParam = new ComputerInfo();
		List<ComputerInfo> rojectiveScreen = computerManageService.queryComputerInfo(mapParam);
		map.put("rows", rojectiveScreen);
		return map;
	}
	
	/**
	 * 投放信息
	 * @return9
	 * @throws Exception
	 */
	@ResponseBody
	@RequestMapping("startDisplay")
	public Map<String, Object> startDisplay(@RequestParam("index") String index, @RequestParam("updateUser") String updateUser) throws Exception{
		Map<String, Object> map = new HashMap<String, Object>();		
		Map<String, Object> mapParam = new HashMap<String, Object>();
		mapParam.put("id", index);		
		List<DataProjective> dataProjective = dataProjectiveService.queryDataProjective(mapParam);
		if(dataProjective.size() == 0){
			map.put("result", "投放过程中无法获取到对应相关的投放配置, 投放出错！");
			return map;
		}
		Map<String, Object> param = new HashMap<String, Object>();
		param.put("projectiveScreen", dataProjective.get(0).getProjectiveScreen());
		List<DataProjective> dataProjectiveList = dataProjectiveService.queryDataProjective(param);
		if(dataProjectiveList.size() >= 1){
			for(DataProjective dp : dataProjectiveList){
				if(CommonConstant.RUNNING_TYPE.equals(dp.getRunType())){
					map.put("result", "显示屏幕[" + dp.getProjectiveScreen() + "]正在展示[" + dp.getDisplayName() + "]的数据, 请先停止该屏幕投放！");
					return map;
				}
			}
		}
		
		mapParam = new HashMap<String, Object>();
		mapParam.put("displayName", dataProjective.get(0).getDisplayName());
		List<DataDisplay> dataDisplays = dataDisplayService.queryDataDisplay(mapParam);
		if(dataDisplays.size() == 0){
			map.put("result", "投放过程中无法获取到对应的展示页面信息, 投放出错！");
			return map;
		}
		ComputerInfo computerInfo = new ComputerInfo();
		computerInfo.setComputerName(dataProjective.get(0).getProjectiveScreen());
		List<ComputerInfo> rojectiveScreen = computerManageService.queryComputerInfo(computerInfo);
		if(rojectiveScreen.size() == 0){
			map.put("result", "投放过程中无法获取到对应的展示屏幕信息, 投放出错！");
			return map;
		}
		final String webUrl = dataDisplays.get(0).getDisplayPreview();
		final String clientIp = rojectiveScreen.get(0).getComputerIp();
		if(webUrl == null || clientIp == null || "".equals(webUrl) || "".equals(clientIp)){
			map.put("result", "投放过程中获取到对应的展示页面或者展示屏幕信息为空, 投放出错！");
			return map;
		}	
		
		final int port = 8888;
		final int startFlg = 1;  //0表示关闭  1表示开启投放
		boolean isStart = false;
		Executor executor=Executors.newSingleThreadExecutor();
		FutureTask<Boolean> future=new FutureTask<Boolean>(new Callable<Boolean>() {
			public Boolean call() throws Exception {
				ProjectiveServer projectiveServer = new ProjectiveServer(webUrl, clientIp, port, startFlg);
				return projectiveServer.connectServer();
			}
		});
		executor.execute(future);
		try{
			isStart= future.get(20, TimeUnit.SECONDS);
		}catch (InterruptedException e) {
			System.out.println("方法执行中断");
		}catch (ExecutionException e) {
			System.out.println("Excution异常");
			future.cancel(true);
		}catch (TimeoutException e) {
			System.out.println("方法执行时间超时");
			map.put("result", "投放过程超时, 请检查客户端投放屏幕配置是否正确, 服务器IP为[" + InetAddress.getLocalHost().getHostAddress() + "] 服务器端口为[" + port + "]");
		}
		
		//更新数据库信息
		if(isStart){
			try {
				if(index != null && !"".equals(index)){
					DataProjective dpParam = dataProjective.get(0);
					Date date = new Date();
					SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
					dpParam.setId(index);
					dpParam.setRunType(CommonConstant.RUNNING_TYPE);
					dpParam.setUpdateTime(sdf.format(date).toString());
					dpParam.setUpdateUser(updateUser);
					dataProjectiveService.editProjectiveData(dpParam);
				}			
			} catch (Exception e) {
				map.put("result", "投放已经正常处理, 更新投放状态到数据库中出现错误");
			}
		}else{
			if(map.get("result") == null){
				map.put("result", "投放过程出现未知错误, 请稍后再试！");	
			}
			
			return map;
		}		
		return map;
	}
	
	/**
	 * 投放信息
	 * @return
	 * @throws Exception
	 */
	@ResponseBody
	@RequestMapping("stopDisplay")
	public Map<String, Object> stopDisplay(@RequestParam("index") String index, @RequestParam("updateUser") String updateUser) throws Exception{
		Map<String, Object> map = new HashMap<String, Object>();
		Map<String, Object> mapParam = new HashMap<String, Object>();
		mapParam.put("id", index);
		List<DataProjective> dataProjective = dataProjectiveService.queryDataProjective(mapParam);
		if(dataProjective.size() == 0){
			map.put("result", "投放过程中无法获取到对应相关的投放配置, 投放出错！");
			return map;
		}	
		try {
			if(index != null && !"".equals(index)){
				ComputerInfo computerInfo = new ComputerInfo();
				computerInfo.setComputerName(dataProjective.get(0).getProjectiveScreen());
				List<ComputerInfo> rojectiveScreen = computerManageService.queryComputerInfo(computerInfo);
				if(rojectiveScreen.size() == 0){
					map.put("result", "投放过程中无法获取到对应的展示屏幕信息, 投放出错！");
					return map;
				}
				final String clientIp = rojectiveScreen.get(0).getComputerIp();
				if( clientIp == null ||  "".equals(clientIp)){
					map.put("result", "停止投放过程中获取到对应的展示页面或者展示屏幕信息为空, 投放出错！");
					return map;
				}	
				
				final int port = 8888;
				final int startFlg = 0;  //0表示关闭  1表示开启投放
				boolean isStart = false;
				Executor executor=Executors.newSingleThreadExecutor();
				FutureTask<Boolean> future=new FutureTask<Boolean>(new Callable<Boolean>() {
					public Boolean call() throws Exception {
						ProjectiveServer projectiveServer = new ProjectiveServer(null, clientIp, port, startFlg);
						return projectiveServer.connectServer();
					}
				});
				executor.execute(future);
				try{
					isStart= future.get(20, TimeUnit.SECONDS);
				}catch (InterruptedException e) {
					System.out.println("方法执行中断");
				}catch (ExecutionException e) {
					System.out.println("Excution异常");
					future.cancel(true);
				}catch (TimeoutException e) {
					System.out.println("方法执行时间超时");
					map.put("result", "停止投放过程超时, 请检查客户端投放屏幕配置是否正确, 服务器IP为[" + InetAddress.getLocalHost().getHostAddress() + "] 服务器端口为[" + port + "]");
				}
				if(isStart){
					DataProjective dpParam = dataProjective.get(0);
					Date date = new Date();
					SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
					dpParam.setId(index);
					dpParam.setRunType(CommonConstant.STOPPED_TYPE);
					dpParam.setUpdateTime(sdf.format(date).toString());
					dpParam.setUpdateUser(updateUser);
					dataProjectiveService.editProjectiveData(dpParam);
				}else{
					map.put("result", "停止投放过程出现未知错误, 请稍后再试！");
				}
			}
		} catch (Exception e) {
			if(map.get("result") == null){
				map.put("result", "停止投放过程出现未知错误, 请稍后再试！");	
			}
		}
		
		return map;
	}
	
}
