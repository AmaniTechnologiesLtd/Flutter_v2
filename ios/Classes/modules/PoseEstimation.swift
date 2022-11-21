//
//  PoseEstimation.swift
//  flutter_amanisdk_v2
//
//  Created by Deniz Can on 14.11.2022.
//

import AmaniSDK
import Flutter
import UIKit

@available(iOS 12.0, *)
class PoseEstimation {
  private let module = Amani.sharedInstance.poseEstimation()
  private var moduleView: UIView!
  
  public func start(settings: PoseEstimationSettings, result: @escaping FlutterResult) {
    let vc = UIApplication.shared.windows.last?.rootViewController
    module.setScreenConfig(screenConfig: [
      .appBackgroundColor: settings.appBackgroundColor,
      .appFontColor: settings.appFontColor,
      .primaryButtonBackgroundColor: settings.primaryButtonBackgroundColor,
      .primaryButtonTextColor: settings.primaryButtonTextColor,
      .ovalBorderColor: settings.ovalBorderColor,
      .ovalBorderSuccessColor: settings.ovalBorderSuccessColor,
      .poseCount: settings.poseCount,
    ])
    
    module.setInfoMessages(infoMessages: [
      .faceIsOk: settings.faceIsOk,
      .notInArea: settings.notInArea,
      .faceTooSmall: settings.faceTooSmall,
      .faceTooBig: settings.faceTooBig,
      .completed: settings.completed,
      .turnedRight: settings.turnedRight,
      .turnedLeft: settings.turnedLeft,
      .turnedUp: settings.turnedUp,
      .turnedDown: settings.turnedDown,
      .straightFace: settings.straightMessage,
      .errorMessage: settings.errorMessage,
      .sonraki: settings.next,
      .tekrarDene: settings.tryAgain,
      .errorTitle: settings.errorTitle,
      .informationScreenDesc1: settings.informationScreenDesc1,
      .informationScreenDesc2: settings.informationScreenDesc2,
      .informationScreenTitle: settings.informationScreenTitle,
      .wrongPose: settings.wrongPose,
      .descriptionHeader: settings.descriptionHeader,
    ])
    
    module.setManualCropTimeout(Timeout: settings.manualCropTimeout)
    
    do {
      moduleView = try module.start { [weak self] image in
        guard let self = self else {return}
        
        let data = image.pngData()
        result(FlutterStandardTypedData(bytes: data!))
        
        DispatchQueue.main.async {
          self.moduleView.removeFromSuperview()
        }
      }
      
      DispatchQueue.main.async {
        vc?.view.addSubview(self.moduleView)
        vc?.view.bringSubviewToFront(self.moduleView)
        vc?.navigationController?.setNavigationBarHidden(true, animated: false)
      }
    } catch let err {
      result(FlutterError(code: "ModuleError", message: err.localizedDescription, details: nil))
    }
  }
  
  public func setType(type: String, result: @escaping FlutterResult) {
    module.setType(type: type)
    result(nil)
  }
  
  public func upload(result: @escaping FlutterResult) {
    module.upload { (isSuccess, error) in
      if let error = error {
        result(FlutterError(code: "UploadError", message: error.first?.error_message, details: nil))
      } else {
        result(isSuccess)
      }
    }
  }
  
}
