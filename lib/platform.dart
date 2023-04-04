import 'package:flutter/services.dart';

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
}
