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
    
    let banners = BehaviorRelay<[Banner]>(value: [])
    let bannerIndex = BehaviorRelay<Int>(value: 0)
    
    let topColor = BehaviorRelay<UIColor>(value: UIColor.white)
    
    init() {
      bindOutput()
    }

    func bindOutput() {
        
        bannerIndex.subscribe(onNext: { [weak self] bannerIndex in
            guard let self = self, bannerIndex < self.banners.value.count else { return }
            let banner = self.banners.value[bannerIndex]
            
            if banner.bgColor.count == 7 {
                let color = UIColor(hex: banner.bgColor)
                self.topColor.accept(color)
            }
        }).disposed(by: disposeBag)

        PupuApi.banners()
            .map { bannerJsonObjects in
                let filterObjects = bannerJsonObjects.filter({ bannerJsonObject -> Bool in
                    return bannerJsonObject["img_url"] != nil && !(bannerJsonObject["img_url"] is NSNull) && bannerJsonObject["bg_color"] != nil && (bannerJsonObject["bg_color"] as! String).count > 0
            })
            return (try? unbox(dictionaries: Array(filterObjects[0..<8]), allowInvalidElements: true) as [Banner]) ?? []
        }.bind(to: banners).disposed(by: disposeBag)
    }
}
