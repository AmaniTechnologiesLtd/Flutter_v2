//
//  ImageProvider.swift
//  flutter_amanisdk_v2
//
//  Created by Deniz Can on 15.05.2023.
//

import Foundation
public class ImageProvider {
  public static func image(named: String) -> UIImage? {
    return UIImage(named: named, in: Bundle(for: self), compatibleWith: nil)
  }
}
