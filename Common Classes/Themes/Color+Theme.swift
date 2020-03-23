//
//  Color+Theme.swift
//  DwPupu
//
//  Created by 吴迪玮 on 2020/3/23.
//  Copyright © 2020 davidandty. All rights reserved.
//

import Foundation
import UIKit

extension UIColor {
    public static var backgroundColor: UIColor {
        if #available(iOS 13, *) {
            return UIColor { (traitCollection: UITraitCollection) -> UIColor in
                if traitCollection.userInterfaceStyle == .dark {
                    return UIColor(hex: "#333333")
                } else {
                    return UIColor.white
                }
            }
        } else {
            return UIColor.white
        }
    }
}
