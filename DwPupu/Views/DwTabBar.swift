//
//  DwTabBar.swift
//  DwPupu
//
//  Created by 吴迪玮 on 2020/3/16.
//  Copyright © 2020 davidandty. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class DwTabBar: UITabBar {
    private var _plusButton: UIButton?
    var plusButton: UIButton {
        get {
            if _plusButton == nil {
                _plusButton = UIButton(type: .custom)
                _plusButton!.setImage(UIImage(named: "puputoday"), for: .normal)
                _plusButton!.frame = CGRect(x: 0, y: 0, width: 48, height: 48)
                self.addSubview(_plusButton!)
            }
            return _plusButton!
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let w = self.bounds.size.width
        var butX = CGFloat(0)
        let butW = w / CGFloat(self.items!.count + 1)
        
        var i = 0
        var center = CGFloat(0)
        
        for tarBarItemView in self.subviews {
            if let tabBarButtonClass = NSClassFromString("UITabBarButton"), tarBarItemView.isKind(of:tabBarButtonClass ) {
                if i == 2 {
                    i = 3
                    center = tarBarItemView.center.y
                }
                butX = CGFloat(i) * butW
                tarBarItemView.frame = CGRect(x: butX, y: tarBarItemView.frame.origin.y, width: butW, height: tarBarItemView.frame.size.height)
                i += 1
            }
        }
        self.plusButton.center = CGPoint(x: w*0.5, y: center)
    }
}
