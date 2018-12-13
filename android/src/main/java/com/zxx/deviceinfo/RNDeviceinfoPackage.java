
package com.zxx.deviceinfo;

import android.Manifest;
import android.widget.Toast;

import java.util.Arrays;
import java.util.Collections;
import java.util.List;

import com.facebook.react.ReactPackage;
import com.facebook.react.bridge.Arguments;
import com.facebook.react.bridge.NativeModule;
import com.facebook.react.bridge.Promise;
import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactMethod;
import com.facebook.react.bridge.WritableMap;
import com.facebook.react.uimanager.ViewManager;
import com.facebook.react.bridge.JavaScriptModule;
import com.zxx.deviceinfo.Util.PermissionUtil;

public class RNDeviceinfoPackage implements ReactPackage {
    @Override
    public List<NativeModule> createNativeModules(ReactApplicationContext reactContext) {
      return Arrays.<NativeModule>asList(new RNDeviceinfoModule(reactContext));
    }

    // Deprecated from RN 0.47
    public List<Class<? extends JavaScriptModule>> createJSModules() {
      return Collections.emptyList();
    }

    @Override
    public List<ViewManager> createViewManagers(ReactApplicationContext reactContext) {
      return Collections.emptyList();
    }
}