//
//  CategoryViewModel.swift
//  DwPupu
//
//  Created by 吴迪玮 on 2020/3/22.
//  Copyright © 2020 davidandty. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa

class CategoryViewModel {
    private let disposeBag = DisposeBag()
    
    let title = BehaviorRelay<String>(value: "")
    let categories = BehaviorRelay<[Category]>(value: [])
    let linkUrlMap = BehaviorRelay<[String:String]>(value: [:])
    
    init() {
      bindOutput()
    }

    func bindOutput() {
        
        Category.categorys().bind(to: categories).disposed(by: disposeBag)
        Category.homeSearchPlaceholder.bind(to: title).disposed(by: disposeBag)
        Banner.linkUrlMap.bind(to: linkUrlMap).disposed(by: disposeBag)
        
    }
}
