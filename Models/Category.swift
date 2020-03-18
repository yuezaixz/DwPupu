//
//  Category.swift
//  DwPupu
//
//  Created by 吴迪玮 on 2020/3/18.
//  Copyright © 2020 davidandty. All rights reserved.
//

import Foundation
//import RealmSwift
import Unbox

class Category: Unboxable {
    
    var id = ""
    var name = ""
    var imgUrl = ""

    // MARK: Init with Unboxer
    convenience required init(unboxer: Unboxer) throws {
      self.init()

      id = try unboxer.unbox(key: "id")
      name = try unboxer.unbox(key: "name")
      imgUrl = try unboxer.unbox(key: "img_url")
        
    }

}
