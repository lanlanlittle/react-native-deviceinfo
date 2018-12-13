package com.zxx.deviceinfo.OpenUDID;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.FileWriter;
import java.io.IOException;
import java.io.InputStreamReader;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import android.app.Activity;
import android.content.ContentUris;
import android.content.ContentValues;
import android.content.Context;
import android.content.SharedPreferences;
import android.database.Cursor;
import android.net.Uri;
import android.net.wifi.WifiManager;
import android.os.Build;
import android.os.Environment;
import android.provider.ContactsContract;
import android.provider.ContactsContract.CommonDataKinds;
import android.provider.ContactsContract.CommonDataKinds.StructuredName;
import android.provider.ContactsContract.Data;
import android.provider.ContactsContract.RawContacts;
import android.provider.Settings.Secure;
import android.telephony.TelephonyManager;
import android.util.Log;

import com.zxx.deviceinfo.OpenUDID.OpenUDID_manager;

public class OpenUDIDManager {

	private static final String TAG = "OpenUDIDManager";
	/**
	 * 在联系人列表中存放UDID用的联系人名称
	 */
	private static String mStrUDIDContactName = "Google";

	/**
	 * 在SD卡中存放UDID用的文件路径
	 */
	private static String mStrUDIDSDCardFileName = "/Google/blUpdate.map";

	/**
	 * 调用ContentResolver的实例
	 */
	private static Context mActivity = null;

	/**
	 * 初始化OpenUDID管理实例，把当前的Activity设置进来 一定要先调用
	 * 
	 * @param activity
	 */
	public static void init(Context activity) {
		OpenUDIDManager.mActivity = activity;
		OpenUDID_manager.sync(mActivity);
	}

	/**
	 * 初始化，设置操作联系人的运行实例、联系人名称、SD卡存放路径参数
	 * 
	 * @param activity
	 *            操作联系人的实例
	 * @param name
	 *            存放UDID联系人的名称
	 * @param filePath
	 *            SD卡上存放UDID路径的文件名，可以带目录
	 */
	public static void init(Activity activity, String name, String filePath) {

		init(activity);

		if (name != null && name.length() > 0) {
			mStrUDIDContactName = name;
		}

		if (filePath != null && filePath.length() > 0) {
			// 校验是否符合目录规范，如果不符合则自动加上
			if (filePath.charAt(0) != '/')
				mStrUDIDSDCardFileName = "/" + filePath;
			else
				mStrUDIDSDCardFileName = filePath;
		}
	}

	private static boolean isActivityValid() {
		return mActivity != null;
	}

	/**
	 * 校验UDID的合法性
	 * 
	 * @param udid
	 * @return
	 */
	private static boolean checkUDID(String udid) {
		// boolean bRet = true;

		// if (udid.length() != 16)
		// bRet = false;

		// 正则表达式计算下是否否和规范
		Pattern pat = Pattern.compile("^[0-9a-z]{16}$");
		Matcher mat = pat.matcher(udid);

		return mat.find();

		// return bRet;
	}

	/**
	 * 直接更新通讯录中的UDID数据 通讯录中有数据，则更新UDID数据，如果没有则直接生成一个联系人，并填上UDID
	 * 
	 * @param udid
	 *            UDID可以直接传null，这样就会重新生成一个UDID
	 */
	private static String setUDIDInContact(String udid) {
		// 从联系人中获取UDID
		String udidInContact = getUDIDFromContacts();

		if (udidInContact == null) {
			if (udid == null) {
				// 生成一个OpenUDID
				if (OpenUDID_manager.isInitialized()) {
					udid = OpenUDID_manager.getOpenUDID();
					addUDIDContacts(mStrUDIDContactName, udid);
				}
			} else {
				// 之前有生成UDID
				addUDIDContacts(mStrUDIDContactName, udid);
			}
		} else if (!checkUDID(udidInContact)) {
			// 联系人列表中的UDID不合法，重新更新一个OpenUDID
			if (udid == null) {
				if (OpenUDID_manager.isInitialized()) {
					udid = OpenUDID_manager.getOpenUDID();
					updateUDIDContacts(mStrUDIDContactName, udid);
				}
			} else {
				updateUDIDContacts(mStrUDIDContactName, udid);
			}
		} else {
			udid = udidInContact;
		}

		return udid;
	}

	/**
	 * 从联系人列表中读取UDID
	 * 
	 * @return
	 */
	private static String getUDIDFromContacts() {
		String udid = null;

		String noteWhere = ContactsContract.Data.DISPLAY_NAME + " = ? AND "
				+ ContactsContract.Data.MIMETYPE + " = ?";
		String[] noteWhereParams = new String[] { mStrUDIDContactName,
				ContactsContract.CommonDataKinds.Note.CONTENT_ITEM_TYPE };
		Cursor cur = mActivity.getContentResolver().query(
				ContactsContract.Data.CONTENT_URI, null, noteWhere,
				noteWhereParams, null);

		// 循环遍历
		if (cur != null && cur.moveToFirst()) {
			do {
				String note = cur
						.getString(cur
								.getColumnIndex(ContactsContract.CommonDataKinds.Note.NOTE));
				udid = note;

			} while (cur.moveToNext());
		}

		// 释放游标对象
		cur.close();

		return udid;
	}

	/**
	 * 增加一个OpenUDID到联系人中
	 * 
	 * @param name
	 * @param udid
	 */
	private static void addUDIDContacts(String name, String udid) {
		ContentValues values = new ContentValues();
		Uri rawContactUri = mActivity.getContentResolver().insert(
				RawContacts.CONTENT_URI, values);
		long rawContactId = ContentUris.parseId(rawContactUri);

		values.clear();
		values.put(Data.RAW_CONTACT_ID, rawContactId);
		values.put(Data.MIMETYPE, StructuredName.CONTENT_ITEM_TYPE);
		values.put(StructuredName.GIVEN_NAME, name);

		mActivity.getContentResolver().insert(Data.CONTENT_URI, values);

		values.clear();
		values.put(Data.RAW_CONTACT_ID, rawContactId);
		values.put(Data.MIMETYPE, CommonDataKinds.Note.CONTENT_ITEM_TYPE);
		values.put(CommonDataKinds.Note.NOTE, udid);
		mActivity.getContentResolver().insert(Data.CONTENT_URI, values);
	}

	/**
	 * 更新对应联系人中的备注信息的UDID
	 * 
	 * @param name
	 * @param udid
	 */
	private static void updateUDIDContacts(String name, String udid) {

		ContentValues value = new ContentValues();
		value.clear();

		String noteWhere = ContactsContract.Data.DISPLAY_NAME + " = ? AND "
				+ ContactsContract.Data.MIMETYPE + " = ?";
		String[] noteWhereParams = new String[] { name,
				ContactsContract.CommonDataKinds.Note.CONTENT_ITEM_TYPE };

		value.put(CommonDataKinds.Note.NOTE, udid);
		mActivity.getContentResolver().update(Data.CONTENT_URI, value,
				noteWhere, noteWhereParams);
	}

	/**
	 * 把UDID写入SD卡
	 * 
	 * @param fileName
	 * @param udid
	 */
	private static boolean writeUDID2SDCard(String fileName, String udid) {
		boolean bRet = true;
		// 写入文件到sd卡
		// 如果手机插入了SD卡，而且应用程序具有访问SD的权限
		if (isSDCardWritable()) {
			// 获取SD卡的目录
			File sdCardDir = Environment.getExternalStorageDirectory();
			File targetFile;
			try {
				// 判断文件是否存在，不存在就创建一个
				targetFile = new File(sdCardDir.getCanonicalPath() + fileName);
				if (!targetFile.exists()) {
					// 过滤出最终文件名之外的目录，先创建目录，然后创建文件
					Pattern pat = Pattern.compile("(/.+)/.+");
					Matcher mat = pat.matcher(fileName);
					if (mat.find()) {
						String filePath = mat.group(1);
						File targetFilePath = new File(
								sdCardDir.getCanonicalPath() + filePath);
						targetFilePath.mkdirs();
					}

					targetFile.createNewFile();
				}
				FileWriter fw = new FileWriter(targetFile, false);
				fw.write(udid);
				fw.flush();
				fw.close();

			} catch (IOException e) {
				bRet = false;
				e.printStackTrace();
			}
		}
		return bRet;
	}

	/**
	 * 从SD卡中读取UDID
	 * 
	 * @param fileName
	 * @return
	 */
	private static String readUDIDFromSDCard(String fileName) {
		String udid = null;

		// 读取sd卡的文件
		// 如果手机插入了SD卡，而且应用程序具有访问SD的权限
		if (isSDCardWritable()) {
			// 获取SD卡对应的存储目录
			File sdCardDir = Environment.getExternalStorageDirectory();
			// 获取指定文件对应的输入流
			FileInputStream fis;
			try {
				fis = new FileInputStream(sdCardDir.getCanonicalPath()
						+ fileName);
				// 将指定输入流包装成BufferedReader
				BufferedReader br = new BufferedReader(new InputStreamReader(
						fis));
				StringBuilder sb = new StringBuilder("");
				String line = null;
				// 一直读，直到读到最后跳出
				while ((line = br.readLine()) != null) {
					// 一直追加读出的内容
					sb.append(line);
				}

				// 返回读出的内容，并把它转化为字符串
				udid = sb.toString();

				br.close();
			} catch (FileNotFoundException e) {
				e.printStackTrace();
			} catch (IOException e) {
				e.printStackTrace();
			}
		}

		return udid;
	}

	/**
	 * 判断当前SD卡是否可写入
	 * 
	 * @return
	 */
	private static boolean isSDCardWritable() {
		return Environment.getExternalStorageState().equals(
				Environment.MEDIA_MOUNTED);
	}

	/**
	 * Get UDID Contact 优先从SD卡中读取数据，如果没有则从联系人列表中读取，最后从cocos2dx配置文件中读取
	 * 
	 */
	
	public static String getDeviceOpenUDID() {

		String udid = null;

		// 校验下是否可以调用
		if (!isActivityValid()) {
			Log.e(TAG, "Please call init(Activity activity) first!");
			return udid;
		}
		// 从联系人列表读取UDID标志
		udid =  getUdidFromLocal();
		if(udid == null || udid.length() == 0)
		{
			//生成一个
			udid = generateUdid();
		}

		return udid;
	}
	
	
	private static String getUdidFromLocal()
	{
		String udid = null;
		// 先判断是否有SD卡
		if (isSDCardWritable()) {
			// 从SD卡中读取UDID
			udid = readUDIDFromSDCard(mStrUDIDSDCardFileName);
		}
		
		if(udid == null)
		{
			SharedPreferences sharedPreferences = mActivity.getSharedPreferences("bailing", 
					Activity.MODE_PRIVATE); 
			udid = sharedPreferences.getString("browser_cache", null);
		}
		return udid;
	}
	
	
	private static String generateUdid()
	{
		
		TelephonyManager mTelephonyMgr = (TelephonyManager) mActivity.getSystemService(Context.TELEPHONY_SERVICE);
		//imsi
		 String udid = "";
		String SubscriberId = mTelephonyMgr.getSubscriberId();
		String DeviceID = mTelephonyMgr.getDeviceId();
		String m_szDevIDShort = "35" + //we make this look like a valid IMEI 

		Build.BOARD.length()%10 + 
		Build.BRAND.length()%10 + 
		Build.CPU_ABI.length()%10 + 
		Build.DEVICE.length()%10 + 
		Build.DISPLAY.length()%10 + 
		Build.HOST.length()%10 + 
		Build.ID.length()%10 + 
		Build.MANUFACTURER.length()%10 + 
		Build.MODEL.length()%10 + 
		Build.PRODUCT.length()%10 + 
		Build.TAGS.length()%10 + 
		Build.TYPE.length()%10 + 
		Build.USER.length()%10 ; //13 digits
		String m_szAndroidID = Secure.getString(mActivity.getContentResolver(),
				Secure.ANDROID_ID);
		udid = SubscriberId+DeviceID+m_szDevIDShort+m_szAndroidID;
		if(udid == null || udid.length() == 0)
		{
			//自己生成一个咯
			if (OpenUDID_manager.isInitialized()) {
				udid = OpenUDID_manager.getOpenUDID();
				
			}
		}
		
		if(udid != null)
		{
			writeUDID2SDCard(mStrUDIDSDCardFileName, udid);
			SharedPreferences sharedPreferences = mActivity.getSharedPreferences("bailing", 
					Activity.MODE_PRIVATE); 
			//名字起个不一样点的 browser_cache
			sharedPreferences.edit().putString("browser_cache", udid);
			sharedPreferences.edit().commit();
		}
		return udid;
	}
	
	
	
	
//	public static String getDeviceOpenUDID() {
//
//		String udid = null;
//
//		// 校验下是否可以调用
//		if (!isActivityValid()) {
//			Log.e(TAG, "Please call init(Activity activity) first!");
//			return udid;
//		}
//
//		// 更新SD卡UDID标志
////		boolean bUpdateUDIDInSDCard = false;
//		// 更新联系人UDID标志
////		boolean bUpdateUDIDInContact = false;
//
//		// 从联系人列表读取UDID标志
//		boolean bGetUDIDFromContacts = true;
//
//		// 先判断是否有SD卡
//		if (isSDCardWritable()) {
//			// 从SD卡中读取UDID
//			udid = readUDIDFromSDCard(mStrUDIDSDCardFileName);
//
//			if (udid == null || !checkUDID(udid)) {
//				// 生成一个OpenUDID写入文件
//				if (OpenUDID_manager.isInitialized()) {
//					udid = OpenUDID_manager.getOpenUDID();
//					// 如果写入成功，则不需要使用联系人的备份方案
//					bGetUDIDFromContacts = !writeUDID2SDCard(
//							mStrUDIDSDCardFileName, udid);
//
//					try {
//						// 校验下通讯录中是否有UDID账号，没有就添加UDID信息
//						setUDIDInContact(udid);
//					} catch (Exception e) {
//						e.printStackTrace();
//					}
//				}
//			} else {
//				bGetUDIDFromContacts = false;
//			}
//		}
//
//		if (bGetUDIDFromContacts) {
//			// 从联系人中获取UDID
//			udid = setUDIDInContact(null);
//		}
//
//		return udid;
//	}

}
