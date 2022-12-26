import 'dart:io';

import 'package:flutter_amanisdk_v2/common/models/customer_detail.dart';
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
    if (server.isEmpty) {
      throw Exception("server parameter cannot be empty string");
    }

    Uri serverURI = Uri.parse(server).normalizePath();
    String serverURL = "";

    // Parse the server and adjust by path.
    if (serverURI.path.contains('/api/v1') && Platform.isAndroid) {
      serverURL = serverURI.toString();
    } else if (serverURI.path.contains('/api/v1') && Platform.isIOS) {
      serverURL = serverURI.origin;
    } else if (serverURI.hasEmptyPath && Platform.isIOS) {
      serverURL = serverURI.origin;
    } else if (serverURI.hasEmptyPath && Platform.isAndroid) {
      serverURL = serverURI.replace(path: "/api/v1/").toString();
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

  Future<CustomerInfoModel> getCustomerInfo() async {
    final customerInfo = await _methodChannel.getCustomerInfo();
    var model =
        CustomerInfoModel.fromMap(Map<String, dynamic>.from(customerInfo));
    return model;
  }
}
