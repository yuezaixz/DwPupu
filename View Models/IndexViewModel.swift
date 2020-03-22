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
        
        Category.categorys().bind(to: categories).disposed(by: disposeBag)
        Category.homeSearchPlaceholder.bind(to: title).disposed(by: disposeBag)

        Banner.banners().map { Array($0[0..<min($0.count, 8)])}.bind(to: banners).disposed(by: disposeBag)
        
    }
}
