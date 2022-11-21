import 'dart:typed_data';

import 'package:flutter_amanisdk_v2/common/models/nvi_data.dart';
import 'package:flutter_amanisdk_v2/flutter_amanisdk_v2_method_channel.dart';

class IOSNFCCapture {
  final MethodChannelAmaniSDK _methodChannel;

  IOSNFCCapture(this._methodChannel);

  Future<bool> startWithImageData(Uint8List imageData) async {
    final bool isSuccess =
        await _methodChannel.iOSNFCCaptureWithImageData(imageData);
    return isSuccess;
  }

  Future<bool> startWithNviModel(NviModel nviModel) async {
    final bool isSuccess =
        await _methodChannel.iOSNFCCaptureWithNviData(nviModel);
    return isSuccess;
  }

  Future<bool> startWithMRZCapture() async {
    final bool isSuccess = await _methodChannel.iosNFCCaptureWithMRZCapture();
    return isSuccess;
  }

  Future<bool> upload() async {
    final bool isSuccess = await _methodChannel.iosUploadNFCCapture();
    return isSuccess;
  }

  Future<void> setType(String type) async {
    await _methodChannel.iosSetNFCType(type);
  }
}
