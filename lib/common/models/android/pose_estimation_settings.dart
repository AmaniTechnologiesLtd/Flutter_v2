class AndroidPoseEstimationSettings {
  int? poseCount;
  int? animationDuration;
  String? faceNotInsideMessage;
  String? faceNotStraightMessage;
  String? faceTooFarMessage;
  String? keepStraightMessage;
  String? alertTitle;
  String? alertDescription;
  String? alertTryAgainMessage;

  AndroidPoseEstimationSettings({
    this.poseCount,
    this.animationDuration,
    this.faceNotInsideMessage,
    this.faceNotStraightMessage,
    this.keepStraightMessage,
    this.alertTitle,
    this.alertDescription,
    this.alertTryAgainMessage,
  });

  Map toJson() {
    return {
      "poseCount": poseCount,
      "animationDuration": animationDuration,
      "faceNotInsideMessage": faceNotInsideMessage,
      "faceNotStraightMessage": faceNotStraightMessage,
      "keepStraightMessage": keepStraightMessage,
      "alertTitle": alertTitle,
      "alertDescription": alertDescription,
      "alertTryAgainMessage": alertTryAgainMessage
    };
  }
}
