//
//  AmaniSDKStreamHandler.swift
//  flutter_amanisdk
//
//  Created by Deniz Can on 18.01.2024.
//

import Foundation
import Flutter
import AmaniSDK

class DelegateEventHandler: NSObject, FlutterStreamHandler {
  private var eventSink: FlutterEventSink?
  
  func onListen(withArguments arguments: Any?, eventSink events: @escaping FlutterEventSink) -> FlutterError? {
    self.eventSink = events
    return nil
  }
  
  func onCancel(withArguments arguments: Any?) -> FlutterError? {
    eventSink = nil
    return nil
  }
}

extension DelegateEventHandler: AmaniDelegate {
  public func onProfileStatus(customerId: String, profile: AmaniSDK.wsProfileStatusModel) {
    do {
      let jsonData = try JSONEncoder().encode(profile)
      eventSink?(["type": "profileStatus", "data": String(data: jsonData, encoding: .utf8)])
    } catch {
      eventSink?(["type": "error", "data": ["type": "JSONConversation", "errors": ["error_code": "30011", "error_message": "\(error.localizedDescription)"]] as [String: Any]])
    }
  }
  
  public func onStepModel(customerId: String, rules: [AmaniSDK.KYCRuleModel]?) {
    do {
      let jsonData = try JSONEncoder().encode(["rules": rules])
      eventSink?(["type": "stepModel", "data": String(data: jsonData, encoding: .utf8)])
    } catch {
      eventSink?(["type": "error", "data": ["type": "JSONConversation", "errors": ["error_code": "30011", "error_message": "\(error.localizedDescription)"]] as [String: Any]])
    }
  }
  
  public func onError(type: String, error: [AmaniSDK.AmaniError]) {
    do {
      let jsonData = try JSONEncoder().encode(error)
      let jsonString = String(data: jsonData, encoding: .utf8)
      let returnJsonString = try JSONEncoder().encode(["errorType": type, "errors": jsonString])
      eventSink?(["type": "error", "data": String(data: returnJsonString, encoding: .utf8)])
    } catch {
      eventSink?(["type": "error", "data": ["type": "JSONConversation", "errors": ["error_code": "30011", "error_message": "\(error.localizedDescription)"]] as [String: Any]])
    }
    
  }
}
extension DelegateEventHandler: mrzInfoDelegate {
   public func mrzInfo(_ mrz: AmaniSDK.MrzModel?, documentId: String?) {
       guard let mrz = mrz else {
        eventSink?(["type": "error", "data": ["type": "JSONConversion", "errors": ["error_code": "30022", "error_message": "mrz model is nil"]] as [String: Any]])
        return
    }

    let nviData = AmaniSDK.NviModel(mrzModel: mrz)
    if nviData != nil {
        eventSink?(["type": "mrzInfoDelegate", "data": String(describing: mrz)])
    } else {
        eventSink?(["type": "error", "data": ["type": "JSONConversion", "errors": ["error_code": "30021", "error_message": "Nvi model parsing error"]] as [String: Any]])
    }
   }
}