package cn.utils;

import java.io.File;
import java.net.InetAddress;
import java.net.NetworkInterface;
import java.net.SocketException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.Enumeration;

public class PathUtil {
	
	public static String getClasspath(){
		String path = (String.valueOf(Thread.currentThread().getContextClassLoader().getResource(""))+"../../").replaceAll("file:/", "").replaceAll("%20", " ").trim();	
		if(path.indexOf(":") != 1){
			path = File.separator + path;
		}
		return path;
	}
	
	/**
	 * 获取上传文件路径：都是以/结尾
	 * @return
	 */
	public static String getAllPath(String filePath){		
		SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMddHHmmss");
		String ymd = sdf.format(new Date());
		String path = filePath + "/" + ymd + "/";
		return path;
	}
	
	/**
	 * 获取服务器IP
	 * @return
	 */
	public static String getServerIp() {
		InetAddress ip = null;
		String serverIp = null;
		try {
			Enumeration<NetworkInterface> netInterfaces = NetworkInterface.getNetworkInterfaces();
			while (netInterfaces.hasMoreElements()) {
				NetworkInterface ni = (NetworkInterface) netInterfaces.nextElement();
				ip = (InetAddress) ni.getInetAddresses().nextElement();
				serverIp = ip.getHostAddress();
				if (!ip.isSiteLocalAddress() && !ip.isLoopbackAddress()
						&& ip.getHostAddress().indexOf(":") == -1) {
					serverIp = ip.getHostAddress();
					break;
				} else {
					ip = null;
				}
			}
		} catch (SocketException e) {
			e.printStackTrace();
		}

		return serverIp;
	} 
	
	/**
	 * 获取本地IP
	 * @return
	 */
	public static String getLocalIP() {
		InetAddress addr = null;
		try {
			addr = InetAddress.getLocalHost();
		} catch (Exception e) {
			e.printStackTrace();
		}
		byte[] ipAddr = addr.getAddress();
		String ipAddrStr = "";
		for (int i = 0; i < ipAddr.length; i++) {
			if (i > 0) {
				ipAddrStr += ".";
			}
			ipAddrStr += ipAddr[i] & 0xFF;
		}
		return ipAddrStr;
	}
}
