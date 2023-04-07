package com.example.testffi;

import android.os.Bundle;
import android.util.Log;

import java.nio.ByteBuffer;
import java.nio.charset.StandardCharsets;

import androidx.annotation.Nullable;
import io.flutter.embedding.android.FlutterActivity;
import io.flutter.plugin.common.BasicMessageChannel;
import io.flutter.plugin.common.BinaryCodec;
import io.flutter.plugin.common.BinaryMessenger;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.StringCodec;

public class MainActivity extends FlutterActivity {
    private static final String CHANNEL = "ffi/method_channel/test";
    private MethodChannel channel;
    Jni jni;
    String TAG = "FFI TAG";

    BinaryMessenger getFlutterView() {
        return getFlutterEngine().getDartExecutor().getBinaryMessenger();
    }

    @Override
    protected void onCreate(@Nullable Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        jni = new Jni();

        channel = new MethodChannel(getFlutterView(), CHANNEL);
        channel.setMethodCallHandler(new MethodChannel.MethodCallHandler() {
            @Override
            public void onMethodCall(MethodCall call, MethodChannel.Result result) {
                switch (call.method) {
                    case "setJniRef":
                        Jni.setJniRef(MainActivity.this);
                        break;
                    case "emitMsg":
                        int p = call.argument("value");
                        Jni.emitMsg(p);
                        break;
                    case "nativeAddMethodChanel":
                        int x = call.argument("x");
                        int y = call.argument("y");
                        result.success(Jni.nativeAdd(x,y));
                        break;
                }
            }
        });
    }

    public int emitMsgJava(int para) {
        int res = para + 10086;
        String resString = res + "";
        Log.d(TAG, resString);
        BasicMessageChannel messageChannel = new BasicMessageChannel(getFlutterView(), "ffiCall", BinaryCodec.INSTANCE);
        ByteBuffer buffer = ByteBuffer.allocateDirect(resString.length()).put(resString.getBytes());
        messageChannel.send(buffer);
        return res;
    }
}