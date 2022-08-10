package org.keltron.pinelab_sdk;

import android.app.Activity;
import android.content.ComponentName;
import android.content.Context;
import android.content.Intent;
import android.content.ServiceConnection;
import android.os.Bundle;
import android.os.Handler;
import android.os.IBinder;
import android.os.Looper;
import android.os.Message;
import android.os.Messenger;
import android.os.RemoteException;

import androidx.annotation.NonNull;

import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.embedding.engine.plugins.activity.ActivityAware;
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugin.common.PluginRegistry;

/** PinelabSdkPlugin */
public class Bckp implements FlutterPlugin, MethodCallHandler, ActivityAware, PluginRegistry.ActivityResultListener {

  private MethodChannel channel;
  private Activity activity;
  int REQUEST_CODE = 1001;
  String PLUTUS_SMART_PACKAGE =  	"com.pinelabs.masterapp";
  String PLUTUS_SMART_ACTION =  	"com.pinelabs.masterapp.SERVER";
  int MESSAGE_CODE =  	1001;
  String BILLING_REQUEST_TAG =  	"MASTERAPPREQUEST";
  String BILLING_RESPONSE_TAG =  	"MASTERAPPRESPONSE";
  private Messenger mServerMessenger;
  boolean mBound = false;
  private boolean isBound;
  private static final int BILLING_APP = 1001;

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
    if ("makePayment".equals(call.method)) {
      final String transactionMap = call.argument("transactionMap");
      final String packageName = call.argument("packageName");
//      makePayment(transactionMap, packageName);
      makePaymentDivya(transactionMap, packageName);
      result.success(true);
      return;
    }
    result.notImplemented();
  }


  @Override
  public void onAttachedToActivity(@NonNull ActivityPluginBinding binding) {
    activity = binding.getActivity();
    binding.addActivityResultListener(this);
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

  //This is the method that is called with main action. It starts a new activity by a new intent, then it should listen for a async result
  public void makePayment(String transactionMap, String packageName) {
    Bundle bundle = new Bundle();
    bundle.putString("REQUEST_DATA",  transactionMap);
    bundle.putString("packageName", packageName);

    Intent intent = new Intent("com.pinelabs.masterapp.HYBRID_REQUEST");
    intent.putExtras(bundle);

    intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK);

    activity.startActivityForResult(intent, REQUEST_CODE);
  }

  //This is the method that I need to be called after new activity returns a result
  public boolean onActivityResult(int requestCode, int resultCode, Intent data) {
    System.out.println("#########################################");
    System.out.println(data);
    System.out.println("#########################################");
    try {

      new Handler(Looper.getMainLooper()).post(() -> channel.invokeMethod("success", data));
      return true;
    } catch (Exception e) {
        channel.invokeMethod("error", e);
        return  true;
    }
  }


  public void makePaymentDivya(String transactionMap, String packageName) {
      Intent intent = new Intent("com.pinelabs.masterapp.HYBRID_REQUEST");
      intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK);

       intent.setAction("com.pinelabs.masterapp.SERVER");
       intent.setPackage("com.pinelabs.masterapp");


    ServiceConnection connections = new ServiceConnection() {
      @Override
      public void onServiceConnected(ComponentName name, IBinder service) {
        mServerMessenger = new Messenger(service);
        isBound = true;
        sendMessage(BILLING_APP, transactionMap);
      }

      @Override
      public void onServiceDisconnected(ComponentName name) {
        mServerMessenger = null;
        isBound = false;
      }
    };

    activity.bindService(intent, connections, Context.BIND_AUTO_CREATE);

  }

  private void sendMessage(int what, String transactionMap) {
    Bundle data = new Bundle();
    data.putString("MASTERAPPREQUEST",  transactionMap);
    Message message = Message.obtain(null, what);
    message.setData(data);
    try {
      message.replyTo = new Messenger(new IncomingHandler());
      mServerMessenger.send(message);
    } catch (RemoteException e) {
      e.printStackTrace();
    }
  }

  private class IncomingHandler extends Handler {
    public void handleMessage(Message msg) {
      Bundle bundle = msg.getData();
      String value = bundle.getString("MASTERAPPRESPONSE");
      System.out.println("output" + value);
    }
  }
}

