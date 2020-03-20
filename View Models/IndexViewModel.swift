//
//  IndexViewModel.swift
//  DwPupu
//
//  Created by 吴迪玮 on 2020/3/17.
//  Copyright © 2020 davidandty. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import RxRealm
import RxCocoa
import Unbox
import Hue

class IndexViewModel {
    private let disposeBag = DisposeBag()
    
    let title = BehaviorRelay<String>(value: "")
    
    
    let banners = BehaviorRelay<[Banner]>(value: [])
    let categories = BehaviorRelay<[Category]>(value: [])
    let bannerIndex = BehaviorRelay<Int>(value: 0)
    let homeItems = BehaviorRelay<[HomeItem]>(value: [])
    
    let topColor = BehaviorRelay<UIColor>(value: UIColor.white)
    let mainItems = BehaviorRelay<[Int]>(value: [1,2,3,4,5,6,7,8,9])
    
    let menuTitles = BehaviorRelay<[[String]]>(value: [["精选", "好货专区"], ["限时抢购", "超值限量"], ["疯狂折扣", "天天特价"], ["新品推荐", "当季新品"], ["懒人菜单", "方便快手"], ["网红爆款", "网红系列"]])
    
    init() {
      bindOutput()
    }

    func bindOutput() {
        
        HomeItem.homePageData().bind(to: homeItems).disposed(by: disposeBag)
        
        bannerIndex.subscribe(onNext: { [weak self] bannerIndex in
            guard let self = self, bannerIndex < self.banners.value.count else { return }
            let banner = self.banners.value[bannerIndex]
            
            if banner.bgColor.count == 7 {
                let color = UIColor(hex: banner.bgColor)
                self.topColor.accept(color)
            }
        }).disposed(by: disposeBag)
        
        PupuApi.baseData()
            .do(onNext: {[weak self] jsonObject in
                guard jsonObject["default_search_placeholder"] != nil ,let self = self, let title = jsonObject["default_search_placeholder"] as? String else {return}
                print("placehold:\(title)")
                self.title.accept(title)
            }).map { jsonObject -> [Category] in
                guard let cityCategories = jsonObject["city_categories"] as? Dictionary<String, Any> , let categories = cityCategories["categories"] as? [Dictionary<String, Any>], categories.count >= 8 else { return [] }
                return (try? unbox(dictionaries: categories, allowInvalidElements: true) as [Category]) ?? []
        }.filter({ $0.count > 0 }).bind(to: categories).disposed(by: disposeBag)

        PupuApi.banners()
            .map { bannerJsonObjects in
                let filterObjects = bannerJsonObjects.filter({ bannerJsonObject -> Bool in
                    return bannerJsonObject["img_url"] != nil && !(bannerJsonObject["img_url"] is NSNull) && bannerJsonObject["bg_color"] != nil && (bannerJsonObject["bg_color"] as! String).count > 0
            })
                return (try? unbox(dictionaries: Array(filterObjects[0..<min(filterObjects.count, 8)]), allowInvalidElements: true) as [Banner]) ?? []
        }.bind(to: banners).disposed(by: disposeBag)
        
        
    }
}
