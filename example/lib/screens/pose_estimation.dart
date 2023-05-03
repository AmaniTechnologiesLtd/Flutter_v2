import 'package:flutter/material.dart';
import 'package:flutter_amanisdk_v2/amani_sdk.dart';
import 'package:flutter_amanisdk_v2/common/models/android/pose_estimation_settings.dart';
import 'package:flutter_amanisdk_v2/common/models/ios/pose_estimation_settings.dart';
import 'package:flutter_amanisdk_v2_example/screens/confim.dart';

class PoseEstimationScreen extends StatefulWidget {
  const PoseEstimationScreen({Key? key}) : super(key: key);

  @override
  State<PoseEstimationScreen> createState() => _PoseEstimationScreenState();
}

class _PoseEstimationScreenState extends State<PoseEstimationScreen> {
  final _amaniPoseEstimation = AmaniSDK().getPoseEstimation();

  static const routeName = "/pose-estimation";

  Future<void> initSDK() async {
    await _amaniPoseEstimation.setType("XXX_SE_0");
  }

  @override
  void initState() {
    super.initState();
    initSDK();
  }

  // Configure the pose estimation
  // Configure the AutoSelfie
  final AndroidPoseEstimationSettings _androidPoseEstimationSettings =
      AndroidPoseEstimationSettings(
    poseCount: 3,
    animationDuration: 500,
    faceNotInside: "Your face is not inside the area",
    faceNotStraight: "Your face is not straight",
    keepStraight: "Please hold stable",
    alertTitle: "Verification Failed",
    alertDescription: "Failed 1",
    alertTryAgain: "Try again",
    mainGuideVisibility: true,
    secondaryGuideVisibility: true,
  );

  final IOSPoseEstimationSettings _iosPoseEstimationSettings =
      IOSPoseEstimationSettings(
    faceIsOk: "Please hold stable",
    notInArea: "Please align your face to the area",
    faceTooSmall: "Your face is in too far",
    faceTooBig: "Your face is in too close",
    completed: "Verification Completed",
    turnRight: "→",
    turnLeft: "←",
    turnUp: "↑",
    turnDown: "↓",
    lookStraight: "Look straight",
    errorMessage:
        "Please complete the steps while your face is aligned to the area",
    tryAgain: "Try again",
    errorTitle: "Verification Failure",
    confirm: "Confirm",
    next: "Next",
    holdPhoneVertically: "Please hold the phone straight",
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
    mainGuideVisibility: "true",
    secondaryGuideVisibility: "true",
    buttonRadious: "10",
    manualCropTimeout: 30,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        title: const Text("Pose estimation"),
      ),
      body: Center(
        child: OutlinedButton(
          onPressed: () {
            _amaniPoseEstimation
                .start(
                    androidSettings: _androidPoseEstimationSettings,
                    iosSettings: _iosPoseEstimationSettings)
                .then((imageData) {
              Navigator.pushNamed(context, ConfirmScreen.routeName,
                  arguments: ConfirmArguments(
                      source: "poseEstimation", imageData: imageData));
            }).catchError((err) {
              throw Exception(err);
            });
          },
          child: const Text('Start Pose Estimation'),
        ),
      ),
    );
  }
}
