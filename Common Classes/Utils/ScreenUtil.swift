//
//  ScreenUtil.swift
//  DwPupu
//
//  Created by 吴迪玮 on 2020/3/19.
//  Copyright © 2020 davidandty. All rights reserved.
//

import UIKit

struct DwScreen {
    //当前屏幕尺寸
    static var statusBarHeight:CGFloat {
        if #available(iOS 13.0, *) {
            let window = UIApplication.shared.windows.filter {$0.isKeyWindow}.first
            let height = window?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0
            return height
        } else {
            return UIApplication.shared.statusBarFrame.height
        }
    }
    static let navigationBarHeight = DwScreen.statusBarHeight + 44
    static let width = UIScreen.main.bounds.size.width
    static let height = UIScreen.main.bounds.size.height
    static let size = UIScreen.main.bounds.size
}
