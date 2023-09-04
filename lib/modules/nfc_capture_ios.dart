import 'dart:typed_data';

import 'package:flutter_amanisdk/common/models/nvi_data.dart';
import 'package:flutter_amanisdk/flutter_amanisdk_method_channel.dart';

class IOSNFCCapture {
  final MethodChannelAmaniSDK _methodChannel;

  IOSNFCCapture(this._methodChannel);

  Future<bool> startWithImageData(Uint8List imageData) async {
    try {
      final bool isSuccess =
          await _methodChannel.iOSNFCCaptureWithImageData(imageData);
      return isSuccess;
    } catch (err) {
      rethrow;
    }
  }

  Future<bool> startWithNviModel(NviModel nviModel) async {
    try {
      final bool isSuccess =
          await _methodChannel.iOSNFCCaptureWithNviData(nviModel);
      return isSuccess;
    } catch (err) {
      rethrow;
    }
  }

  Future<bool> startWithMRZCapture() async {
    try {
      final bool isSuccess = await _methodChannel.iosNFCCaptureWithMRZCapture();
      return isSuccess;
    } catch (err) {
      rethrow;
    }
  }

  Future<bool> upload() async {
    try {
      final bool isDone = await _methodChannel.iosUploadNFCCapture();
      return isDone;
    } catch (err) {
      rethrow;
    }
  }

  Future<void> setType(String type) async {
    await _methodChannel.iosSetNFCType(type);
  }
}
