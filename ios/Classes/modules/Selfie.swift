//
//  Selfie.swift
//  flutter_amanisdk_v2
//
//  Created by Deniz Can on 14.11.2022.
//

import AmaniSDK
import UIKit
import Flutter

class Selfie {
  private let module = Amani.sharedInstance.selfie()
  private var moduleView: UIView!
  
  public func start(result: @escaping FlutterResult) {
    let vc = UIApplication.shared.windows.last?.rootViewController
    do {
      moduleView = try module.start { image in
        let data = image.pngData()
        result(FlutterStandardTypedData(bytes: data!))
        DispatchQueue.main.async {
          self.moduleView.removeFromSuperview()
        }
      }
      
      DispatchQueue.main.async {
        vc!.view.addSubview(self.moduleView)
        vc!.view.bringSubviewToFront(self.moduleView)
        vc!.navigationController?.setNavigationBarHidden(true, animated: false)
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
