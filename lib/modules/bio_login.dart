import 'dart:typed_data';

import 'package:flutter_amanisdk_v2/common/models/android/auto_selfie_settings.dart';
import 'package:flutter_amanisdk_v2/common/models/android/pose_estimation_settings.dart';
import 'package:flutter_amanisdk_v2/common/models/ios/auto_selfie_settings.dart';
import 'package:flutter_amanisdk_v2/common/models/ios/pose_estimation_settings.dart';
import 'package:flutter_amanisdk_v2/flutter_amanisdk_v2_method_channel.dart';

class BioLogin {
  final MethodChannelAmaniSDK _methodChannel;
  BioLogin(this._methodChannel);

  Future<void> init({
    required String customerId,
    required String server,
    required String token,
    required String attemptId,
    int? source,
    int? comparisonAdapter,
    String? sharedSecret,
  }) async {
    return _methodChannel.initBioLogin(
        server: server,
        token: token,
        customerId: customerId,
        attemptId: attemptId,
        source: source,
        comparisonAdapter: comparisonAdapter,
        sharedSecret: sharedSecret);
  }

  Future<Uint8List> startWithAutoSelfie(
      {required IOSAutoSelfieSettings iosAutoSelfieSettings,
      required AndroidAutoSelfieSettings androidAutoSelfieSettings}) {
    return _methodChannel.startBioLoginWithAutoSelfie(
        iosSettings: iosAutoSelfieSettings,
        androidSettings: androidAutoSelfieSettings) as Future<Uint8List>;
  }

  Future<Uint8List> startWithPoseEstimation(
      {required IOSPoseEstimationSettings iosPoseEstimationSettings,
      required AndroidPoseEstimationSettings androidPoseEstimationSettings}) {
    return _methodChannel.startBioLoginWithPoseEstimation(
        iosSettings: iosPoseEstimationSettings,
        androidSettings: androidPoseEstimationSettings) as Future<Uint8List>;
  }

  Future<Uint8List> startWithManualSelfie(
      {required String androidSelfieDescriptionText}) {
    return _methodChannel.startBioLoginWithManualSelfie(
            androidSelfieDescriptionText: androidSelfieDescriptionText)
        as Future<Uint8List>;
  }

  Future<bool> upload() {
    return _methodChannel.uploadBioLogin();
  }
}
