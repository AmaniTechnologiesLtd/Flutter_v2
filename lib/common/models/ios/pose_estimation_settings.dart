class IOSPoseEstimationSettings {
  // Info messages
  String? faceIsOk;
  String? notInArea;
  String? faceTooSmall;
  String? faceTooBig;
  String? completed;
  String? turnRight;
  String? turnLeft;
  String? turnUp;
  String? turnDown;
  String? lookStraight;
  String? errorMessage;
  String? tryAgain;
  String? errorTitle;
  String? confirm;
  String? next;
  String? holdPhoneVertically;
  String? informationScreenDesc1;
  String? informationScreenDesc2;
  String? informationScreenTitle;
  String? wrongPose;
  String? descriptionHeader;
  // screen config
  String? appBackgroundColor;
  String? appFontColor;
  String? primaryButtonBackgroundColor;
  String? primaryButtonTextColor;
  String? ovalBorderColor;
  String? ovalBorderSuccessColor;
  String? poseCount;
  String? secondaryGuideVisibility;
  String? mainGuideVisibility;
  String? buttonRadious;
  int? manualCropTimeout;

  // main guide images
  String? mainGuideUp;
  String? mainGuideDown;
  String? mainGuideLeft;
  String? mainGuideRight;
  String? mainGuideStraight;

  // secondary guide images
  String? secondaryGuideUp;
  String? secondaryGuideDown;
  String? secondaryGuideLeft;
  String? secondaryGuideRight;

  IOSPoseEstimationSettings(
      {this.faceIsOk,
      this.notInArea,
      this.faceTooSmall,
      this.faceTooBig,
      this.completed,
      this.turnRight,
      this.turnLeft,
      this.turnUp,
      this.turnDown,
      this.lookStraight,
      this.errorMessage,
      this.tryAgain,
      this.errorTitle,
      this.confirm,
      this.next,
      this.holdPhoneVertically,
      this.informationScreenDesc1,
      this.informationScreenDesc2,
      this.informationScreenTitle,
      this.wrongPose,
      this.descriptionHeader,
      this.appBackgroundColor,
      this.appFontColor,
      this.primaryButtonBackgroundColor,
      this.primaryButtonTextColor,
      this.ovalBorderColor,
      this.ovalBorderSuccessColor,
      this.poseCount,
      this.mainGuideVisibility,
      this.secondaryGuideVisibility,
      this.buttonRadious,
      this.manualCropTimeout});

  Map toJson() {
    return {
      "faceIsOk": faceIsOk,
      "notInArea": notInArea,
      "faceTooSmall": faceTooSmall,
      "faceTooBig": faceTooBig,
      "completed": completed,
      "turnRight": turnRight,
      "turnLeft": turnLeft,
      "turnUp": turnUp,
      "turnDown": turnDown,
      "lookStraight": lookStraight,
      "errorMessage": errorMessage,
      "tryAgain": tryAgain,
      "errorTitle": errorTitle,
      "confirm": confirm,
      "next": next,
      "holdPhoneVertically": holdPhoneVertically,
      "informationScreenDesc1": informationScreenDesc1,
      "informationScreenDesc2": informationScreenDesc2,
      "informationScreenTitle": informationScreenTitle,
      "wrongPose": wrongPose,
      "descriptionHeader": descriptionHeader,
      "appBackgroundColor": appBackgroundColor,
      "appFontColor": appFontColor,
      "primaryButtonBackgroundColor": primaryButtonBackgroundColor,
      "primaryButtonTextColor": primaryButtonTextColor,
      "ovalBorderColor": ovalBorderColor,
      "ovalBorderSuccessColor": ovalBorderSuccessColor,
      "poseCount": poseCount,
      "mainGuideVisibility": mainGuideVisibility,
      "secondaryGuideVisibility": secondaryGuideVisibility,
      "buttonRadious": buttonRadious,
      "manualCropTimeout": manualCropTimeout
    };
  }
}
