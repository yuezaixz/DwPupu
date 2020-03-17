//
//  DeviceUtil.swift
//  DwPupu
//
//  Created by 吴迪玮 on 2020/3/17.
//  Copyright © 2020 davidandty. All rights reserved.
//

import Foundation
import UIKit

class DeviceUtil {
    public static var isFullScreen: Bool {
        if #available(iOS 11, *) {
              guard let w = UIApplication.shared.delegate?.window, let unwrapedWindow = w else {
                  return false
              }
              
              if unwrapedWindow.safeAreaInsets.left > 0 || unwrapedWindow.safeAreaInsets.bottom > 0 {
//                  print(unwrapedWindow.safeAreaInsets)
                  return true
              }
        }
        return false
    }
}
