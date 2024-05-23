package com.zego.callkit.zego_callkit_incoming.notification;

import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.util.Log;

import androidx.localbroadcastmanager.content.LocalBroadcastManager;

import com.zego.callkit.zego_callkit_incoming.Defines;

public class ClickReceiver extends BroadcastReceiver {
    @Override
    public void onReceive(Context context, Intent intent) {
        Log.i("call plugin", "click receiver, Received broadcast " + intent.getAction());
        LocalBroadcastManager.getInstance(context).sendBroadcast(intent);
    }
}
