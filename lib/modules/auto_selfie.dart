import 'dart:typed_data';

import 'package:flutter_amanisdk_v2/common/models/android/auto_selfie_settings.dart';
import 'package:flutter_amanisdk_v2/common/models/ios/auto_selfie_settings.dart';
import 'package:flutter_amanisdk_v2/flutter_amanisdk_v2_method_channel.dart';

class AutoSelfie {
  final MethodChannelAmaniSDK _methodChannel;

  AutoSelfie(this._methodChannel);

  Future<Uint8List> start({
    required AndroidAutoSelfieSettings androidAutoSelfieSettings,
    required IOSAutoSelfieSettings iosAutoSelfieSettings,
  }) async {
    try {
      final dynamic imgData = await _methodChannel.startAutoSelfie(
          androidSettings: androidAutoSelfieSettings,
          iosSettings: iosAutoSelfieSettings);
      if (imgData != null) {
        return imgData as Uint8List;
      } else {
        throw Exception("[AmaniSDK] no image returned from autoSelfieModule");
      }
    } catch (err) {
      rethrow;
    }
  }

  Future<bool> upload() async {
    try {
      final bool isDone = await _methodChannel.uploadAutoSelfie();
      return isDone;
    } catch (err) {
      rethrow;
    }
  }

  Future<void> setType(String type) async {
    await _methodChannel.setAutoSelfieType(type: type);
  }

  Future<bool> androidBackButtonHandle() async {
    return await _methodChannel.androidAutoSelfieBackPressHandle();
  }
}
