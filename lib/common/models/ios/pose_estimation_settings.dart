class IOSPoseEstimationSettings {
  String? faceIsOk;
  String? notInArea;
  String? faceTooSmall;
  String? faceTooBig;
  String? completed;
  String? turnedRight;
  String? turnedLeft;
  String? turnedUp;
  String? turnedDown;
  String? straightMessage;
  String? errorMessage;
  String? tryAgain;
  String? errorTitle;
  String? confirm;
  String? next;
  String? phonePitch;
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
  String? showOnlyArrow;
  String? buttonRadious;
  int? manualCropTimeout;

  IOSPoseEstimationSettings(
      {this.faceIsOk,
      this.notInArea,
      this.faceTooSmall,
      this.faceTooBig,
      this.completed,
      this.turnedRight,
      this.turnedLeft,
      this.turnedUp,
      this.turnedDown,
      this.straightMessage,
      this.errorMessage,
      this.tryAgain,
      this.errorTitle,
      this.confirm,
      this.next,
      this.phonePitch,
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
      this.showOnlyArrow,
      this.buttonRadious,
      this.manualCropTimeout});

  Map toJson() {
    return {
      "faceIsOk": faceIsOk,
      "notInArea": notInArea,
      "faceTooSmall": faceTooSmall,
      "faceTooBig": faceTooBig,
      "completed": completed,
      "turnedRight": turnedRight,
      "turnedLeft": turnedLeft,
      "turnedUp": turnedUp,
      "turnedDown": turnedDown,
      "straightMessage": straightMessage,
      "errorMessage": errorMessage,
      "tryAgain": tryAgain,
      "errorTitle": errorTitle,
      "confirm": confirm,
      "next": next,
      "phonePitch": phonePitch,
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
      "showOnlyArrow": showOnlyArrow,
      "buttonRadious": buttonRadious,
      "manualCropTimeout": manualCropTimeout
    };
  }
}
