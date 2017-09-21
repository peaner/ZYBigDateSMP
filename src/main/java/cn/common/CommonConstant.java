package cn.common;

public class CommonConstant {

	/**默认状态*/
	public static final String DEFAULT_RUN_TYPE = "0";	
	
	/**停止状态*/
	public static final String STOPPED_TYPE = "1";	
	
	/**运行状态*/
	public static final String RUNNING_TYPE = "2";	
	
	/**默认状态*/
	public static final String DEFAULT_RUN_PROJECTIVE_TYPE = "";	
	
	/**上传ZIP文件路径*/
	public static String uploadZipPath = System.getProperty("catalina.home") + "/temp/zip";
	
	/**解压ZIP文件中的生成数据库XML绝对路径*/
	public static String UNZIP_CREATDB_XML_PATH = "temp/dbxml/";
	
	/**解压ZIP文件中的采集数据JAR包绝对路径*/
	public static String UNZIP_COLLECTION_JAR_PATH = "temp/jar/";M
	
	/**上传WAR文件路径*/
	public static String uploadWarPath = System.getProperty("catalina.home") + "/temp/war";	
	
	/**复制WAR文件的目标路径*/
	public static String copyToWarPath = System.getProperty("catalina.home") + "/webapps";
	
	/**启动采集jar包的bat文件名称*/
	public static final String STRAT_JAR_BAT_NAME = "start.bat";
	
	/**数据采集jar包的配置文件名称*/
	public static final String JAR_CONFIG_PATH = System.getProperty("catalina.home") + "/conf/config_collection.xml";
	
	/**展示war包的配置文件名称*/
	public static final String WAR_CONFIG_PATH = System.getProperty("catalina.home") + "/conf/config_display.xml";
		
	/**采集jar包的配置文件的节点名称（多个jar包的区分）*/
	//public static final String JAR_CONFIG_NODE_NAME = "DataCollectionDemo";
	
	/**采集jar包的配置文件中配置运行状态的节点名称*/
	public static final String JAR_CONFIG_RUN_TYPE_NAME = "startType";
	
	/**展示war的配置文件中配置节点名称*/
	public static final String WAR_CONFIG_SERVER_IP = "server-ip";
	
	/**展示war的配置文件中配置节点名称*/
	public static final String WAR_CONFIG_SERVER_PORT = "server-port";
	
	/**展示war的端口*/
	public static final String WAR_CONFIG_SERVER_PORT_DEFAULT = "8080";
	
	/**展示war的配置文件中配置节点名称*/
	public static final String WAR_CONFIG_WELCOME_FILE = "welcome-file";
	
	/**投放相关的配置文件名称*/
	public static final String PROJECTIVE_CONFIG_PATH = "C:/apache-tomcat-6.0.37" + "/conf/config_projective.xml";
	
	/**用户状态-在线*/
	public static final String USER_TYPE_ON = "在线";	
	
	/**用户状态-离线*/
	public static final String USER_TYPE_OFF = "离线";	
	
	/**用户缓存信息*/
	public static final String SESSION_USER = "sessionUser";
	
}
