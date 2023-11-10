import 'dart:io';
import 'dart:typed_data';

import 'package:flutter_amanisdk/flutter_amanisdk_method_channel.dart';

enum IdSide { front, back }

class IdCapture {
  final MethodChannelAmaniSDK _methodChannel;

  IdCapture(this._methodChannel);

  Future<Uint8List> start(IdSide idSide) async {
    try {
      final dynamic imageData =
          await _methodChannel.startIDCapture(idSide.index);
      if (imageData != null) {
        return imageData as Uint8List;
      } else {
        throw Exception("[AmaniSDK] no image returned from idCapture module");
      }
    } catch (err) {
      rethrow;
    }
  }

  Future<bool> iosStartNFC() async {
    if (!Platform.isIOS) return false;
    try {
      final bool isDone = await _methodChannel.iOSStartIDCaptureNFC();
      return isDone;
    } catch (err) {
      rethrow;
    }
  }

  Future<void> setAndroidUsesNFC(bool usesNFC) async {
    if (Platform.isAndroid) {
      await _methodChannel.androidSetUsesNFC(usesNFC);
    }
  }

  Future<bool> upload() async {
    try {
      final bool isDone = await _methodChannel.uploadIDCapture();
      return isDone;
    } catch (err) {
      rethrow;
    }
  }

  Future<void> setType(String type) async {
    await _methodChannel.setIDCaptureType(type);
  }

  Future<void> setManualButtonTimeout(int time) async {
    await _methodChannel.setIDCaptureManualButtonTimeout(time);
  }

  Future<bool> androidBackButtonHandle() async {
    return await _methodChannel.androidIDCaptureBackPressHandle();
  }

  Future<void> setHologramDetection(bool enabled) async {
    return await _methodChannel.setIDCaptureHologramDetection(enabled);
  }

  Future<void> setVideoRecording(bool enabled) async {
    return await _methodChannel.setIDCaptureVideoRecording(enabled);
  }
}
