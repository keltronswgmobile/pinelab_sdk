package org.keltron.pinelab_sdk;

import android.app.Activity;
import android.content.ComponentName;
import android.content.Context;
import android.content.Intent;
import android.content.ServiceConnection;
import android.os.Bundle;
import android.os.Handler;
import android.os.IBinder;
import android.os.Message;
import android.os.Messenger;

import androidx.annotation.NonNull;

import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.embedding.engine.plugins.activity.ActivityAware;
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;

/** PinelabSdkPlugin */
public class PinelabSdkPlugin implements FlutterPlugin, MethodCallHandler, ActivityAware {

  private MethodChannel channel;
  private Activity activity;
  private Messenger mServerMessenger;
  private static final int BILLING_APP = 1001;
  private boolean isBound;

  @Override
  public void onAttachedToEngine(@NonNull FlutterPluginBinding flutterPluginBinding) {
    channel = new MethodChannel(flutterPluginBinding.getBinaryMessenger(),
            "pinelab_sdk");
    channel.setMethodCallHandler(this);
  }

  @Override
  public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {
    channel.setMethodCallHandler(null);
  }

  @Override
  public void onMethodCall(@NonNull MethodCall call, @NonNull Result result) {
    if ("startTransaction".equals(call.method)) {
      final String transactionMap = call.argument("transactionRequest");
      startTransaction(transactionMap);
      result.success(true);
      return;
    }
    result.notImplemented();
  }


  @Override
  public void onAttachedToActivity(@NonNull ActivityPluginBinding binding) {
    activity = binding.getActivity();
  }

  @Override
  public void onDetachedFromActivityForConfigChanges() {
    this.activity = null;
  }

  @Override
  public void onReattachedToActivityForConfigChanges(@NonNull ActivityPluginBinding binding) {
    this.activity = binding.getActivity();
  }

  @Override
  public void onDetachedFromActivity() {
    this.activity = null;
  }

  public void startTransaction(String transactionMap) {
    try {

      Intent intent = new Intent("com.pinelabs.masterapp.HYBRID_REQUEST");
      intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK);

       intent.setAction("com.pinelabs.masterapp.SERVER");
       intent.setPackage("com.pinelabs.masterapp");


    ServiceConnection connections = new ServiceConnection() {
      @Override
      public void onServiceConnected(ComponentName name, IBinder service) {
        mServerMessenger = new Messenger(service);
        isBound = true;
        sendMessage(transactionMap);
      }

      @Override
      public void onServiceDisconnected(ComponentName name) {
        mServerMessenger = null;
        isBound = false;
      }
    };

    activity.bindService(intent, connections, Context.BIND_AUTO_CREATE);
    } catch (Exception e) {
      channel.invokeMethod("error", e);
    }

  }

  private void sendMessage(String transactionMap) {
    try {
    Bundle data = new Bundle();
    data.putString("MASTERAPPREQUEST",  transactionMap);
    Message message = Message.obtain(null, PinelabSdkPlugin.BILLING_APP);
    message.setData(data);
      message.replyTo = new Messenger(new IncomingHandler());
      mServerMessenger.send(message);
    } catch (Exception e) {
      channel.invokeMethod("error", e);
    }
  }


  private  class IncomingHandler extends Handler {
    public void handleMessage(@NonNull Message msg) {
      Bundle bundle = msg.getData();
      String value = bundle.getString("MASTERAPPRESPONSE");
      System.out.println("output" + value);

      channel.invokeMethod("success", value);
    }
  }
}

