package com.zxx.deviceinfo.Util;

import android.app.Activity;
import android.content.Context;
import android.content.pm.PackageInfo;
import android.content.pm.PackageManager;
import android.os.Build;
import android.provider.Settings;
import android.telephony.TelephonyManager;
import android.util.Log;
import android.webkit.WebSettings;
import android.webkit.WebView;

import com.zxx.deviceinfo.OpenUDID.OpenUDIDManager;

import org.json.JSONObject;

import java.net.InetAddress;
import java.net.NetworkInterface;
import java.util.Enumeration;

/**
 * Created by zhaoxx on 2018/12/13.
 */

public class DeviceUtil {
    public static JSONObject getDeviceInfo(Context context){
        String model = android.os.Build.MODEL; // 手机型号
        String udid = OpenUDIDManager.getDeviceOpenUDID();// String

        //硬件制造商 如 oppo
        String manufacturer = android.os.Build.MANUFACTURER;

        String useAgent = useAgent = "";
        udid = MD5.md5(udid);
        int nAPILevel = android.os.Build.VERSION.SDK_INT;
        String ver = getAppVersionName(context);
        String wifi = "";//getWiFiInfo();
        String androidDeviceInfo = getAndroidDeviceInfo(context ,udid);
        String wholeDeviceInfo = getAndroidWholeDevice(context);
        String packageName = getAppPackageName(context);
        String blChannel = getBlChannel(context);
        String ip = "";
        InetAddress inetaddress = null;
        try {
            inetaddress = getLocalHostLANAddress();
            ip = inetaddress.getHostAddress();
        } catch (Exception e) {
            e.printStackTrace();
        }
        JSONObject obj = new JSONObject();
        try {
            obj.put("phonetype", model);
            obj.put("udid", udid);
            obj.put("gamever", ver);
            obj.put("manufacturer", manufacturer);
            obj.put("api_level", ""+nAPILevel);
            obj.put("gamever", ver);
            obj.put("useAgent", useAgent);
            obj.put("blchannel", blChannel);

            obj.put("packageName", packageName);
            obj.put("ip", ip);
            if(androidDeviceInfo != null)
                obj.put("androidDeviceInfo", androidDeviceInfo);
            if(wholeDeviceInfo != null)
                obj.put("wholeDeviceInfo", wholeDeviceInfo);
            if(!wifi.equals("")){
                obj.put("wifi", wifi);
            }else{
                Log.d("wifi","is null");
            }
//            if(AntiEmulator.isSimulate(AppActivity.m_AppActivity)){
//                AppActivity.isSimulate = true;
//            }
//            if(AppActivity.isSimulate){
//                obj.put("simulate", 1);
//            }else{
//                obj.put("simulate", 0);
//            }
            obj.put("useragent", getUserAgent(context));
//            obj.put("bOnlyHuge", Integer.valueOf(only_huge));
//            obj.put("updatechannel", update_channel);

        } catch (Exception e) {
            e.printStackTrace();
        }
        return obj;
    }

    /**
     * 获得当前app的版本名称
     *
     * @return String
     */
    public static String getAppVersionName(Context context) {
        String versionName = "";
        try {
            PackageInfo pinfo = context.getPackageManager().getPackageInfo(
                    context.getPackageName(), PackageManager.GET_CONFIGURATIONS);
            if (pinfo == null)
                return "";
            // versionCode = pinfo.versionCode;
            versionName = pinfo.versionName;
        } catch (Exception e) {

        }
        return versionName;
    }

    /**
     * 获取当前设备的信息
     *
     *
     */
    public static String getAndroidDeviceInfo(Context context, String udid){


        TelephonyManager telmgr = (TelephonyManager) context.getSystemService(Context.TELEPHONY_SERVICE);
        String deviceID = telmgr.getDeviceId();
        String imsi = telmgr.getSubscriberId();
        String serial = android.os.Build.SERIAL;
        String android_id = Settings.Secure.getString(context.getContentResolver(), Settings.Secure.ANDROID_ID);


        JSONObject obj = new JSONObject();
        try {
            if(udid!=null)
                obj.put("udid", udid);

            if(deviceID!=null)
                obj.put("deviceID", deviceID);
            if(imsi != null)
                obj.put("imsi", imsi);
            if(serial != null)
                obj.put("serial", serial);
            if(android_id != null)
                obj.put("androidid", android_id);

            if(Build.BOARD != null)
                obj.put("BBOARD", Build.BOARD);
//			if(Build.BRAND != null)
//				obj.put("BBRAND", Build.BRAND);
            if(Build.CPU_ABI != null)
                obj.put("BCPUABI", Build.CPU_ABI);
            if(Build.CPU_ABI2 != null)
                obj.put("BCPUABI2", Build.CPU_ABI2);

            if(Build.DEVICE != null)
                obj.put("BDEVICE", Build.DEVICE);
            if(Build.DISPLAY != null)
                obj.put("BDISPLAY", Build.DISPLAY);

            if(Build.HOST != null)
                obj.put("BHOST", Build.HOST);
            if(Build.ID != null)
                obj.put("BID", Build.ID);
//			if(Build.MANUFACTURER != null)
//				obj.put("BMANUFACTURER", Build.MANUFACTURER);
            if(Build.MODEL != null)
                obj.put("BMODEL", Build.MODEL);
//			if(Build.PRODUCT != null)
//				obj.put("BPRODUCT", Build.PRODUCT);
            if(Build.TAGS != null)
                obj.put("BTAGS", Build.TAGS);

            if(Build.USER != null)
                obj.put("BUSER", Build.USER);


        } catch (Exception e) {
            e.printStackTrace();
        }
        return obj.toString();
    }

    /**
     * 获取当前设备的信息
     */
    public static String getAndroidWholeDevice(Context context){
        TelephonyManager telmgr = (TelephonyManager) context.getSystemService(Context.TELEPHONY_SERVICE);
        String whole_d_normal = telmgr.getDeviceId();
        String whole_d_none = "";
        String whole_d_gsm = "";
        String whole_d_cdma = "";
        String whole_d_sip = "";

        JSONObject obj = new JSONObject();

        try {
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
                whole_d_none = telmgr.getDeviceId(TelephonyManager.PHONE_TYPE_NONE);
                whole_d_gsm = telmgr.getDeviceId(TelephonyManager.PHONE_TYPE_GSM);
                whole_d_cdma = telmgr.getDeviceId(TelephonyManager.PHONE_TYPE_CDMA);
                whole_d_sip = telmgr.getDeviceId(TelephonyManager.PHONE_TYPE_SIP);
            }

            if(whole_d_normal != null)
                obj.put("whole_d_normal", whole_d_normal);

            if(whole_d_none != null)
                obj.put("whole_d_none", whole_d_none);

            if(whole_d_gsm != null)
                obj.put("whole_d_gsm", whole_d_gsm);

            if(whole_d_cdma != null)
                obj.put("whole_d_cdma", whole_d_cdma);

            if(whole_d_sip != null)
                obj.put("whole_d_sip", whole_d_sip);
        } catch (Exception e) {
            e.printStackTrace();
        }

        return obj.toString();
    }

    /**
     * 获得当前App的包名
     *
     * @return int
     */
    public static String getAppPackageName(Context context) {
        // final String pName = "com.bailin.killbulls";
        String packageName = "";
        try {
            PackageInfo pinfo = context.getPackageManager().getPackageInfo(
                    context.getPackageName(), PackageManager.GET_CONFIGURATIONS);

            if (pinfo == null)
                return "";
            packageName = pinfo.packageName;
            // versionName = pinfo.versionName;
        } catch (Exception e) {

        }
        return packageName;
    }

    /**
     * 获得对应程序的渠道
     *
     * @return
     */
    public static String getBlChannel(Context context) {
        return AppTools.getApplicationMetaData("BL_CHANNEL",context);
    }

    /**
     * 获得ip
     *
     * @return
     */
    public static InetAddress getLocalHostLANAddress() throws Exception {
        try {
            InetAddress candidateAddress = null;
            // 遍历所有的网络接口
            for (Enumeration ifaces = NetworkInterface.getNetworkInterfaces(); ifaces.hasMoreElements(); ) {
                NetworkInterface iface = (NetworkInterface) ifaces.nextElement();
                // 在所有的接口下再遍历IP
                for (Enumeration inetAddrs = iface.getInetAddresses(); inetAddrs.hasMoreElements(); ) {
                    InetAddress inetAddr = (InetAddress) inetAddrs.nextElement();
                    if (!inetAddr.isLoopbackAddress()) {// 排除loopback类型地址
                        if (inetAddr.isSiteLocalAddress()) {
                            // 如果是site-local地址，就是它了
                            return inetAddr;
                        } else if (candidateAddress == null) {
                            // site-local类型的地址未被发现，先记录候选地址
                            candidateAddress = inetAddr;
                        }
                    }
                }
            }
            if (candidateAddress != null) {
                return candidateAddress;
            }
            // 如果没有发现 non-loopback地址.只能用最次选的方案
            InetAddress jdkSuppliedAddress = InetAddress.getLocalHost();
            return jdkSuppliedAddress;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    private static String getUserAgent(Context context)
    {
        WebView pWebView = new WebView(context);

        WebSettings settings = pWebView.getSettings();
        String ua = settings.getUserAgentString();
        Log.e("AppActivity", "User Agent:" + ua);
        return ua;
    }
}
