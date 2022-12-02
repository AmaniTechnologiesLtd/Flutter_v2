import 'package:flutter/material.dart';
import 'package:flutter_amanisdk_v2/amani_sdk.dart';
import 'package:flutter_amanisdk_v2/common/models/android/auto_selfie_settings.dart';
import 'package:flutter_amanisdk_v2/common/models/android/pose_estimation_settings.dart';
import 'package:flutter_amanisdk_v2/common/models/ios/auto_selfie_settings.dart';
import 'package:flutter_amanisdk_v2/common/models/ios/pose_estimation_settings.dart';

class BioLogin extends StatefulWidget {
  const BioLogin({Key? key}) : super(key: key);

  @override
  State<BioLogin> createState() => _BioLoginState();
}

class _BioLoginState extends State<BioLogin> {
  final _bioLogin = AmaniSDK().getBioLogin();
  String _customerID = "";

  Future<void> initBioLogin() async {
    print("biologin");
    await _bioLogin.init(
        server: "server",
        token:
            "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ0b2tlbl90eXBlIjoiYWNjZXNzIiwiZXhwIjoxNjY5ODk5OTA1LCJqdGkiOiJlMjlhMjQ2Y2FlMzU0MDMyYTg2MGQxMDkwZTUwZjFmNCIsInVzZXJfaWQiOjEwfQ.WYRdDwDBs1Nc6la2Y-N8nrmQGeDjuFcgxmH52mrh4L8",
        customerId: "81",
        attemptId: "A952053");
  }

  @override
  void initState() {
    print("initState");
    super.initState();
    initBioLogin();
  }

  final AndroidPoseEstimationSettings _androidPoseEstimationSettings =
      AndroidPoseEstimationSettings(
    poseCount: 3,
    animationDuration: 500,
    faceNotInsideMessage: "Your face is not inside the area",
    faceNotStraightMessage: "Your face is not straight",
    keepStraightMessage: "Please hold stable",
    alertTitle: "Verification Failed",
    alertDescription: "Failed 1",
    alertTryAgainMessage: "Try again",
  );

  final IOSPoseEstimationSettings _iosPoseEstimationSettings =
      IOSPoseEstimationSettings(
    faceIsOk: "Please hold stable",
    notInArea: "Please align your face to the area",
    faceTooSmall: "Your face is in too far",
    faceTooBig: "Your face is in too close",
    completed: "Verification Completed",
    turnedRight: "→",
    turnedLeft: "←",
    turnedUp: "↑",
    turnedDown: "↓",
    straightMessage: "Look straight",
    errorMessage:
        "Please complete the steps while your face is aligned to the area",
    tryAgain: "Try again",
    errorTitle: "Verification Failure",
    confirm: "Confirm",
    next: "Next",
    phonePitch: "Please hold the phone straight",
    informationScreenDesc1:
        "To start verification, align your face with the area",
    informationScreenDesc2: "",
    informationScreenTitle: "Selfie Verification Instructions",
    wrongPose: "Your face must be straight",
    descriptionHeader:
        "Please make sure you are doing the correct pose and your face is aligned with the area",
    appBackgroundColor: "000000",
    appFontColor: "ffffff",
    primaryButtonBackgroundColor: "ffffff",
    primaryButtonTextColor: "000000",
    ovalBorderColor: "ffffff",
    ovalBorderSuccessColor: "00ff00",
    poseCount: "3",
    showOnlyArrow: "true",
    buttonRadious: "10",
    manualCropTimeout: 30,
  );

  final IOSAutoSelfieSettings _iOSAutoSelfieSettings = IOSAutoSelfieSettings(
      faceIsOk: "Please hold stable",
      notInArea: "Please align your face with the area",
      faceTooSmall: "Your face is in too far",
      faceTooBig: "Your face is in too close",
      completed: "All OK!",
      appBackgroundColor: "000000",
      appFontColor: "ffffff",
      primaryButtonBackgroundColor: "ffffff",
      ovalBorderSuccessColor: "00ff00",
      ovalBorderColor: "ffffff",
      countTimer: "3",
      manualCropTimeout: 30);

  final AndroidAutoSelfieSettings _androidAutoSelfieSettings =
      AndroidAutoSelfieSettings(
          textSize: 16,
          counterVisible: true,
          counterTextSize: 21,
          manualCropTimeout: 30,
          distanceText: "Please align your face with the area",
          faceNotFoundText: "No faces found",
          restartText: "Process failed, restarting...",
          stableText: "Please hold stable");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:
          AppBar(backgroundColor: Colors.red, title: const Text("BioLogin")),
      body: Center(
        child: Column(
          children: [
            TextField(
              decoration: const InputDecoration(
                  labelText: "Customer ID", border: UnderlineInputBorder()),
              onChanged: (customerID) {
                setState(() {
                  _customerID = customerID;
                });
              },
            ),
            OutlinedButton(
                onPressed: () {
                  _bioLogin.startWithAutoSelfie(
                      iosAutoSelfieSettings: _iOSAutoSelfieSettings,
                      androidAutoSelfieSettings: _androidAutoSelfieSettings);
                },
                child: const Text("Start AutoSelfie BioLogin")),
            OutlinedButton(
                onPressed: () {
                  _bioLogin.startWithPoseEstimation(
                      iosPoseEstimationSettings: _iosPoseEstimationSettings,
                      androidPoseEstimationSettings:
                          _androidPoseEstimationSettings);
                },
                child: const Text("Start PoseEstimation BioLogin")),
            OutlinedButton(
                onPressed: () {
                  _bioLogin.startWithManualSelfie(
                      androidSelfieDescriptionText: "Hi");
                },
                child: const Text("Start Manual Selfie BioLogin")),
          ],
        ),
      ),
    );
  }
}
