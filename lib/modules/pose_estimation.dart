import 'dart:typed_data';
import 'package:flutter_amanisdk/common/models/android/pose_estimation_settings.dart';
import 'package:flutter_amanisdk/common/models/ios/pose_estimation_settings.dart';
import 'package:flutter_amanisdk/flutter_amanisdk_method_channel.dart';

class PoseEstimation {
  final MethodChannelAmaniSDK _methodChannel;

  PoseEstimation(this._methodChannel);

  Future<Uint8List> start(
      {required IOSPoseEstimationSettings iosSettings,
      required AndroidPoseEstimationSettings androidSettings}) async {
    try {
      final dynamic imageData = await _methodChannel.startPoseEstimation(
          iosPoseEstimationSettings: iosSettings,
          androidPoseEstimationSettings: androidSettings);
      if (imageData != null) {
        return imageData as Uint8List;
      } else {
        throw Exception(
            "[AmaniSDK] no image returned from poseEstimation module");
      }
    } catch (err) {
      rethrow;
    }
  }

  Future<bool> upload() async {
    try {
      final bool isDone = await _methodChannel.uploadPoseEstimation();
      return isDone;
    } catch (err) {
      rethrow;
    }
  }

  Future<void> setType(String type) async {
    await _methodChannel.setPoseEstimationType(type);
  }

  Future<bool> androidBackButtonHandle() async {
    return await _methodChannel.androidPoseEstimationBackPressHandle();
  }

  Future<void> setVideoRecording(bool enabled) async {
    await _methodChannel.setPoseEstimationVideoRecording(enabled);
  }
}
