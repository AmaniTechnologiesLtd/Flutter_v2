//
//  NFC.swift
//  flutter_amanisdk_v2
//
//  Created by Deniz Can on 14.11.2022.
//

import AmaniSDK
import Flutter
import UIKit

@available(iOS 13, *)
class NFC {
  private let module = Amani.sharedInstance.scanNFC()
  private var moduleView: UIView!

  func start(imageData: FlutterStandardTypedData, result: @escaping FlutterResult) {
    module.start(imageBase64: imageData.data.base64EncodedString()) { (_, err) in
      if let err = err {
        result(FlutterError(code: String(err.error_code), message: err.error_message, details: nil))
      } else {
        result(true)
      }
    }
    
  }

  func start(nviData: NviModel, result: @escaping FlutterResult) {
    do {
      try module.start(nviData: nviData) { _, err in
        if let err = err {
          result(FlutterError(code: String(err.error_code), message: err.error_message, details: nil))
        } else {
          result(true)
        }
      }

    } catch let err {
      result(FlutterError(code: "30007", message: err.localizedDescription, details: nil))
    }
  }

  func start(result: @escaping FlutterResult) {
    let vc = UIApplication.shared.windows.last?.rootViewController

    moduleView = module.start { _, err in
      if let err = err {
        result(FlutterError(code: String(err.error_code), message: err.error_message, details: nil))
      } else {
        result(true)
      }

      DispatchQueue.main.async {
        vc!.view.addSubview(self.moduleView)
        vc!.view.bringSubviewToFront(self.moduleView)
        vc!.navigationController?.setNavigationBarHidden(true, animated: false)
      }
    }
  }
  
  func setType(type: String, result: @escaping FlutterResult) {
    module.setType(type: type)
    result(nil)
  }
  
  func upload(result: @escaping FlutterResult) {
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
  
}
