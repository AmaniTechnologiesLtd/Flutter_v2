class AndroidPoseEstimationSettings {
  int? poseCount;
  int? animationDuration;
  String? faceNotInside;
  String? faceNotStraight;
  String? faceTooFar;
  String? keepStraight;
  String? alertTitle;
  String? alertDescription;
  String? alertTryAgain;
  bool? mainGuideVisibility;
  bool? secondaryGuideVisibility;

  AndroidPoseEstimationSettings(
      {this.poseCount,
      this.animationDuration,
      this.faceNotInside,
      this.faceNotStraight,
      this.keepStraight,
      this.alertTitle,
      this.alertDescription,
      this.alertTryAgain,
      this.mainGuideVisibility,
      this.secondaryGuideVisibility});

  Map toJson() {
    return {
      "poseCount": poseCount,
      "animationDuration": animationDuration,
      "faceNotInside": faceNotInside,
      "faceNotStraight": faceNotStraight,
      "keepStraight": keepStraight,
      "alertTitle": alertTitle,
      "alertDescription": alertDescription,
      "alertTryAgain": alertTryAgain,
      "mainGuideVisibility": mainGuideVisibility,
      "secondaryGuideVisibility": secondaryGuideVisibility,
    };
  }
}
