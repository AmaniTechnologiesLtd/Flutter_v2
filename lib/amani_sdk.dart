import 'dart:io';

import 'package:flutter_amanisdk_v2/flutter_amanisdk_v2_method_channel.dart';
import 'package:flutter_amanisdk_v2/modules/auto_selfie.dart';
import 'package:flutter_amanisdk_v2/modules/bio_login.dart';
import 'package:flutter_amanisdk_v2/modules/id_capture.dart';
import 'package:flutter_amanisdk_v2/modules/nfc_capture_android.dart';
import 'package:flutter_amanisdk_v2/modules/nfc_capture_ios.dart';
import 'package:flutter_amanisdk_v2/modules/pose_estimation.dart';
import 'package:flutter_amanisdk_v2/modules/selfie.dart';

class AmaniSDK {
  final MethodChannelAmaniSDK _methodChannel = MethodChannelAmaniSDK();

  /// returns [IdCapture] module
  IdCapture getIDCapture() {
    return IdCapture(_methodChannel);
  }

  /// returns [Selfie] module
  Selfie getSelfie() {
    return Selfie(_methodChannel);
  }

  /// returns [AutoSelfie] module
  AutoSelfie getAutoSelfie() {
    return AutoSelfie(_methodChannel);
  }

  /// Returns [PoseEstimation] module
  PoseEstimation getPoseEstimation() {
    return PoseEstimation(_methodChannel);
  }

  /// Returns [IOSNFCCapture] module
  IOSNFCCapture getIOSNFCCapture() {
    return IOSNFCCapture(_methodChannel);
  }

  /// Returns [AndroidNFCCapture] module
  AndroidNFCCapture getAndroidNFCCapture() {
    return AndroidNFCCapture(_methodChannel);
  }

  /// Returns [BioLogin] module
  BioLogin getBioLogin() {
    return BioLogin(_methodChannel);
  }

  /// Initializes the SDK
  Future<bool> initAmani({
    /// server url
    required String server,

    /// customer token acquired from our rest api
    required String customerToken,

    /// customers id card number or any random string, must match with
    /// the id supplied while creating the customerToken field
    required String customerIdCardNumber,

    /// Sets if location info must be supplied while uploading the document
    required bool useLocation,

    /// Language parameters
    required String lang,

    /// Optional shared secret
    String? sharedSecret,
  }) async {
    String serverURL = "";
    if (server.endsWith("/") == false) {
      throw Exception("Server url shouldn't end without trailing slash.");
    }
    if (server.endsWith("/api/v1/") && Platform.isAndroid) {
      serverURL = server;
    } else if (server.endsWith("/api/v1/") && Platform.isIOS) {
      serverURL = server.replaceAll("/api/v1/", server);
    }
    if (!server.endsWith("/api/v1/") && Platform.isAndroid) {
      serverURL = "$server/api/v1/";
    }
    try {
      var login = await _methodChannel.initAmani(
          server: serverURL,
          customerToken: customerToken,
          customerIdCardNumber: customerIdCardNumber,
          lang: lang,
          useLocation: useLocation,
          sharedSecret: sharedSecret);
      return login;
    } catch (err) {
      throw Exception(err);
    }
  }
}
