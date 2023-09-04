import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_amanisdk/common/models/api_version.dart';
import 'package:flutter_amanisdk/common/models/customer_detail.dart';
import 'package:flutter_amanisdk/flutter_amanisdk_method_channel.dart';
import 'package:flutter_amanisdk/modules/auto_selfie.dart';
import 'package:flutter_amanisdk/modules/bio_login.dart';
import 'package:flutter_amanisdk/modules/id_capture.dart';
import 'package:flutter_amanisdk/modules/nfc_capture_android.dart';
import 'package:flutter_amanisdk/modules/nfc_capture_ios.dart';
import 'package:flutter_amanisdk/modules/pose_estimation.dart';
import 'package:flutter_amanisdk/modules/selfie.dart';

class AmaniSDK {
  final MethodChannelAmaniSDK _methodChannel = MethodChannelAmaniSDK();
  final delegateChannel = const MethodChannel("amanisdk_delegate_channel");

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

    /// API Version defaults to v2. Do not set this unless
    /// it's specified by Amani to you.
    AmaniApiVersion? apiVersion,

    /// Optional shared secret
    String? sharedSecret,
  }) async {
    if (server.isEmpty) {
      throw Exception("server parameter cannot be empty string");
    }

    String apiV = apiVersion == AmaniApiVersion.v1 ? "v1" : "v2";

    Uri serverURI = Uri.parse(server).normalizePath();
    try {
      var login = await _methodChannel.initAmani(
        server: serverURI.origin,
        customerToken: customerToken,
        customerIdCardNumber: customerIdCardNumber,
        lang: lang,
        useLocation: useLocation,
        sharedSecret: sharedSecret,
        apiVersion: apiV,
      );
      return login;
    } catch (err) {
      rethrow;
    }
  }

  void setDelegateMethods(

      /// On error function. Called when native SDK has an error raised
      // TODO: Models?
      Function(String, List<Map<String, dynamic>>) onError,

      /// Called when profile status has changes
      Function(Map<String, dynamic>) onProfileStatus,

      /// Called when steps to complete kyc process has changes
      Function(List<dynamic>) onStepsResult) {
    delegateChannel.setMethodCallHandler((call) async {
      print("call.method = $call.method");
      if (call.method == "onError") {
        String errorCode = call.arguments['type'];
        List<Map<String, dynamic>> errorDetails =
            json.decode(call.arguments["errors"]);
        onError.call(errorCode, errorDetails);
        print("onError call");
      } else if (call.method == "profileStatus") {
        Map<String, dynamic> profileStatus = json.decode(call.arguments);
        onProfileStatus.call(profileStatus);
      } else if (call.method == "stepResult") {
        Map<String, dynamic> stepsResult = json.decode(call.arguments);
        print("stepResult call");
        onStepsResult.call(stepsResult["result"]);
      }
    });
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

    /// ApiVersion
    AmaniApiVersion? apiVersion,

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

    String apiV = apiVersion == AmaniApiVersion.v1 ? "v1" : "v2";

    Uri serverURI = Uri.parse(server).normalizePath();
    try {
      var login = await _methodChannel.initAmaniWithEmail(
          server: serverURI.origin,
          email: email,
          password: password,
          customerIdCardNumber: customerIdCardNumber,
          lang: lang,
          useLocation: useLocation,
          sharedSecret: sharedSecret,
          apiVersion: apiV);
      return login;
    } catch (err) {
      rethrow;
    }
  }
}
