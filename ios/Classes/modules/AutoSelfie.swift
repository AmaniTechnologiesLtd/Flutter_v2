//
//  AutoSelfie.swift
//  flutter_amanisdk_v2
//
//  Created by Deniz Can on 14.11.2022.
//

import Foundation
import Flutter
import AmaniSDK

class AutoSelfie {
  private let module = Amani.sharedInstance.autoSelfie()
  private var sdkView: SDKView!
  
  func start(settings: AutoSelfieSettings, result: @escaping FlutterResult) {
    let vc = UIApplication.shared.windows.last?.rootViewController
    
    module.setInfoMessages(infoMessages: [
      .faceTooBig: settings.faceTooBig,
      .faceTooSmall: settings.faceTooSmall,
      .notInArea: settings.notInArea,
      .completed: settings.completed,
      .faceIsOk: settings.faceIsOk,
    ])
    
    module.setScreenConfig(screenConfig: [
      .appBackgroundColor: settings.appBackgroundColor,
      .appFontColor: settings.appFontColor,
      .ovalBorderColor: settings.ovalBorderColor,
      .ovalBorderSuccessColor: settings.ovalBorderSuccessColor,
      .countTimer: settings.countTimer,
    ])
    
    do {
      let moduleView = try module.start { image in
        let data = image.pngData()
        result(FlutterStandardTypedData(bytes: data!))
        DispatchQueue.main.async {
          self.sdkView.removeFromSuperview()
        }
      }
      
      sdkView = SDKView(sdkView: moduleView!)
      sdkView.start(on: vc!)
      sdkView.setupBackButton(on: moduleView!)
    } catch let err {
      result(FlutterError(code: "30007", message: err.localizedDescription, details: nil))
    }
    
  }
  
  public func setType(type: String, result: @escaping FlutterResult) {
    module.setType(type: type)
    result(nil)
  }
  
  public func upload(result: @escaping FlutterResult) {
    module.upload { (isSuccess, error) in
      if let error = error {
        result(FlutterError(code: String(error.first!.error_code), message: error.first?.error_message, details: nil))
      } else {
        result(isSuccess)
      }
    }
  }
  
}
