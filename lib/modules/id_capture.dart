import 'dart:typed_data';

import 'package:flutter_amanisdk_v2/flutter_amanisdk_v2_method_channel.dart';

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
      throw Exception(err);
    }
  }

  Future<bool> iosStartNFC() async {
    try {
      final bool isDone = await _methodChannel.iOSStartIDCaptureNFC();
      return isDone;
    } catch (err) {
      throw Exception(err);
    }
  }

  Future<bool> upload() async {
    try {
      final bool isDone = await _methodChannel.uploadIDCapture();
      return isDone;
    } catch (err) {
      throw Exception(err);
    }
  }

  Future<void> setType(String type) async {
    await _methodChannel.setIDCaptureType(type);
  }
}
