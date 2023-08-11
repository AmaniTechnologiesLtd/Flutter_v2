//
//  IdCapture.swift
//  flutter_amanisdk_v2
//
//  Created by Deniz Can on 14.11.2022.
//

import AmaniSDK
import Flutter
import UIKit

class IdCapture {
  private let module = Amani.sharedInstance.IdCapture()
  private var sdkView: SDKView!
  
  public func start(stepID: Int, result: @escaping FlutterResult) {
    let vc = UIApplication.shared.windows.last?.rootViewController
    do {
       let moduleView = try module.start(stepId: stepID) { image in
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
  
  @available(iOS 13, *)
  public func startNFC(result: @escaping FlutterResult) {
    module.startNFC { done in
      result(done)
    }
  }
  
  public func setType(type: String, result: @escaping FlutterResult) {
    module.setType(type: type)
    result(nil)
  }
  
  public func upload(result: @escaping FlutterResult) {
    module.upload { (isSuccess, error) in
      if let success = isSuccess, success {
        result(success)
      } else {
        if let error = error {
          let errorsDict = error.map {
            $0.toDictionary()
          }
          result(FlutterError(code: "30010", message: "Upload result errors", details: errorsDict))
        } else {
          result(FlutterError(code: "30011", message: "Upload result returning with nil value", details: nil))
        }
      }
    }
  }
  
  public func setManualCaptureButtonTimeout(timeout: Int, result: @escaping FlutterResult) {
    module.setManualCropTimeout(Timeout: timeout)
    result(nil)
  }
  
}

