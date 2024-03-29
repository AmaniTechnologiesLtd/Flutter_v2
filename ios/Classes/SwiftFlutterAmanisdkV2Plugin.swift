import AmaniSDK
import Flutter

public class SwiftFlutterAmanisdkV2Plugin: NSObject, FlutterPlugin {
    
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "amanisdk_method_channel", binaryMessenger: registrar.messenger())
    let instance = SwiftFlutterAmanisdkV2Plugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    let arguments = call.arguments as? [String: Any]
    switch call.method {
    case "initAmani":
      let server = arguments?["server"] as! String
      let customerIdCardNumber = arguments?["customerIdCardNumber"] as! String
      let customerToken = arguments?["customerToken"] as! String
      let lang = arguments?["lang"] as! String
      let useLocation = arguments?["useLocation"] as! Bool
      let sharedSecret = arguments?["sharedSecret"] as? String
     initAmani(server: server, customerIdCardNumber: customerIdCardNumber, customerToken: customerToken, useLocation: useLocation, lang: lang , sharedSecret: sharedSecret, result: result)
    case "initAmaniWithEmail":
      let server = arguments?["server"] as! String
      let customerIdCardNumber = arguments?["customerIdCardNumber"] as! String
      let email = arguments?["email"] as! String
      let password = arguments?["password"] as! String
      let lang = arguments?["lang"] as! String
      let useLocation = arguments?["useLocation"] as! Bool
      let sharedSecret = arguments?["sharedSecret"] as? String
      initAmaniWithEmail(server: server, customerIdCardNumber: customerIdCardNumber, email: email, password: password, useLocation: useLocation, lang: lang, sharedSecret: sharedSecret, result: result)
    // ID Capture
    case "setIDCaptureType":
      let idCapture = IdCapture()
      let type = arguments?["type"] as! String
      idCapture.setType(type: type, result: result)
    case "startIDCapture":
      let idCapture = IdCapture()
      let stepID = arguments?["stepID"] as? Int
      idCapture.start(stepID: stepID ?? 0, result: result)
    case "setIDCaptureManualButtonTimeout":
      let idCapture = IdCapture()
      let timeout = arguments?["timeout"] as! Int
      idCapture.setManualCaptureButtonTimeout(timeout: timeout, result: result)
    case "iosIDCaptureNFC":
      let idCapture = IdCapture()
      if #available(iOS 13, *) {
        idCapture.startNFC(result: result)
      } else {
        result(FlutterError(code: "30008", message: "NFC Requires iOS 13 or newer", details: nil))
      }
    case "uploadIDCapture":
      let idCapture = IdCapture()
      idCapture.upload(result: result)
    // Selfie
    case "setSelfieType":
      let selfie = Selfie()
      let type = arguments?["type"] as! String
      selfie.setType(type: type, result: result)
    case "startSelfie":
      let selfie = Selfie()
      selfie.start(result: result)
    case "uploadSelfie":
      let selfie = Selfie()
      selfie.upload(result: result)
    // AutoSelfie
    case "startAutoSelfie":
      let autoSelfie = AutoSelfie()
      let decoder = JSONDecoder()
      let iosArgs = arguments?["iosSettings"] as! String
      let autoSelfieSettings = try! decoder.decode(AutoSelfieSettings.self, from: Data(iosArgs.utf8))
      autoSelfie.start(settings: autoSelfieSettings, result: result)
    case "setAutoSelfieType":
      let autoSelfie = AutoSelfie()
      let type = arguments?["type"] as! String
      autoSelfie.setType(type: type, result: result)
    case "uploadAutoSelfie":
      let autoSelfie = AutoSelfie()
      autoSelfie.upload(result: result)
    // Pose Estimation
    case "startPoseEstimation":
      if #available(iOS 12.0, *) {
        let poseEstimation = PoseEstimation()
        let iosArgs = arguments?["iosSettings"] as! String
        let decoder = JSONDecoder()
        let poseEstimationSettings = try! decoder.decode(PoseEstimationSettings.self, from: Data(iosArgs.utf8))
        poseEstimation.start(settings: poseEstimationSettings, result: result)
      } else {
        result(FlutterError(code: "30008", message: "Pose estimation is only avaible after iOS 12.0", details: nil))
      }
    case "setPoseEstimationType":
      if #available(iOS 12.0, *) {
        let poseEstimation = PoseEstimation()
        let type = arguments?["type"] as! String
        poseEstimation.setType(type: type, result: result)
      } else {
        result(FlutterError(code: "30008", message: "Pose estimation is only avaible after iOS 12.0", details: nil))
      }
    case "uploadPoseEstimation":
      if #available(iOS 12.0, *) {
        let poseEstimation = PoseEstimation()
        poseEstimation.upload(result: result)
      } else {
        result(FlutterError(code: "30008", message: "Pose estimation is only avaible after iOS 12.0", details: nil))
      }
    // NFC
    case "iOSstartNFCWithImageData":
      if #available(iOS 13.0, *) {
        let nfc = NFC()
        let imageData = arguments?["imageData"] as! FlutterStandardTypedData
        nfc.start(imageData: imageData, result: result)
      } else {
        result(FlutterError(code: "30008", message: "NFC Scan is only avaible after iOS 13.0", details: nil))
      }
    case "iOSstartNFCWithNviModel":
      if #available(iOS 13.0, *) {
        let nfc = NFC()
        let nviData = arguments?["nviData"] as! [String: String]
        let nviModel = NviModel(documentNo: nviData["documentNo"]!, dateOfBirth: nviData["dateOfBirth"]!, dateOfExpire: nviData["dateOfExpire"]!)
        nfc.start(nviData: nviModel, result: result)
      } else {
        result(FlutterError(code: "30008", message: "NFC Scan is only avaible after iOS 13.0", details: nil))
      }
    case "iOSstartNFCWithMRZCapture":
      if #available(iOS 13.0, *) {
        let nfc = NFC()
        nfc.start(result: result)
      } else {
        result(FlutterError(code: "30008", message: "NFC Scan is only avaible after iOS 13.0", details: nil))
      }
    case "iOSsetNFCType":
      if #available(iOS 13.0, *) {
        let nfc = NFC()
        let type = arguments?["type"] as! String
        nfc.setType(type: type, result: result)
      } else {
        result(FlutterError(code: "30008", message: "NFC Scan is only avaible after iOS 13.0", details: nil))
      }
    case "iOSuploadNFC":
      if #available(iOS 13.0, *) {
        let nfc = NFC()
        nfc.upload(result: result)
      } else {
        result(FlutterError(code: "30008", message: "NFC Scan is only avaible after iOS 13.0", details: nil))
      }
    case "initBioLogin":
        let bioLogin = BioLogin.shared
        bioLogin.initBioLogin(server: arguments!["server"] as! String,
                              token: arguments!["token"] as! String,
                              customerId: arguments!["customerId"] as! String,
                              attemptId: arguments!["attemptId"] as! String,
                              source: arguments!["source"] as? Int,
                              comparisonAdapter: arguments!["comparisonAdapter"] as? Int,
                              result: result)
    case "startBioLoginWithAutoSelfie":
        let bioLogin = BioLogin.shared
        let decoder = JSONDecoder()
        let iosArgs = arguments?["iosSettings"] as! String
        let autoSelfieSettings = try! decoder.decode(AutoSelfieSettings.self, from: Data(iosArgs.utf8))
        bioLogin.startWithAutoSelfie(settings: autoSelfieSettings, result: result)
    case "startBioLoginWithPoseEstimation":
        let bioLogin = BioLogin.shared
        let decoder = JSONDecoder()
        let iosArgs = arguments!["iosSettings"] as! String
        let poseEstimationSettings = try! decoder.decode(PoseEstimationSettings.self, from: Data(iosArgs.utf8))
        bioLogin.startWithPoseEstimation(settings: poseEstimationSettings, result: result)
    case "startBioLoginWithManualSelfie":
        let bioLogin = BioLogin.shared
        bioLogin.startWithManualSelfie(result: result)
    case "uploadBioLogin":
        let bioLogin = BioLogin.shared
        bioLogin.upload(result: result)
    case "getCustomerInfo":
        getCustomerInfo(result: result)
    default:
      result(FlutterMethodNotImplemented)
    }
  }

  private func initAmani(server: String,
                         customerIdCardNumber: String,
                         customerToken: String,
                         useLocation: Bool,
                         lang: String,
                         sharedSecret: String?,
                         result: @escaping FlutterResult) {
    let customer = CustomerRequestModel(name: nil, email: nil, phone: nil, idCardNumber: customerIdCardNumber)
    Amani.sharedInstance.initAmani(server: server, token: customerToken, customer: customer, useGeoLocation: useLocation, language: lang) { customerRes, err in
      if customerRes != nil {
        result(true)
      } else if let err = err {
        result(FlutterError(code: String(err.error_code), message: "Couldn't login to Amani server", details: err.error_message))
      }
    }
  }
  private func initAmaniWithEmail(
                        server: String,
                        customerIdCardNumber: String,
                        email: String,
                        password: String,
                        useLocation: Bool,
                        lang: String,
                        sharedSecret: String?,
                        result: @escaping FlutterResult) {
    let customer = CustomerRequestModel(name: "", email: "", phone: "", idCardNumber: customerIdCardNumber)
    Amani.sharedInstance.initAmani(server: server, userName: email, password: password, customer: customer, useGeoLocation: useLocation, language: lang) { customerRes, err in
      if customerRes != nil {
        result(true)
      } else if let err = err {
        result(FlutterError(code: String(err.error_code), message: "Couldn't login to Amani server", details: err.error_message))
      }
    }
  }
    private func getCustomerInfo(result: @escaping FlutterResult) {
     Amani.sharedInstance.customerInfo().getCustomer(forceUpdateCallback: {
        info, error in
        guard let customerInfo = info else {
          return
        }
        var rulesArray: [[String: Any]] = []
        if let rules = customerInfo.rules {
            for rule in rules {
                rulesArray.append(["id": rule.id as Any, "title": rule.title as Any, "documentClasses": rule.documentClasses as Any, "status": rule.status as Any])
            }
        }
        
        var missingRulesArray: [[String: Any]] = []
        if let missingRules = customerInfo.missingRules {
            for rule in missingRules {
                missingRulesArray.append(["id": rule.id as Any, "title": rule.title as Any, "documentClasses": rule.documentClasses as Any, "status": rule.status as Any])
            }
        }
        
        let customerInfoDict: [String: Any] = [
            "id": customerInfo.id as Any,
            "name": customerInfo.name as Any,
            "email": customerInfo.email as Any,
            "phone": customerInfo.phone as Any,
            "companyID": customerInfo.companyID as Any,
            "status": customerInfo.status as Any,
            "occupation": customerInfo.occupation as Any,
            "city": customerInfo.address?.city as Any,
            "address": customerInfo.address?.address as Any,
            "province": customerInfo.address?.province as Any,
            "rules": rulesArray,
            "missingRules": missingRulesArray,
        ]
        
        result(customerInfoDict)
      })
  }
    
}
