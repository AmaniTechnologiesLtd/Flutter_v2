class IOSAutoSelfieSettings {
  // info messages
  String? faceIsOk;
  String? notInArea;
  String? faceTooSmall;
  String? faceTooBig;
  String? completed;
  // screen config
  String? appBackgroundColor;
  String? appFontColor;
  String? primaryButtonBackgroundColor;
  String? ovalBorderSuccessColor;
  String? ovalBorderColor;
  String? countTimer;
  int? manualCropTimeout;

  IOSAutoSelfieSettings(
      {this.faceIsOk,
      this.notInArea,
      this.faceTooSmall,
      this.faceTooBig,
      this.completed,
      this.appBackgroundColor,
      this.appFontColor,
      this.primaryButtonBackgroundColor,
      this.ovalBorderColor,
      this.ovalBorderSuccessColor,
      this.countTimer,
      this.manualCropTimeout});

  Map toJson() {
    return {
      "faceIsOk": faceIsOk,
      "notInArea": notInArea,
      "faceTooSmall": faceTooSmall,
      "faceTooBig": faceTooBig,
      "completed": completed,
      "appBackgroundColor": appBackgroundColor,
      "appFontColor": appFontColor,
      "primaryButtonBackgroundColor": primaryButtonBackgroundColor,
      "ovalBorderSuccessColor": ovalBorderSuccessColor,
      "ovalBorderColor": ovalBorderColor,
      "countTimer": countTimer,
      "manualCropTimeout": manualCropTimeout,
    };
  }
}
