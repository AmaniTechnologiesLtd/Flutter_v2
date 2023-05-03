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
      .mainGuideVisibility: settings.mainGuideVisibility,
      .secondaryGuideVisibility: settings.secondaryGuideVisibility,
    ])

    module.setInfoMessages(infoMessages: [
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
      .next: settings.next,
      .tryAgain: settings.tryAgain,
      .errorTitle: settings.errorTitle,
      .informationScreenDesc1: settings.informationScreenDesc1,
      .informationScreenDesc2: settings.informationScreenDesc2,
      .informationScreenTitle: settings.informationScreenTitle,
      .wrongPose: settings.wrongPose,
      .descriptionHeader: settings.descriptionHeader,
    ])

    if
    let mainGuideUp = settings.mainGuideUp,
    let mainGuideDown = settings.mainGuideDown,
    let mainGuideLeft = settings.mainGuideLeft,
    let mainGuideRight = settings.mainGuideRight,
    let mainGuideStraight = settings.mainGuideStraight {
      module.setMainGuideImages(guideImages: [
        .mainGuideUp: UIImage(named: mainGuideUp)!,
        .mainGuideDown: UIImage(named: mainGuideDown)!,
        .mainGuideLeft: UIImage(named: mainGuideLeft)!,
        .mainGuideRight: UIImage(named: mainGuideRight)!,
        .mainGuideStraight: UIImage(named: mainGuideStraight)!,
      ])
    }
    
    if
    let secondaryGuideUp = settings.secondaryGuideUp,
    let secondaryGuideDown = settings.secondaryGuideDown,
    let secondaryGuideLeft = settings.secondaryGuideLeft,
    let secondaryGuideRight = settings.secondaryGuideRight
    {
      module.setSecondaryGuideImages(guideImages: [
        .secondaryGuideUp: UIImage(named: secondaryGuideUp)!,
        .secondaryGuideDown: UIImage(named: secondaryGuideDown)!,
        .secondaryGuideLeft: UIImage(named: secondaryGuideLeft)!,
        .secondaryGuideRight: UIImage(named: secondaryGuideRight)!,
      ])
    }

    module.setManualCropTimeout(Timeout: settings.manualCropTimeout)

    do {
      moduleView = try module.start { [weak self] image in
        guard let self = self else { return }

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
    module.upload { isSuccess, error in
      if let error = error {
        result(FlutterError(code: "UploadError", message: error.first?.error_message, details: nil))
      } else {
        result(isSuccess)
      }
    }
  }
}
