package cn.utils;

import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.dom4j.Document;
import org.dom4j.DocumentException;
import org.dom4j.Element;
import org.dom4j.io.OutputFormat;
import org.dom4j.io.SAXReader;
import org.dom4j.io.XMLWriter;

public class ProjectiveXmlUtil {
	
	/**
	 * 写入xml文件
	 * @param path  xml文件路径
	 * @param rootName 根节点的下一节点名称
	 * @param map   传入的URL、IP、STATE
	 * @return
	 */
	public static boolean Write(String path, String rootName, Map<String, Object> map) {
		boolean setFlag = true;
		SAXReader sax = new SAXReader();
	    File xmlFile = new File(path); //读取文件名
	    FileOutputStream out = null;
	    XMLWriter writer = null;
	    try {
		    Document document = sax.read(xmlFile); 
		    document.getRootElement().element(rootName).element("URL").setText(map.get("URL").toString());
		    document.getRootElement().element(rootName).element("IP").setText(map.get("IP").toString());
		    document.getRootElement().element(rootName).element("STATE").setText(map.get("STATE").toString());
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
	
	
	/**
	 * 读取xml文件
	 * @param fileName  文件路径
	 * @return
	 */
	@SuppressWarnings("unused")
	public static Map<String, Object> Read(String fileName){
		
		Map<String, Object> map = new HashMap<String, Object>();
		
		SAXReader reader = new SAXReader();
		File configFile = new File(fileName);
		
		try {
			Document document = reader.read(configFile);
			//根节点
			Element rootElement = document.getRootElement();
			//根节点下的所有元素
			List<?> elementList = rootElement.elements("user");
			if(elementList != null && elementList.size() > 0){
				for(int i = 0 ; i<elementList.size() ; i++){
					//下一级元素
					Element catElement = (Element) elementList.get(i);
					//获取元素数据
					String URL = catElement.elementText("URL");
					if(URL == null && URL == ""){
						continue;
					}
					String IP = catElement.elementText("IP");
					if(IP == null && IP == ""){
						continue;
					}
					
					String STATE  =catElement.elementText("STATE");
					System.out.println(STATE);
					if(STATE == null && STATE == ""){
						continue;
					}
					
					map.put("URL", URL);
					map.put("IP", IP);
					map.put("STATE", STATE);
					
					System.out.println(map.get("URL").toString()+"===="+map.get("IP").toString()+"===="+map.get("STATE").toString());
				}
			}

		} catch (DocumentException e) {
			e.printStackTrace();
		}
		
		return map;
		
	}
	
	
	

}
