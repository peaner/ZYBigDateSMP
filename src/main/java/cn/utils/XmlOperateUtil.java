package cn.utils;

import java.io.File;

import org.dom4j.Document;
import org.dom4j.DocumentException;
import org.dom4j.Element;
import org.dom4j.io.SAXReader;

import cn.common.CommonConstant;

public class XmlOperateUtil {

	/**
	 * 获取根节点
	 * @param path
	 * @throws Exception
	 */
	public static Element getRoot(String path) throws DocumentException{  
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
	public static String getNodeValue(Element root, String nodeName){
		String nodeValue = null;
    	try {		
			nodeValue = root.elementText(nodeName);			
		} catch (Exception e) {
			e.printStackTrace();
		}
    	
    	return nodeValue;
    }
	
	/**
	 * 
	 * @param warName
	 * @param nodeName
	 * @return
	 */
	public static String getWarConfigInfo(String warName, String nodeName) {
		String configInfo = null;
		try {
			Element root = XmlOperateUtil.getRoot(CommonConstant.WAR_CONFIG_PATH);			
			configInfo = XmlOperateUtil.getNodeValue(root.element(warName), nodeName);
		} catch (DocumentException e) {
			e.printStackTrace();
		}
		return configInfo;
	}
}
