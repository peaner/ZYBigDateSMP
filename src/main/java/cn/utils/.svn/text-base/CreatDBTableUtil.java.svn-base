package cn.utils;

import java.io.File;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.log4j.Logger;
import org.dom4j.Document;
import org.dom4j.DocumentException;
import org.dom4j.Element;
import org.dom4j.io.SAXReader;

/**
 * 解析文件生成数据库工具类
 * 
 * @author hjk
 */
public class CreatDBTableUtil {
	private static final Logger log = Logger.getLogger(CreatDBTableUtil.class);	
	//private static final String OPERATE_TYPE = "operateType";
	private static final String TABLE_NAME = "tableName";
	private static final String TABLE_COLUMN = "column";
	
	/**
	 * 获取生成数据库表格的所有SQL集合
	 */
	@SuppressWarnings("unchecked")
	public static List<Map<String , Object>> getCreatDataTableSQL(String sqlPath) throws Exception{
		List<Map<String , Object>> list = new ArrayList<Map<String , Object>>();	
		
		List<String> fileNameList = new ArrayList<String>();
		getAllFileName(sqlPath, fileNameList);	
		for(String fileName : fileNameList) {
			Map<String , Object> map = new HashMap<String , Object>();
			try {
				//获取根节点
				Element root = getRoot(sqlPath + fileName);
				
				//数据库表的操作类型：[1:新增][2:修改][3:删除]
				//String operateType = getNodeValue(root, OPERATE_TYPE);
				
				//数据库表名，可以是文件名或者直接在配置里面读取，目前先采用配置里面，后面可以删除String tableName = fileName.split("\\.")[0];
				String tableName = getNodeValue(root, TABLE_NAME);
				map.put(TABLE_NAME, tableName);
				
				//获取数据表所有的列
				Element columnElement = root.element(TABLE_COLUMN);				
				List<Element> listElement = columnElement.elements();
				if(listElement.size() > 0){
					int i = 0;
					String[] keys = new String[listElement.size()];
					for(Element element : listElement) {					
						String type = element.elementText("type");
						String length = element.elementText("length");
						String point = element.elementText("point");
						String isNull = element.elementText("isNull");
						String isAutoIncrement = element.elementText("isAutoIncrement");					
						String isPrikey = element.elementText("isPrikey");					
						
						//格式：字段名 + 空格 + 数据类型  + (长度 )  + 空格 + 修饰符（not null, auto_increment, primary key）					
						StringBuffer columnSql = new StringBuffer();
						columnSql.append(element.getName());
						columnSql.append(" ");
						columnSql.append(type);
						columnSql.append(getDataLength(length, point));					
						if(isNull != null && !"".equals(isNull)){
							columnSql.append(" ");
							columnSql.append("not null");
						}
						if(isAutoIncrement != null && !"".equals(isAutoIncrement)){
							columnSql.append(" ");
							columnSql.append("auto_increment");
						}
						if(isPrikey != null && !"".equals(isPrikey)){
							columnSql.append(" ");
							columnSql.append("primary key");
						}
						keys[i++] = columnSql.toString();
				    }
					map.put("keys", keys);
				}	
			} catch (DocumentException e) {
				log.error("获取创建数据路XML[" + fileName + "]出现异常：" + e.getMessage());
			}
			
			list.add(map);
		}
		
		return list;
	}
	/**
	 * 获取文件指定文件夹下所有文件
	 * @param path
	 */
	public static void getAllFileName(String path, List<String> fileNameList) {
        File file = new File(path);
        File [] files = file.listFiles();
        String [] names = file.list();
        if(names != null) {
        	fileNameList.addAll(Arrays.asList(names));
        }        
        for(File keyFile : files) {
            if(keyFile.isDirectory()) {
                getAllFileName(keyFile.getAbsolutePath(), fileNameList);
            }
        }
    }
	/**
	 * 获取数据长度。
	 * @param dataType
	 * @return
	 */
	private static String getDataLength(String length, String point) { 
		StringBuffer dataLength = new StringBuffer();		
		//小数点位数存在的时候为数字类型，长度格式为(10,4)
		dataLength.append("(");
		if(point == null || "".equals(point)){
			dataLength.append(length);
		} else {			
			dataLength.append(length);
			dataLength.append(",");
			dataLength.append(point);			
		}
		dataLength.append(")");
		
		return dataLength.toString();
	}
	
	/**
	 * 获取根节点
	 * @param path
	 * @throws Exception
	 */
	private static Element getRoot(String path) throws DocumentException{  
	    SAXReader sax = new SAXReader();
	    File xmlFile = new File(path);  
	    Document document = sax.read(xmlFile); 
	    Element root = document.getRootElement();
	    
	    return root;
	}
	
    /**
     * 获取配置文件中指定某个具体节点的value值
     * @param rootName 
     * @param nodeName
     * @return
     */
	private static String getNodeValue(Element root, String nodeName){
		String nodeValue = null;
    	try {		
			nodeValue = root.elementText(nodeName);			
		} catch (Exception e) {
			log.error("获取配置文件中节点[" + nodeName + "]的值出现异常:" + e.getMessage());
		}
    	
    	return nodeValue;
    }

}
