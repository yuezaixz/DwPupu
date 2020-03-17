//
//  Bannber.swift
//  DwPupu
//
//  Created by 吴迪玮 on 2020/3/17.
//  Copyright © 2020 davidandty. All rights reserved.
//

import Foundation
//import RealmSwift
import Unbox

class Banner: Unboxable {

  // MARK: - Properties
//  @objc dynamic var id = ""
//  @objc dynamic var title = ""
//  @objc dynamic var imgUrl = ""
//  @objc dynamic var linkType = ""
//  @objc dynamic var linkUrl = ""
//  @objc dynamic var linkId = ""
//  @objc dynamic var timeOpen = ""
//  @objc dynamic var timeClose = ""
//  @objc dynamic var remark = ""
//  @objc dynamic var userIdUpdate = ""
//  @objc dynamic var urlParams = ""
//  @objc dynamic var positionType = ""
//  @objc dynamic var positionId = ""
//  @objc dynamic var activeType = ""
//  @objc dynamic var deliveryReasonType = ""
//  @objc dynamic var dayTimeOpen = ""
//  @objc dynamic var dayTimeClose = ""
//  @objc dynamic var isGlobal = ""
//  @objc dynamic var isLimited = ""
//  @objc dynamic var linkProducts = ""
//  @objc dynamic var linkName = ""
//  @objc dynamic var textColor = ""
//  @objc dynamic var subTitle = ""
//  @objc dynamic var name = ""
//  @objc dynamic var userNameUpdate = ""
//  @objc dynamic var userNameCreate = ""
//  @objc dynamic var timeCreate = ""
//  @objc dynamic var timeUpdate = ""
//  @objc dynamic var storeProducts = ""
//  @objc dynamic var bgColor = ""
//  @objc dynamic var sortNum = ""
//  @objc dynamic var imgId = ""
    
    var id = ""
    var title = ""
    var imgUrl = ""
    var linkType = ""
    var linkUrl = ""
    var linkId = ""
    var timeOpen = ""
    var timeClose = ""
    var remark = ""
    var userIdUpdate = ""
    var urlParams = ""
    var positionType = ""
    var positionId = ""
    var activeType = ""
    var deliveryReasonType = ""
    var dayTimeOpen = ""
    var dayTimeClose = ""
    var isGlobal = ""
    var isLimited = ""
    var linkProducts = ""
    var linkName = ""
    var textColor = ""
    var subTitle = ""
    var name = ""
    var userNameUpdate = ""
    var userNameCreate = ""
    var timeCreate = ""
    var timeUpdate = ""
    var storeProducts = ""
    var bgColor = ""
    var sortNum = ""
    var imgId = ""
    
//    
//  // MARK: - Meta
//  override static func primaryKey() -> String? {
//    return "id"
//  }

  // MARK: Init with Unboxer
  convenience required init(unboxer: Unboxer) throws {
    self.init()

    id = try unboxer.unbox(key: "id")
    title = try unboxer.unbox(key: "title")
    imgUrl = try unboxer.unbox(key: "img_url")
    linkType = try unboxer.unbox(key: "link_type")
    linkUrl = try unboxer.unbox(key: "link_url")
    linkId = try unboxer.unbox(key: "link_id")
    timeOpen = try unboxer.unbox(key: "time_open")
    timeClose = try unboxer.unbox(key: "time_close")
//    remark = try unboxer.unbox(key: "remark")
//    userIdUpdate = try unboxer.unbox(key: "user_id_update")
//    urlParams = try unboxer.unbox(key: "url_params")
    positionType = try unboxer.unbox(key: "position_type")
    positionId = try unboxer.unbox(key: "position_id")
    activeType = try unboxer.unbox(key: "active_type")
    deliveryReasonType = try unboxer.unbox(key: "delivery_reason_type")
    dayTimeOpen = try unboxer.unbox(key: "day_time_open")
    dayTimeClose = try unboxer.unbox(key: "day_time_close")
    isGlobal = try unboxer.unbox(key: "is_global")
    isLimited = try unboxer.unbox(key: "is_limited")
//    linkProducts = try unboxer.unbox(key: "link_products")
//    linkName = try unboxer.unbox(key: "link_name")
    textColor = try unboxer.unbox(key: "text_color")
//    subTitle = try unboxer.unbox(key: "sub_title")
    name = try unboxer.unbox(key: "name")
//    userNameUpdate = try unboxer.unbox(key: "user_name_update")
//    userNameCreate = try unboxer.unbox(key: "user_name_create")
    timeCreate = try unboxer.unbox(key: "time_create")
    timeUpdate = try unboxer.unbox(key: "time_update")
//    storeProducts = try unboxer.unbox(key: "store_products")
    bgColor = try unboxer.unbox(key: "bg_color")
    sortNum = try unboxer.unbox(key: "sort_num")
    imgId = try unboxer.unbox(key: "img_id")
  }
}

