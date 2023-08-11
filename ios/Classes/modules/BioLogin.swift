//
//  BioLogin.swift
//  flutter_amanisdk_v2
//
//  Created by Deniz Can on 22.11.2022.
//
import AmaniSDK
import UIKit
import Flutter

class BioLogin {
    private let vc = UIApplication.shared.windows.last?.rootViewController!
    private let module = Amani.sharedInstance.bioLogin()
    private var sdkView: SDKView!
    private var customerId: String!
    private var attemptId: String!
    private var source = 3
    private var comparison_adapter = 2
    private var server: String!
    private var token: String!
    
    // Locking the initializer
    private init() {}
    
    public static let shared = BioLogin()
    
    public func initBioLogin(server: String, token: String, customerId: String, attemptId: String, source: Int?, comparisonAdapter: Int?, result: @escaping FlutterResult) {
        self.customerId = String(customerId)
        self.source = source ?? self.source
        self.comparison_adapter = comparisonAdapter ?? self.comparison_adapter
        self.server = server
        self.token = token
        self.attemptId = attemptId
        
        module.setParams(server: server, token: token, customer_id: customerId, source: source ?? 3, comparison_adapter: comparisonAdapter ?? 2, attempt_id: attemptId)
        result(nil)
    }
    
    
    public func startWithAutoSelfie(settings: AutoSelfieSettings, result: @escaping FlutterResult) {
        module.setParams(server: server, token: token, customer_id: customerId, source: source, comparison_adapter: comparison_adapter, attempt_id: attemptId, biologintype: .autoSelfie)
        module.setSelfieMessages(key: .faceIsOk, value: settings.faceIsOk)
        module.setSelfieMessages(key: .notInArea, value: settings.notInArea)
        module.setSelfieMessages(key: .faceTooBig, value: settings.faceTooBig)
        module.setSelfieMessages(key: .faceTooSmall, value: settings.faceTooSmall)
        module.setSelfieMessages(key: .completed, value: settings.completed)
        
        module.setSelfieColor(key: .appBackgroundColor, value: settings.appBackgroundColor)
        module.setSelfieColor(key: .appFontColor, value: settings.appFontColor)
        module.setSelfieColor(key: .primaryButtonBackgroundColor, value: settings.primaryButtonBackgroundColor)
        module.setSelfieColor(key: .ovalBorderSuccessColor, value: settings.ovalBorderSuccessColor)
        module.setSelfieColor(key: .ovalBorderColor, value: settings.ovalBorderColor)
        module.setSelfieColor(key: .countTimer, value: settings.countTimer)
        
        startModule(result: result)
    }
    
    public func startWithPoseEstimation(settings: PoseEstimationSettings, result: @escaping FlutterResult) {
        module.setParams(server: server, token: token, customer_id: customerId, source: source, comparison_adapter: comparison_adapter, attempt_id: attemptId, biologintype: .poseEstimation)
        module.setPoseEstimationColors(screenConfig: [
            .appBackgroundColor: settings.appBackgroundColor,
            .appFontColor: settings.appFontColor,
            .primaryButtonBackgroundColor: settings.primaryButtonBackgroundColor,
            .primaryButtonTextColor: settings.primaryButtonTextColor,
            .ovalBorderColor: settings.ovalBorderColor,
            .ovalBorderSuccessColor: settings.ovalBorderSuccessColor,
            .poseCount: settings.poseCount,
            .mainGuideVisibility: settings.mainGuideVisibility,
            .secondaryGuideVisibility: settings.secondaryGuideVisibility,
            .buttonRadius: settings.buttonRadious,
        ])
        module.setPoseEstimationMessages(infoMessages: [
            .faceIsOk: settings.faceIsOk,
            .notInArea: settings.notInArea,
            .faceTooSmall: settings.faceTooSmall,
            .faceTooBig: settings.faceTooBig,
            .completed: settings.completed,
            .turnRight: settings.turnRight,
            .turnLeft: settings.turnLeft,
            .turnUp: settings.turnUp,
            .turnDown: settings.turnDown,
            .lookStraight: settings.lookStraight,
            .errorMessage: settings.errorMessage,
            .errorTitle: settings.errorTitle,
            .confirm: settings.confirm,
            .next: settings.next,
            .holdPhoneVertically: settings.holdPhoneVertically,
            .informationScreenDesc1: settings.informationScreenDesc1,
            .informationScreenDesc2: settings.informationScreenDesc2,
            .informationScreenTitle: settings.informationScreenTitle,
            .wrongPose: settings.wrongPose,
            .descriptionHeader: settings.descriptionHeader
        ])
  
        startModule(result: result)
    }
    
    public func startWithManualSelfie(result: @escaping FlutterResult) {
        module.setParams(server: server, token: token, customer_id: customerId, source: source, comparison_adapter: comparison_adapter, attempt_id: attemptId, biologintype: .manualSelfie)
        startModule(result: result)
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
    
    private func startModule(result: @escaping FlutterResult) {
        do {
            let moduleView = try module.start { image in
                let data = image.pngData()!
                result(FlutterStandardTypedData(bytes: data))
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
    
}
