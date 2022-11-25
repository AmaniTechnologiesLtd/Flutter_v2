import 'package:flutter/services.dart';
import 'package:flutter_amanisdk_v2/flutter_amanisdk_v2_method_channel.dart';

class AndroidNFCCapture {
  final MethodChannelAmaniSDK _methodChannel;
  Function(bool)? _onFinishedCallback;

  AndroidNFCCapture(this._methodChannel);

  /// Run this on initState()
  void startNFCListener(
      {required String birthDate,
      required String expireDate,
      required String documentNo,
      required Function(bool) onFinishedCallback}) {
    _onFinishedCallback = onFinishedCallback;
    _methodChannel
        .androidStartNFCListener(
            birthDate: birthDate,
            expireDate: expireDate,
            documentNo: documentNo)
        .then((_) {
      _methodChannel.methodChannel.setMethodCallHandler(_handleInverseChannel);
    });
  }

  Future<void> _handleInverseChannel(MethodCall call) async {
    final args = Map.from(call.arguments);
    switch (call.method) {
      case 'onNFCCompleted':
        if (_onFinishedCallback != null) {
          _onFinishedCallback!(args["isSuccess"]);
        }
        break;
      case 'onError':
        throw Exception(args["message"]);
    }
  }

  // Run this whenever you destroy your widget e.g deactivate / dispose
  Future<void> stopNFCListener() async {
    try {
      await _methodChannel.androidDisableNFCListener();
    } catch (err) {
      throw Exception(err);
    }
  }

  Future<void> setType(String type) async {
    await _methodChannel.androidSetNFCType(type);
  }

  Future<bool> upload() async {
    final bool isDone = await _methodChannel.androidUploadNFC();
    return isDone;
  }
}
