class AndroidPoseEstimationSettings {
  int? poseCount;
  int? animationDuration;
  String? faceNotInside;
  String? faceNotStraight;
  String? faceIsTooFar;
  String? holdPhoneVertically;
  String? alertTitle;
  String? alertDescription;
  String? alertTryAgain;
  String? turnLeft;
  String? turnRight;
  String? turnUp;
  String? turnDown;
  String? lookStraight;
  bool? mainGuideVisibility;
  bool? secondaryGuideVisibility;

  AndroidPoseEstimationSettings(
      {this.poseCount,
      this.animationDuration,
      this.faceNotInside,
      this.faceNotStraight,
      this.faceIsTooFar,
      this.holdPhoneVertically,
      this.alertTitle,
      this.alertDescription,
      this.alertTryAgain,
      this.turnLeft,
      this.turnRight,
      this.turnUp,
      this.turnDown,
      this.lookStraight,
      this.mainGuideVisibility,
      this.secondaryGuideVisibility});

  Map toJson() {
    return {
      "poseCount": poseCount,
      "animationDuration": animationDuration,
      "faceNotInside": faceNotInside,
      "faceNotStraight": faceNotStraight,
      "faceIsTooFar": faceIsTooFar,
      "holdPhoneVertically": holdPhoneVertically,
      "alertTitle": alertTitle,
      "alertDescription": alertDescription,
      "alertTryAgain": alertTryAgain,
      "turnLeft": turnLeft,
      "turnRight": turnRight,
      "turnUp": turnUp,
      "turnDown": turnDown,
      "lookStraight": lookStraight,
      "mainGuideVisibility": mainGuideVisibility,
      "secondaryGuideVisibility": secondaryGuideVisibility,
    };
  }
}
