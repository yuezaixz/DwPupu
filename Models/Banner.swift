//
//  Bannber.swift
//  DwPupu
//
//  Created by 吴迪玮 on 2020/3/17.
//  Copyright © 2020 davidandty. All rights reserved.
//

import Foundation
//import RealmSwift
import HandyJSON
import RxSwift
import RxCocoa

class Banner: HandyJSON {
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

    required init() {}

    func mapping(mapper: HelpingMapper) {
        mapper <<<
            self.imgUrl <-- "img_url"
                
        mapper <<<
            self.linkType <-- "link_type"
            
        mapper <<<
            self.linkUrl <-- "link_url"
            
        mapper <<<
            self.linkId <-- "link_id"
            
        mapper <<<
            self.timeOpen <-- "time_open"
            
        mapper <<<
            self.timeClose <-- "time_close"
            
        mapper <<<
            self.positionType <-- "position_type"
            
        mapper <<<
            self.positionId <-- "position_id"
            
        mapper <<<
            self.activeType <-- "active_type"
            
        mapper <<<
            self.deliveryReasonType <-- "delivery_reason_type"
            
        mapper <<<
            self.dayTimeOpen <-- "day_time_open"
            
        mapper <<<
            self.dayTimeClose <-- "day_time_close"
            
        mapper <<<
            self.isGlobal <-- "is_global"
            
        mapper <<<
            self.isLimited <-- "is_limited"
            
        mapper <<<
            self.textColor <-- "text_color"
            
        mapper <<<
            self.timeCreate <-- "time_create"
            
        mapper <<<
            self.timeUpdate <-- "time_update"
            
        mapper <<<
            self.bgColor <-- "bg_color"
            
        mapper <<<
            self.sortNum <-- "sort_num"
            
        mapper <<<
            self.imgId <-- "img_id"
    }
}


extension Banner {
    
    static let linkUrlMap = BehaviorRelay<[String:String]>(value: [:])
    
    static func banners() ->Observable<[Banner]> {
        return PupuApi.banners()
            .map { bannerJsonObjects -> [Banner] in
                let filterObjects = bannerJsonObjects.filter({ bannerJsonObject -> Bool in
                    return bannerJsonObject["img_url"] != nil && !(bannerJsonObject["img_url"] is NSNull) && bannerJsonObject["bg_color"] != nil && (bannerJsonObject["bg_color"] as! String).count > 0
                })
                return filterObjects.map { jsonObject -> Banner in
                    guard let homeItem = Banner.deserialize(from: jsonObject) else {return Banner()}
                    
                    return homeItem
                }
            }
            .do(onNext: { banners in
                var result:[String:String] = [:]
                
                banners.forEach { banner in
                    guard String.isNotEmpty(banner.linkId) && String.isNotEmpty(banner.imgUrl) else { return }
                    result[banner.linkId] = banner.imgUrl
                }
                
                linkUrlMap.accept(result)
            }).share(replay: 1)
    }
}
