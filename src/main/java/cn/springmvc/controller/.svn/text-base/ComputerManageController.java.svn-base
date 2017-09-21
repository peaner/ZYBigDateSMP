package cn.springmvc.controller;

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

import cn.common.CommonConstant;
import cn.springmvc.model.ComputerInfo;
import cn.springmvc.model.DataProjective;
import cn.springmvc.service.ComputerManageService;
import cn.springmvc.service.DataProjectiveService;

@Controller
@RequestMapping("/computerInfo")
public class ComputerManageController {

	@Autowired
	private ComputerManageService computerManageService;
	
	@Autowired
	private DataProjectiveService dataProjectiveService;
	
	@RequestMapping("index")
	public String index(){
		return "index";
	}

	/**
	 * 结合easy ui返回json 数据
	 * @return
	 * @throws Exception
	 */
	@ResponseBody
	@RequestMapping("computerInfos")
	public Map<String, Object> showComputers(@ModelAttribute("computerInfo") ComputerInfo computerInfo,@RequestParam(required = false,defaultValue ="1") Integer page,@RequestParam(required = false,defaultValue ="10") Integer rows) throws Exception{
		System.out.println(computerInfo.getComputerName());
		Map<String, Object> map = new HashMap<String, Object>(); 
		Map<String, Object> mapParam=new HashMap<String, Object>();
		mapParam.put("start", (page-1)*rows);
		mapParam.put("end", page*rows);
		mapParam.put("computerName", computerInfo.getComputerName());
		List<ComputerInfo> computers = computerManageService.queryComputerInfoByPage(mapParam);
		map.put("rows",computers);
		map.put("total", computerManageService.queryComputerInfo(computerInfo).size());
		return map;
	}	

	/**
	 * 接收前台传递过来的表单数据
	 * 用户的增加操作
	 * @return
	 */
	@ResponseBody
	@RequestMapping("addComputerInfo")
	public Map<String, Object> addComputerInfo(@ModelAttribute("computerInfo") ComputerInfo computerInfo) throws Exception{
		Map<String, Object> map = new HashMap<String, Object>();
		if (computerManageService.queryComputerInfo(computerInfo).size() >= 1) {
			map.put("result", "\""+computerInfo.getComputerName()+"\"显示屏已存在，无法新增！");
		} else {
			//判断IP是不是已存在，如果存在，抛出message，如果不存在可以更新
			ComputerInfo ComputerInfoTmpIp = new ComputerInfo();
			ComputerInfoTmpIp.setComputerIp(computerInfo.getComputerIp());
			List<ComputerInfo> computerInfosIp = computerManageService.queryComputerInfoById(ComputerInfoTmpIp);
			if (computerInfosIp.size() > 0) {
				map.put("result", "\""+computerInfo.getComputerName()+"\"显示屏IP在数据库这已存在，不能执行修改操作！");
				return map;
			}
			//更新操作
			Date date =new Date();
			SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
			computerInfo.setUpdatedTime(sdf.format(date));
			int result = computerManageService.insertComputerInfo(computerInfo);
			if (result==1) {
				map.put("result", "\""+computerInfo.getComputerName()+"\"显示屏成功插入！");
			} else {
				map.put("result", "\""+computerInfo.getComputerName()+"\"显示屏插入失败！");
			}
		}
		return map;
	}
	
	/**
	 * 接收前台传递过来的表单数据
	 * 用户信息的修改操作
	 * @return
	 */
	@ResponseBody
	@RequestMapping("updateComputerInfo")
	public Map<String, Object> modifyComputerInfo(@ModelAttribute("computerInfo") ComputerInfo computerInfo) throws Exception{
		Map<String, Object> map = new HashMap<String, Object>();
		//判断显示屏名称是否被修改
		ComputerInfo ComputerInfoTmpId = new ComputerInfo();
		ComputerInfoTmpId.setComputerId(computerInfo.getComputerId());
		List<ComputerInfo> computerInfos = computerManageService.queryComputerInfoById(ComputerInfoTmpId);
		if (computerInfos.size() == 1) {
			if (computerInfos.get(0).getComputerName() != null && computerInfos.get(0).getComputerName().equals(computerInfo.getComputerName())) {
				//判断IP是不是已存在，如果存在，抛出message，如果不存在可以更新
				ComputerInfo ComputerInfoTmpIp = new ComputerInfo();
				ComputerInfoTmpIp.setComputerIp(computerInfo.getComputerIp());
				List<ComputerInfo> computerInfosIp = computerManageService.queryComputerInfoById(ComputerInfoTmpIp);
				if (computerInfosIp.size() > 0) {
					map.put("result", "\""+computerInfo.getComputerName()+"\"显示屏IP在数据库这已存在，不能执行修改操作！");
					return map;
				}
				Date date =new Date();
				SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
				computerInfo.setUpdatedTime(sdf.format(date));
				int result = computerManageService.updateComputerInfo(computerInfo);
				if (result==1) {
					map.put("result", "\""+computerInfos.get(0).getComputerName()+"\"显示屏更新成功！");
				} else {
					map.put("result", "\""+computerInfos.get(0).getComputerName()+"\"显示屏跟新失败！");
				}
			} else if (computerInfos.get(0).getComputerName() != null && !computerInfos.get(0).getComputerName().equals(computerInfo.getComputerName())) {
				//判断IP是不是已存在，如果存在，抛出message，如果不存在可以更新
				ComputerInfo ComputerInfoTmpIp = new ComputerInfo();
				ComputerInfoTmpIp.setComputerIp(computerInfo.getComputerIp());
				List<ComputerInfo> computerInfosIp = computerManageService.queryComputerInfoById(ComputerInfoTmpIp);
				if (computerInfosIp.size() > 0) {
					map.put("result", "\""+computerInfo.getComputerName()+"\"显示屏IP在数据库这已存在，不能执行修改操作！");
					return map;
				}
				List<ComputerInfo> newComputerInfos = computerManageService.queryComputerInfo(computerInfo);
				if (newComputerInfos.size() > 0) {
					map.put("result", "\""+computerInfo.getComputerName()+"\"显示屏名称在数据库这已存在，不能执行修改操作！");
					return map;
				} else {
					boolean flg = false;
					Map<String, Object> mapParam=new HashMap<String, Object>();
					mapParam.put("projectiveScreen", computerInfos.get(0).getComputerName());
					List<DataProjective> list = dataProjectiveService.queryDataProjective(mapParam);
					// 判断数据投放表中状态是否处于运行状态
					if (list.size() > 0) {
						for (int i = 0; i < list.size(); i++) {
							if (CommonConstant.RUNNING_TYPE.equals(list.get(i).getRunType())) {
								flg = true;
								break;
							}
						}
					}
					// 数据投放表中状态处于运行状态，则不能执行更新操作；
					// 如果是非运行状态，则可执行更新操作
					if (flg) {
						map.put("result", "\""+computerInfos.get(0).getComputerName()+"\"显示屏已在用，不能修改！");
					} else {
						Date date =new Date();
						SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
						computerInfo.setUpdatedTime(sdf.format(date));
						// 更细数据投放表中数据
						if (list.size() > 0) {
							Map<String, Object> mapParamTmp=new HashMap<String, Object>();
							mapParamTmp.put("oldScreen", computerInfos.get(0).getComputerName());
							mapParamTmp.put("newScreen", computerInfo.getComputerName());
							mapParamTmp.put("updateUser", computerInfo.getUpdatedUser());
							mapParamTmp.put("updateTime", sdf.format(date));
							dataProjectiveService.editProjectiveDataByScreen(mapParamTmp);
						}
						// 更新显示屏表中数据
						int result = computerManageService.updateComputerInfo(computerInfo);
						if (result==1) {
							map.put("result", "\""+computerInfos.get(0).getComputerName()+"\"显示屏更新成功！");
						} else {
							map.put("result", "\""+computerInfos.get(0).getComputerName()+"\"显示屏跟新失败！");
						}
					}
				}
			} else {
				//不做处理
			}
		} else {
			map.put("result", "\""+computerInfo.getComputerName()+"\"显示屏不存在，不能修改！");
		}
		return map;
	}
	
	/**
	 * 接收前台传递过来的表单数据
	 * 用户信息的删除操作
	 * @return
	 */
	@ResponseBody
	@RequestMapping("deleteComputerInfo")
	public Map<String, Object> deleteComputerInfo(@ModelAttribute("computerInfo") ComputerInfo computerInfo) throws Exception{
		Map<String, Object> map = new HashMap<String, Object>();
		Map<String, Object> mapParam=new HashMap<String, Object>();
		mapParam.put("projectiveScreen", computerInfo.getComputerName());
		List<DataProjective> list = dataProjectiveService.queryDataProjective(mapParam);
		if (list.size() == 0) {
			int result = computerManageService.deleteComputerInfo(computerInfo);
			if (result==1) {
				map.put("result", "\""+computerInfo.getComputerName()+"\"显示屏删除成功！");
			} else {
				map.put("result", "\""+computerInfo.getComputerName()+"\"显示屏删除失败！");
			}
		} else {
			map.put("result", "\""+computerInfo.getComputerName()+"\"显示屏已在用，不能删除！");
		}
		
		return map;
	}
	
}