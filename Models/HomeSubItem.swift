//
//  HomeSubItem.swift
//  DwPupu
//
//  Created by 吴迪玮 on 2020/3/20.
//  Copyright © 2020 davidandty. All rights reserved.
//

import Foundation
import HandyJSON

class HomeSubItem: HandyJSON {
    
    var id = ""
    var name = ""
    var subTitle = ""
    var imgUrl = ""
    var price = 0
    var marketPrice = 0
    var productId = ""
    var spec = ""
    var origin = ""

    required init() {}

    func mapping(mapper: HelpingMapper) {
        mapper <<<
            self.imgUrl <-- "main_image"
        mapper <<<
            self.subTitle <-- "sub_title"
        mapper <<<
            self.marketPrice <-- "market_price"
        mapper <<<
            self.productId <-- "product_id"
    }


}
