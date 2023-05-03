//
//  PoseEstimationSettings.swift
//  flutter_amanisdk_v2
//
//  Created by Deniz Can on 14.11.2022.
//

struct PoseEstimationSettings: Codable {
  // info messages
  var faceIsOk: String = "Lütfen sabit durun."
  var notInArea: String = "Yüzünüzü daire içine hizalayın"
  var faceTooSmall: String = "Yüzünüz çok uzakta"
  var faceTooBig: String = "Yüzünüz çok yakında"
  var completed: String = "İşlem Tamam"
  var turnRight: String = "→"
  var turnLeft: String = "←"
  var turnUp: String = "↑"
  var turnDown: String = "↓"
  var lookStraight: String = "düz bak"
  var errorMessage: String = "Lütfen adımları dairenin içinden çıkmadan gerçekleştirin"
  var tryAgain: String = "Tekrar Dene"
  var errorTitle: String = "Başarısız"
  var confirm: String = "Onayla"
  var next: String = "Sonraki"
  var holdPhoneVertically: String = "Telefonu düz tutun"
  var informationScreenDesc1: String = "Doğrulamaya başlamak için, yüzünü alanın içinde tut"
  var informationScreenDesc2: String = ""
  var informationScreenTitle: String = "Selfie Doğrulama Talimatları"
  var wrongPose: String = "Yüzün düz konumda olmalı"
  var descriptionHeader: String = "Lütfen telefonu dik tutun ve yüzünü belirtilen alana hizalamaya özen göster"
  // screen config
  var appBackgroundColor: String = "000000"
  var appFontColor: String = "ffffff"
  var primaryButtonBackgroundColor: String = "ffffff"
  var primaryButtonTextColor: String = ""
  var ovalBorderColor: String = "ffffff"
  var ovalBorderSuccessColor: String = "00ff00"
  var poseCount: String = "3"
  var mainGuideVisibility: String = "true"
  var secondaryGuideVisibility: String = "false"
  var buttonRadious: String = "10"
  
  
  var mainGuideUp: String?
  var mainGuideDown: String?
  var mainGuideLeft: String?
  var mainGuideRight: String?
  var mainGuideStraight: String?
 
  var secondaryGuideUp: String?
  var secondaryGuideDown: String?
  var secondaryGuideLeft: String?
  var secondaryGuideRight: String?
  
  var manualCropTimeout: Int = 30
}
