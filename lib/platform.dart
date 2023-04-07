import 'dart:ffi';
import 'dart:io';
import 'dart:math';

import 'package:flutter/services.dart';
import 'package:isolate/isolate_runner.dart';
import 'package:isolate/load_balancer.dart';

import 'generated_bindings.dart';

Future<LoadBalancer> loadBalancer = LoadBalancer.create(2, IsolateRunner.spawn);

class FFIPlatform {
  static const platform = const MethodChannel('ffi/method_channel/test');
  static const String _chanelFFiCallName = "ffiCall";
  static const BasicMessageChannel<ByteData> _channelFFICall =
      BasicMessageChannel<ByteData>(_chanelFFiCallName, BinaryCodec());
  Future<ByteData> Function(ByteData?)? onNewImage;

  init(Future<ByteData> Function(ByteData?)? ffiCallback) {
    onNewImage = ffiCallback;

    _channelFFICall.setMessageHandler(onNewImage);
  }

  setJniRef() async {
    var result = await platform.invokeMethod("setJniRef", <String, dynamic>{});
  }

  emitMsg(int p) async {
    var result =
        await platform.invokeMethod("emitMsg", <String, dynamic>{"value": p});
  }

  nativeAddMethodChanel(int x, int y) async {
    var result = await platform.invokeMethod(
        "nativeAddMethodChanel", <String, dynamic>{"x": x, "y": y});
    return result;
  }

  static NativeLibrary lib = NativeLibrary(Platform.isAndroid
      ? DynamicLibrary.open('libnative_add.so')
      : DynamicLibrary.process());

  static int nativeAdd(Point<int> p) {
    return lib.native_add(p.x, p.y);
  }

  static ffi_Dart_InitializeApiDL() {
    return lib.ffi_Dart_InitializeApiDL(NativeApi.initializeApiDLData);
  }

  static nativeAddCallback(int a, int b, callback c) {
    return lib.native_add_callback(a, b, c);
  }

  static int Function(int int) callbackF = (res){
    print('callbackF $res');
    return res;
  };
}
