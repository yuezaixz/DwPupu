//
//  Category.swift
//  DwPupu
//
//  Created by 吴迪玮 on 2020/3/18.
//  Copyright © 2020 davidandty. All rights reserved.
//

import Foundation
//import RealmSwift
import HandyJSON
import RxSwift
import RxCocoa

class Category: HandyJSON {
    
    var id = ""
    var name = ""
    var imgUrl = ""
    
    var subCategorys:[Category] = []

    required init() {}

    func mapping(mapper: HelpingMapper) {
        mapper <<<
            self.imgUrl <-- "img_url"
    }

}

extension Category {
    
    static let homeSearchPlaceholder = BehaviorRelay<String>(value: "")
    
    static func categorys() ->Observable<[Category]> {
        return PupuApi.baseData()
            .do(onNext: {jsonObject in
                guard jsonObject["default_search_placeholder"] != nil , let title = jsonObject["default_search_placeholder"] as? String else {return}
                homeSearchPlaceholder.accept(title)
            }).map { jsonObject -> [Category] in
                guard let cityCategories = jsonObject["city_categories"] as? Dictionary<String, Any> , let categories = cityCategories["categories"] as? [Dictionary<String, Any>], categories.count >= 8 else { return [] }
                return categories.map { jsonObject -> Category in
                    guard let categoryItem = Category.deserialize(from: jsonObject) else {return Category()}
                    
                    if let itemJsonObjects = jsonObject["sub_category"] as? [JSONObject], itemJsonObjects.count > 0 {
                        categoryItem.subCategorys = itemJsonObjects.map({ subCategoryItemJsonObject -> Category in
                            guard let subCategoryItem = Category.deserialize(from: subCategoryItemJsonObject) else {return Category()}
                            return subCategoryItem
                        })
                    }
                    
                    return categoryItem
                }
            }.filter({ $0.count > 0 }).share(replay: 1)
    }
}
