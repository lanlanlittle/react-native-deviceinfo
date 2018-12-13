package com.zxx.deviceinfo.OpenUDID;

import android.app.Service;
import android.content.Context;
import android.content.Intent;
import android.content.SharedPreferences;
import android.os.Binder;
import android.os.IBinder;

import com.zxx.deviceinfo.OpenUDID.OpenUDID_manager;


/*
 * You have to add this in your manifest
 
<service android:name="org.OpenUDID.OpenUDID_service">
	<intent-filter>
		<action android:name="org.OpenUDID.GETUDID" />
	</intent-filter>
</service>

*/


public class OpenUDID_service extends Service{
	@Override
	public IBinder onBind(Intent arg0) {
		return new  Binder() {
			@Override
			public boolean onTransact(int code, android.os.Parcel data, android.os.Parcel reply, int flags) {
				final SharedPreferences preferences = getSharedPreferences(OpenUDID_manager.PREFS_NAME, Context.MODE_PRIVATE);
		
				reply.writeInt(data.readInt()); //Return to the sender the input random number
				reply.writeString(preferences.getString(OpenUDID_manager.PREF_KEY, null));
				return true;
			}
		};
	}
	
	@Override
	public void onCreate() {
		// TODO Auto-generated method stub
		super.onCreate();
	}
	
	
	@Override
	public int onStartCommand(Intent intent, int flags, int startId) {
		System.out.println("onStartCommand  startId = "+startId);
		return START_STICKY;
	}
}
