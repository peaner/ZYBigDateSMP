package cn.server;

import java.io.IOException;
import java.net.InetAddress;
import java.net.ServerSocket;
import java.net.Socket;

/**
 * 服务器端入口
 * @author PEANER-Li
 * 现在需要解决的就是  给客户端传过去信息后 如何清除自己服务器端的传输的信息
 */
public class ProjectiveServer {

	//将打开的网址
	private String webUrl;
	//客户端IP
	private String clientIp;
	//端口号
	private int port;
	//端口号
	private int startFlg; //0:停止 1：启动

	public ProjectiveServer(String webUrl, String clientIp, int port, int startFlg) {
		super();
		this.webUrl = webUrl;
		this.clientIp = clientIp;
		this.port = port;
		this.startFlg = startFlg;
	}

	/**
	 * 启动服务器向打开投放屏幕的网址
	 * @throws Exception
	 */
	public boolean connectServer() throws Exception{
		boolean isStart = false;
		ServerSocket serverSocket = null;
		Socket socket = null;
		try {
			System.out.println("****服务器即将启动，等待客户端[" + clientIp + "]的连接***");
			serverSocket = new ServerSocket(port);
			//调用accept()等待客户端的连接,在接收到客户端的请求前会处于阻塞状态
			boolean acceptFlag = false;
			Long start = System.currentTimeMillis();
			while(!acceptFlag){				
				socket = serverSocket.accept();
				Long end = System.currentTimeMillis();
				if(end - start > 20*1000){ 
					acceptFlag = true;
				}
				if(socket != null){
					//if(startFlg == 1){
					InetAddress inetAddress = InetAddress.getByName(clientIp);
					System.out.println("****客户端[" + socket.getInetAddress() + "]已经连接, 将发送的客户端为[" + clientIp + "]***");
					if(inetAddress != null && inetAddress.equals(socket.getInetAddress())){
						ServerThread serverThread = new ServerThread(startFlg , clientIp, webUrl, socket, serverSocket);
						serverThread.run();
						acceptFlag = true;
						isStart = true;
					}else{
						socket.close();							
					}
					//}
				}	
			}		
		} catch (Exception e) {
			e.printStackTrace();
		}finally{
			//5.关闭相关资源
			try {
				if(socket != null){
					socket.close();
				}
				if(serverSocket != null){
					serverSocket.close();
				}
			}catch (IOException e) {
				e.printStackTrace();
			}
		}
		
		return isStart;
	}
}
