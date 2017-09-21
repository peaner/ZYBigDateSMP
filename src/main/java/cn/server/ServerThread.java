package cn.server;

import java.io.BufferedInputStream;
import java.io.DataInputStream;
import java.io.DataOutputStream;
import java.io.IOException;
import java.net.InetAddress;
import java.net.ServerSocket;
import java.net.Socket;


public class ServerThread {

	Socket socket = null;
	
	public String webUrl = null;

	private String clientIp = null;
	
	private int startFlg = 0 ;
	
	private ServerSocket serverSocket = null;

	public ServerThread(int startFlg ,String clientIp ,String webUrl, Socket socket, ServerSocket serverSocket) throws Exception{
		this.socket =socket;
		this.webUrl = webUrl;
		this.clientIp = clientIp;
		this.serverSocket = serverSocket;
		this.startFlg = startFlg;
	}

	//线程执行操作，响应客户端的请求
	public void run(){

		DataInputStream dis = null;
		DataOutputStream ps = null;
		DataOutputStream dos = null;
		try {

			InetAddress inetAddress = InetAddress.getByName(clientIp);
			if(startFlg==1){
				if(webUrl != null){
					//在這裡指定發送的客戶端 即是定向投放
					if(inetAddress != null && inetAddress.equals(socket.getInetAddress())){
						System.out.println("进入发送···");
						dos = new DataOutputStream(socket.getOutputStream());
						dos.writeBytes("iexplore.exe -k "+webUrl);
						System.out.println("URL:" + webUrl);
						dos.flush();
					}
				}
			}else {
				if(inetAddress != null && inetAddress.equals(socket.getInetAddress())){
					System.out.println("进入发送···");
					dos = new DataOutputStream(socket.getOutputStream());
					dos.writeBytes("taskkill /F /IM iexplore.exe");
					System.out.println("URL:" + startFlg);
					dos.flush();
				}
			}
		} catch (Exception e1) {
			e1.printStackTrace();
		}finally{
			//5.关闭相关资源
			try {
				if(dos != null){
					dos.close();
				}
				if(ps != null){
					ps.close();
				}
				if(dis != null){
					dis.close();
				}
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

	}


	/**
	 * 接收服务器端的信息
	 * @return
	 * @throws Exception
	 */
	public DataInputStream getMessageStream() throws Exception {  
		DataInputStream dis = null;
		try { 
			dis = new DataInputStream(new BufferedInputStream(  
					socket.getInputStream()));  
			return dis;  
		} catch (Exception e) {  
			e.printStackTrace();
			throw e;  
		} finally {
			if (dis != null) {
				dis.close();
			}
		}  
	}
}


