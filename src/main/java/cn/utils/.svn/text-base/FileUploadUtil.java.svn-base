package cn.utils;

import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;

import javax.servlet.ServletException;

import org.springframework.web.multipart.MultipartFile;

public class FileUploadUtil {
	// 最大文件大小100M
	private static long maxSize = 100 * 1024 * 1024;
	// 限制上传类型doc,docx,xls,xlsx,ppt,htm,html,txt,
	private static String limitFile = "zip,jar,rar,war";

	/**
	 * 上传过程
	 * @param file
	 * @param filePath
	 * @param deCompress
	 * @return
	 * @throws ServletException
	 * @throws IOException
	 */
	public static boolean processFileUpload(MultipartFile file, String filePath, boolean deCompress)
			throws ServletException, IOException {
		
		File dirFile = new File(filePath);
		if (!dirFile.exists()) {
			dirFile.mkdirs();
		}
		
		// 检查文件大小
		long fileSize = file.getSize();
		if (fileSize > maxSize) {
			// "文件内容超过最大限制!"
			return false;
		}
		// 扩展名格式
		String extName = file.getOriginalFilename()
				.substring(file.getOriginalFilename().lastIndexOf(".") + 1)
				.toLowerCase();
		
		// 检查扩展名
		if (limitFile.indexOf(extName) < 0) {
			// 上传文件扩展名是不允许的扩展名
			return false;
		}
		File uploadedFile = new File(filePath, file.getOriginalFilename());
		OutputStream os = null;
		InputStream is = null;
		try {
			os = new FileOutputStream(uploadedFile);
			is = file.getInputStream();
			byte buf[] = new byte[1024*2];// 可以修改 1024 以提高读取速度
			int length = 0;
			while ((length = is.read(buf)) > 0) {
				os.write(buf, 0, length);
			}
			// 关闭流
			os.flush();
			os.close();
			is.close();
		} catch (Exception e1) {
			e1.printStackTrace();
		} finally{
			if(os != null){
				os.close();
			}
			if(is != null){
				is.close();
			}
		}
		
		//是否需要解压
		if(deCompress){
			try {
				// 解压文件路径
				String unpath = filePath + "/temp";
				File dirTempFile = new File(unpath);
				if (!dirTempFile.exists()) {
					dirTempFile.mkdirs();
				}
				DeCompressUtil.deCompress(uploadedFile.getPath(), unpath);
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
		
		return true;
	}

}
