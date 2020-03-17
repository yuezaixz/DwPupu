//
//  IndexHeaderView+Rx.swift
//  DwPupu
//
//  Created by 吴迪玮 on 2020/3/17.
//  Copyright © 2020 davidandty. All rights reserved.
//

import RxSwift
import RxCocoa
import UIKit

private var leftPadding:CGFloat = 15

extension Reactive where Base: IndexHeaderView {
    
    
    internal var offset: Binder<CGFloat?> {
        return Binder(self.base) { headerView, offset in
            guard let offset = offset, let searchTopToBtn = headerView.searchTopToBtnConstraint, let searchLeading = headerView.searchLeadingConstraint, let mainView = headerView.mainView, let innerView = headerView.innerTopView, let darkLocationBtn = headerView.darkLocationBtn else { return }
            searchTopToBtn.constant = -offset
            searchLeading.constant = leftPadding + offset
            let alpha = offset/44.0
            innerView.alpha = 1-alpha
            darkLocationBtn.alpha = alpha
            
            mainView.backgroundColor = UIColor(white: 1.0, alpha: alpha)
        }
    }
    
}
