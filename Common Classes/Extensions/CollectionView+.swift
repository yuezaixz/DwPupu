//
//  CollectionView+.swift
//  DwPupu
//
//  Created by 吴迪玮 on 2020/3/21.
//  Copyright © 2020 davidandty. All rights reserved.
//

import Foundation
import UIKit

extension UICollectionView {
    func dequeueCell<T>(ofType type: T.Type, for indexPath:IndexPath) -> T {
        return dequeueReusableCell(withReuseIdentifier: String(describing: T.self), for: indexPath) as! T
    }
}
