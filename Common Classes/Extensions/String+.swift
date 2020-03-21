//
//  String+.swift
//  DwPupu
//
//  Created by 吴迪玮 on 2020/3/21.
//  Copyright © 2020 davidandty. All rights reserved.
//

import UIKit

extension String {
    func textSize(font : UIFont , maxSize : CGSize) -> CGSize{
        return self.boundingRect(with: maxSize, options: [.usesLineFragmentOrigin], attributes: [NSAttributedString.Key.font : font], context: nil).size
    }
}
