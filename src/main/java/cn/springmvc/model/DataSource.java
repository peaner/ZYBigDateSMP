package cn.springmvc.model;

import java.io.Serializable;

import org.springframework.stereotype.Repository;

@Repository
public class DataSource implements Serializable
{
	private static final long serialVersionUID = 546520467205484988L;

	private String id;	
	
	private String dataName;
	
	private String collectionSorce;
	
	private String runType;
	
	private String remark;
	
	private String path;
	
	private String updateUser;
	
	private String updateTime;	

	public String getId() {
		return id;
	}

	public void setId(String id) {
		this.id = id;
	}

	public String getDataName() {
		return dataName;
	}

	public void setDataName(String dataName) {
		this.dataName = dataName;
	}

	public String getCollectionSorce() {
		return collectionSorce;
	}

	public void setCollectionSorce(String collectionSorce) {
		this.collectionSorce = collectionSorce;
	}

	public String getRunType() {
		return runType;
	}

	public void setRunType(String runType) {
		this.runType = runType;
	}

	public String getRemark() {
		return remark;
	}

	public void setRemark(String remark) {
		this.remark = remark;
	}

	public String getUpdateUser() {
		return updateUser;
	}

	public void setUpdateUser(String updateUser) {
		this.updateUser = updateUser;
	}

	public String getUpdateTime() {
		return updateTime;
	}

	public void setUpdateTime(String updateTime) {
		this.updateTime = updateTime;
	}

	public String getPath() {
		return path;
	}

	public void setPath(String path) {
		this.path = path;
	}
	
}
