

enum AmaniAndroidDynamicFeature {
  idCapture,
  idHologramDetection,
  nfcScan,
  selfieAuto,
  selfiePoseEstimation,
}

enum AmaniUploadSource { kyc, video, password }

extension AmaniUploadSourceExtension on AmaniUploadSource {
  String get getUploadSourceString {
    switch (this) {
      case AmaniUploadSource.kyc:
        return "KYC";
      case AmaniUploadSource.video:
        return "VIDEO";
      case AmaniUploadSource.password:
        return "PASSWORD";
    }
  }
}