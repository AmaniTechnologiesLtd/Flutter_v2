//
//  DelegateOnErrorModel.swift
//  flutter_amanisdk_v2
//
//  Created by Deniz Can on 28.08.2023.
//

import Foundation
import AmaniSDK

struct DelegateOnErrorModel: Codable {
  let type: String
  let errors: [AmaniError]
}
