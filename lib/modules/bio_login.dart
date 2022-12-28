import 'package:flutter/services.dart';
import 'package:flutter_amanisdk_v2/common/models/android/auto_selfie_settings.dart';
import 'package:flutter_amanisdk_v2/common/models/android/pose_estimation_settings.dart';
import 'package:flutter_amanisdk_v2/common/models/ios/auto_selfie_settings.dart';
import 'package:flutter_amanisdk_v2/common/models/ios/pose_estimation_settings.dart';
import 'package:flutter_amanisdk_v2/flutter_amanisdk_v2_method_channel.dart';

class BioLogin {
  final MethodChannelAmaniSDK _methodChannel;
  BioLogin(this._methodChannel);

  MethodChannel? _androidBioLoginChannel;
  Function(Uint8List)? _androidPoseEstimationOnSuccess;
  Function(Map<String, dynamic>)? _androidPoseEstimationOnFailure;

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
      required AndroidAutoSelfieSettings androidAutoSelfieSettings}) async {
    try {
      final imageData = await _methodChannel.startBioLoginWithAutoSelfie(
          iosSettings: iosAutoSelfieSettings,
          androidSettings: androidAutoSelfieSettings);
      if (imageData != null) {
        return imageData;
      } else {
        throw Exception("Nothing returned from BioLogin.startWithAutoSelfie");
      }
    } catch (err) {
      rethrow;
    }
  }

  Future<void> _handleInverseChannel(MethodCall call) async {
    final args = Map.from(call.arguments);
    switch (call.method) {
      case 'androidBioLoginPoseEstimation#onSuccess':
        if (_androidPoseEstimationOnSuccess != null) {
          _androidPoseEstimationOnSuccess!(args["image"] as Uint8List);
        }
        break;
      case 'androidBioLoginPoseEstimation#onError':
        throw Exception(args["message"]);
      case 'androidBioLoginPoseEstimation#onFailure':
        if (_androidPoseEstimationOnFailure != null) {
          _androidPoseEstimationOnFailure!(args as Map<String, dynamic>);
        }
    }
  }

  Future<Uint8List> iOSStartWithPoseEstimation(
      {required IOSPoseEstimationSettings settings}) async {
    final imageData = await _methodChannel.iOSStartBioLoginWithPoseEstimation(
        settings: settings);
    if (imageData != null) {
      return imageData;
    } else {
      throw Exception("Nothing returned from BioLogin.startWithPoseEstimation");
    }
  }

  Future<Uint8List?> androidStartWithPoseEstimation(
      {required AndroidPoseEstimationSettings settings,
      required Function(Uint8List) onSuccessCallback,
      required Function(Map<String, dynamic>) onFailureCallback}) async {
    _androidPoseEstimationOnSuccess = onSuccessCallback;
    _androidPoseEstimationOnFailure = onFailureCallback;
    _androidBioLoginChannel = const MethodChannel('amanisdk_biologin_channel');
    _androidBioLoginChannel!.setMethodCallHandler(_handleInverseChannel);

    return await _methodChannel.androidStartBioLoginWithPoseEstimation(
        settings: settings);
  }

  Future<Uint8List> startWithManualSelfie(
      {required String androidSelfieDescriptionText}) async {
    try {
      final imageData = await _methodChannel.startBioLoginWithManualSelfie(
          androidSelfieDescriptionText: androidSelfieDescriptionText);
      if (imageData != null) {
        return imageData;
      } else {
        throw Exception("Nothing returned from BioLogin.startWithManualSelfie");
      }
    } catch (err) {
      rethrow;
    }
  }

  Future<bool> upload() async {
    try {
      final bool isDone = await _methodChannel.uploadBioLogin();
      return isDone;
    } catch (err) {
      rethrow;
    }
  }
}
