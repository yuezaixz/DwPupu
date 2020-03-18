//
//  HomeCategoryMoreView.swift
//  DwPupu
//
//  Created by 吴迪玮 on 2020/3/18.
//  Copyright © 2020 davidandty. All rights reserved.
//

import UIKit
import RxSwift

class HomeCategoryMoreView: UIView {

    @IBOutlet weak var categoryImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}

extension Reactive where Base: HomeCategoryMoreView {
    
}
