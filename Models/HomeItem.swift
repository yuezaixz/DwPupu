//
//  HomeItem.swift
//  DwPupu
//
//  Created by 吴迪玮 on 2020/3/20.
//  Copyright © 2020 davidandty. All rights reserved.
//

import Foundation
//import RealmSwift
import HandyJSON
import RxSwift
import RxCocoa

class HomeItem: HandyJSON {
    
    var name = ""
    var summary = ""
    var imgUrl = ""
    var moreUrlParam = ""
    
    var items:[HomeSubItem] = []

    required init() {}

    func mapping(mapper: HelpingMapper) {
        mapper <<<
            self.imgUrl <-- "img_url"
        mapper <<<
            self.items <-- TransformOf<[HomeSubItem], JSONObject>(fromJSON: { (jsonObject) -> [HomeSubItem]? in
                guard let jsonObject = jsonObject else { return nil }
                print(jsonObject)
                return nil
            }, toJSON: { (subItems) -> JSONObject? in
                guard let subItems = subItems else { return nil }
                print(subItems)

                return nil
            })
        mapper <<<
            self.moreUrlParam <-- "more_url_param"
    }

}

extension HomeItem {
    static func homePageData() ->Observable<[HomeItem]> {
        return PupuApi.homePage().map { jsonObjects -> [HomeItem] in
            let filterObjects = jsonObjects.filter({ filterObject -> Bool in
                return filterObject["img_url"] != nil && !(filterObject["img_url"] is NSNull) && filterObject["name"] != nil && (filterObject["name"] as! String).count > 0
            })
            return filterObjects.map { jsonObject -> HomeItem in
                guard let homeItem = HomeItem.deserialize(from: jsonObject) else {return HomeItem()}
                
                if let itemJsonObjects = jsonObject["items"] as? [JSONObject], itemJsonObjects.count > 0 {
                    homeItem.items = itemJsonObjects.map({ homeSubItemJsonObject -> HomeSubItem in
                        guard let homeSubItem = HomeSubItem.deserialize(from: homeSubItemJsonObject) else {return HomeSubItem()}
                        return homeSubItem
                    })
                }
                
                return homeItem
            }
        }
    }
}
