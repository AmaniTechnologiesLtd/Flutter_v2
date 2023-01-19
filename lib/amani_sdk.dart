import 'dart:io';

import 'package:flutter/foundation.dart';
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
    try {
      var login = await _methodChannel.initAmani(
          server: serverURI.origin,
          customerToken: customerToken,
          customerIdCardNumber: customerIdCardNumber,
          lang: lang,
          useLocation: useLocation,
          sharedSecret: sharedSecret);
      return login;
    } catch (err) {
      rethrow;
    }
  }

  Future<CustomerInfoModel> getCustomerInfo() async {
    final customerInfo = await _methodChannel.getCustomerInfo();
    if (customerInfo != null) {
      final model =
          CustomerInfoModel.fromMap(Map<String, dynamic>.from(customerInfo));
      return model;
    } else {
      throw Exception("Failed to get customer info");
    }
  }

  /// Initializes the SDK
  /// **warning** do not use this command in production.
  /// It'll throw exception if used in production
  Future<bool> initAmaniWithEmail({
    /// server url
    required String server,

    /// api login email
    required String email,

    // api login password
    required String password,

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

    if (!kDebugMode) {
      throw Exception(
          "You can't run this method on production version of your app");
    }

    Uri serverURI = Uri.parse(server).normalizePath();
    try {
      var login = await _methodChannel.initAmaniWithEmail(
          server: serverURI.origin,
          email: email,
          password: password,
          customerIdCardNumber: customerIdCardNumber,
          lang: lang,
          useLocation: useLocation,
          sharedSecret: sharedSecret);
      return login;
    } catch (err) {
      rethrow;
    }
  }
}
