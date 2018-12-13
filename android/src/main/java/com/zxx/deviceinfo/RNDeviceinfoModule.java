
package com.zxx.deviceinfo;

import android.Manifest;
import android.widget.Toast;

import com.facebook.react.bridge.Arguments;
import com.facebook.react.bridge.Promise;
import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactContextBaseJavaModule;
import com.facebook.react.bridge.ReactMethod;
import com.facebook.react.bridge.Callback;
import com.facebook.react.bridge.ReadableMap;
import com.facebook.react.bridge.ReadableNativeMap;
import com.facebook.react.bridge.WritableMap;
import com.zxx.deviceinfo.Util.DeviceUtil;
import com.zxx.deviceinfo.Util.PermissionUtil;

import org.json.JSONObject;

public class RNDeviceinfoModule extends ReactContextBaseJavaModule {

  private final ReactApplicationContext reactContext;

  public RNDeviceinfoModule(ReactApplicationContext reactContext) {
    super(reactContext);
    this.reactContext = reactContext;
  }

  @Override
  public String getName() {
    return "RNDeviceinfo";
  }

  /**
   * 获取设备信息
   * @param promise
   */
  @ReactMethod
  public void getDeviceInfo(Promise promise){
    // 没有权限
    if(!PermissionUtil.hasPermission(reactContext, Manifest.permission.INTERNET) ||
            !PermissionUtil.hasPermission(reactContext, Manifest.permission.WRITE_EXTERNAL_STORAGE) ||
            !PermissionUtil.hasPermission(reactContext, Manifest.permission.READ_EXTERNAL_STORAGE) ||
            !PermissionUtil.hasPermission(reactContext, Manifest.permission.ACCESS_NETWORK_STATE)){
      Toast.makeText(reactContext, "请先打开读取设备信息权限", Toast.LENGTH_SHORT);
      return;
    }

    JSONObject obj = DeviceUtil.getDeviceInfo(reactContext);
    WritableMap map = Arguments.createMap();
    if(obj != null){
      map.putString("result", obj.toString());
    }
    promise.resolve(map);
  }
}