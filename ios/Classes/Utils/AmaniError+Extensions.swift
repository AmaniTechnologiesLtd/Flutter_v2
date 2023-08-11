//
//  AmaniError+Extensions.swift
//  flutter_amanisdk_v2
//
//  Created by Deniz Can on 11.08.2023.
//

import Foundation
import AmaniSDK

extension AmaniError {
  
  func toDictionary() -> [String: Any] {
    return [
      "error_code": self.error_code as Int,
      "error_message": self.error_message as Any
    ]
  }
  
}
