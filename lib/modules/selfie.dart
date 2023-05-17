import 'dart:typed_data';

import 'package:flutter_amanisdk_v2/flutter_amanisdk_v2_method_channel.dart';

class Selfie {
  final MethodChannelAmaniSDK _methodChannel;

  Selfie(this._methodChannel);

  Future<Uint8List> start() async {
    try {
      final dynamic imageData = await _methodChannel.startSelfie();
      if (imageData != null) {
        return imageData as Uint8List;
      } else {
        throw Exception("[AmaniSDK] no image returned from selfie module");
      }
    } catch (err) {
      rethrow;
    }
  }

  Future<bool> upload() async {
    try {
      final bool isDone = await _methodChannel.uploadSelfie();
      return isDone;
    } catch (err) {
      rethrow;
    }
  }

  Future<void> setType(String type) async {
    await _methodChannel.setSelfieType(type);
  }

  Future<bool> androidBackButtonHandle() async {
    return await _methodChannel.androidSelfieBackPressHandle();
  }
}
