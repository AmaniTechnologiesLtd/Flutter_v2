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
    private var moduleView: UIView!
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
            .showOnlyArrow: settings.showOnlyArrow,
            .buttonRadius: settings.buttonRadious,
        ])
        module.setPoseEstimationMessages(infoMessages: [
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
            .errorTitle: settings.errorTitle,
            .confirm: settings.confirm,
            .sonraki: settings.next,
            .phonePitch: settings.phonePitch,
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
        if let error = error {
          result(FlutterError(code: "UploadError", message: error.first?.error_message, details: nil))
        } else {
          result(isSuccess)
        }
      }
    }
    
    private func startModule(result: @escaping FlutterResult) {
        do {
            moduleView = try module.start { image in
                let data = image.pngData()!
                result(FlutterStandardTypedData(bytes: data))
                DispatchQueue.main.async {
                    self.moduleView.removeFromSuperview()
                }
            }
            
            DispatchQueue.main.async {
                self.vc!.view.addSubview(self.moduleView)
                self.vc!.view.bringSubviewToFront(self.moduleView)
                self.vc!.navigationController?.setNavigationBarHidden(true, animated: false)
            }
            
        } catch let err {
            result(FlutterError(code: "ModuleError", message: err.localizedDescription, details: nil))
        }
    }
    
}
