package com.zxx.deviceinfo.Util;

import org.json.JSONObject;

import android.app.AlertDialog;
import android.app.Dialog;
import android.content.Context;
import android.content.DialogInterface;
import android.content.pm.ApplicationInfo;
import android.content.pm.PackageManager;

public class AppTools {
	

	/**
	 * 得到Application段中的元数据
	 */
	public static String getApplicationMetaData(String strKey,Context context) {
		String strMetaData = null;
		ApplicationInfo info;
		try {
			info = context.getPackageManager().getApplicationInfo(
					context.getPackageName(), PackageManager.GET_META_DATA);

			if(info== null)
				return "";
			// 先取字符串
			strMetaData = info.metaData.getString(strKey);

			if (strMetaData == null || strMetaData.length() <= 0) {
				int nValue = info.metaData.getInt(strKey);
				strMetaData = String.valueOf(nValue);
			}

		} catch (Exception e) {
			e.printStackTrace();
		}
		return strMetaData == null ? "" : strMetaData;
	}

}


