import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/services.dart';
import 'package:flutter_amanisdk_v2/common/models/android/auto_selfie_settings.dart';
import 'package:flutter_amanisdk_v2/common/models/android/pose_estimation_settings.dart';
import 'package:flutter_amanisdk_v2/common/models/ios/auto_selfie_settings.dart';
import 'package:flutter_amanisdk_v2/common/models/ios/pose_estimation_settings.dart';

import 'amanisdk_platform_interface.dart';
import 'common/models/nvi_data.dart';

/// An implementation of [AmaniSDKPlatform] that uses method channels.
class MethodChannelAmaniSDK extends AmaniSDKPlatform {
  /// The method channel used to interact with the native platform.
  final methodChannel = const MethodChannel('amanisdk_method_channel');

  @override
  Future<dynamic> startIDCapture(int stepID) async {
    final dynamic imageData = await methodChannel.invokeMethod<dynamic>(
        'startIDCapture', {"stepID": stepID}).catchError((err) {
      throw Exception(err.toString());
    });
    return imageData;
  }

  @override
  Future<bool> uploadIDCapture() async {
    final bool isDone =
        await methodChannel.invokeMethod('uploadIDCapture').catchError((err) {
      throw Exception(err);
    });
    return isDone;
  }

  @override
  Future<void> setIDCaptureType(String type) async {
    await methodChannel
        .invokeMethod('setIDCaptureType', {"type": type}).catchError((err) {
      throw Exception(err);
    });
  }

  @override
  Future<bool> iOSStartIDCaptureNFC() async {
    final bool isDone =
        await methodChannel.invokeMethod('iosIDCaptureNFC').catchError((err) {
      throw Exception(err);
    });
    return isDone;
  }

  @override
  Future<bool> initAmani(
      {required String server,
      required String customerToken,
      required String customerIdCardNumber,
      required bool useLocation,
      required String lang,
      String? sharedSecret}) async {
    try {
      final bool loginResult = await methodChannel.invokeMethod('initAmani', {
        "server": server,
        "customerToken": customerToken,
        "customerIdCardNumber": customerIdCardNumber,
        "useLocation": useLocation,
        "lang": lang,
        "sharedSecret": sharedSecret
      });
      return loginResult;
    } catch (err) {
      throw Exception(err);
    }
  }

  @override
  Future<dynamic> startSelfie() async {
    final dynamic imgData = await methodChannel
        .invokeMethod<dynamic>('startSelfie')
        .catchError((err) {
      throw Exception(err.toString());
    });
    return imgData;
  }

  @override
  Future<void> setSelfieType(String type) async {
    await methodChannel.invokeMethod('setSelfieType', {'type': type});
  }

  @override
  Future<bool> uploadSelfie() async {
    final bool status =
        await methodChannel.invokeMethod('uploadSelfie').catchError((err) {
      throw Exception(err.toString());
    });
    return status;
  }

  // AutoSelfie
  @override
  Future<dynamic> startAutoSelfie(
      {required AndroidAutoSelfieSettings androidSettings,
      required IOSAutoSelfieSettings iosSettings}) async {
    final String androidSettingsJSON = jsonEncode(androidSettings);
    final String iosSettingsJSON = jsonEncode(iosSettings);

    final imgData = await methodChannel.invokeMethod('startAutoSelfie', {
      "iosSettings": iosSettingsJSON,
      "androidSettings": androidSettingsJSON
    }).catchError((err) {
      throw Exception(err);
    });
    return imgData;
  }

  @override
  Future<void> setAutoSelfieType({required String type}) async {
    await methodChannel
        .invokeMethod('setAutoSelfieType', {"type": type}).catchError((err) {
      throw Exception(err.toString());
    });
  }

  @override
  Future<bool> uploadAutoSelfie() async {
    final bool status =
        await methodChannel.invokeMethod('uploadAutoSelfie').catchError((err) {
      throw Exception(err.toString());
    });
    return status;
  }

  // Pose Estimation
  @override
  Future startPoseEstimation(
      {required AndroidPoseEstimationSettings androidPoseEstimationSettings,
      required IOSPoseEstimationSettings iosPoseEstimationSettings}) async {
    final String androidSettingsJSON =
        jsonEncode(androidPoseEstimationSettings);
    final String iosSettingsJSON = jsonEncode(iosPoseEstimationSettings);
    final dynamic imgData =
        await methodChannel.invokeMethod('startPoseEstimation', {
      "androidSettings": androidSettingsJSON,
      "iosSettings": iosSettingsJSON,
    }).catchError((err) {
      throw Exception(err);
    });

    return imgData;
  }

  @override
  Future<bool> uploadPoseEstimation() async {
    final bool isDone = await methodChannel
        .invokeMethod('uploadPoseEstimation')
        .catchError((err) {
      throw Exception(err);
    });
    return isDone;
  }

  @override
  Future<void> setPoseEstimationType(String type) async {
    await methodChannel.invokeMethod('setPoseEstimationType', {"type": type});
  }

  // NFC Capture For IOS
  @override
  Future<bool> iosNFCCaptureWithMRZCapture() async {
    try {
      final bool isSuccess =
          await methodChannel.invokeMethod('iOSstartNFCWithMRZCapture');
      return isSuccess;
    } catch (err) {
      throw Exception(err);
    }
  }

  @override
  Future<bool> iOSNFCCaptureWithImageData(Uint8List imageData) async {
    try {
      final bool isSuccess = await methodChannel
          .invokeMethod('iOSstartNFCWithImageData', {'imageData': imageData});
      return isSuccess;
    } catch (err) {
      throw Exception(err);
    }
  }

  @override
  Future<bool> iOSNFCCaptureWithNviData(NviModel nviModel) async {
    try {
      final bool isSuccess = await methodChannel.invokeMethod(
          'iOSstartNFCWithNviModel', nviModel.toMap());
      return isSuccess;
    } catch (err) {
      throw Exception(err);
    }
  }

  @override
  Future<bool> iosUploadNFCCapture() async {
    try {
      final bool isSuccess = await methodChannel.invokeMethod('iOSuploadNFC');
      return isSuccess;
    } catch (err) {
      throw Exception(err);
    }
  }

  @override
  Future<void> iosSetNFCType(String type) async {
    await methodChannel.invokeMethod('iOSsetNFCType', {"type": type});
  }

  // NFC Capture For Android
  @override
  Future<void> androidStartNFCListener(
      {required String birthDate,
      required String expireDate,
      required String documentNo}) async {
    await methodChannel.invokeMethod('androidStartNFC', {
      "birthDate": birthDate,
      "expireDate": expireDate,
      "documentNo": documentNo
    });
  }

  @override
  Future<void> androidDisableNFCListener() async {
    await methodChannel.invokeMethod('androidDisableNFC');
  }

  @override
  Future<void> androidSetNFCType(String type) async {
    await methodChannel.invokeMethod('androidSetNFCType', {"type": type});
  }

  @override
  Future<bool> androidUploadNFC() async {
    final bool isDone =
        await methodChannel.invokeMethod('androidUploadNFC').catchError((err) {
      throw Exception(err);
    });
    return isDone;
  }

  // BioLogin
  @override
  Future<void> initBioLogin(
      {required String server,
      required String token,
      required String customerId,
      required String attemptId,
      int? source,
      int? comparisonAdapter,
      String? sharedSecret}) {
    return methodChannel.invokeMethod("initBioLogin", {
      "server": server,
      "token": token,
      "customerId": customerId,
      "attemptId": attemptId,
      "source": source,
      "comparisonAdapter": comparisonAdapter,
      "sharedSecret": sharedSecret,
    });
  }

  @override
  Future<dynamic> startBioLoginWithAutoSelfie(
      {required IOSAutoSelfieSettings iosSettings,
      required AndroidAutoSelfieSettings androidSettings}) {
    return methodChannel.invokeMethod("startBioLoginWithAutoSelfie", {
      "iosSettings": jsonEncode(iosSettings),
      "androidSettings": jsonEncode(androidSettings)
    });
  }

  @override
  Future<dynamic> startBioLoginWithPoseEstimation(
      {required IOSPoseEstimationSettings iosSettings,
      required AndroidPoseEstimationSettings androidSettings}) {
    return methodChannel.invokeMethod("startBioLoginWithPoseEstimation", {
      "iosSettings": jsonEncode(iosSettings),
      "androidSettings": jsonEncode(androidSettings)
    });
  }

  @override
  Future<dynamic> startBioLoginWithManualSelfie(
      {required String androidSelfieDescriptionText}) {
    return methodChannel.invokeMethod("startBioLoginWithManualSelfie",
        {"androidSelfieDescriptionText": androidSelfieDescriptionText});
  }

  @override
  Future<bool> uploadBioLogin() {
    return methodChannel.invokeMethod("uploadBioLogin") as Future<bool>;
  }
}
