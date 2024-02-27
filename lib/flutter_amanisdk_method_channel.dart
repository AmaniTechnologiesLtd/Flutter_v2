import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/services.dart';
import 'package:flutter_amanisdk/common/models/android/auto_selfie_settings.dart';
import 'package:flutter_amanisdk/common/models/android/pose_estimation_settings.dart';
import 'package:flutter_amanisdk/common/models/ios/auto_selfie_settings.dart';
import 'package:flutter_amanisdk/common/models/ios/pose_estimation_settings.dart';

import 'amanisdk_platform_interface.dart';
import 'common/models/nvi_data.dart';

/// An implementation of [AmaniSDKPlatform] that uses method channels.
class MethodChannelAmaniSDK extends AmaniSDKPlatform {
  /// The method channel used to interact with the native platform.
  final methodChannel = const MethodChannel('amanisdk_method_channel');

  @override
  Future<dynamic> startIDCapture(int stepID) async {
    try {
      final dynamic imageData = await methodChannel
          .invokeMethod<dynamic>('startIDCapture', {"stepID": stepID});
      return imageData;
    } catch (err) {
      rethrow;
    }
  }

  @override
  Future<bool> uploadIDCapture() async {
    try {
      final bool isDone = await methodChannel.invokeMethod('uploadIDCapture');
      return isDone;
    } catch (err) {
      rethrow;
    }
  }

  @override
  Future<void> setIDCaptureType(String type) async {
    try {
      await methodChannel.invokeMethod('setIDCaptureType', {"type": type});
    } catch (err) {
      rethrow;
    }
  }

  @override
  Future<void> setIDCaptureVideoRecording(bool enabled) async {
    await methodChannel.invokeMethod(
        "setIDCaptureVideoRecordingEnabled", {"enabled": enabled});
  }

  @override
  Future<void> setIDCaptureHologramDetection(bool enabled) async {
    await methodChannel
        .invokeMethod("setIDCaptureHologramDetection", {"enabled": enabled});
  }

  @override
  Future<void> setIDCaptureManualButtonTimeout(int timeout) async {
    try {
      await methodChannel.invokeMethod(
          'setIDCaptureManualButtonTimeout', {"timeout": timeout});
    } catch (err) {
      rethrow;
    }
  }

  @override
  Future<bool> iOSStartIDCaptureNFC() async {
    try {
      final bool isDone = await methodChannel.invokeMethod('iosIDCaptureNFC');
      return isDone;
    } catch (err) {
      rethrow;
    }
  }

  @override
  Future<void> androidSetUsesNFC(bool usesNFC) async {
    await methodChannel.invokeMethod("setIDCaptureNFC", {"usesNFC": usesNFC});
  }

  @override
  Future<bool> androidIDCaptureBackPressHandle() async {
    if (Platform.isAndroid) {
      try {
        final bool result =
            await methodChannel.invokeMethod("idCaptureAndroidBackPressHandle");
        return result;
      } catch (e) {
        rethrow;
      }
    } else {
      return true;
    }
  }

  @override
  Future<bool> initAmani(
      {required String server,
      required String customerToken,
      required String customerIdCardNumber,
      required bool useLocation,
      required String lang,
      required String apiVersion,
      String? sharedSecret}) async {
    try {
      final bool loginResult = await methodChannel.invokeMethod('initAmani', {
        "server": server,
        "customerToken": customerToken,
        "customerIdCardNumber": customerIdCardNumber,
        "useLocation": useLocation,
        "lang": lang,
        "sharedSecret": sharedSecret,
        "apiVersion": apiVersion,
      });
      return loginResult;
    } catch (err) {
      rethrow;
    }
  }

  @override
  Future<dynamic> startSelfie() async {
    try {
      final dynamic imgData =
          await methodChannel.invokeMethod<dynamic>('startSelfie');
      return imgData;
    } catch (err) {
      rethrow;
    }
  }

  @override
  Future<void> setSelfieType(String type) async {
    try {
      await methodChannel.invokeMethod('setSelfieType', {'type': type});
    } catch (err) {
      rethrow;
    }
  }

  @override
  Future<bool> androidSelfieBackPressHandle() async {
    if (Platform.isAndroid) {
      try {
        final bool result =
            await methodChannel.invokeMethod("selfieAndroidBackPressHandle");
        return result;
      } catch (e) {
        rethrow;
      }
    } else {
      return true;
    }
  }

  @override
  Future<bool> uploadSelfie() async {
    try {
      final bool status = await methodChannel.invokeMethod('uploadSelfie');
      return status;
    } catch (err) {
      rethrow;
    }
  }

  // AutoSelfie
  @override
  Future<dynamic> startAutoSelfie(
      {required AndroidAutoSelfieSettings androidSettings,
      required IOSAutoSelfieSettings iosSettings}) async {
    final String androidSettingsJSON = jsonEncode(androidSettings);
    final String iosSettingsJSON = jsonEncode(iosSettings);
    try {
      final imgData = await methodChannel.invokeMethod('startAutoSelfie', {
        "iosSettings": iosSettingsJSON,
        "androidSettings": androidSettingsJSON
      });
      return imgData;
    } catch (err) {
      rethrow;
    }
  }

  @override
  Future<void> setAutoSelfieType({required String type}) async {
    try {
      await methodChannel.invokeMethod('setAutoSelfieType', {"type": type});
    } catch (err) {
      rethrow;
    }
  }

  @override
  Future<bool> androidAutoSelfieBackPressHandle() async {
    if (Platform.isAndroid) {
      try {
        final bool result = await methodChannel
            .invokeMethod("autoSelfieAndroidBackPressHandle");
        return result;
      } catch (e) {
        rethrow;
      }
    } else {
      return true;
    }
  }

  @override
  Future<bool> uploadAutoSelfie() async {
    try {
      final bool status = await methodChannel.invokeMethod('uploadAutoSelfie');
      return status;
    } catch (err) {
      rethrow;
    }
  }

  // Pose Estimation
  @override
  Future startPoseEstimation(
      {required AndroidPoseEstimationSettings androidPoseEstimationSettings,
      required IOSPoseEstimationSettings iosPoseEstimationSettings}) async {
    final String androidSettingsJSON =
        jsonEncode(androidPoseEstimationSettings);
    final String iosSettingsJSON = jsonEncode(iosPoseEstimationSettings);
    try {
      final dynamic imgData =
          await methodChannel.invokeMethod('startPoseEstimation', {
        "androidSettings": androidSettingsJSON,
        "iosSettings": iosSettingsJSON,
      });
      return imgData;
    } catch (err) {
      rethrow;
    }
  }

  @override
  Future<bool> androidPoseEstimationBackPressHandle() async {
    if (Platform.isAndroid) {
      try {
        final bool result = await methodChannel
            .invokeMethod("poseEstimationAndroidBackPressHandle");
        return result;
      } catch (e) {
        rethrow;
      }
    } else {
      return true;
    }
  }

  @override
  Future<bool> uploadPoseEstimation() async {
    try {
      final bool isDone =
          await methodChannel.invokeMethod('uploadPoseEstimation');
      return isDone;
    } catch (err) {
      rethrow;
    }
  }

  @override
  Future<void> setPoseEstimationType(String type) async {
    try {
      await methodChannel.invokeMethod('setPoseEstimationType', {"type": type});
    } catch (err) {
      rethrow;
    }
  }

  @override
  Future<void> setPoseEstimationVideoRecording(bool enabled) async {
    await methodChannel
        .invokeMethod("setPoseEstimationVideoRecording", {"enabled": enabled});
  }

  // NFC Capture For IOS
  @override
  Future<bool> iosNFCCaptureWithMRZCapture() async {
    try {
      final bool isSuccess =
          await methodChannel.invokeMethod('iOSstartNFCWithMRZCapture');
      return isSuccess;
    } catch (err) {
      rethrow;
    }
  }

  @override
  Future<bool> iOSNFCCaptureWithImageData(Uint8List imageData) async {
    try {
      final bool isSuccess = await methodChannel
          .invokeMethod('iOSstartNFCWithImageData', {'imageData': imageData});
      return isSuccess;
    } catch (err) {
      rethrow;
    }
  }

  @override
  Future<bool> iOSNFCCaptureWithNviData(NviModel nviModel) async {
    try {
      final bool isSuccess = await methodChannel.invokeMethod(
          'iOSstartNFCWithNviModel', {'nviData': nviModel.toMap()});
      return isSuccess;
    } catch (err) {
      rethrow;
    }
  }

  @override
  Future<bool> iosUploadNFCCapture() async {
    try {
      final bool isSuccess = await methodChannel.invokeMethod('iOSuploadNFC');
      return isSuccess;
    } catch (err) {
      rethrow;
    }
  }

  @override
  Future<void> iosSetNFCType(String type) async {
    try {
      await methodChannel.invokeMethod('iOSsetNFCType', {"type": type});
    } catch (err) {
      rethrow;
    }
  }

  // NFC Capture For Android
  @override
  Future<bool> androidStartNFCListener(
      {String? birthDate, String? expireDate, String? documentNo}) async {
    try {
      var startRes = await methodChannel.invokeMethod('androidStartNFC', {
        "birthDate": birthDate,
        "expireDate": expireDate,
        "documentNo": documentNo
      });
      return startRes;
    } catch (err) {
      rethrow;
    }
  }

  @override
  Future<void> androidDisableNFCListener() async {
    try {
      await methodChannel.invokeMethod('androidDisableNFC');
    } catch (err) {
      rethrow;
    }
  }

  @override
  Future<void> androidSetNFCType(String type) async {
    try {
      await methodChannel.invokeMethod('androidSetNFCType', {"type": type});
    } catch (err) {
      rethrow;
    }
  }

  @override
  Future<bool> androidUploadNFC() async {
    try {
      final bool isDone = await methodChannel.invokeMethod('androidUploadNFC');
      return isDone;
    } catch (err) {
      rethrow;
    }
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
      String? sharedSecret}) async {
    try {
      await methodChannel.invokeMethod("initBioLogin", {
        "server": server,
        "token": token,
        "customerId": customerId,
        "attemptId": attemptId,
        "source": source,
        "comparisonAdapter": comparisonAdapter,
        "sharedSecret": sharedSecret,
      });
    } catch (err) {
      rethrow;
    }
  }

  @override
  Future<Uint8List?> startBioLoginWithAutoSelfie(
      {required IOSAutoSelfieSettings iosSettings,
      required AndroidAutoSelfieSettings androidSettings}) async {
    try {
      final imageData = await methodChannel
          .invokeMethod<Uint8List>("startBioLoginWithAutoSelfie", {
        "iosSettings": jsonEncode(iosSettings),
        "androidSettings": jsonEncode(androidSettings)
      });
      return imageData;
    } catch (err) {
      rethrow;
    }
  }

  @override
  Future<Uint8List?> iOSStartBioLoginWithPoseEstimation(
      {required IOSPoseEstimationSettings settings}) async {
    try {
      final imageData = await methodChannel
          .invokeMethod<Uint8List>("iOSStartBioLoginWithPoseEstimation", {
        "iosSettings": jsonEncode(settings),
      });
      return imageData;
    } catch (err) {
      rethrow;
    }
  }

  @override
  Future<Uint8List?> androidStartBioLoginWithPoseEstimation(
      {required AndroidPoseEstimationSettings settings}) async {
    try {
      final imageData = await methodChannel.invokeMethod<Uint8List>(
          "androidStartBioLoginWithPoseEstimation",
          {"androidSettings": jsonEncode(settings)});
      return imageData;
    } catch (err) {
      rethrow;
    }
  }

  @override
  Future<Uint8List?> startBioLoginWithManualSelfie(
      {required String androidSelfieDescriptionText}) async {
    try {
      final imageData = methodChannel.invokeMethod<Uint8List>(
          "startBioLoginWithManualSelfie",
          {"androidSelfieDescriptionText": androidSelfieDescriptionText});
      return imageData;
    } catch (err) {
      rethrow;
    }
  }

  @override
  Future<bool> androidBioLoginBackPressHandle() async {
    if (Platform.isAndroid) {
      try {
        final bool result = await methodChannel
            .invokeMethod("autoSelfieAndroidBackPressHandle");
        return result;
      } catch (e) {
        rethrow;
      }
    } else {
      return true;
    }
  }

  @override
  Future<bool> uploadBioLogin() async {
    try {
      final bool isSuccess = await methodChannel.invokeMethod("uploadBioLogin");
      return isSuccess;
    } catch (err) {
      rethrow;
    }
  }

  @override
  Future<Map<String, dynamic>?> getCustomerInfo() async {
    try {
      final Map<String, dynamic>? customerInfo = await methodChannel
          .invokeMapMethod<String, dynamic>("getCustomerInfo");
      return customerInfo;
    } catch (err) {
      rethrow;
    }
  }

  @override
  Future<Uint8List?> startDocumentCaptureWithView(int documentCount) async {
    try {
      final Uint8List? resultingDocumentImage = await methodChannel
          .invokeMethod<Uint8List>(
              'startDocumentCapture', {'documentCount': documentCount});
      return resultingDocumentImage;
    } catch (err) {
      rethrow;
    }
  }

  @override
  Future<void> documentCaptureSetType(String type) async {
    try {
      await methodChannel
          .invokeMethod('documentCaptureSetType', {'type': type});
    } catch (err) {
      rethrow;
    }
  }

  @override
  Future<bool> documentCaptureUpload(List<Map<String, dynamic>>? files) async {
    try {
      final bool uploadRes = await methodChannel
          .invokeMethod('documentCaptureUpload', {'files': files});
      return uploadRes;
    } catch (err) {
      rethrow;
    }
  }

  @override
  Future<bool> initAmaniWithEmail(
      {required String server,
      required String email,
      required String password,
      required String customerIdCardNumber,
      required bool useLocation,
      required String apiVersion,
      required String lang,
      String? sharedSecret}) async {
    try {
      final bool loginResult =
          await methodChannel.invokeMethod('initAmaniWithEmail', {
        "server": server,
        "email": email,
        "password": password,
        "customerIdCardNumber": customerIdCardNumber,
        "useLocation": useLocation,
        "lang": lang,
        "sharedSecret": sharedSecret,
        "apiVersion": apiVersion
      });
      return loginResult;
    } catch (err) {
      rethrow;
    }
  }
}
